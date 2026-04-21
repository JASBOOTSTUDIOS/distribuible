# CHECKLIST DE FUNCIONES DE CADENAS - JASBOOT

## Checklist de Pruebas Función por Función

### Instrucciones de Uso:
1. Marca cada función con [X] cuando la hayas probado exitosamente
2. Anota cualquier observación o problema encontrado
3. Puedes usar el archivo `test_completo_funciones_texto.jasb` como referencia

---

## 1. FUNCIONES BÁSICAS DE CONVERSIÓN

### [ ] `str_desde_numero(n)`
- **Estado**: Pendiente
- **Test**: Probar con entero y flotante
- **Observaciones**: 
```
# Código de prueba:
entero num_entero = 42
texto resultado_entero = str_desde_numero(num_entero)
imprimir "Entero a texto: " + resultado_entero

flotante num_float = 3.14159
texto resultado_float = str_desde_numero(num_float)
imprimir "Flotante a texto: " + resultado_float
```

### [ ] `str_a_entero(s)`
- **Estado**: Pendiente
- **Test**: Probar con número válido e inválido
- **Observaciones**:
```
# Código de prueba:
texto valido = "123"
entero resultado_valido = str_a_entero(valido)
imprimir "Texto a entero válido: " + str_desde_numero(resultado_valido)

texto invalido = "abc"
entero resultado_invalido = str_a_entero(invalido)
imprimir "Texto a entero inválido: " + str_desde_numero(resultado_invalido)
```

### [ ] `str_a_flotante(s)`
- **Estado**: Pendiente
- **Test**: Probar con número válido e inválido
- **Observaciones**:
```
# Código de prueba:
texto valido = "3.14"
flotante resultado_valido = str_a_flotante(valido)
imprimir "Texto a flotante válido: " + str_desde_numero(resultado_valido)

texto invalido = "xyz"
flotante resultado_invalido = str_a_flotante(invalido)
imprimir "Texto a flotante inválido: " + str_desde_numero(resultado_invalido)
```

### [ ] `longitud(s)`
- **Estado**: Pendiente
- **Test**: Probar con texto y lista
- **Observaciones**:
```
# Código de prueba:
texto texto_largo = "Hola Mundo Jasboot"
entero largo_texto = longitud(texto_largo)
imprimir "Longitud texto: " + str_desde_numero(largo_texto)

lista numeros = [1, 2, 3, 4, 5]
enterero largo_lista = longitud(numeros)
imprimir "Longitud lista: " + str_desde_numero(largo_lista)
```

### [ ] `longitud_texto(s)`
- **Estado**: Pendiente
- **Test**: Probar con diferentes textos
- **Observaciones**:
```
# Código de prueba:
texto texto1 = "Hola"
entero largo1 = longitud_texto(texto1)
imprimir "Longitud 'Hola': " + str_desde_numero(largo1)

texto texto2 = "Jasboot es increíble"
entero largo2 = longitud_texto(texto2)
imprimir "Longitud frase: " + str_desde_numero(largo2)
```

### [ ] `concatenar(s1, s2)`
- **Estado**: Pendiente
- **Test**: Probar diferentes combinaciones
- **Observaciones**:
```
# Código de prueba:
texto parte1 = "Hola"
texto parte2 = " Mundo"
texto resultado = concatenar(parte1, parte2)
imprimir "Concatenado: " + resultado

# Comparar con operador +
texto resultado_op = parte1 + parte2
imprimir "Con operador +: " + resultado_op
```

### [ ] `decimal(f, p)`
- **Estado**: Pendiente
- **Test**: Probar diferentes precisiones
- **Observaciones**:
```
# Código de prueba:
flotante numero = 123.456789
texto dos_decimales = decimal(numero, 2)
imprimir "2 decimales: " + dos_decimales

texto cuatro_decimales = decimal(numero, 4)
imprimir "4 decimales: " + cuatro_decimales
```

---

## 2. FUNCIONES DE EXTRACCIÓN

