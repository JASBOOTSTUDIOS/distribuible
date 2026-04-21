$ErrorActionPreference = "Stop"

$root = "c:\src\jasboot"
$jbc = Join-Path $root "sdk-dependiente\jas-compiler-c\bin\jbc.exe"
$vm = Join-Path $root "sdk-dependiente\jasboot-ir\bin\jasboot-ir-vm-net.exe"
$serverScript = Join-Path $root "benchmarks\red_nativa\loopback_server.py"
$httpsServerScript = Join-Path $root "benchmarks\red_nativa\loopback_https_server.py"
$certPath = Join-Path $root "tests\P4_55_red_nativa\certs\localhost-cert.pem"
$keyPath = Join-Path $root "tests\P4_55_red_nativa\certs\localhost-key.pem"
$runs = 5

$cases = @(
    [pscustomobject]@{
        Nombre = "http_loopback_cliente"
        Jasb = (Join-Path $root "benchmarks\red_nativa\http_loopback_cliente.jasb")
        Jbo = (Join-Path $root "benchmarks\red_nativa\http_loopback_cliente.jbo")
        Js = (Join-Path $root "benchmarks\red_nativa\http_loopback_cliente.js")
        Puerto = 18083
        Https = $false
    },
    [pscustomobject]@{
        Nombre = "https_loopback_cliente"
        Familia = "https_alto_nivel"
        Jasb = (Join-Path $root "benchmarks\red_nativa\https_loopback_cliente.jasb")
        Jbo = (Join-Path $root "benchmarks\red_nativa\https_loopback_cliente.jbo")
        Js = (Join-Path $root "benchmarks\red_nativa\https_loopback_cliente.js")
        Puerto = 18444
        Https = $true
    },
    [pscustomobject]@{
        Nombre = "tls_crudo_cliente"
        Familia = "tls_crudo"
        Tipo = "client_node_server"
        Jasb = (Join-Path $root "benchmarks\red_nativa\tls_loopback_cliente.jasb")
        Jbo = (Join-Path $root "benchmarks\red_nativa\tls_loopback_cliente.jbo")
        Js = (Join-Path $root "benchmarks\red_nativa\tls_loopback_cliente.js")
        NodeServer = (Join-Path $root "benchmarks\red_nativa\tls_servidor_node.js")
        Puerto = 18446
    },
    [pscustomobject]@{
        Nombre = "http_servidor_loopback"
        Familia = "http_alto_nivel"
        Tipo = "server"
        JasbootServerJbo = (Join-Path $root "benchmarks\red_nativa\http_servidor_jasboot_100.jbo")
        NodeServer = (Join-Path $root "benchmarks\red_nativa\http_servidor_node.js")
        Cliente = "node"
        ClienteScript = (Join-Path $root "benchmarks\red_nativa\http_cliente_externo.js")
        Puerto = 18082
    },
    [pscustomobject]@{
        Nombre = "https_servidor_loopback"
        Familia = "https_alto_nivel"
        Tipo = "server"
        JasbootServerJbo = (Join-Path $root "benchmarks\red_nativa\https_servidor_jasboot_100.jbo")
        NodeServer = (Join-Path $root "benchmarks\red_nativa\https_servidor_node.js")
        Cliente = "node"
        ClienteScript = (Join-Path $root "benchmarks\red_nativa\https_cliente_externo.js")
        Puerto = 18443
    },
    [pscustomobject]@{
        Nombre = "tls_crudo_servidor"
        Familia = "tls_crudo"
        Tipo = "server"
        JasbootServerJbo = (Join-Path $root "benchmarks\red_nativa\tls_servidor_jasboot_100.jbo")
        NodeServer = (Join-Path $root "benchmarks\red_nativa\tls_servidor_node.js")
        Cliente = "node"
        ClienteScript = (Join-Path $root "benchmarks\red_nativa\tls_cliente_externo.js")
        Puerto = 18447
    }
)

function Invoke-Program([string]$FilePath, [string[]]$Arguments) {
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $FilePath
    $psi.Arguments = (($Arguments | ForEach-Object {
        if ($_ -match '[\s"]') {
            '"' + ($_ -replace '"', '\"') + '"'
        } else {
            $_
        }
    }) -join ' ')
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true

    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $psi
    [void]$proc.Start()
    $stdout = $proc.StandardOutput.ReadToEnd()
    $stderr = $proc.StandardError.ReadToEnd()
    $proc.WaitForExit()

    [pscustomobject]@{
        ExitCode = $proc.ExitCode
        StdOut = $stdout.Trim()
        StdErr = $stderr.Trim()
    }
}

