# ERROR PATTERNS - Aurora IA Conversacional Híbrida

## PATRON 1: Sintaxis JMN (Memoria Neuronal)

### Descripción
Errores comunes al usar funciones de memoria neuronal en Jasboot.

### Errores Comunes
- **Error**: `recordar clave valor`
- **Solución**: `recordar clave con valor`
- **Ejemplo**:
  ```jasb
  # Incorrecto
  recordar "mi_clave" "mi_valor"
  
  # Correcto
  recordar "mi_clave" con "mi_valor"
  ```

### Errores Comunes
- **Error**: `mapa_poner clave valor` (cuando valor es literal)
- **Solución**: `mapa_poner clave + valor`
- **Ejemplo**:
  ```jasb
  # Incorrecto
  mapa_poner estadisticas "total" 0
  
  # Correcto
  mapa_poner estadisticas "total" + 0
  ```

---

## PATRON 2: Palabras Reservadas

### Descripción
Uso accidental de palabras reservadas del lenguaje Jasboot como nombres de variables.

### Palabras Reservadas Comunes
- `concepto` - Usar `concepto_txt`
- `resultado` - Usar `_resultado`
- `si`, `mientras`, `cuando`, `funcion`, `clase`, `registro`
- `entero`, `texto`, `flotante`, `caracter`, `bool`, `nulo`

### Ejemplo
```jasb
# Incorrecto
funcion procesar_concepto(texto concepto) retorna

# Correcto
funcion procesar_concepto(texto concepto_txt) retorna
```

---

## PATRON 3: Llamadas a Funciones con Múltiples Parámetros

### Descripción
El compilador Jasboot no usa comas para separar parámetros en llamadas a funciones.

### Errores Comunes
- **Error**: `funcion(param1, param2, param3)`
- **Solución**: `funcion param1 param2 param3`
- **Ejemplo**:
  ```jasb
  # Incorrecto
  memoria_global.crear_dialogo("id1", "id2", "contexto")
  
  # Correcto
  memoria_global.crear_dialogo "id1" "id2" "contexto"
  ```

---

## PATRON 4: Variables Locales No Declaradas (Bug del Compilador)

### Descripción
El compilador tiene problemas declarando variables locales en funciones.

### Solución
- Usar expresiones directas en lugar de variables locales
- Evitar declaraciones complejas dentro de funciones

### Ejemplo
```jasb
# Incorrecto
funcion mi_funcion(texto parametro) retorna
    texto variable_local = "valor"
    recordar "clave" variable_local
fin_funcion

# Correcto
funcion mi_funcion(texto parametro) retorna
    recordar "clave" "valor"
fin_funcion
```

---

## PATRON 5: Instanciación de Clases (Bug del Compilador)

### Descripción
El compilador no puede instanciar clases directamente en variables locales.

### Solución
- Usar variables globales con workaround
- Inicializar en funciones globales separadas

### Ejemplo
```jasb
# Variables globales (al inicio del archivo)
MiClase mi_global
bool mi_inicializado = falso

# Función de inicialización
funcion inicializar_mi_clase retorna
    si no mi_inicializado entonces
        mi_global = MiClase()
        mi_inicializado = verdadero
    fin_si
fin_funcion
```

---

## PATRON 6: Tipos Complejos en Retorno

### Descripción
Las funciones no pueden retornar tipos complejos como clases.

### Solución
- Usar variables globales para retornar valores complejos
- Cambiar firma de función a tipo entero o sin retorno

### Ejemplo
```jasb
# Incorrecto
funcion obtener_clase() retorna MiClase
    MiClase instancia = MiClase()
    retornar instancia
fin_funcion

# Correcto
funcion obtener_clase() retorna
    inicializar_mi_clase
    retornar  // o no retornar nada
fin_funcion
```

---

## VALIDACIÓN CHECKLIST

Antes de compilar código Aurora IA:

- [ ] Revisar todas las llamadas a `recordar` - deben usar `con`
- [ ] Revisar todas las llamadas a `mapa_poner` - usar `+` para valores literales
- [ ] Verificar que no se usen palabras reservadas como nombres de variables
- [ ] Comprobar que las llamadas a funciones no usen comas
- [ ] Evitar variables locales complejas, usar expresiones directas
- [ ] Usar workaround de variables globales para instanciación de clases
- [ ] Verificar que las funciones no retornen tipos complejos

---

## EJEMPLOS CORRECTOS - Aurora IA

### JMN Wrapper Correcto
```jasb
funcion guardar_en_jmn(texto clave, texto valor) retorna
    recordar clave con valor
    asociar clave con "almacenado"
fin_funcion

funcion buscar_en_jmn(texto clave) retorna texto
    buscar clave
    si resultado != "" entonces
        retornar resultado
    sino
        retornar "no_encontrado"
    fin_si
fin_funcion
```

### Clase con Workaround Correcto
```jasb
# Variables globales
MemoriaConversacional memoria_global
bool memoria_inicializada = falso

funcion inicializar_memoria() retorna
    si no memoria_inicializada entonces
        memoria_global = MemoriaConversacional()
        memoria_inicializada = verdadero
    fin_si
fin_funcion

funcion procesar_dialogo(texto id, texto mensaje) retorna
    inicializar_memoria
    memoria_global.agregar_mensaje id mensaje "usuario"
fin_funcion
```
