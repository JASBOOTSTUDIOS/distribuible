# JASBOOT PACKAGE MANAGER (jpm) - Diseño y Especificación

## Visión General

Un sistema de gestión de paquetes similar a npm para Jasboot que permita:
- Instalar dependencias externas
- Publicar paquetes comunitarios
- Gestionar versiones
- Resolución automática de dependencias

## Estructura Propuesta

### 1. Formato de Paquete (.jpkg)

```
mi-paquete-1.2.3.jpkg (formato ZIP)
├── jasboot.json          # Metadatos del paquete
├── src/                 # Código fuente
│   ├── main.jasb        # Punto de entrada principal
│   └── modulo1.jasb     # Módulos adicionales
├── docs/                # Documentación opcional
├── examples/            # Ejemplos de uso
└── tests/               # Tests del paquete
```

### 2. Archivo de Metadatos (jasboot.json)

```json
{
  "nombre": "analitica-neuronal",
  "version": "1.0.0",
  "descripcion": "Librería de análisis predictivo con redes neuronales",
  "autor": "JASBOOTSTUDIOS",
  "licencia": "MIT",
  "principal": "src/main.jasb",
  "dependencias": {
    "logging": "^1.0.0",
    "matematicas": "^2.1.0"
  },
  "devDependencias": {
    "testing": "^0.5.0"
  },
  "scripts": {
    "probar": "jpm test",
    "construir": "jpm build"
  },
  "repositorio": {
    "tipo": "git",
    "url": "https://github.com/JASBOOTSTUDIOS/analitica-neuronal"
  },
  "palabrasClave": ["ia", "neuronal", "prediccion", "analisis"],
  "jasbootVersion": ">=1.0.0"
}
```

### 3. Comandos del Gestor de Paquetes (jpm)

#### Comandos Básicos
```bash
# Inicializar un nuevo paquete
jpm init

# Instalar dependencias
jpm install
jpm install <paquete>
jpm install <paquete>@<version>

# Instalar dependencias de desarrollo
jpm install --dev <paquete>

# Publicar un paquete
jpm publish

# Buscar paquetes
jpm search <termino>

# Información de un paquete
jpm info <paquete>

# Listar paquetes instalados
jpm list

# Actualizar paquetes
jpm update
jpm update <paquete>

# Desinstalar
jpm uninstall <paquete>
```

#### Comandos de Desarrollo
```bash
# Ejecutar tests
jpm test

# Construir paquete
jpm build

# Ejecutar script personalizado
jpm run <script>

# Validar paquete
jpm validate

# Limpiar cache
jpm clean
```

### 4. Sistema de Dependencias

#### Archivo de Dependencias (jasboot.lock)
```json
{
  "version": "1.0.0",
  "dependencias": {
    "analitica-neuronal": {
      "version": "1.2.3",
      "resuelto": "1.2.3",
      "integridad": "sha512:abc123...",
      "ruta": "node_modules/analitica-neuronal"
    },
    "logging": {
      "version": "^1.0.0",
      "resuelto": "1.1.0",
      "integridad": "sha512:def456...",
      "ruta": "node_modules/logging"
    }
  }
}
```

#### Resolución de Versiones
- **Exacta**: `1.2.3` - Solo esa versión
- **Caret**: `^1.2.3` - Compatible hacia adelante (1.x.x)
- **Tilde**: `~1.2.3` - Compatible a nivel de patch (1.2.x)
- **Rango**: `>=1.0.0 <2.0.0` - Rango específico
- **Latest**: `*` o `latest` - Última versión

### 5. Integración con Jasboot

#### Importación Mejorada
```jasb
# Importación tradicional (sigue funcionando)
usar {funcion} de "stdlib/analitica-neuronal/analitica.jasb"

# Importación con jpm
usar {regresion_lineal} de "analitica-neuronal"
usar {logger} de "logging"

# Importación con alias
usar {regresion_lineal as rl} de "analitica-neuronal"

# Importación de todo el módulo
usar "analitica-neuronal" como analitica
```

