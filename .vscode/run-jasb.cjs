"use strict";
const { spawnSync, spawn } = require("child_process");
const fs = require("fs");
const path = require("path");

const workspaceRoot = path.resolve(__dirname, "..");
/** Raiz del repo para ffi_cargar (VM hace chdir al directorio del .jasb con jbc -e). */
const childEnv = { ...process.env, JASBOOT_REPO_ROOT: workspaceRoot };

/** Elige el .exe mas reciente en `dir` por mtime (si `jbc.exe` esta bloqueado al enlazar, suele crearse `jbc-cursor.exe` o actualizarse solo `jbc-next.exe`). */
function newestExeInDir(dir, names) {
  let best = null;
  let bestMs = -1;
  for (const n of names) {
    const p = path.join(dir, n);
    if (!fs.existsSync(p)) continue;
    try {
      const ms = fs.statSync(p).mtimeMs;
      if (ms > bestMs) {
        bestMs = ms;
        best = p;
      }
    } catch (_) {
      /* ignorar */
    }
  }
  return best;
}

function findJbc() {
  if (process.env.JASBOOT_JBC) {
    const p = path.isAbsolute(process.env.JASBOOT_JBC)
      ? process.env.JASBOOT_JBC
      : path.join(workspaceRoot, process.env.JASBOOT_JBC);
    if (fs.existsSync(p)) return p;
  }

  /* Toolchain canónico: sdk-dependiente/ (sin copia espejo bajo export/). */
  const compilerBins = [
    path.join(workspaceRoot, "sdk-dependiente", "jas-compiler-c", "bin"),
    path.join(workspaceRoot, "sdk", "jas-compiler-c", "bin"),
  ];
  for (const dir of compilerBins) {
    const pick = newestExeInDir(dir, [
      "jbc-cursor.exe",
      "jbc.exe",
      "jbc-next.exe",
    ]);
    if (pick) return pick;
  }

  const rels = [
    ["sdk-dependiente", "jas-compiler-c", "bin", "jbc.exe"],
    ["sdk-dependiente", "jas-compiler-c", "bin", "jbc-next.exe"],
    ["sdk", "jas-compiler-c", "bin", "jbc.exe"],
    ["sdk", "jas-compiler-c", "bin", "jbc"],
    ["sdk-dependiente", "jas-compiler-c", "bin", "jbc"],
    ["sdk-dependiente", "bin", "jbc.exe"],
    ["sdk-dependiente", "bin", "jbc.cmd"],
    ["sdk-dependiente", "bin", "jbc"],
    ["..", "bin", "jbc.exe"],
    ["..", "bin", "jbc_new.exe"],
    ["..", "bin", "jbc-next.exe"],
    ["..", "bin", "jbc"],
  ];
  for (const parts of rels) {
    const p = path.join(workspaceRoot, ...parts);
    if (fs.existsSync(p)) return p;
  }
  return null;
}

function findVm() {
  if (process.env.JASBOOT_VM) {
    const p = path.isAbsolute(process.env.JASBOOT_VM)
      ? process.env.JASBOOT_VM
      : path.join(workspaceRoot, process.env.JASBOOT_VM);
    if (fs.existsSync(p)) return p;
  }
  // Por defecto: VM rapida (sin trace). Para depuracion: JASBOOT_VM_TRACE=1
  if (process.env.JASBOOT_VM_TRACE === "1") {
    const traceCandidates = [
      ["sdk-dependiente", "jasboot-ir", "bin", "jasboot-ir-vm-trace.exe"],
      ["sdk", "jasboot-ir", "bin", "jasboot-ir-vm-trace.exe"],
    ];
    for (const parts of traceCandidates) {
      const p = path.join(workspaceRoot, ...parts);
      if (fs.existsSync(p)) return p;
    }
  }
  const rels = [
    ["sdk-dependiente", "jasboot-ir", "bin", "jasboot-ir-vm.exe"],
    ["sdk-dependiente", "jasboot-ir", "bin", "jasboot-ir-vm-net.exe"],
    ["sdk-dependiente", "jasboot-ir", "bin", "jasboot-ir-vm-trace.exe"],
    ["sdk-dependiente", "bin", "jasboot-ir-vm.exe"],
    ["sdk", "jasboot-ir", "bin", "jasboot-ir-vm.exe"],
  ];
  for (const parts of rels) {
    const p = path.join(workspaceRoot, ...parts);
    if (fs.existsSync(p)) return p;
  }
  return null;
}

