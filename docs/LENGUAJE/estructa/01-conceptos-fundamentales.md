# 🧠 Conceptos Fundamentales de Estructa

**Base teórica y filosófica de la librería**

---

## 🎯 Visión General

Estructa transforma la forma en que creamos interfaces de usuario:

**De esto:**
```html
<div class="container">
  <h1 style="color: red; font-size: 24px;">Título</h1>
  <button onclick="alert('Hola')">Click</button>
</div>
```

**A esto:**
```jasboot
contenedor {
    titulo color: rojo tamaño: 24 "Título"
    boton "Click" { al_presionar { alerta("Hola") } }
}
```

---

## 🏗️ Arquitectura Mental

### 🔄 Pipeline de Transpilación

```
Jasboot (Estructa) → AST → IR → HTML/JS → Navegador
```

### 📦 Capas del Sistema

1. **Lenguaje** - Sintaxis en español natural
2. **Componentes** - Bloques reutilizables
3. **Estado** - Datos reactivos
4. **Eventos** - Interacciones del usuario
5. **Estilos** - Visual sin CSS
6. **Layout** - Estructura y posicionamiento

---

## 🎨 Filosofía de Diseño

### ✅ Principios Fundamentales

#### 🌿 **Naturaleza Española**
- Todas las palabras clave en español
- Terminología intuitiva y natural
- Sin anglicismos técnicos

```jasboot
// ✅ Natural
texto "Hola mundo"
boton "Guardar"
contenedor clase: "tarjeta"

// ❌ Artificial
text "Hello world"
button "Save"
div class="card"
```

#### 🎯 **Declarativo Puro**
- Describes QUÉ quieres, no CÓMO hacerlo
- El sistema se encarga del CÓMO
- Sin manipulación directa del DOM

```jasboot
// ✅ Declarativo
texto "Contenido" {
    color: rojo
    tamaño: 20
}

// ❌ Imperativo
let p = document.createElement("p")
p.textContent = "Contenido"
p.style.color = "red"
p.style.fontSize = "20px"
```

#### ⚡ **Reactividad Automática**
- El estado actualiza la UI automáticamente
- Sin `render()` manual
- Sin `setState()` explícito

```jasboot
estado busqueda = ""

texto "Resultados para: " + busqueda

boton "Sumar" {
    al_presionar { busqueda = "nuevo valor" }  // UI se actualiza automáticamente
}
```

#### 🎨 **Estilos Integrados**
- Los estilos son propiedades del lenguaje
- Sin archivos CSS separados
- Sin conflictos de especificidad

```jasboot
// ✅ Estilos como propiedades
texto "Importante" {
    color: rojo
    peso: negrita
    tamaño: 18
}
```

---

## 🧩 Bloques de Construcción

### 📦 **Componentes**
Unidades reutilizables de UI:

```jasboot
componente Tarjeta(titulo, descripcion) {
    contenedor clase: "tarjeta" {
        titulo nivel: 2 titulo
        texto descripcion
    }
}
```

### 🔄 **Estado**
Datos que cambian y actualizan la UI:

```jasboot
estado usuario = { nombre: "Juan", edad: 25 }
estado cargando = falso
```

### ⚡ **Eventos**
Interacciones del usuario:

```jasboot
boton "Guardar" {
    al_presionar { guardar_datos() }
    al_hover { mostrar_tooltip() }
}
```

### 🎨 **Estilos**
Apariencia visual:

```jasboot
texto "Importante" {
    color: rojo
    peso: negrita
    tamaño: 18
}
```

---

## 🔄 Modelo Mental Reactivo

### 📊 **Flujo de Datos**

```
Usuario interactúa → Evento se dispara → Estado cambia → UI se actualiza
```

### 🎯 **Single Source of Truth**

El estado es la única fuente de verdad:

```jasboot
estado busqueda = ""

campo_texto valor: busqueda {
    al_cambiar { busqueda = valor }
}

lista {
    para cada item en filtrar(productos, busqueda) {
        texto item.nombre
    }
}
```

---

## 🚀 Características Únicas

### 🤖 **Estilos Inteligentes**
IA que genera estilos automáticamente:

```jasboot
boton "Comprar" {
    estilo_auto: "moderno, atractivo, fintech"
}
```

### 🌐 **Routing Integrado**
- Navegación sin configuración
- URLs amigables
- Parámetros dinámicos

```jasboot
boton "Ir a perfil" {
    al_presionar { navegar "/perfil" }
}
```

### 📱 **Responsive Nativo**
- Diseño adaptativo sin media queries
- Breakpoints integrados
- Layout flexible

```jasboot
contenedor {
    movil { columna }
    escritorio { fila }
}
```

---

## 🎯 Metáforas Conceptuales

### 🏠 **Casa como Componente**
- **Fundación** = Estado
- **Paredes** = Layout
- **Pintura** = Estilos
- **Electricidad** = Eventos
- **Muebles** = Componentes hijos

### 📖 **Libro como Aplicación**
- **Capítulos** = Páginas/Rutas
- **Párrafos** = Componentes
- **Estilo** = Temas
- **Índice** = Navegación

---

## 🔄 Comparación con Otras Librerías

| Característica | React | Vue | Estructa |
|---|---|---|---|
| Lenguaje | JSX | Template | Jasboot |
| Estilos | CSS-in-JS | Scoped CSS | Integrados |
| Estado | useState | reactive | nativo |
| Eventos | onClick | @click | al_presionar |
| Español | No | No | **Sí** |

---

## 🎯 Beneficios Clave

### 🚀 **Productividad**
- Menos código que escribir
- Sin contexto switching
- Menos errores comunes

### 🧠 **Mantenibilidad**
- Código más legible
- Menos complejidad
- Sin "spaghetti code"

### 🎨 **Consistencia**
- Diseño sistemático
- Sin conflictos de CSS
- Componentes predecibles

---

## 📚 Próximos Pasos

Ahora que entiendes los conceptos fundamentales, continúa con:

1. **[Sintaxis de Componentes](02-sintaxis-componentes.md)** - Cómo definir componentes
2. **[Sintaxis de Estado](03-sintaxis-estado.md)** - Gestión de estado reactivo
3. **[Sintaxis de Eventos](04-sintaxis-eventos.md)** - Manejo de interacciones

---

*Última actualización: Versión 1.0.0*
