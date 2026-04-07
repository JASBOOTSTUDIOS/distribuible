# Orden de implementación del pipeline hacia OS-IA

Según la arquitectura del proyecto, este es el orden recomendado para implementar las herramientas y alcanzar el OS-IA.

---

## Stack tecnológico (de abajo hacia arriba)

```
┌─────────────────────────────────────────────────────────┐
│  Aplicaciones cognitivas (módulos IA, decisiones, etc.)  │
├─────────────────────────────────────────────────────────┤
│  Lenguaje Jasboot (.jasb)                                │
├─────────────────────────────────────────────────────────┤
│  Kernel OS-IA (scheduler, memoria, procesos)             │
├─────────────────────────────────────────────────────────┤
│  jasISA / IR (.jbo) — ISA virtual, opcodes               │
├─────────────────────────────────────────────────────────┤
│  VM (intérprete/translator)                              │
├─────────────────────────────────────────────────────────┤
│  Hardware (x86, ARM, RISC-V)                             │
└─────────────────────────────────────────────────────────┘
```

**Regla:** Cada capa depende de la inferior. No se puede construir la superior sin que la inferior exista.

---

## Orden de implementación recomendado

### 1️⃣ IR / jasISA (primero)

**Por qué:** Es el contrato común. Tanto la VM como el compilador dependen de él. Si cambia, todo se rompe.

| Tarea | Descripción | Estado |
|-------|-------------|--------|
| 1.1 | Especificación estable del formato .jbo (header, instrucciones 5B) | ✅ Existe (ir_format.h) |
| 1.2 | Catálogo completo de opcodes documentado | ⚠️ Parcial |
| 1.3 | Alinear jasISA (docs) con IR real (ir_format.h) | ❌ Hay divergencias (6B vs 5B) |
| 1.4 | Validación de IR (checksums, CFG, saltos) | ❌ |

**Salida:** Especificación jasISA/IR congelada, referenciada por VM y compilador.

---

### 2️⃣ VM (segundo)

**Por qué:** Sin VM no se ejecuta nada. Es el ejecutor del IR.

| Tarea | Descripción | Estado |
|-------|-------------|--------|
| 2.1 | VM estable que ejecute todo el IR definido | ✅ Existe (vm.c) |
| 2.2 | Memoria neuronal (JMN) integrada y persistente | ⚠️ Parcial |
| 2.3 | Opcodes de IA (OP_MEM_*, etc.) funcionales | ✅ |
| 2.4 | Persistencia real de cerebro.jmn | ❌ Crítico para OS-IA |
| 2.5 | Portabilidad (build para x86, ARM) | ⚠️ Parcial |

**Salida:** VM que ejecuta .jbo de forma estable, con JMN persistente.

---

### 3️⃣ Compilador (tercero)

**Por qué:** Traduce Jasboot a IR. Sin él, hay que escribir .jbo a mano (inviable).

| Tarea | Descripción | Estado |
|-------|-------------|--------|
| 3.1 | Compilador de referencia estable (**jbc**, C) | ✅ `sdk-dependiente/jas-compiler-c` |
| 3.2 | Cobertura completa del lenguaje (vars, funciones, control) | ⚠️ Parcial |
| 3.3 | Emisión correcta de todos los opcodes necesarios | ⚠️ Parcial |
| 3.4 | Segunda implementación del compilador en `.jasb` (self-hosting) | ⏸️ Fuera del árbol |
| 3.5 | ~~Compilador soberano en jasb~~ | Retirado del repo (usar solo **jbc**) |

**Salida:** Compilador que produce .jbo válido para cualquier programa Jasboot válido.

---

### 4️⃣ Lenguaje Jasboot (en paralelo con compilador)

**Por qué:** Lenguaje y compilador evolucionan juntos, pero el lenguaje define el contrato.

| Tarea | Descripción | Estado |
|-------|-------------|--------|
| 4.1 | Especificación formal (gramática, semántica) | ❌ |
| 4.2 | Sintaxis estable documentada | ⚠️ Dispersa |
| 4.3 | Perfil Jasboot-K (bajo nivel, kernel) separado | ❌ |
| 4.4 | Sistema de módulos (usar, importar) | ⚠️ Parcial |

**Salida:** Documento de especificación del lenguaje que el compilador implementa.

---

### 5️⃣ Núcleo del OS-IA (quinto)

**Por qué:** El kernel es lo que convierte la VM + IR en un “sistema operativo”. Requiere VM y compilador.

| Tarea | Descripción | Estado |
|-------|-------------|--------|
| 5.1 | Scheduler / bucle principal continuo | ❌ |
| 5.2 | Modelo de procesos o hilos de pensamiento | ❌ |
| 5.3 | Comunicación entre módulos en tiempo real | ❌ |
| 5.4 | Gestión de memoria del kernel | ❌ |
| 5.5 | Módulos base (decisiones, orquestador) | ✅ Existen |

**Salida:** Kernel mínimo que corre sobre la VM, planifica y coordina módulos.

---

### 6️⃣ Capa IA y aplicaciones (sexto)

**Por qué:** La “IA” son aplicaciones que usan JMN, aprendizaje y eventos. Dependen del kernel.

| Tarea | Descripción | Estado |
|-------|-------------|--------|
| 6.1 | Persistencia real de cerebro.jmn | ❌ |
| 6.2 | Aprendizaje por corrección y refuerzo | ❌ |
| 6.3 | Bucle de eventos (entrada, timers, sensores) | ❌ |
| 6.4 | Interfaz de usuario (texto o gráfica) | ❌ |
| 6.5 | Abstracción sensores/salida (sentidos/expresión) | ❌ |

**Salida:** OS-IA funcional: persiste, aprende, reacciona en tiempo real.

---

## Resumen: orden sugerido

| # | Componente | Razón |
|---|------------|-------|
| 1 | **IR / jasISA** | Contrato base; VM y compilador dependen de él |
| 2 | **VM** | Ejecutor del IR; sin VM no hay ejecución |
| 3 | **Compilador** | Traduce Jasboot → IR; sin él no hay programas |
| 4 | **Lenguaje Jasboot** | En paralelo con compilador; define qué se compila |
| 5 | **Kernel OS-IA** | Convierte VM en sistema; necesita VM + compilador |
| 6 | **Capa IA** | Persistencia, aprendizaje, eventos; necesita kernel |

---

## Regla práctica

> **No implementes la capa N+1 hasta que la capa N sea estable.**
>
> IR estable → VM estable → Compilador estable → Kernel → IA.

---

## Referencias

- `docs/PROYECTO/CHECKLIST_ROADMAP_JASBOOT.md` — Checklist general
- `docs/PROYECTO/ESTADO_PROYECTO_ACTUAL.md` — Estado del proyecto
- `sdk-dependiente/jasboot-ir/src/ir_format.h` — IR actual

---

**Última actualización:** 2026-02-18
