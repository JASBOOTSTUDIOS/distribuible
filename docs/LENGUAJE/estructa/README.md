# 📚 Estructa UI - Documentación Oficial

**Librería de UI declarativa para Jasboot**

---

## 🎯 ¿Qué es Estructa?

Estructa es la **librería de interfaz de usuario** para Jasboot que permite:

- **UI declarativa** en español natural
- **Estado reactivo** automático  
- **Estilos integrados** sin CSS
- **Componentes reutilizables**
- **Transpilación directa** a HTML/JS

---

## 📖 Estructura de esta Documentación

### 🧠 **Conceptos Fundamentales**
- `01-conceptos-fundamentales.md` - Base teórica y filosofía

### 🏗️ **Sintaxis Core**
- `02-sintaxis-componentes.md` - Definición de componentes
- `03-sintaxis-estado.md` - Gestión de estado reactivo
- `04-sintaxis-eventos.md` - Manejo de eventos

### 🎨 **Sistema de Estilos**
- `05-sintaxis-estilos.md` - Estilos inline y propiedades
- `06-sistema-clases.md` - Clases y estilos reutilizables
- `07-estilos-estado.md` - Hover, focus, active
- `08-sistema-temas.md` - Temas globales
- `09-layout-sistema.md` - Layout y posicionamiento

### 🚀 **Características Avanzadas**
- `10-routing-navegacion.md` - Sistema de routing
- `11-transpilacion.md` - Proceso de transpilación
- `12-mapeo-completo.md` - Mapeo Jasboot → HTML/JS

### 🔧 **Referencia Completa**
- `13-referencia-rapida.md` - Cheat sheet completo
- `14-ejemplos-completos.md` - Ejemplos del mundo real

---

## 🎯 Filosofía de Diseño

### ✅ Principios

1. **Español natural** - Todas las palabras clave en español
2. **Cero HTML** - Nunca escribes HTML directamente
3. **Cero CSS** - Los estilos son propiedades del lenguaje
4. **Declarativo** - Describes QUÉ, no CÓMO
5. **Reactivo** - El estado actualiza la UI automáticamente

### 🚫 Anti-principios

1. **No mezclar lenguajes** - Sin HTML/CSS/JS crudo
2. **No complejidad innecesaria** - Simple pero poderoso
3. **No comportamiento implícito** - Todo es explícito y claro

---

## 🔄 Flujo de Trabajo

1. **Escribir** código Jasboot con Estructa
2. **Transpilar** a HTML/JS optimizado
3. **Ejecutar** en cualquier navegador moderno

---

## 🎯 Ejemplo Rápido

```jasboot
componente Tarjeta(titulo, descripcion) {
    contenedor clase: "tarjeta" {
        titulo nivel: 2 titulo
        texto descripcion
    }
}

aplicacion MiApp

iniciar {
    ventana Principal {
        titulo nivel: 1 "Mi App"
        
        Tarjeta("Usuarios", "Gestión de usuarios")
        
        boton "Clicks: " + contador {
            al_presionar { contador++ }
        }
    }
}
```

---

## 📚 Siguiente Paso

Empieza con **[Conceptos Fundamentales](01-conceptos-fundamentales.md)** para entender la base, luego avanza por los archivos en orden numérico.

---

*Última actualización: Versión 1.0.0*
