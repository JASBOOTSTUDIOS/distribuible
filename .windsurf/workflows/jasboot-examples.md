# JASBOOT EXAMPLES - Ejemplos Canónicos

Estos ejemplos definen el estilo y patrones correctos para programar en Jasboot. Úsalos como referencia.

---

## Ejemplo 1: Programa Básico

```jasb
# programa_basico.jasb
# Demostración de estructura mínima y sintaxis
 
principal
    # Variables con tipado explícito
    entero edad = 25
    texto nombre = "Juan"
    flotante altura = 1.75
    
    # Salida básica
    imprimir "Nombre: " + nombre
    imprimir "Edad: " + str_desde_numero(edad)
    imprimir "Altura: " + str_desde_numero(altura)
    
    # Condicional simple
    si edad >= 18 entonces
        imprimir "Es mayor de edad"
    sino
        imprimir "Es menor de edad"
    fin_si
    
fin_principal
```

---

## Ejemplo 2: Bucles y Listas

```jasb
# bucles_listas.jasb
# Manejo de estructuras de datos

principal
    # Crear y manipular listas
    lista numeros = crear_lista()
    lista_agregar(numeros, 10.0)
    lista_agregar(numeros, 20.0)
    lista_agregar(numeros, 30.0)
    lista_agregar(numeros, 40.0)
    lista_agregar(numeros, 50.0)
    
    imprimir "Lista con " + str_desde_numero(lista_tamano(numeros)) + " elementos"
    
    # Bucle mientras para procesar lista
    entero i = 0
    flotante suma = 0.0
    
    mientras i < lista_tamano(numeros) hacer
        elemento elemento_valor = lista_obtener(numeros, i)
        suma = suma + elemento_valor
        imprimir "Elemento " + str_desde_numero(i) + ": " + str_desde_numero(elemento_valor)
        i = i + 1
    fin_mientras
    
    flotante media = suma / lista_tamano(numeros)
    imprimir "Suma: " + str_desde_numero(suma)
    imprimir "Media: " + str_desde_numero(media)
    
fin_principal
```

---

## Ejemplo 3: Funciones y Módulos

```jasb
# calculadora.jasb
# Definición de funciones reutilizables

funcion sumar(flotante num_a, flotante num_b) retorna flotante
    retornar num_a + num_b
fin_funcion

funcion restar(flotante num_a, flotante num_b) retorna flotante
    retornar num_a - num_b
fin_funcion

funcion multiplicar(flotante num_a, flotante num_b) retorna flotante
    retornar num_a * num_b
fin_funcion

funcion dividir(flotante num_a, flotante num_b) retorna flotante
    si num_b == 0 entonces
        retornar -999999.0  # Valor especial para error
    fin_si
    retornar num_a / num_b
fin_funcion

principal
    flotante cord_x = 15.0
    flotante cord_y = 3.0
    
    imprimir "Operaciones con " + str_desde_numero(cord_x) + " y " + str_desde_numero(cord_y)
    imprimir "Suma: " + str_desde_numero(sumar(cord_x, cord_y))
    imprimir "Resta: " + str_desde_numero(restar(cord_x, cord_y))
    imprimir "Multiplicación: " + str_desde_numero(multiplicar(cord_x, cord_y))
    imprimir "División: " + str_desde_numero(dividir(cord_x, cord_y))
    
fin_principal

# Exportar funciones para uso en otros módulos
enviar {sumar, restar, multiplicar, dividir}

```

---

## Ejemplo 4: Clases y Herencia

```jasb
# clases.jasb
# Programación orientada a objetos

clase Animal
    texto nombre
    entero edad
    
    funcion Animal(texto nombre_param, entero edad_param)
        este.nombre = nombre_param
        este.edad = edad_param
    fin_funcion
    
    funcion hacer_sonido() retorna texto
        retornar "Sonido genérico"
    fin_funcion
    
    funcion presentarse() retorna texto
        retornar "Soy " + este.nombre + " y tengo " + str_desde_numero(este.edad) + " años"
    fin_funcion
    
fin_clase

clase Perro extiende Animal
    texto raza
    
    funcion Perro(texto nombre_param, entero edad_param, texto raza_param)
        # Llamar constructor padre
        este.nombre = nombre_param
        este.edad = edad_param
        este.raza = raza_param
    fin_funcion
    
    funcion hacer_sonido() retorna texto
        retornar "Guau guau!"
    fin_funcion
    
    funcion ladrar() retorna texto
        retornar este.nombre + " está ladrando"
    fin_funcion
    
fin_clase

principal
    # Crear instancias
    Animal animal_generico = Animal("Criatura", 5)
    Perro mi_perro = Perro("Fido", 3, "Labrador")
    
    # Usar métodos
    imprimir animal_generico.presentarse()
    imprimir animal_generico.hacer_sonido()
    
    imprimir mi_perro.presentarse()
    imprimir mi_perro.hacer_sonido()
    imprimir mi_perro.ladrar()
    
fin_principal
```