function Measure-Runner([string]$Name, [scriptblock]$Action) {
    $times = @()
    $outputs = @()
    for ($i = 0; $i -lt $runs; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $result = & $Action
        $sw.Stop()
        if ($result.ExitCode -ne 0) {
            throw "$Name fallo: $($result.StdErr)"
        }
        $times += [math]::Round($sw.Elapsed.TotalMilliseconds, 3)
        $outputs += $result.StdOut
    }

    [pscustomobject]@{
        Nombre = $Name
        MinMs = ($times | Measure-Object -Minimum).Minimum
        AvgMs = [math]::Round((($times | Measure-Object -Average).Average), 3)
        MaxMs = ($times | Measure-Object -Maximum).Maximum
        Salidas = @($outputs | Sort-Object -Unique)
    }
}

function Stop-PortProcesses([int]$Port) {
    $ids = @(
        netstat -ano |
        Select-String (":" + $Port) |
        ForEach-Object { ($_ -split '\s+')[-1] } |
        Where-Object { $_ -match '^[0-9]+$' } |
        Sort-Object -Unique
    )

    foreach ($procId in $ids) {
        try {
            Stop-Process -Id ([int]$procId) -Force -ErrorAction Stop
        } catch {
        }
    }
}

function Wait-ListeningPort([int]$Port, [int]$MaxAttempts = 300, [int]$SleepMs = 100) {
    for ($i = 0; $i -lt $MaxAttempts; $i++) {
        $listening = netstat -ano | Select-String ("127.0.0.1:{0}\s+0.0.0.0:0\s+LISTENING" -f $Port)
        if ($listening) {
            return
        }
        Start-Sleep -Milliseconds $SleepMs
    }
    throw "El puerto $Port no entro en LISTENING a tiempo."
}

function Measure-ServerRunner([string]$Name, [int]$Port, [scriptblock]$StartServer, [scriptblock]$RunClient) {
    $times = @()
    $outputs = @()
    for ($i = 0; $i -lt $runs; $i++) {
        Stop-PortProcesses $Port
        $server = & $StartServer
        Wait-ListeningPort $Port
        try {
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            $result = & $RunClient
            $sw.Stop()
            if ($result.ExitCode -ne 0) {
                throw "$Name fallo: $($result.StdErr)"
            }
            $times += [math]::Round($sw.Elapsed.TotalMilliseconds, 3)
            $outputs += $result.StdOut
        }
        finally {
            if ($server -and !$server.HasExited) {
                Stop-Process -Id $server.Id -Force
            }
            Stop-PortProcesses $Port
        }
    }

    [pscustomobject]@{
        Nombre = $Name
        MinMs = ($times | Measure-Object -Minimum).Minimum
        AvgMs = [math]::Round((($times | Measure-Object -Average).Average), 3)
        MaxMs = ($times | Measure-Object -Maximum).Maximum
        Salidas = @($outputs | Sort-Object -Unique)
    }
}

function Wait-Port([int]$Port, [int]$MaxAttempts = 80, [int]$SleepMs = 100) {
    for ($i = 0; $i -lt $MaxAttempts; $i++) {
        try {
            $client = New-Object System.Net.Sockets.TcpClient
            $async = $client.BeginConnect("127.0.0.1", $Port, $null, $null)
            if ($async.AsyncWaitHandle.WaitOne(200) -and $client.Connected) {
                $client.EndConnect($async)
                $client.Close()
                return
            }
            $client.Close()
        } catch {
        }
        Start-Sleep -Milliseconds $SleepMs
    }
    throw "El puerto $Port no estuvo disponible a tiempo."
}

$serverCode = @'
import socket

RESPONSE = b"HTTP/1.1 200 OK\r\nContent-Length: 2\r\nConnection: close\r\n\r\nok"

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind(("127.0.0.1", 18083))
s.listen(32)

try:
    while True:
        conn, _ = s.accept()
        try:
            conn.recv(4096)
            conn.sendall(RESPONSE)
        finally:
            conn.close()
finally:
    s.close()
'@
Set-Content -Path $serverScript -Value $serverCode

$httpsServerCode = @"
import socket
import ssl

RESPONSE = b"HTTP/1.1 200 OK\r\nContent-Length: 2\r\nConnection: close\r\n\r\nok"

ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
ctx.load_cert_chain(certfile=r"$certPath", keyfile=r"$keyPath")

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind(("127.0.0.1", 18444))
s.listen(32)

