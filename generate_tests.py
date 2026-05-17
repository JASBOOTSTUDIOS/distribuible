import random

def generate_jasboot_tests(n_cases=400):
    header = """# tests/production_robustness/test_L_massive.jasb
# Test de robustez de produccion para el pipeline L (400 casos)

principal
    imprimir "=== INICIANDO TEST DE ROBUSTEZ L (400 CASOS) ==="
    
    texto lemmas = "corriendo=correr,casas=casa,gatos=gato,estudiando=estudiar,mejorado=mejorar,comiendo=comer,perros=perro,libros=libro,leyendo=leer,escrito=escribir"
    texto stops = "el,la,los,las,un,una,de,en,y,a,con,por,para,que"
    
"""
    
    scenarios = [
        ("Basic", ["hola mundo", "esto es jasboot", "tokenizacion l"]),
        ("Unicode", ["HOLA MUNDO", "Mañana será un gran día", "Café y té"]),
        ("Punct", ["hola, mundo!", "¿cómo estás?", "jasboot: el lenguaje."]),
        ("Stop", ["el gato de la vecina", "un perro y una gata", "la casa de papel"]),
        ("Lemma", ["corriendo por las casas", "estudiando los libros", "comiendo con los gatos"]),
        ("Ngram2", ["a b c d", "uno dos tres", "rojo verde azul"]),
        ("Ngram3", ["la casa grande", "el perro blanco", "un gato negro"]),
        ("Ngram4", ["esto es un test", "me gusta programar mucho", "jasboot es muy potente"]),
        ("Ngram5", ["el rapido zorro marron salta", "uno dos tres cuatro cinco", "programacion orientada a objetos"]),
        ("Contract", ["de el", "a el", "por que", "para que"]),
        ("Complex", ["El Gato de la vecina está corriendo por las CASAS!", "Mañana, el PERRO comerá mucho.", "Jasboot: potente y rápido."])
    ]

    body = ""
    for i in range(1, n_cases + 1):
        s_name, s_texts = random.choice(scenarios)
        txt = random.choice(s_texts)
        
        # Pick random flags for variety
        current_mode = 1 # Lower always
        if i % 2 == 0: current_mode |= 2 # Collapse
        if i % 3 == 0: current_mode |= 64 # Punct
        if i % 5 == 0: current_mode |= 256 # Stop
        if i % 7 == 0: current_mode |= 16777216 # Lemma
        if i % 11 == 0: current_mode |= 4 # Bigram
        if i % 13 == 0: current_mode |= 16 # Trigram
        if i % 17 == 0: current_mode |= 512 # Contract
        if i % 19 == 0: current_mode |= 67108864 # 4gram
        if i % 23 == 0: current_mode |= 134217728 # 5gram
        
        body += f'    imprimir "Test {i} [{s_name}]: {txt} (Modo: {current_mode})"\n'
        body += f'    lista l{i} = tokenizar_L("{txt}", " ", {current_mode}, stops, 0, lemmas)\n'
        body += f'    imprimir l{i}\n'
    
    footer = """
    imprimir "\\n=== TEST FINALIZADO CON EXITO (400 CASOS) ==="
fin_principal
"""
    
    import os
    os.makedirs("c:/src/jasboot/tests/production_robustness", exist_ok=True)
    with open("c:/src/jasboot/tests/production_robustness/test_L_massive.jasb", "w", encoding="utf-8") as f:
        f.write(header + body + footer)
    print(f"Generated 400 test cases in c:/src/jasboot/tests/production_robustness/test_L_massive.jasb")

if __name__ == "__main__":
    generate_jasboot_tests(400)
