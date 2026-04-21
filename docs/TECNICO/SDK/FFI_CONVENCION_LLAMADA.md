# Convención de llamada FFI (jbc + VM)

Cómo llamar a funciones C desde Jasboot usando **ffi_cargar**, **ffi_simbolo** y **ffi_llamar**.

---

## 1. Opcodes en la VM

| Opcode | Nombre | Semántica |
|--------|--------|-----------|
| 0x2F | OP_CARGAR_BIBLIOTECA | A ← handle; B\|C = offset (16b) de la ruta en la sección data. Carga DLL/SO y devuelve handle (0 si falla). |
| 0x93 | OP_FFI_OBTENER_SIMBOLO | A ← dirección de función; B = handle, C = offset en data del nombre del símbolo. GetProcAddress/dlsym. |
| 0x94 | OP_FFI_LLAMAR | A ← resultado; B = puntero a función; C = número de argumentos (0–4). Argumentos en registros 3, 4, 5, 6. |

---

## 2. Registros y argumentos

- **Hasta 4 argumentos** se pasan en los **registros 3, 4, 5 y 6** (cada uno como `uint64_t`).
- El **resultado** se escribe en el registro destino (operando A de OP_FFI_LLAMAR).
- **Convención C:** en la VM la llamada se hace con 4 `uint64_t`; la función C debe tener una firma compatible con `uint64_t (*)(uint64_t, uint64_t, uint64_t, uint64_t)` (los 4 argumentos y el retorno como enteros o punteros).

---

## 3. Tipos y valores

- **Enteros:** se pasan y devuelven como `uint64_t` (incluye punteros y handles).
- **Flotantes:** no hay paso explícito por registro. Para devolver `float`/`double` desde C, la ABI real usa registros distintos (p. ej. XMM0 en x64). La VM actual asume **retorno en un único registro como uint64**. Para devolver flotante hay que:
  - usar en C un wrapper que devuelva `uint64_t` (p. ej. reinterpreting bits del float), o
  - extender la VM con un opcode que trate el retorno como flotante (futuro).
- **Structs:** no se pasan “por valor” en esta convención; pasar puntero (entero como dirección) y que C reciba un puntero.

---

## 4. Uso desde Jasboot (jbc)

Llamadas de sistema reconocidas:

- **ffi_cargar(ruta)**  
  `ruta` = literal texto (ej. `"opengl32.dll"` o `"libc.so.6"`).  
  Devuelve handle (entero); 0 si falla.

- **ffi_simbolo(handle, nombre)**  
  `handle` = valor devuelto por `ffi_cargar`.  
  `nombre` = literal texto con el nombre del símbolo (ej. `"glClear"`), o expresión que dé un **offset válido** en la sección data donde está el nombre.  
  Devuelve puntero de función (entero); 0 si no se encuentra.

- **ffi_llamar(fn, arg1, arg2, arg3, arg4)**  
  `fn` = puntero devuelto por `ffi_simbolo`.  
  Hasta 4 argumentos; los que no se usen pueden ser 0.  
  Devuelve el valor de retorno de la función C (entero/puntero).

Ejemplo:

```jasb
principal
    entero h = ffi_cargar("mi_lib.dll")
    si h != 0 entonces
        entero fn = ffi_simbolo(h, "mi_funcion")
        si fn != 0 entonces
            entero r = ffi_llamar(fn, 1, 2, 0, 0)
            imprimir("resultado: ")
            imprimir(r)
            imprimir("\n")
        fin_si
    fin_si
fin_principal
```

---

## 5. Resumen

| Aspecto | Convención actual |
|---------|-------------------|
| Argumentos | 0–4, en registros 3–6, tipo `uint64_t`. |
| Retorno | Un solo valor en registro destino, `uint64_t`. |
| Flotante | No soportado directamente; usar wrapper o extensión futura. |
| Structs | Pasar por puntero (entero). |
| Handles | Se guardan en variables; la VM libera las bibliotecas al destruirse. |

Sintaxis futura tipo `extern "lib" nombre(args) retorno` podría generar internamente estas mismas tres llamadas (ffi_cargar, ffi_simbolo, ffi_llamar) y reservar un slot global para el puntero de función.
