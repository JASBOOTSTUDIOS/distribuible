# FUNCIONES DE CADENAS - JASBOOT

## Documentación Completa con Ejemplos

---

## 1. FUNCIONES BÁSICAS DE CONVERSIÓN

### `str_desde_numero(n)`
Convierte un número (entero o flotante) a texto.

```jasb
# Ejemplo con entero
entero edad = 25
texto edad_str = str_desde_numero(edad)
imprimir "Tengo " + edad_str + " años"  # "Tengo 25 años"

# Ejemplo con flotante
flotante pi = 3.14159
texto pi_str = str_desde_numero(pi)
imprimir "Pi es " + pi_str  # "Pi es 3.14159"
```

### `str_a_entero(s)`
Convierte una cadena de texto a número entero.

```jasb
texto num_str = "123"
entero numero = str_a_entero(num_str)
imprimir numero + 10  # 133

# Si no es número válido, retorna 0
texto invalido = "abc"
entero resultado = str_a_entero(invalido)  # 0
```

### `str_a_flotante(s)`
Convierte una cadena de texto a número flotante.

```jasb
texto float_str = "3.14"
flotante numero = str_a_flotante(float_str)
imprimir numero * 2  # 6.28

# Si no es número válido, retorna 0.0
texto invalido = "xyz"
flotante resultado = str_a_flotante(invalido)  # 0.0
```

### `longitud(s)`
Retorna la longitud de una cadena o lista.

```jasb
texto frase = "Hola Mundo"
entero largo = longitud(frase)
imprimir "Longitud: " + str_desde_numero(largo)  # "Longitud: 10"

# También funciona con listas
lista numeros = [1, 2, 3, 4, 5]
entero tamano = longitud(numeros)  # 5
```

### `longitud_texto(s)`
Variante específica para cadenas de texto.

```jasb
texto texto_largo = "Jasboot es increíble"
entero caracteres = longitud_texto(texto_largo)
imprimir "Caracteres: " + str_desde_numero(caracteres)  # "Caracteres: 23"
```

### `concatenar(s1, s2)`
Une dos cadenas de texto.

```jasb
texto nombre = "Aurora"
texto saludo = concatenar("Hola, ", nombre)
imprimir saludo  # "Hola, Aurora"

# Equivalente al operador +
texto resultado = "Hola, " + nombre  # "Hola, Aurora"
```

### `decimal(f, p)`
Formatea un número flotante con p decimales.

```jasb
flotante precio = 123.456789
texto precio_formateado = decimal(precio, 2)
imprimir "Precio: $" + precio_formateado  # "Precio: $123.46"

flotante pi = 3.14159
texto pi_formateado = decimal(pi, 4)
imprimir pi_formateado  # "3.1416"
```

---

## 2. FUNCIONES DE EXTRACCIÓN

### `extraer_subtexto(texto, inicio, longitud)`
Extrae una subcadena de una cadena.

```jasb
texto frase = "Hola Mundo Jasboot"
texto sub = extraer_subtexto(frase, 5, 5)
imprimir sub  # "Mundo"

# Extraer primeras 4 letras
texto inicio = extraer_subtexto(frase, 0, 4)
imprimir inicio  # "Hola"

# Extraer últimas 7 letras
texto fin = extraer_subtexto(frase, 10, 7)
imprimir fin  # "Jasboot"
```

### `extraer_antes_de(texto, separador)`
Extrae el texto antes del separador.

```jasb
texto ruta = "C:\\Users\\Usuario\\documento.txt"
texto directorio = extraer_antes_de(ruta, "\\")
imprimir directorio  # "C:"

# Extraer antes del primer espacio
texto nombre_completo = "Juan Pérez García"
texto nombre = extraer_antes_de(nombre_completo, " ")
imprimir nombre  # "Juan"
```

### `extraer_despues_de(texto, separador)`
Extrae el texto después del separador.

```jasb
texto email = "usuario@dominio.com"
texto dominio = extraer_despues_de(email, "@")
imprimir dominio  # "dominio.com"

# Extraer después del primer espacio
texto frase = "Hola mundo cruel"
texto resto = extraer_despues_de(frase, " ")
imprimir resto  # "mundo cruel"
```

---

## 3. FUNCIONES DE BÚSQUEDA

### `buscar_en_texto(texto, patron)`
Busca un patrón en el texto y retorna su posición (0-based).

```jasb
texto frase = "programación en Jasboot es divertida"
entero posicion = buscar_en_texto(frase, "Jasboot")
imprimir "Posición: " + str_desde_numero(posicion)  # "Posición: 16"

# Si no encuentra, retorna -1
entero no_existe = buscar_en_texto(frase, "Python")
imprimir "No encontrado: " + str_desde_numero(no_existe)  # "No encontrado: -1"
```