---

## Ejemplo 5: Memoria Neuronal

```jasb
# memoria_neuronal.jasb
# Uso de capacidades cognitivas de Jasboot

principal
    # Almacenar información en memoria neuronal
    recordar("usuario_actual", "Maria")
    recordar("sesion_inicio", "2024-01-15")
    recordar("preferencia_tema", "oscuro")
    
    # Recuperar información

    buscar("usuario_actual")
    texto usuario = resultado
    buscar("sesion_inicio")
    texto sesion = resultado
    buscar("preferencia_tema")
    texto tema = resultado
    
    imprimir "Usuario: " + usuario
    imprimir "Sesión: " + sesion
    imprimir "Tema: " + tema
    
    # Asociación de conceptos
    asociar("programacion", "jasboot")
    asociar("jasboot", "memoria_neuronal")
    asociar("memoria_neuronal", "ia")
    
    # Procesamiento cognitivo
    texto pregunta = "Qué es Jasboot?"
    texto respuesta = pensar(pregunta)
    imprimir "Pregunta: " + pregunta
    imprimir "Respuesta: " + respuesta
    
    # Registrar patrones
    registrar_patron("saludo_formal", "Buenos días")
    registrar_patron("saludo_informal", "Hola")
    asociar_relacion("saludo_formal", "contexto_profesional")
    asociar_relacion("saludo_informal", "contexto_amigos")
    
    # Comparar patrones
    texto similitud = comparar_patrones("Buenos días", "Hola")
    imprimir "Similitud entre saludos: " + similitud
    
fin_principal
```

---

## Ejemplo 6: Manejo de Archivos

```jasb
# manejo_archivos.jasb
# Operaciones de entrada/salida

funcion leer_archivo_completo(texto ruta) retorna texto
    texto contenido = ""
    si existe_archivo(ruta) entonces
        archivo handle = abrir_archivo(ruta, "lectura")
        si handle != nulo entonces
            texto linea = leer_linea_archivo(handle)
            mientras linea != "" hacer
                contenido = contenido + linea + "\n"
                linea = leer_linea_archivo(handle)
            fin_mientras
            cerrar_archivo(handle)
        fin_si
    fin_si
    retornar contenido
fin_funcion

funcion escribir_archivo(texto ruta, texto contenido) retorna booleano
    archivo handle = abrir_archivo(ruta, "escritura")
    si handle != nulo entonces
        escribir_archivo(handle, contenido)
        cerrar_archivo(handle)
        retornar verdadero
    fin_si
    retornar falso
fin_funcion

principal
    # Escribir archivo de prueba
    texto datos = "Este es un archivo de prueba\n"
    datos = datos + "Creado con Jasboot\n"
    datos = datos + "Fecha: " + str_desde_numero(obtener_timestamp()) + "\n"
    
    si escribir_archivo("test.txt", datos) entonces
        imprimir "Archivo escrito exitosamente"
        
        # Leer y mostrar contenido
        texto leido = leer_archivo_completo("test.txt")
        imprimir "Contenido del archivo:"
        imprimir leido
    sino
        imprimir "Error al escribir archivo"
    fin_si
    
fin_principal
```

---

## Ejemplo 7: Mapas y Configuración

```jasb
# configuracion.jasb
# Uso de mapas para almacenar configuración

funcion crear_configuracion_default() retorna mapa
    mapa config = mapa_crear()
    mapa_poner(config, "app_nombre", "MiApp")
    mapa_poner(config, "version", "1.0.0")
    mapa_poner(config, "debug", verdadero)
    mapa_poner(config, "max_usuarios", 100)
    mapa_poner(config, "timeout", 30.0)
    retornar config
fin_funcion

funcion obtener_config(mapa config, texto _clave) retorna cualquiera
    elemento _valor = mapa_obtener(config, _clave)
    si _valor == nulo entonces
        imprimir "Configuración no encontrada: " + _clave
        retornar "indefinido"
    fin_si
    retornar _valor
fin_funcion

funcion imprimir_configuracion(mapa config)
    imprimir "=== CONFIGURACIÓN ==="
    imprimir "App: " + obtener_config(config, "app_nombre")
    imprimir "Versión: " + obtener_config(config, "version")
    imprimir "Debug: " + obtener_config(config, "debug")
    imprimir "Max usuarios: " + obtener_config(config, "max_usuarios")
    imprimir "Timeout: " + obtener_config(config, "timeout")
    imprimir "===================="
fin_funcion

principal
    # Crear configuración
    mapa mi_config = crear_configuracion_default()
    
    # Mostrar configuración
    imprimir_configuracion(mi_config)
    
    # Modificar valores
    mapa_poner(mi_config, "debug", falso)
    mapa_poner(mi_config, "max_usuarios", 200)
    
    imprimir "Configuración modificada:"
    imprimir_configuracion(mi_config)
    
fin_principal
```