/** Transpilador Jasboot → C (AOT). Ejecutable `jbc-to-c` o variable JASBOOT_JBC_TO_C. */
function findJbcToC() {
  if (process.env.JASBOOT_JBC_TO_C) {
    const p = path.isAbsolute(process.env.JASBOOT_JBC_TO_C)
      ? process.env.JASBOOT_JBC_TO_C
      : path.join(workspaceRoot, process.env.JASBOOT_JBC_TO_C);
    if (fs.existsSync(p)) return p;
  }
  const names =
    process.platform === "win32"
      ? ["jbc-to-c.exe", "jbc-to-c.cmd", "jbc-to-c"]
      : ["jbc-to-c", "jbc-to-c.exe"];
  const dirs = [
    path.join(workspaceRoot, "sdk-dependiente", "jasboot-to-c", "bin"),
    path.join(workspaceRoot, "sdk-dependiente", "jasboot-to-c"),
    path.join(workspaceRoot, "sdk-dependiente", "bin"),
    path.join(workspaceRoot, "sdk", "jasboot-to-c", "bin"),
  ];
  for (const dir of dirs) {
    const pick = newestExeInDir(dir, names);
    if (pick) return pick;
    for (const n of names) {
      const p = path.join(dir, n);
      if (fs.existsSync(p)) return p;
    }
  }
  return null;
}

function captureBlock(lines, startIndex) {
  let depth = 0;
  let started = false;
  const body = [];
  for (let i = startIndex; i < lines.length; i++) {
    const line = lines[i];
    const trimmed = line.trim();
    const opens = (line.match(/\{/g) || []).length;
    const closes = (line.match(/\}/g) || []).length;
    if (!started) {
      depth += opens;
      started = true;
      continue;
    }
    if (trimmed === "}" && depth === 1) {
      return { body: body.join("\n"), nextIndex: i + 1 };
    }
    body.push(line);
    depth += opens;
    depth -= closes;
  }
  return { body: body.join("\n"), nextIndex: lines.length };
}

function splitJasbBlocks(body) {
  const lines = body.split(/\r?\n/);
  const safe = [];
  const jasb = [];
  for (let i = 0; i < lines.length; ) {
    const trimmed = lines[i].trim();
    if (trimmed.startsWith("jasb {")) {
      const block = captureBlock(lines, i);
      jasb.push(block.body);
      i = block.nextIndex;
      continue;
    }
    safe.push(lines[i]);
    i += 1;
  }
  return { safe: safe.join("\n"), jasb: jasb.join("\n") };
}

function extractQuotedStrings(line) {
  return [...line.matchAll(/"([^"]*)"/g)].map((m) => m[1]);
}

function normalizeJasbLine(raw) {
  const trimmedRight = raw.replace(/\s+$/g, "");
  if (!trimmedRight.trim()) return "";
  return trimmedRight.trimStart();
}