### `contiene_texto(texto, patron)`
Verifica si el texto contiene el patrón.

```jasb
texto pagina = "<html><body>Hola</body></html>"
bool tiene_html = contiene_texto(pagina, "<html>")
imprimir tiene_html ? "Tiene HTML" : "No tiene HTML"  # "Tiene HTML"

bool tiene_python = contiene_texto(pagina, "python")
imprimir tiene_python ? "Tiene Python" : "No tiene Python"  # "No tiene Python"
```

### `termina_con(texto, sufijo)`
Verifica si el texto termina con el sufijo.

```jasb
texto archivo = "documento.txt"
bool es_txt = termina_con(archivo, ".txt")
imprimir es_txt ? "Es archivo TXT" : "No es TXT"  # "Es archivo TXT"

texto imagen = "foto.jpg"
bool es_png = termina_con(imagen, ".png")
imprimir es_png ? "Es PNG" : "No es PNG"  # "No es PNG"
```

---

## 4. FUNCIONES DE TRANSFORMACIÓN

### `minusculas(texto)`
Convierte todo el texto a minúsculas.

```jasb
texto original = "HOLA MUNDO"
texto minus = minusculas(original)
imprimir minus  # "hola mundo"

texto mixto = "JasBoot Es GENIAL"
texto resultado = minusculas(mixto)
imprimir resultado  # "jasboot es genial"
```

### `mayusculas(texto)`
Convierte todo el texto a mayúsculas.

```jasb
texto original = "hola mundo"
texto mayus = mayusculas(original)
imprimir mayus  # "HOLA MUNDO"

texto mixto = "JasBoot Es GENIAL"
texto resultado = mayusculas(mixto)
imprimir resultado  # "JASBOOT ES GENIAL"
```

### `dividir_texto(texto, separador)`
Divide el texto en una lista usando el separador.

```jasb
texto csv = "manzana,banana,naranja"
lista frutas = dividir_texto(csv, ",")
imprimir "Frutas: " + str_desde_numero(lista_tamano(frutas))  # "Frutas: 3"

# Acceder a elementos
texto primera = lista_obtener(frutas, 0)  # "manzana"
texto segunda = lista_obtener(frutas, 1)   # "banana"
```

### `segmentar_palabras(texto, separador)`
Segmenta el texto en palabras usando el separador.

```jasb
texto frase = "Hola mundo Jasboot"
lista palabras = segmentar_palabras(frase, " ")
imprimir "Palabras: " + str_desde_numero(lista_tamano(palabras))  # "Palabras: 3"

# Recorrer palabras
enterero i = 0
mientras i < lista_tamano(palabras) hacer
    imprimir "Palabra " + str_desde_numero(i) + ": " + lista_obtener(palabras, i)
    i = i + 1
fin_mientras
```

### `palabras_de(texto, separador)`
Obtiene las palabras del texto usando el separador.

```jasb
texto oracion = "El aprendizaje automático es fascinante"
lista palabras = palabras_de(oracion, " ")
imprimir "Total palabras: " + str_desde_numero(lista_tamano(palabras))  # "Total palabras: 5"

# Última palabra
texto ultima = lista_obtener(palabras, lista_tamano(palabras) - 1)
imprimir "Última: " + ultima  # "Última: fascinante"
```

---

## 5. FUNCIONES DE FORMATEO AVANZADO

### `formatear_timestamp(ts, formato)`
Formatea un timestamp Unix según el formato.

```jasb
entero ahora = obtener_timestamp()

# Formato fecha completa
texto fecha = formatear_timestamp(ahora, "%d/%m/%Y")
imprimir "Fecha: " + fecha  # "18/04/2026"

# Formato hora
texto hora = formatear_timestamp(ahora, "%H:%M:%S")
imprimir "Hora: " + hora  # "16:30:45"

# Formato personalizado
texto completo = formatear_timestamp(ahora, "%A, %d de %B de %Y")
imprimir completo  # "Friday, 18 de April de 2026"
```

---

## 6. FUNCIONES DE PROCESAMIENTO INTELIGENTE

### `pensar(texto)`
Procesamiento cognitivo del texto con memoria neuronal.

```jasb
texto consulta = "¿Qué es el aprendizaje automático?"
texto resultado = pensar(consulta)
imprimir "Respuesta: " + resultado
# Resultado puede ser una respuesta generada por la red neuronal
```

### `procesar_texto(texto)`
Procesamiento avanzado de texto.

```jasb
texto complejo = "La inteligencia artificial revoluciona el mundo"
texto procesado = procesar_texto(complejo)
imprimir "Procesado: " + procesado
# Puede incluir análisis semántico o extracción de conceptos
```

### `ultima_palabra(texto)`
Extrae la última palabra del texto.