---

## Ejemplo 8: Manejo de Errores

```jasb
# manejo_errores.jasb
# Control de errores y excepciones

funcion dividir_seguro(flotante numerador, flotante denominador) retorna cualquiera
    intentar
        si denominador == 0 entonces
            lanzar "División por cero"
        fin_si
        
        flotante resultado = numerador / denominador
        retornar resultado
        
    atrapar error
        imprimir "Error en división: " + error
        retornar -999999.0  # Valor especial de error
    fin_intentar
fin_funcion

funcion procesar_lista(lista datos) retorna booleano
    si datos == nulo o lista_tamano(datos) == 0 entonces
        imprimir "Error: Lista vacía o nula"
        retornar falso
    fin_si
    
    intentar
        entero i = 0
        mientras i < lista_tamano(datos) hacer
            elemento valor = lista_obtener(datos, i)
            si valor == nulo entonces
                lanzar "Elemento nulo en posición " + str_desde_numero(i)
            fin_si
            
            # Procesar valor
            imprimir "Procesando: " + str_desde_numero(valor)
            i = i + 1
        fin_mientras
        
        retornar verdadero
        
    atrapar error
        imprimir "Error procesando lista: " + error
        retornar falso
    fin_intentar
fin_funcion

principal
    # Probar división segura
    flotante resultado1 = dividir_seguro(10.0, 2.0)
    imprimir "10 / 2 = " + str_desde_numero(resultado1)
    
    flotante resultado2 = dividir_seguro(10.0, 0.0)
    imprimir "10 / 0 = " + str_desde_numero(resultado2)
    
    # Probar procesamiento de lista
    lista datos_validos = crear_lista()
    lista_agregar(datos_validos, 1.0)
    lista_agregar(datos_validos, 2.0)
    lista_agregar(datos_validos, 3.0)
    
    imprimir "Procesando lista válida:"
    booleano exito1 = procesar_lista(datos_validos)
    imprimir "Resultado: " + (exito1 ? "Éxito" : "Fallo")
    
fin_principal
```

---

## Ejemplo 9: Importación de Módulos

```jasb
# math_utils.jasb
# Módulo de utilidades matemáticas

funcion factorial(entero n) retorna entero
    si n <= 1 entonces
        retornar 1
    fin_si
    retornar n * factorial(n - 1)
fin_funcion

funcion es_primo(entero n) retorna booleano
    si n <= 1 entonces
        retornar falso
    fin_si
    
    entero i = 2
    mientras i * i <= n hacer
        si n % i == 0 entonces
            retornar falso
        fin_si
        i = i + 1
    fin_mientras
    
    retornar verdadero
fin_funcion

funcion fibonacci(entero n) retorna entero
    si n <= 0 entonces
        retornar 0
    sino si n == 1 entonces
        retornar 1
    sino
        retornar fibonacci(n - 1) + fibonacci(n - 2)
    fin_si
fin_funcion

# Exportar funciones
enviar factorial
enviar es_primo
enviar fibonacci
```

```jasb
# programa_principal.jasb
# Uso de módulos importados

usar { factorial, es_primo, fibonacci } de "math_utils.jasb"

principal
    entero numero = 10
    
    imprimir "Análisis del número " + str_desde_numero(numero)
    imprimir "Factorial: " + str_desde_numero(factorial(numero))
    imprimir "Es primo: " + (es_primo(numero) ? "Sí" : "No")
    
    entero i = 0
    imprimir "Serie Fibonacci hasta " + str_desde_numero(numero) + ":"
    mientras i <= numero hacer
        imprimir "F(" + str_desde_numero(i) + ") = " + str_desde_numero(fibonacci(i))
        i = i + 1
    fin_mientras
    
fin_principal
```

---

## Compilación y Ejecución

Para compilar y ejecutar cualquier ejemplo:

```bash
# Compilar
jbc ejemplo.jasb -o ejemplo.jbo

# Ejecutar
jasboot-ir-vm.exe ejemplo.jbo

# O usar el atajo
jb.cmd ejemplo.jasb
```

---

## Buenas Prácticas Demostradas

1. **Tipado explícito** - Siempre declarar tipos
2. **Nombres descriptivos** - Variables y funciones claras
3. **Modularidad** - Funciones reutilizables y módulos
4. **Manejo de errores** - Validación y control de excepciones
5. **Comentarios** - Documentar el propósito del código
6. **Estructura limpia** - Sangría y organización consistentes
7. **Memoria neuronal** - Usar capacidades cognitivas apropiadamente
8. **Validación** - Verificar entradas y estados

Estos ejemplos sirven como referencia canónica para todo código Jasboot generado.