### [ ] `extraer_subtexto(texto, inicio, longitud)`
- **Estado**: Pendiente
- **Test**: Probar diferentes posiciones y longitudes
- **Observaciones**:
```
# Código de prueba:
texto frase = "Hola Mundo Jasboot"
texto sub1 = extraer_subtexto(frase, 0, 4)
imprimir "Primeras 4 letras: " + sub1

texto sub2 = extraer_subtexto(frase, 5, 5)
imprimir "Medio: " + sub2

texto sub3 = extraer_subtexto(frase, 10, 7)
imprimir "Últimas 7 letras: " + sub3
```

### [ ] `extraer_antes_de(texto, separador)`
- **Estado**: Pendiente
- **Test**: Probar diferentes separadores
- **Observaciones**:
```
# Código de prueba:
texto email = "usuario@dominio.com"
texto usuario = extraer_antes_de(email, "@")
imprimir "Usuario: " + usuario

texto ruta = "C:\\Users\\Nombre\\archivo.txt"
texto directorio = extraer_antes_de(ruta, "\\")
imprimir "Directorio: " + directorio
```

### [ ] `extraer_despues_de(texto, separador)`
- **Estado**: Pendiente
- **Test**: Probar diferentes separadores
- **Observaciones**:
```
# Código de prueba:
texto email = "usuario@dominio.com"
texto dominio = extraer_despues_de(email, "@")
imprimir "Dominio: " + dominio

texto frase = "Hola mundo cruel"
texto resto = extraer_despues_de(frase, " ")
imprimir "Resto: " + resto
```

---

## 3. FUNCIONES DE BÚSQUEDA

### [ ] `buscar_en_texto(texto, patron)`
- **Estado**: Pendiente
- **Test**: Probar con patrones existentes y no existentes
- **Observaciones**:
```
# Código de prueba:
texto frase = "programación en Jasboot es divertida"
entero pos1 = buscar_en_texto(frase, "Jasboot")
imprimir "Posición 'Jasboot': " + str_desde_numero(pos1)

entero pos2 = buscar_en_texto(frase, "Python")
imprimir "Posición 'Python': " + str_desde_numero(pos2)
```

### [ ] `contiene_texto(texto, patron)`
- **Estado**: Pendiente
- **Test**: Probar con patrones existentes y no existentes
- **Observaciones**:
```
# Código de prueba:
texto html = "<html><body>Contenido</body></html>"
bool tiene_html = contiene_texto(html, "<html>")
imprimir "Tiene HTML: " + (tiene_html ? "Sí" : "No")

bool tiene_python = contiene_texto(html, "python")
imprimir "Tiene Python: " + (tiene_python ? "Sí" : "No")
```

### [ ] `termina_con(texto, sufijo)`
- **Estado**: Pendiente
- **Test**: Probar diferentes extensiones y sufijos
- **Observaciones**:
```
# Código de prueba:
texto archivo1 = "documento.txt"
bool es_txt = termina_con(archivo1, ".txt")
imprimir "Es TXT: " + (es_txt ? "Sí" : "No")

texto archivo2 = "imagen.jpg"
bool es_jpg = termina_con(archivo2, ".jpg")
imprimir "Es JPG: " + (es_jpg ? "Sí" : "No")
```

---

## 4. FUNCIONES DE TRANSFORMACIÓN

### [ ] `minusculas(texto)`
- **Estado**: Pendiente
- **Test**: Probar con diferentes mayúsculas
- **Observaciones**:
```
# Código de prueba:
texto original = "HOLA MUNDO JASBOOT"
texto resultado = minusculas(original)
imprimir "Minúsculas: " + resultado

texto mixto = "JasBoot Es GENIAL"
texto resultado2 = minusculas(mixto)
imprimir "Mixto a minúsculas: " + resultado2
```