```jasb
texto frase = "El aprendizaje automático es fascinante"
ultima_palabra(frase) en ultima
imprimir "Última palabra: " + ultima  # "fascinante"

texto comando = "guardar documento importante"
ultima_palabra(comando) en accion
imprimir "Acción: " + accion  # "importante"
```

---

## 7. FUNCIONES DE MEMORIA NEURAL (JMN)

### `crear_memoria(ruta)`
Crea o abre un archivo de memoria neuronal.

```jasb
crear_memoria("mi_memoria.jmn")
imprimir "Memoria neuronal creada"
```

### `recordar clave con valor v`
Almacena un valor asociado a una clave.

```jasb
recordar "usuario_nombre" con valor "Aurora"
recordar "usuario_edad" con valor 25
recordar "usuario_intereses" con valor "IA, programación"
```

### `buscar clave`
Recupera el valor asociado a la clave.

```jasb
buscar "usuario_nombre"
imprimir "Nombre: " + resultado  # "Nombre: Aurora"

buscar "usuario_edad"
imprimir "Edad: " + resultado  # "Edad: 25"
```

### `asociar c1 con c2`
Crea una conexión semántica entre conceptos.

```jasb
asociar "Aurora" con "IA"
asociar "programación" con "creatividad"
asociar "aprendizaje" con "crecimiento"
```

### `pensar consulta`
Búsqueda semántica en la red neuronal.

```jasb
pensar "Aurora"
imprimir "Asociaciones: " + resultado
# Puede retornar conceptos relacionados
```

### `buscar_asociados consulta`
Busca conceptos asociados semánticamente.

```jasb
buscar_asociados "IA"
imprimir "ID asociado: " + str_desde_numero(resultado)
# Retorna un ID numérico de conceptos asociados
```

### `propagar_activacion(texto)`
Propaga activación semántica en la red.

```jasb
propagar_activacion "aprendizaje"
imprimir "Activación: " + str_desde_numero(resultado)
# Retorna un ID numérico de activación propagada
```

### `cerrar_memoria()`
Cierra la memoria neuronal y guarda cambios.

```jasb
cerrar_memoria()
imprimir "Memoria neuronal cerrada y guardada"
```

---

## 8. NOTAS IMPORTANTES

### Caracteres Especiales en Cadenas
- `\n` - Nueva línea
- `\t` - Tabulador
- `\"` - Comillas dobles
- `\\` - Barra invertida

### Concatenación
- Puedes usar `concatenar(a, b)` o el operador `+`
- La conversión automática de números a texto está disponible

### Manejo de Errores
- Las funciones de conversión retornan valores por defecto si fallan
- `buscar_en_texto` retorna -1 si no encuentra el patrón
- Las funciones booleanas retornan `verdadero`/`falso`

### Rendimiento
- Las funciones de texto están optimizadas para manejo de cadenas largas
- La memoria neuronal proporciona persistencia y asociación semántica
- Las operaciones con listas son eficientes para colecciones grandes

---

## 9. EJEMPLO COMPLETO INTEGRADO

```jasb
principal
    # Crear memoria neuronal
    crear_memoria("demo_texto.jmn")
    
    # Trabajar con texto
    texto frase = "Jasboot es un lenguaje de programación increíble"
    imprimir "Original: " + frase
    
    # Transformaciones
    texto minusculas_frase = minusculas(frase)
    texto mayusculas_frase = mayusculas(frase)
    imprimir "Minúsculas: " + minusculas_frase
    imprimir "Mayúsculas: " + mayusculas_frase
    
    # Extracción
    texto primera_palabra = extraer_antes_de(frase, " ")
    texto resto = extraer_despues_de(frase, " ")
    imprimir "Primera palabra: " + primera_palabra
    imprimir "Resto: " + resto
    
    # Búsqueda
    bool tiene_lenguaje = contiene_texto(frase, "lenguaje")
    entero pos_increible = buscar_en_texto(frase, "increíble")
    imprimir "Tiene 'lenguaje': " + (tiene_lenguaje ? "Sí" : "No")
    imprimir "Posición 'increíble': " + str_desde_numero(pos_increible)
    
    # División
    lista palabras = palabras_de(frase, " ")
    imprimir "Número de palabras: " + str_desde_numero(lista_tamano(palabras))
    
    # Almacenar en memoria neuronal
    recordar "frase_demo" con valor frase
    recordar "palabras_count" con valor lista_tamano(palabras)
    
    # Recuperar
    buscar "frase_demo"
    imprimir "Recuperado: " + resultado
    
    # Cerrar memoria
    cerrar_memoria()
    
fin_principal
```

---

**Última actualización: 2026-04-18**
**Versión: Jasboot v2.0+**