try:
    while True:
        conn, _ = s.accept()
        try:
            tls_conn = ctx.wrap_socket(conn, server_side=True)
            try:
                tls_conn.recv(4096)
                tls_conn.sendall(RESPONSE)
            finally:
                tls_conn.close()
        except Exception:
            conn.close()
finally:
    s.close()
"@
Set-Content -Path $httpsServerScript -Value $httpsServerCode

try {
    foreach ($case in $cases) {
        if ($case.Tipo -eq "server") {
            $jasboot = Measure-ServerRunner "Jasboot" $case.Puerto {
                Start-Process -FilePath $vm -ArgumentList @($case.JasbootServerJbo) -WorkingDirectory $root -PassThru -WindowStyle Hidden
            } {
                Invoke-Program $case.Cliente @($case.ClienteScript, [string]$case.Puerto)
            }

            $node = Measure-ServerRunner "Node" $case.Puerto {
                Start-Process -FilePath "node" -ArgumentList @($case.NodeServer) -WorkingDirectory $root -PassThru -WindowStyle Hidden
            } {
                Invoke-Program $case.Cliente @($case.ClienteScript, [string]$case.Puerto)
            }
        } elseif ($case.Tipo -eq "client_node_server") {
            $compile = Invoke-Program $jbc @($case.Jasb, "-o", $case.Jbo)
            if ($compile.ExitCode -ne 0) {
                throw "Compilacion Jasboot fallo para $($case.Nombre): $($compile.StdErr)"
            }

            Stop-PortProcesses $case.Puerto
            $server = Start-Process -FilePath "node" -ArgumentList @($case.NodeServer, [string]$case.Puerto) -WorkingDirectory $root -PassThru -WindowStyle Hidden
            Wait-ListeningPort $case.Puerto
            try {
                $jasboot = Measure-Runner "Jasboot" { Invoke-Program $vm @($case.Jbo) }
                $node = Measure-Runner "Node" { Invoke-Program "node" @($case.Js) }
            }
            finally {
                if ($server -and !$server.HasExited) {
                    Stop-Process -Id $server.Id -Force
                }
                Stop-PortProcesses $case.Puerto
            }
        } else {
            $compile = Invoke-Program $jbc @($case.Jasb, "-o", $case.Jbo)
            if ($compile.ExitCode -ne 0) {
                throw "Compilacion Jasboot fallo para $($case.Nombre): $($compile.StdErr)"
            }

            $server = $null
            if ($case.Https) {
                $server = Start-Process -FilePath "python" -ArgumentList @($httpsServerScript) -WorkingDirectory $root -PassThru -WindowStyle Hidden
            } else {
                $server = Start-Process -FilePath "python" -ArgumentList @($serverScript) -WorkingDirectory $root -PassThru -WindowStyle Hidden
            }
            Wait-Port $case.Puerto

            try {
                $jasboot = Measure-Runner "Jasboot" { Invoke-Program $vm @($case.Jbo) }
                $node = Measure-Runner "Node" { Invoke-Program "node" @($case.Js) }
            }
            finally {
                if ($server -and !$server.HasExited) {
                    Stop-Process -Id $server.Id -Force
                }
            }
        }

        "Benchmark: $($case.Nombre) (100 requests)"
        ""
        $jasboot
        $node
        ""

        if ($jasboot.Salidas.Count -ne 1 -or $node.Salidas.Count -ne 1) {
            throw "Salidas inconsistentes en $($case.Nombre). Jasboot=$($jasboot.Salidas -join ',') Node=$($node.Salidas -join ',')"
        }

        if ($jasboot.Salidas[0] -ne $node.Salidas[0] -and $case.Tipo -ne "server") {
            throw "Las salidas no coinciden en $($case.Nombre). Jasboot=$($jasboot.Salidas -join ',') Node=$($node.Salidas -join ',')"
        }

        $ganador = if ($jasboot.AvgMs -lt $node.AvgMs) { "Jasboot" } else { "Node" }
        "Ganador promedio: $ganador"
        if ($jasboot.Salidas[0] -eq $node.Salidas[0]) {
            "Salida validada: $($jasboot.Salidas[0])"
        } else {
            "Salida equivalente pendiente de normalizar: Jasboot=$($jasboot.Salidas[0]) Node=$($node.Salidas[0])"
        }
        ""
    }
}
finally {
    if (Test-Path $serverScript) {
        Remove-Item $serverScript -Force
    }
    if (Test-Path $httpsServerScript) {
        Remove-Item $httpsServerScript -Force
    }
}