function buildUiBlock(lines, startIndex, state) {
  const header = lines[startIndex].trim();
  const type = header.replace("{", "").trim().split(/\s+/)[0];
  const innerVar = `jd_hijos_${state.counter++}`;
  const blockVar = `jd_bloque_${state.counter++}`;
  const code = [`    texto ${innerVar} = ""`];
  let title = "";
  let variant = "";
  let i = startIndex + 1;
  while (i < lines.length) {
    const line = lines[i].trim();
    if (!line) {
      i += 1;
      continue;
    }
    if (line === "}") {
      break;
    }
    if (/^(columna|fila|tarjeta)\s*\{$/.test(line)) {
      const nested = buildUiBlock(lines, i, state);
      code.push(...nested.code);
      code.push(`    ${innerVar} = concatenar(${innerVar}, ${nested.varName})`);
      i = nested.nextIndex;
      continue;
    }
    if (/^(campo|panel_seguro|panel_seguro_oculto)\s*\{$/.test(line)) {
      const nested = buildUiBlock(lines, i, state);
      code.push(...nested.code);
      code.push(`    ${innerVar} = concatenar(${innerVar}, ${nested.varName})`);
      i = nested.nextIndex;
      continue;
    }
    if (line.startsWith("titulo:")) {
      title = extractQuotedStrings(line)[0] || "";
      i += 1;
      continue;
    }
    if (line.startsWith("variante:")) {
      variant = extractQuotedStrings(line)[0] || "";
      i += 1;
      continue;
    }
    const args = extractQuotedStrings(line);
    if (line.startsWith("texto ") && args[0] !== undefined) {
      code.push(
        `    ${innerVar} = concatenar(${innerVar}, estructura_texto("${args[0]}"))`,
      );
    } else if (line.startsWith("titulo ") && args[0] !== undefined) {
      code.push(
        `    ${innerVar} = concatenar(${innerVar}, estructura_titulo("${args[0]}"))`,
      );
    } else if (line.startsWith("subtitulo ") && args[0] !== undefined) {
      code.push(
        `    ${innerVar} = concatenar(${innerVar}, estructura_subtitulo("${args[0]}"))`,
      );
    } else if (line.startsWith("boton_ruta ") && args.length >= 2) {
      code.push(
        `    ${innerVar} = concatenar(${innerVar}, estructura_boton_ruta("${args[0]}", "${args[1]}"))`,
      );
    } else if (line.startsWith("boton_alerta ") && args.length >= 2) {
      code.push(
        `    ${innerVar} = concatenar(${innerVar}, estructura_boton_alerta("${args[0]}", "${args[1]}"))`,
      );
    } else if (line.startsWith("boton_secundario ") && args.length >= 2) {
      code.push(
        `    ${innerVar} = concatenar(${innerVar}, estructura_boton_secundario("${args[0]}", "${args[1]}"))`,
      );
    } else if (line.startsWith("boton ") && args.length >= 2) {
      code.push(
        `    ${innerVar} = concatenar(${innerVar}, estructura_boton("${args[0]}", "${args[1]}"))`,
      );
    } else if (line.startsWith("boton_mostrar ") && args.length >= 2) {
      code.push(
        `    ${innerVar} = concatenar(${innerVar}, estructura_boton_mostrar("${args[0]}", "${args[1]}"))`,
      );
    } else if (line.startsWith("boton_ocultar ") && args.length >= 2) {
      code.push(
        `    ${innerVar} = concatenar(${innerVar}, estructura_boton_ocultar("${args[0]}", "${args[1]}"))`,
      );
    } else if (line.startsWith("boton_alternar ") && args.length >= 2) {
      code.push(
        `    ${innerVar} = concatenar(${innerVar}, estructura_boton_alternar("${args[0]}", "${args[1]}"))`,
      );
    } else if (line.startsWith("entrada ") && args.length >= 3) {
      code.push(
        `    ${innerVar} = concatenar(${innerVar}, estructura_entrada("${args[0]}", "${args[1]}", "${args[2]}"))`,
      );
    } else if (line.startsWith("entrada ") && args.length >= 2) {
      code.push(
        `    ${innerVar} = concatenar(${innerVar}, estructura_entrada("${args[0]}", "", "${args[1]}"))`,
      );
    } else if (line.startsWith("divisor")) {
      code.push(
        `    ${innerVar} = concatenar(${innerVar}, estructura_divisor())`,
      );
    }
    i += 1;
  }
  if (type === "columna") {
    code.push(`    texto ${blockVar} = estructura_columna(${innerVar})`);
  } else if (type === "fila") {
    code.push(`    texto ${blockVar} = estructura_fila(${innerVar})`);
  } else if (type === "tarjeta") {
    if (variant)
      code.push(
        `    texto ${blockVar} = estructura_tarjeta_visual("${title}", "${variant}", ${innerVar})`,
      );
    else
      code.push(
        `    texto ${blockVar} = estructura_tarjeta("${title}", ${innerVar})`,
      );
  } else if (type === "campo") {
    code.push(
      `    texto ${blockVar} = estructura_campo("${title}", ${innerVar})`,
    );
  } else if (type === "panel_seguro") {
    const panelId = title || "panel";
    code.push(
      `    texto ${blockVar} = estructura_panel_seguro("${panelId}", ${innerVar})`,
    );
  } else if (type === "panel_seguro_oculto") {
    const panelId = title || "panel";
    code.push(
      `    texto ${blockVar} = estructura_panel_seguro_oculto("${panelId}", ${innerVar})`,
    );
  } else {
    code.push(`    texto ${blockVar} = ${innerVar}`);
  }
  return { code, nextIndex: i + 1, varName: blockVar };
}

function buildViewFunction(view) {
  const lines = view.safeBody.split(/\r?\n/);
  const start = lines.findIndex((line) => line.trim());
  const state = { counter: 0 };
  const block =
    start >= 0
      ? buildUiBlock(lines, start, state)
      : { code: ['    texto jd_bloque_0 = ""'], varName: "jd_bloque_0" };
  const out = [`funcion jd_vista_${view.name}(texto solicitud) retorna texto`];
  out.push(...block.code);
  out.push(`    texto cuerpo = ${block.varName}`);
  for (const raw of view.jasbCode.split(/\r?\n/)) {
    const normalized = normalizeJasbLine(raw);
    if (normalized) out.push(`    ${normalized}`);
  }
  out.push("    retornar cuerpo");
  out.push("fin_funcion");
  out.push("");
  return out;
}

function parseThemeExpr(body) {
  const defaults = {
    primario: "#2563eb",
    secundario: "#0f172a",
    fondo: "#f8fafc",
    texto: "#0f172a",
    radio: "16px",
    espacio: "16px",
  };
  for (const raw of body.split(/\r?\n/)) {
    const line = raw.trim();
    const m = line.match(/^([a-z_]+)\s*:\s*"([^"]*)"$/i);
    if (m && Object.prototype.hasOwnProperty.call(defaults, m[1]))
      defaults[m[1]] = m[2];
  }
  return `estructura_tema("${defaults.primario}", "${defaults.secundario}", "${defaults.fondo}", "${defaults.texto}", "${defaults.radio}", "${defaults.espacio}")`;
}

function transpileJdToJasb(sourceText, options) {
  const estructuraImport = options.estructura.replace(/\\/g, "/");
  const uiImport = options.ui.replace(/\\/g, "/");
  const apiImport = options.apiBasica.replace(/\\/g, "/");
  const lines = sourceText.split(/\r?\n/);
  const views = [];
  const extraImports = [];
  let app = {
    name: "EstructaJD",
    body: "",
    themeName: "",
    port: 18230,
    routes: [],
  };
  let theme = null;

  for (let i = 0; i < lines.length; ) {
    const trimmed = lines[i].trim();
    if (!trimmed || trimmed.startsWith("#") || trimmed === "usar estructa") {
      i += 1;
      continue;
    }
    let importMatch = trimmed.match(/^usar\s+todas\s+de\s+"([^"]+)"$/);
    if (importMatch) {
      extraImports.push(importMatch[1]);
      i += 1;
      continue;
    }
    let m = trimmed.match(/^tema\s+([A-Za-z_][A-Za-z0-9_]*)\s*\{$/);
    if (m) {
      const block = captureBlock(lines, i);
      theme = { name: m[1], expr: parseThemeExpr(block.body) };
      i = block.nextIndex;
      continue;
    }
    m = trimmed.match(/^vista\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(([^)]*)\)\s*\{$/);
    if (m) {
      const block = captureBlock(lines, i);
      const parts = splitJasbBlocks(block.body);
      views.push({ name: m[1], safeBody: parts.safe, jasbCode: parts.jasb });
      i = block.nextIndex;
      continue;
    }
    m = trimmed.match(/^app\s+([A-Za-z_][A-Za-z0-9_]*)\s*\{$/);
    if (m) {
      const block = captureBlock(lines, i);
      app.name = m[1];
      app.body = block.body;
      const themeMatch = block.body.match(
        /usar\s+tema\s+([A-Za-z_][A-Za-z0-9_]*)/,
      );
      app.themeName = themeMatch ? themeMatch[1] : "";
      const portMatch = block.body.match(/puerto:\s*(\d+)/);
      app.port = portMatch ? Number(portMatch[1]) : 18230;
      app.routes = [
        ...block.body.matchAll(/"([^"]+)"\s*=>\s*([A-Za-z_][A-Za-z0-9_]*)/g),
      ].map((x) => ({ route: x[1], view: x[2] }));
      i = block.nextIndex;
      continue;
    }
    i += 1;
  }

  const imports = [
    `usar todas de "${apiImport}"`,
    `usar todas de "${estructuraImport}"`,
    `usar todas de "${uiImport}"`,
    "",
  ];
  const out = [...imports];
  for (const extraImport of extraImports) {
    out.push(`usar todas de "${extraImport.replace(/\\/g, "/")}"`);
  }
  if (extraImports.length > 0) out.push("");
  if (theme && app.themeName && theme.name === app.themeName) {
    out.push("funcion jd_tema_activo() retorna texto");
    out.push(`    retornar ${theme.expr}`);
    out.push("fin_funcion");
    out.push("");
  }
  for (const view of views) out.push(...buildViewFunction(view));
  out.push("funcion jd_app(texto solicitud) retorna texto");
  out.push('    texto nav = ""');
  for (const route of app.routes) {
    out.push(
      `    nav = concatenar(nav, "<a data-estructa-ruta=\\"${route.route}\\" href=\\"${route.route}\\">${route.view}</a>")`,
    );
  }
  out.push("    texto ruta = estructura_ruta_sin_query(solicitud)");
  out.push('    si api_metodo(solicitud) == "GET" entonces');
  for (const route of app.routes) {
    out.push(`        si ruta == "${route.route}" entonces`);
    if (theme && app.themeName && theme.name === app.themeName) {
      out.push(
        `            retornar estructura_responder_tema("${app.name}", nav, jd_vista_${route.view}(solicitud), jd_tema_activo())`,
      );
    } else {
      out.push(
        `            retornar estructura_responder("${app.name}", nav, jd_vista_${route.view}(solicitud))`,
      );
    }
    out.push("        fin_si");
  }
  out.push("    fin_si");
  if (theme && app.themeName && theme.name === app.themeName) {
    out.push(
      `    retornar estructura_no_encontrado_tema("${app.name}", nav, jd_tema_activo())`,
    );
  } else {
    out.push(`    retornar estructura_no_encontrado("${app.name}", nav)`);
  }
  out.push("fin_funcion");
  out.push("");
  out.push("principal");
  out.push(`    socket srv = tcp_escuchar("127.0.0.1", ${app.port})`);
  out.push("    entero i = 0");
  out.push(`    imprimir "${app.name}"`);
  out.push(`    imprimir "app jd activa en http://127.0.0.1:${app.port}"`);
  out.push("    si srv == 0 entonces");
  out.push(
    `        imprimir api_alerta_puerto_en_uso("127.0.0.1", ${app.port}, "HTTP")`,
  );
  out.push("    sino");
  out.push("        mientras i < 100 hacer");
  out.push("            socket cli = tcp_aceptar(srv)");
  out.push("            si cli == 0 entonces");
  out.push("            sino");
  out.push(
    "                texto solicitud_http = api_leer_solicitud_http(cli)",
  );
  out.push("                texto respuesta = jd_app(solicitud_http)");
  out.push("                api_tcp_enviar_texto_completo(cli, respuesta)");
  out.push("                tcp_cerrar(cli)");
  out.push("                i = i + 1");
  out.push("            fin_si");
  out.push("        fin_mientras");
  out.push("        tcp_cerrar(srv)");
  out.push("    fin_si");
  out.push("fin_principal");
  return out.join("\n");
}

function runJdFlow(jbc, absFile) {
  const runtime = path.join(
    workspaceRoot,
    "stdlib",
    "Estructa",
    "codigo-jasb",
    "jd_runtime.jasb",
  );
  const estructura = path.join(
    workspaceRoot,
    "stdlib",
    "Estructa",
    "codigo-jasb",
    "estructura.jasb",
  );
  const ui = path.join(
    workspaceRoot,
    "stdlib",
    "Estructa",
    "codigo-jasb",
    "ui.jasb",
  );
  const apiBasica = path.join(
    workspaceRoot,
    "stdlib",
    "api",
    "api_basica.jasb",
  );
  const generatedFile = absFile.replace(/\.jd$/i, ".generado.jasb");
  const sourceText = fs.readFileSync(absFile, "utf8");
  const generatedText = transpileJdToJasb(sourceText, {
    estructura,
    runtime,
    ui,
    apiBasica,
  });
  fs.writeFileSync(generatedFile, generatedText, "utf8");

  const runGenerated = spawnSync(jbc, [generatedFile, "-e"], {
    stdio: "inherit",
    cwd: workspaceRoot,
    env: childEnv,
    shell: false,
    windowsHide: true,
  });
  process.exit(
    runGenerated.status !== null && runGenerated.status !== undefined
      ? runGenerated.status
      : 1,
  );
}

function runLinter(filePath, source) {
  const lines = source.split(/\r?\n/);
  let errors = 0;
  let currentClass = null;
  let jmnBalance = 0;
  const classFields = new Map();

  // Pase 1: Identificar campos de clases (solo fuera de funciones)
  let inFunction = false;
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i].trim();
    if (line.startsWith("clase ")) {
      currentClass = line.split(/\s+/)[1];
      classFields.set(currentClass, new Set());
    } else if (line === "fin_clase") {
      currentClass = null;
    } else if (/\bfuncion\s+/.test(line)) {
      inFunction = true;
    } else if (line === "fin_funcion") {
      inFunction = false;
    } else if (
      currentClass &&
      !inFunction &&
      /\b(entero|texto|lista|mapa|flotante|decimal|bool|u32|u64|u8|byte|bytes|vec2|vec3|vec4|mat3|mat4)\s+/.test(
        line,
      )
    ) {
      const parts = line.split(/\s+/);
      // Saltar visibilidad si existe (privado/publico)
      let nameIdx = 1;
      if (parts[0] === "privado" || parts[0] === "publico") nameIdx = 2;
      if (parts.length > nameIdx) {
        const field = parts[nameIdx].split("=")[0].trim();
        classFields.get(currentClass).add(field);
      }
    }
  }

  // Pase 2: Validar buenas practicas
  currentClass = null;
  let currentFuncParams = new Set();
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i].trim();
    const lineNum = i + 1;

    if (line.startsWith("clase ")) {
      currentClass = line.split(/\s+/)[1];
    } else if (line === "fin_clase") {
      currentClass = null;
    }

    if (/\bfuncion\s+/.test(line)) {
      // Extraer nombres de parametros
      const paramMatch = line.match(/\(([^)]*)\)/);
      if (paramMatch) {
        const paramsStr = paramMatch[1];
        const params = paramsStr
          .split(",")
          .map((p) => {
            const parts = p.trim().split(/\s+/);
            // Ignorar tipo, tomar nombre
            let nIdx = 1;
            if (
              parts.length > 0 &&
              (parts[0] === "privado" || parts[0] === "publico")
            )
              nIdx = 2; // No aplica a params pero por si acaso
            return parts.length > nIdx ? parts[nIdx].trim() : parts[0].trim();
          })
          .filter((p) => p !== null && p !== "");
        currentFuncParams = new Set(params);
      }
      inFunction = true;
    } else if (line === "fin_funcion") {
      currentFuncParams = new Set();
      inFunction = false;
    }

    // 1. Balance de memoria JMN
    if (line.includes("crear_memoria(") || line.includes("abrir_memoria("))
      jmnBalance++;
    if (line.includes("cerrar_memoria(")) jmnBalance--;

    // 2. Exportaciones redundantes
    if (line.startsWith("enviar {")) {
      const content = line.match(/\{([^}]*)\}/);
      if (content) {
        const names = content[1].split(",").map((n) => n.trim());
        for (const name of names) {
          if (name.includes("_")) {
            const prefix = name.split("_")[0];
            if (classFields.has(prefix)) {
              console.error(
                `\x1b[31m${filePath}, linea ${lineNum}: error de seguridad: la exportacion de '${name}' es redundante; exporte la clase '${prefix}' completa.\x1b[0m`,
              );
              errors++;
            }
          }
        }
      }
    }

    // 3. Uso obligatorio de este. (Solo en metodos)
    if (
      currentClass &&
      !line.startsWith("funcion ") &&
      !line.startsWith("fin_funcion") &&
      !line.startsWith("#")
    ) {
      const fields = classFields.get(currentClass);

      // Ignorar literales de texto para evitar falsos positivos
      let lineForCheck = line.replace(/"[^"]*"/g, '""');

      for (const field of fields) {
        // Si el nombre coincide con un parametro de la funcion actual, tiene prioridad el parametro (shadowing)
        if (currentFuncParams.has(field)) continue;

        // Regex para encontrar el campo como palabra completa pero no precedido por 'este.'
        const regex = new RegExp(`(?<!este\\.)\\b${field}\\b`, "g");
        if (
          regex.test(lineForCheck) &&
          !line.startsWith("entero ") &&
          !line.startsWith("texto ") &&
          !line.startsWith("lista ") &&
          !line.startsWith("mapa ") &&
          !line.startsWith("flotante ")
        ) {
          // Ignorar si es una declaracion local (aproximado)
          if (
            !/\b(entero|texto|lista|mapa|flotante|si|mientras|para)\s+/.test(
              line,
            )
          ) {
            console.error(
              `\x1b[31m${filePath}, linea ${lineNum}: error de seguridad: el campo '${field}' debe accederse con 'este.${field}' dentro de la clase '${currentClass}'.\x1b[0m`,
            );
            errors++;
          }
        }
      }
    }
  }

  if (jmnBalance !== 0) {
    console.warn(
      `\x1b[33m${filePath}: advertencia: se han encontrado llamadas a 'crear_memoria' o 'abrir_memoria' sin su correspondiente 'cerrar_memoria' (Ciclo de vida dinamico activo).\x1b[0m`,
    );
    // No incrementamos errors para permitir compilacion dinamica
  }

  return errors;
}

