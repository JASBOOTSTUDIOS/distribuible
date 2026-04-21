# Checklist: Tipos primitivos para drivers y motores 3D

Roadmap de tipos de datos y capacidades para desarrollo de bajo nivel, drivers y motores de videojuegos 3D en Jasboot.

---

## Visión

Añadir tipos primitivos y operaciones que permitan:
- Drivers de hardware (memoria, dispositivos)
- Motores de videojuegos 3D (OpenGL, Vulkan, DirectX)
- Procesamiento de buffers binarios (texturas, audio, protocolos)

---

## Leyenda de estados

| Símbolo | Significado |
|---------|-------------|
| ✅ | Hecho / estable |
| 🔄 | En curso |
| ⚠️ | Parcial |
| ❌ | Pendiente |

---

## Prioridad 1: Enteros sin signo (crítico para APIs gráficas)

| # | Tarea | Descripción | Dependencias | Estado |
|---|-------|-------------|--------------|--------|
| 1.1 | Keyword `entero_sin_signo` o `u32` | Tipo entero 32 bits sin signo | Lexer, parser, codegen, VM | ✅ |
| 1.2 | Keyword `u64` | Tipo entero 64 bits sin signo | 1.1 | ✅ |
| 1.3 | Literales hex para unsigned | `0x80000000` sin interpretar como negativo | Parser | ✅ |
| 1.4 | Operaciones aritméticas unsigned | +, -, *, /, % sin overflow negativo | Codegen, VM | ✅ |
| 1.5 | Comparaciones unsigned | <, >, <=, >= correctos para unsigned | Codegen | ✅ |

**Uso:** Handles de GPU, direcciones de memoria, tamaños, píxeles RGBA, registros de hardware.

---

## Prioridad 2: Byte (buffers binarios)

| # | Tarea | Descripción | Dependencias | Estado |
|---|-------|-------------|--------------|--------|
| 2.1 | Keyword `byte` o `u8` | Tipo 8 bits sin signo | Lexer, parser, codegen, VM | ✅ |
| 2.2 | Literal byte | `0xFF` o sintaxis específica | Parser (hex existente) | ✅ |
| 2.3 | Conversión byte ↔ caracter | `byte_a_caracter`, `caracter_a_byte` | Funciones existentes | ✅ |
| 2.4 | Lectura/escritura byte en buffer | `fs_leer_byte`, `fs_escribir_byte` | VM / sistema de llamadas | ✅ |

**Uso:** Buffers binarios, texturas raw, audio, protocolos serie, archivos binarios.

---

## Prioridad 3: Vectores (matemática 3D)

| # | Tarea | Descripción | Dependencias | Estado |
|---|-------|-------------|--------------|--------|
| 3.1 | Tipo `vec2` | Vector 2 flotantes (x, y) | Lexer, parser, codegen | ✅ |
| 3.2 | Tipo `vec3` | Vector 3 flotantes (x, y, z) | 3.1 | ✅ |
| 3.3 | Tipo `vec4` | Vector 4 flotantes (x, y, z, w) | 3.2 | ✅ |
| 3.4 | Literales vector | `vec3(1.0, 0.0, 0.0)` | Parser | ✅ |
| 3.5 | Operaciones vector | +, -, *, longitud, normalizar | Codegen, VM / lib | ✅ |
| 3.6 | Producto escalar y vectorial | dot, cross para vec3 | Funciones o operadores | ✅ |
| 3.7 | Acceso por componente | .x, .y, .z, .w o [0], [1] | Parser, codegen | ✅ |

**Uso:** Posiciones, normales, colores, coordenadas UV, direcciones.

---

## Prioridad 4: Punteros / referencias crudas

| # | Tarea | Descripción | Dependencias | Estado |
|---|-------|-------------|--------------|--------|
| 4.1 | Tipo `puntero` o `referencia` | Apuntador a memoria | Lexer, parser | ❌ |
| 4.2 | Obtener dirección de variable | `direccion_de(x)` | Sistema de llamadas | ❌ |
| 4.3 | Desreferenciar puntero | Lectura/escritura en dirección | VM (modo unsafe) | ❌ |
| 4.4 | Aritmética de punteros | +, - para offset | Codegen | ❌ |
| 4.5 | Bloque `bajo_nivel` o `unsafe` | Alcance donde punteros están permitidos | Parser | ❌ |

**Uso:** Buffers GPU, DMA, memoria de dispositivo, FFI con C.

---

## Prioridad 5: Matrices (transformaciones 3D)