#### Configuración del Proyecto
```json
{
  "nombre": "mi-proyecto",
  "version": "1.0.0",
  "dependencias": {
    "analitica-neuronal": "^1.0.0",
    "logging": "^1.0.0"
  },
  "jpm": {
    "registry": "https://registry.jasboot.org",
    "cache": "./.jpm-cache",
    "autoInstall": true
  }
}
```

### 6. Repositorio Central

#### Registro de Paquetes
- **URL**: `https://registry.jasboot.org`
- **API RESTful** para búsqueda y descarga
- **Autenticación** con tokens para publicación
- **Validación** automática de paquetes

#### Características del Registro
- Búsqueda full-text
- Filtrado por categorías
- Estadísticas de descarga
- Calificación y reseñas
- Verificación de seguridad

### 7. Flujo de Trabajo

#### Desarrollo de Paquete
1. `jpm init` - Crear estructura
2. Escribir código en `src/`
3. `jpm test` - Probar funcionalidad
4. `jpm build` - Construir paquete
5. `jpm publish` - Publicar al registro

#### Uso en Proyecto
1. `jpm install <paquete>` - Instalar dependencia
2. `usar {funcion} de "<paquete>"` - Importar en código
3. `jbc mi_programa.jasb` - Compilar normalmente
4. `jasboot-ir-vm mi_programa.jbo` - Ejecutar

### 8. Características Avanzadas

#### Scripts Personalizados
```json
{
  "scripts": {
    "dev": "jpm run dev-server",
    "build": "jpm build && jpm test",
    "deploy": "jpm build && scp build/*.jpkg server:/opt/jasboot/"
  }
}
```

#### Workspaces (Monorepos)
```json
{
  "workspaces": [
    "packages/*",
    "apps/*"
  ]
}
```

#### Hooks del Ciclo de Vida
```json
{
  "hooks": {
    "preinstall": "echo 'Instalando dependencias...'",
    "postinstall": "jpm run build-native",
    "prepublish": "jpm test && jpm lint",
    "postpublish": "echo 'Publicado exitosamente!'"
  }
}
```

### 9. Seguridad

#### Verificación de Integridad
- Hash SHA-512 para cada paquete
- Firma digital opcional
- Validación de dependencias transitivas

#### Control de Acceso
- Tokens de API para publicación
- Roles y permisos
- Auditoría de cambios

### 10. Herramientas Adicionales

#### jpm doctor
Diagnóstico del entorno y configuración

#### jpm audit
Análisis de seguridad de dependencias

#### jpm outdated
Paquetes con actualizaciones disponibles

#### jpm pack
Crear paquete local sin publicar

## Implementación Sugerida

### Fase 1: Básico
- Formato de paquete .jpkg
- Comandos: init, install, publish
- Registro básico

### Fase 2: Avanzado
- Resolución de versiones
- Scripts y hooks
- Cache local

### Fase 3: Ecosistema
- Workspaces
- Seguridad avanzada
- Herramientas de diagnóstico

## Beneficios

1. **Modularidad**: Código reutilizable y compartible
2. **Colaboración**: Ecosistema de paquetes comunitarios
3. **Versionado**: Gestión controlada de cambios
4. **Automatización**: Instalación y resolución automática
5. **Calidad**: Validación y testing integrado
6. **Descubrimiento**: Fácil encontrar y usar librerías

## Consideraciones Técnicas

- **Rendimiento**: Cache inteligente y descarga paralela
- **Compatibilidad**: Retrocompatibilidad con `usar` tradicional
- **Offline**: Modo offline para paquetes cacheados
- **Multiplataforma**: Windows, Linux, macOS
- **Integración IDE**: Autocompletado y navegación

---

Este diseño proporciona una base sólida para un sistema de gestión de paquetes robusto y moderno para Jasboot, inspirado en las mejores prácticas de npm pero adaptado al ecosistema Jasboot.