const cliArgs = process.argv.slice(2);
/** Nivel opcional para `JASBOOT_PROPAGAR_AUDIT` al ejecutar la VM (stderr por propagación). */
let propagarAuditCli = undefined;
for (const a of cliArgs) {
  const m = /^--propagar-audit=(\d+)$/.exec(a);
  if (m) propagarAuditCli = m[1];
}
const aotMode = cliArgs.some((a) => a === "--aot" || a === "-aot");
const compileOnly =
  cliArgs.some((a) => a === "--compile-only" || a === "-c") && !aotMode;
const fileArg = cliArgs.find(
  (a) =>
    a &&
    !String(a).startsWith("-") &&
    (String(a).toLowerCase().endsWith(".jasb") ||
      String(a).toLowerCase().endsWith(".jd")),
);
if (
  !fileArg ||
  (!String(fileArg).toLowerCase().endsWith(".jasb") &&
    !String(fileArg).toLowerCase().endsWith(".jd"))
) {
  console.error(
    "Uso: node .vscode/run-jasb.cjs <archivo.jasb|archivo.jd> [--aot] [--compile-only|-c] [--propagar-audit=N]\n" +
      "  (sin --aot) F5 / VM: compila con jbc y ejecuta .jbo con la VM.\n" +
      "  --compile-only | -c  Solo jbc → .jbo; no ejecuta la VM (CI / chequeo rapido).\n" +
      "  --aot  F6 / transpilador: ejecuta jbc-to-c (Jasboot→C) con -e.\n" +
      "  --propagar-audit=N  Activa auditoria VM de propagacion (stderr); sin esto se fuerza JASBOOT_PROPAGAR_AUDIT=0\n" +
      "    para no heredar un valor ruidoso del shell. Para heredar el entorno: JASBOOT_PROPAGAR_AUDIT_FROM_PARENT=1.\n" +
      "  Abre un .jasb o .jd y pulsa F5, o pasa la ruta al archivo.",
  );
  process.exit(1);
}