| # | Tarea | Descripción | Dependencias | Estado |
|---|-------|-------------|--------------|--------|
| 5.1 | Tipo `mat4` | Matriz 4×4 de flotantes | Lexer, parser | ❌ |
| 5.2 | Literal / constructores | identidad, traslación, rotación, escala | Funciones | ❌ |
| 5.3 | Multiplicación matriz × vector | mat4 * vec4 → vec4 | Codegen / lib | ❌ |
| 5.4 | Multiplicación matriz × matriz | mat4 * mat4 → mat4 | Codegen / lib | ❌ |
| 5.5 | Inversa y transpuesta | Funciones para mat4 | Lib matemática | ❌ |

**Uso:** Model, view, projection, transforms, cámara.

---

## Prioridad 6: Precisión de flotantes

| # | Tarea | Descripción | Dependencias | Estado |
|---|-------|-------------|--------------|--------|
| 6.1 | `flotante_32` vs `flotante_64` | Distinguir float de double | Lexer, parser | ❌ |
| 6.2 | Actual flotante → definir | Documentar si es f32 o f64 | Documentación | ❌ |
| 6.3 | Conversión explícita | f32 ↔ f64, f32 ↔ entero | Funciones | ❌ |
| 6.4 | `flotante_16` (opcional) | Half precision para ML/GPU | 6.1 | ❌ |

**Uso:** f32 nativo en GPU; f64 para física y precisión; f16 en algunos workloads.

---

## Prioridad 7: Operaciones bit a bit

| # | Tarea | Descripción | Dependencias | Estado |
|---|-------|-------------|--------------|--------|
| 7.1 | `bit_y`, `bit_o`, `bit_xor`, `bit_no` | Operadores lógicos bit a bit | Lexer, parser, codegen, VM | ❌ |
| 7.2 | `bit_shl`, `bit_shr` | Desplazamientos | — | ✅ |
| 7.3 | Literales binarios | `0b1010` | Parser | ❌ |
| 7.4 | Campos de bits en registros | Sintaxis para flags empaquetados | Parser, codegen | ❌ |

---

## Prioridad 8: Tipos compuestos adicionales

| # | Tarea | Descripción | Dependencias | Estado |
|---|-------|-------------|--------------|--------|
| 8.1 | Tipo `union` | Reinterpretar misma memoria con distintos tipos | Parser, codegen | ❌ |
| 8.2 | Tipo `color` / `rgba` | u32 empaquetado 0xAARRGGBB | 1.1, constructores | ❌ |
| 8.3 | Tipo `cuaternión` | Rotaciones 3D sin gimbal lock | vec4 + operaciones | ❌ |
| 8.4 | Tipo `void` / `nada` | Funciones sin retorno | Parser | ⚠️ |

---

## Prioridad 9: Cast y reinterpretación

| # | Tarea | Descripción | Dependencias | Estado |
|---|-------|-------------|--------------|--------|
| 9.1 | Cast explícito seguro | `entero_a_flotante(x)`, `flotante_a_entero(x)` | Funciones | ⚠️ |
| 9.2 | `reinterpretar_como` | Reinterpretar bits (float ↔ int) | Bajo nivel | ❌ |
| 9.3 | Alineamiento y padding | Atributos para structs (align, packed) | Parser, codegen | ❌ |

---

## Orden sugerido de implementación

```
1.1 → 1.2 → 1.3 → 1.4 → 1.5   (u32/u64 base)
2.1 → 2.2 → 2.3               (byte)
7.1 → 7.2 → 7.3               (bits, si faltan)
3.1 → 3.2 → 3.3 → 3.4 → 3.5   (vectores)
5.1 → 5.2 → 5.3               (matrices básicas)
4.1 → 4.2 → 4.3               (punteros, con cuidado)
6.1 → 6.2                     (precisión float)
8.1, 8.2, 9.1, 9.2            (union, color, cast)
```

---

## Referencias

- **OpenGL**: handles `GLuint`, `GLsizei`; vectores `vec3`, `vec4`; matrices `mat4`
- **Vulkan**: handles 64-bit; tipos explícitos `VkDeviceAddress`, etc.
- **DirectX**: `D3D12_GPU_VIRTUAL_ADDRESS`, `XMFLOAT3`, `XMMATRIX`
- **Estado actual del lenguaje**: `docs/LENGUAJE/REFERENCIA_LENGUAJE_JASBOOT.md`

---

**Última actualización:** 2026-02-18