### [ ] `mayusculas(texto)`
- **Estado**: Pendiente
- **Test**: Probar con diferentes minúsculas
- **Observaciones**:
```
# Código de prueba:
texto original = "hola mundo jasboot"
texto resultado = mayusculas(original)
imprimir "Mayúsculas: " + resultado

texto mixto = "JasBoot Es GENIAL"
texto resultado2 = mayusculas(mixto)
imprimir "Mixto a mayúsculas: " + resultado2
```

### [ ] `dividir_texto(texto, separador)`
- **Estado**: Pendiente
- **Test**: Probar diferentes separadores
- **Observaciones**:
```
# Código de prueba:
texto csv = "manzana,banana,naranja,uva"
lista frutas = dividir_texto(csv, ",")
imprimir "Elementos: " + str_desde_numero(lista_tamano(frutas))

texto frase = "palabra1 palabra2 palabra3"
lista palabras = dividir_texto(frase, " ")
imprimir "Palabras: " + str_desde_numero(lista_tamano(palabras))
```

### [ ] `segmentar_palabras(texto, separador)`
- **Estado**: Pendiente
- **Test**: Probar con diferentes separadores
- **Observaciones**:
```
# Código de prueba:
texto frase = "Hola mundo Jasboot"
lista palabras = segmentar_palabras(frase, " ")
imprimir "Palabras segmentadas: " + str_desde_numero(lista_tamano(palabras))

# Recorrer elementos
enterero i = 0
mientras i < lista_tamano(palabras) hacer
    imprimir "Palabra " + str_desde_numero(i) + ": " + lista_obtener(palabras, i)
    i = i + 1
fin_mientras
```

### [ ] `palabras_de(texto, separador)`
- **Estado**: Pendiente
- **Test**: Probar con diferentes textos y separadores
- **Observaciones**:
```
# Código de prueba:
texto oracion = "El aprendizaje automático es fascinante"
lista palabras = palabras_de(oracion, " ")
imprimir "Total palabras: " + str_desde_numero(lista_tamano(palabras))

# Obtener última palabra
texto ultima = lista_obtener(palabras, lista_tamano(palabras) - 1)
imprimir "Última palabra: " + ultima
```

---

## 5. FUNCIONES DE FORMATEO AVANZADO

### [ ] `formatear_timestamp(ts, formato)`
- **Estado**: Pendiente
- **Test**: Probar diferentes formatos de fecha/hora
- **Observaciones**:
```
# Código de prueba:
entero ahora = obtener_timestamp()

texto fecha = formatear_timestamp(ahora, "%d/%m/%Y")
imprimir "Fecha: " + fecha

texto hora = formatear_timestamp(ahora, "%H:%M:%S")
imprimir "Hora: " + hora

texto completo = formatear_timestamp(ahora, "%A, %d de %B de %Y")
imprimir "Completo: " + completo
```

---

## 6. FUNCIONES DE PROCESAMIENTO INTELIGENTE

### [ ] `pensar(texto)`
- **Estado**: Pendiente
- **Test**: Probar con diferentes consultas
- **Observaciones**:
```
# Código de prueba:
crear_memoria("test_pensar.jmn")

texto consulta1 = "¿Qué es Jasboot?"
texto resultado1 = pensar(consulta1)
imprimir "Pensar 1: " + resultado1

texto consulta2 = "aprendizaje automático"
texto resultado2 = pensar(consulta2)
imprimir "Pensar 2: " + resultado2

cerrar_memoria()
```

### [ ] `procesar_texto(texto)`
- **Estado**: Pendiente
- **Test**: Probar con diferentes textos
- **Observaciones**:
```
# Código de prueba:
crear_memoria("test_procesar.jmn")

texto complejo = "La inteligencia artificial revoluciona el mundo"
texto procesado = procesar_texto(complejo)
imprimir "Procesado: " + procesado

texto simple = "hola mundo"
texto procesado2 = procesar_texto(simple)
imprimir "Procesado simple: " + procesado2

cerrar_memoria()
```