if (aotMode && cliArgs.some((a) => a === "--compile-only" || a === "-c")) {
  console.error("\x1b[31mNo combine --aot con --compile-only.\x1b[0m");
  process.exit(1);
}

const absFile = path.resolve(fileArg);
if (!fs.existsSync(absFile)) {
  console.error("No existe el archivo:", absFile);
  process.exit(1);
}

const source = fs.readFileSync(absFile, "utf8");

// Ejecutar linter antes de compilar
if (runLinter(absFile, source) > 0) {
  console.error(
    "\x1b[31mCompilacion abortada por errores de seguridad.\x1b[0m",
  );
  process.exit(1);
}

if (aotMode) {
  if (!String(absFile).toLowerCase().endsWith(".jasb")) {
    console.error(
      "\x1b[31mModo AOT (--aot): solo archivos .jasb (el transpilador no aplica a .jd).\x1b[0m",
    );
    process.exit(1);
  }
  const j2c = findJbcToC();
  if (!j2c) {
    console.error(
      "No se encuentra jbc-to-c (transpilador AOT).\n" +
        "  Construyalo en sdk-dependiente\\jasboot-to-c o defina JASBOOT_JBC_TO_C con la ruta al ejecutable.",
    );
    process.exit(1);
  }
  console.log(`\x1b[36mAOT (transpilador C):\x1b[0m ${j2c}`);
  const aotCwd = path.dirname(absFile);
  const aotResult = spawnSync(j2c, [absFile, "-e"], {
    stdio: "inherit",
    cwd: aotCwd,
    env: childEnv,
    shell: false,
    windowsHide: true,
  });
  process.exit(
    aotResult.status !== null && aotResult.status !== undefined
      ? aotResult.status
      : 1,
  );
}

