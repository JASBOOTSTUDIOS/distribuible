=============================================
                JASBOOT SDK v1.0
        Lenguaje de Programacion en Espanol
=============================================

INSTALACION RAPIDA
──────────────────────────────────────────────────────────────
1. Descomprimir este paquete en una carpeta (ej: C:\Jasboot)
2. Opcional: Agregar C:\Jasboot\bin al PATH del sistema
3. Listo para usar!

ESTRUCTURA DE ARCHIVOS
──────────────────────────────────────────────────────────────
bin/            → Ejecutables principales
├── jbc.exe                    → Compilador Jasboot
├── jasboot-ir-vm.exe          → Maquina Virtual
└── jb.cmd                     → Script de ejecucion

runtime/        → Librerias del runtime
└── jasboot_win32_bridge.dll   → Bridge con sistema Windows

examples/       → Ejemplos para empezar
├── hola.jasb                  → Programa "Hola Mundo"
└── calculadora.jasb           → Demostracion matematica

docs/           → Documentacion
└── README.txt                 → Este archivo

config/         → Configuracion
└── jasboot.conf               → Configuracion del sistema

COMANDOS BASICOS
──────────────────────────────────────────────────────────────
# Compilar un programa:
jbc.exe mi_programa.jasb

# Ejecutar un programa compilado:
jasboot-ir-vm.exe build/mi_programa.jbo

# Compilar y ejecutar en un paso:
jb.cmd mi_programa.jasb

# Probar la instalacion:
jb.cmd examples/hola.jasb

EXTENSION VS CODE
──────────────────────────────────────────────────────────────
El SDK incluye una extension completa para Visual Studio Code:

• Resaltado de sintaxis completo
• Autocompletado de palabras clave
• Snippets para estructuras comunes
• Integracion con compilador y VM
• Depuracion y navegacion de codigo

Instalacion:
1. Abre VS Code
2. Ve a Extensiones (Ctrl+Shift+X)
3. Haz clic en (...) → "Install from Extension Location..."
4. Selecciona la carpeta: vscode-extension/
5. Recarga VS Code

Consulta INSTALL_VSCODE.md para mas detalles.

CARACTERISTICAS PRINCIPALES
──────────────────────────────────────────────────────────────
• Lenguaje 100% en espanol
• Memoria Neuronal (JMN) para IA
• Compilacion a bytecode optimizado
• Sin dependencias externas
• Compatible con Windows 7+

EJEMPLO DE CODIGO
──────────────────────────────────────────────────────────────
principal
    imprimir "¡Hola desde Jasboot!"
    entero x = 42
    imprimir "El valor es: " + x
fin_principal

CONFIGURACION
──────────────────────────────────────────────────────────────
Editar config/jasboot.conf para personalizar:
• Limites de memoria
• Rutas de trabajo
• Opciones del compilador

AYUDA Y SOPORTE
──────────────────────────────────────────────────────────────
• Documentacion completa: https://docs.jasboot.org
• Repositorio: https://github.com/JASBOOTSTUDIOS/jasboot
• Issues: https://github.com/JASBOOTSTUDIOS/jasboot/issues

LICENCIA
──────────────────────────────────────────────────────────────
Este software esta distribuido bajo licencia MIT.
Ver archivo LICENSE para mas detalles.

¡Gracias por usar Jasboot! 
El equipo de Jasboot Development