### [ ] `ultima_palabra(texto)`
- **Estado**: Pendiente
- **Test**: Probar con diferentes frases
- **Observaciones**:
```
# Código de prueba:
texto frase1 = "El aprendizaje automático es fascinante"
ultima_palabra(frase1) en ultima1
imprimir "Última palabra 1: " + ultima1

texto frase2 = "guardar documento importante"
ultima_palabra(frase2) en ultima2
imprimir "Última palabra 2: " + ultima2
```

---

## 7. FUNCIONES DE MEMORIA NEURAL (JMN)

### [ ] `crear_memoria(ruta)`
- **Estado**: Pendiente
- **Test**: Crear archivo de memoria
- **Observaciones**:
```
# Código de prueba:
crear_memoria("test_jmn.jmn")
imprimir "Memoria creada exitosamente"
```

### [ ] `recordar clave con valor v`
- **Estado**: Pendiente
- **Test**: Almacenar diferentes tipos de datos
- **Observaciones**:
```
# Código de prueba:
recordar "nombre_usuario" con valor "Aurora"
recordar "edad_usuario" con valor 25
recordar "intereses_usuario" con valor "IA, programación, aprendizaje"
imprimir "Datos almacenados"
```

### [ ] `buscar clave`
- **Estado**: Pendiente
- **Test**: Recuperar datos almacenados
- **Observaciones**:
```
# Código de prueba:
buscar "nombre_usuario"
imprimir "Nombre: " + resultado

buscar "edad_usuario"
imprimir "Edad: " + resultado

buscar "clave_inexistente"
imprimir "Inexistente: " + resultado
```

### [ ] `asociar c1 con c2`
- **Estado**: Pendiente
- **Test**: Crear asociaciones semánticas
- **Observaciones**:
```
# Código de prueba:
asociar "Aurora" con "IA"
asociar "programación" con "creatividad"
asociar "aprendizaje" con "crecimiento"
imprimir "Asociaciones creadas"
```

### [ ] `pensar consulta`
- **Estado**: Pendiente
- **Test**: Búsqueda semántica
- **Observaciones**:
```
# Código de prueba:
pensar "Aurora"
imprimir "Asociaciones Aurora: " + resultado

pensar "programación"
imprimir "Asociaciones programación: " + resultado
```

### [ ] `buscar_asociados consulta`
- **Estado**: Pendiente
- **Test**: Buscar conceptos asociados
- **Observaciones**:
```
# Código de prueba:
buscar_asociados "IA"
imprimir "ID asociados IA: " + str_desde_numero(resultado)

buscar_asociados "aprendizaje"
imprimir "ID asociados aprendizaje: " + str_desde_numero(resultado)
```

### [ ] `propagar_activacion(texto)`
- **Estado**: Pendiente
- **Test**: Propagar activación semántica
- **Observaciones**:
```
# Código de prueba:
propagar_activacion "Aurora"
imprimir "Activación Aurora: " + str_desde_numero(resultado)

propagar_activacion "creatividad"
imprimir "Activación creatividad: " + str_desde_numero(resultado)
```

### [ ] `cerrar_memoria()`
- **Estado**: Pendiente
- **Test**: Cerrar y guardar memoria
- **Observaciones**:
```
# Código de prueba:
cerrar_memoria()
imprimir "Memoria cerrada y guardada"
```

---

## RESUMEN DE PROGRESO

### Estadísticas Actuales:
- **Total de funciones**: 31
- **Probadas**: 0
- **Pendientes**: 31
- **Porcentaje completado**: 0%

### Categorías:
- **Básicas**: 0/7 probadas
- **Extracción**: 0/3 probadas
- **Búsqueda**: 0/3 probadas
- **Transformación**: 0/5 probadas
- **Formateo**: 0/1 probadas
- **Inteligentes**: 0/3 probadas
- **JMN**: 0/8 probadas

### Notas:
- Usa este checklist para marcar cada función después de probarla
- Anota cualquier comportamiento inesperado o error
- Puedes ejecutar el test completo para verificar todas las funciones a la vez

---

**Fecha de creación**: 2026-04-18  
**Versión**: Jasboot v2.0+  
**Total funciones documentadas**: 31