const jbc = findJbc();
if (!jbc) {
  console.error(
    "No se encuentra jbc. Ejecute build en jas-compiler-c:\n" +
      "  sdk\\jas-compiler-c\\build.bat\n" +
      "  o sdk-dependiente\\jas-compiler-c\\build.bat",
  );
  process.exit(1);
}

if (String(absFile).toLowerCase().endsWith(".jd")) {
  runJdFlow(jbc, absFile);
}

// 1. Compilar primero (genera el .jbo)
console.log(`Compilando: ${absFile}...`);
const compResult = spawnSync(jbc, [absFile], {
  stdio: "inherit",
  cwd: workspaceRoot,
  env: childEnv,
  shell: false,
  windowsHide: true,
});

if (compResult.status !== 0) {
  process.exit(compResult.status !== null ? compResult.status : 1);
}

if (compileOnly && String(absFile).toLowerCase().endsWith(".jasb")) {
  console.log(
    "\x1b[36mSolo compilacion (--compile-only)\x1b[0m: .jbo generado; no se ejecuta la VM.",
  );
  process.exit(0);
}

// 2. Ejecutar con la VM si la compilación tuvo éxito
const jboFile = absFile.replace(/\.jasb$/i, ".jbo");
const vm = findVm();

if (vm && fs.existsSync(jboFile)) {
  console.log(`Ejecutando con VM: ${vm}`);
  // --continuo evita terminar la VM cuando stdin reporta EOF transitorio
  // (comun en algunas sesiones PowerShell interactivas).
  // Con depurador JS, `stdin.isTTY` suele ser false aunque la consola sea interactiva;
  // sin --continuo el segundo `ingresar_texto` ve EOF y la VM sale sin volver al bucle.
  // Si stdin viene por pipe/archivo real, desactivar con JASBOOT_VM_NO_CONTINUO=1.
  const useContinuo =
    process.env.JASBOOT_VM_NO_CONTINUO !== "1" &&
    (process.stdin.isTTY ||
      process.env.JASBOOT_VM_CONTINUO === "1" ||
      Boolean(process.env.VSCODE_INSPECTOR_OPTIONS));
  const vmArgs = useContinuo ? ["--continuo", jboFile] : [jboFile];
  /** cwd del proceso = carpeta del .jasb: rutas relativas (p. ej. tmp_108_fs.bin) quedan junto al fuente, no en la raíz del repo. */
  const vmCwd = path.dirname(absFile);
  const vmEnv = { ...childEnv };
  if (process.env.JASBOOT_PROPAGAR_AUDIT_FROM_PARENT === "1") {
    /* conservar JASBOOT_PROPAGAR_AUDIT del proceso padre (p. ej. shell con AUDIT=1) */
  } else if (propagarAuditCli !== undefined) {
    vmEnv.JASBOOT_PROPAGAR_AUDIT = propagarAuditCli;
  } else {
    vmEnv.JASBOOT_PROPAGAR_AUDIT = "0";
  }
  const child = spawn(vm, vmArgs, {
    stdio: "inherit",
    cwd: vmCwd,
    env: vmEnv,
    shell: false,
    windowsHide: true,
  });
  child.on("error", (err) => {
    console.error(
      `Error ejecutando VM: ${err && err.message ? err.message : err}`,
    );
    process.exit(1);
  });
  child.on("exit", (code) => {
    process.exit(code !== null && code !== undefined ? code : 1);
  });
} else {
  console.error(`Error: No se encontró la VM o el archivo .jbo (${jboFile}).`);
  process.exit(1);
}
