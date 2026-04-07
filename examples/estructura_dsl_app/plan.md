# Estructa V1

## Vision
`Estructa` debe ser una libreria como React, pero mas facil de usar y completamente en espanol.

No debe copiar React literalmente. Debe tomar sus ideas fuertes:
- componentes
- props
- composicion
- rutas
- estado
- eventos

Y quitar su complejidad:
- sin JSX
- sin hooks confusos
- sin varias formas de hacer lo mismo
- sin depender del ecosistema JS para ser util

## Principio rector
El camino principal de `Estructa` debe vivir en Jasboot puro.

Si existe azucar sintactica o un transpIlador futuro, esa capa debe bajar a la API real escrita en Jasboot, no al reves.

## Objetivo de producto
Que un programador hispanohablante pueda crear una app web declarativa pensando asi:
- una app se compone de pantallas
- una pantalla se compone de componentes
- un componente recibe datos
- los eventos cambian estado o navegan
- las rutas muestran una vista concreta

## Modelo mental
`Estructa` debe sentirse asi:

1. Una app define rutas.
2. Cada ruta apunta a una vista.
3. Cada vista se expresa con bloques declarativos cortos.
4. Los componentes se componen de forma natural.
5. El estado se lee y actualiza con helpers claros y en espanol.

## API base esperada
La V1 debe consolidar una API pequena y clara:

- `estructura_texto()`
- `estructura_titulo()`
- `estructura_subtitulo()`
- `estructura_boton()`
- `estructura_boton_ruta()`
- `estructura_boton_alerta()`
- `estructura_entrada()`
- `estructura_campo()`
- `estructura_columna()`
- `estructura_fila()`
- `estructura_tarjeta()`
- `estructura_formulario_get()`
- `estructura_layout_base()`
- `estructura_nav_simple()`
- `estructura_responder()`
- `estructura_resolver_ruta_simple()`

## Sintaxis objetivo
La experiencia deseada debe parecerse a React en poder, pero en espanol, mas simple y mucho menos ceremoniosa.

La capa interna puede seguir viviendo sobre funciones Jasboot, pero la capa visible para el programador debe ser corta y declarativa.

```jasb
componente TarjetaInfo(texto titulo, texto detalle) {
    tarjeta {
        titulo: titulo
        texto detalle
    }
}

vista Inicio(texto solicitud) {
    columna {
        titulo "Inicio"
        texto "Hola desde Estructa"
        boton_ruta "/productos", "Ver productos"
    }
}

app MiApp {
    rutas {
        "/" => Inicio
        "/productos" => Productos
    }
}
```

## Regla de ergonomia
Para apps complejas, `Estructa` debe minimizar:
- `concatenar(...)`
- `texto cuerpo = ...`
- temporales innecesarias
- devoluciones manuales repetitivas

Y debe maximizar:
- bloques declarativos
- composicion natural
- componentes cortos
- anidacion legible
- una sola forma principal de hacer cada cosa

## Capas
`Estructa` debe tener dos capas claras:

- capa interna:
  - funciones Jasboot puras
  - helpers de render
  - helpers de rutas
  - helpers de documento
- capa visible:
  - `componente`
  - `vista`
  - `app`
  - bloques como `columna`, `fila`, `tarjeta`

La capa visible debe bajar a la capa interna, nunca al reves.

## Componentes
Los componentes deben sentirse como bloques declarativos, aunque internamente puedan compilar o bajar a funciones Jasboot.

Reglas:
- reciben parametros o props como argumentos
- retornan `texto`
- se componen llamando otros componentes
- no deben obligar al desarrollador a concatenar manualmente

## Props visuales
Los componentes deben aceptar props semanticas y cortas, no CSS crudo como camino principal.

Props comunes de V1:
- `variante`
- `tamano`
- `espacio`
- `alineacion`
- `ancho`
- `alto`
- `relleno`
- `borde`
- `sombra`
- `color`
- `fondo`

## Estado
La V1 debe mantener el estado simple.

Prioridad:
- estado desde query string
- estado desde ruta
- formularios GET simples

Mas adelante:
- estado local mas reactivo
- actualizacion declarativa mas fina

## Rutas
La libreria debe ofrecer un camino oficial para apps multi-pagina o SPA ligera:
- definicion clara de vistas
- seleccion de ruta estable
- navbar reutilizable
- 404 controlado

## Estilos
Los estilos deben seguir la misma filosofia de simplicidad.

`Estructa` no debe empujar al programador a escribir CSS manual desde el inicio.

La jerarquia de estilos debe ser:

1. estilo implicito del componente
2. variante semantica del componente
3. props visuales cortas
4. tema global
5. escape manual avanzado, solo si hace falta

### Estilo implicito
Cada componente debe traer una base visual usable:
- `titulo` ya parece titulo
- `boton_ruta` ya parece boton
- `tarjeta` ya parece tarjeta

### Variantes
Los componentes deben poder cambiar de intencion visual con valores simples:

```jasb
tarjeta {
    variante: "elevada"
    contenido {
        texto "Resumen"
    }
}
```

### Props visuales
Los bloques deben aceptar propiedades semanticas:

```jasb
columna {
    espacio: "grande"
    alineacion: "inicio"
    contenido {
        titulo "Panel"
        texto "Contenido"
    }
}
```

### Tema global
Debe existir una forma de definir la identidad visual de la app:

```jasb
tema Principal {
    color_primario: "#2563eb"
    color_secundario: "#0f172a"
    color_fondo: "#ffffff"
    color_texto: "#111827"
    radio_base: "12px"
    espacio_base: "12px"
}
```

Y luego:

```jasb
app MiApp {
    usar tema Principal
    rutas {
        "/" => Inicio
    }
}
```

### Escape manual
Si hace falta un control avanzado, puede existir una salida de escape, pero no debe ser el camino principal:
- estilos en linea
- clases personalizadas
- css manual

Eso debe vivir como herramienta avanzada, no como experiencia base.

## Compatibilidad DSL
El DSL actual puede quedarse como compatibilidad temporal.

Pero:
- no debe ser la fuente principal de verdad
- no debe definir la arquitectura de `Estructa`
- debe bajar a la API Jasboot real si se mantiene

## Fases sugeridas
### Fase 1
Consolidar la API 100% Jasboot.

### Fase 2
Definir el ejemplo oficial multi-ruta en Jasboot puro.

### Fase 3
Relegar el DSL a compatibilidad.

### Fase 4
Preparar terreno para tooling del lenguaje escrito en Jasboot.

## Resultado esperado
Una libreria `Estructa` que pueda describirse asi:
- React en filosofia
- Jasboot en implementacion
- espanol en la experiencia
- simple en el uso
- declarativa en su sintaxis
- semantica en sus estilos
- clara en su arquitectura
