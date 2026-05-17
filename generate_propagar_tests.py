import random
import os

def generate_propagar_dmax_tests(n_cases=300):
    header = """# tests/production_robustness/test_propagar_dmax_massive.jasb
# Test masivo de propagacion y d_max (300 casos) con auditoria activa

principal
    imprimir "=== INICIANDO TEST MASIVO DE PROPAGACION Y D_MAX (300 CASOS) ==="
    
    # Crear una memoria RAM para el test
    abrir_memoria("tests/production_robustness/temp_propagar.jmn")
    
    # Definir conceptos base para simular una conversacion
    aprender("hola", 1.0)
    aprender("como", 1.0)
    aprender("estas", 1.0)
    aprender("bien", 1.0)
    aprender("clima", 1.0)
    aprender("sol", 1.0)
    aprender("lluvia", 1.0)
    aprender("ia", 1.0)
    aprender("jasboot", 1.0)
    
    # Crear algunas relaciones para saltos (tipo 3 = SECUENCIA)
    asociar_relacion("hola", "como", 3, 1.0)
    asociar_relacion("como", "estas", 3, 0.9)
    asociar_relacion("estas", "bien", 3, 0.8)
    asociar_relacion("ia", "jasboot", 3, 1.0)
    
"""
    
    words = ["hola", "como", "estas", "bien", "clima", "sol", "lluvia", "ia", "jasboot"]
    
    body = ""
    for i in range(1, n_cases + 1):
        word = random.choice(words)
        d_max = random.randint(0, 5)
        # Empaquetamos d_max en el registro de modo para propagar_activacion (bits 16-23)
        # modo = tipo (bit 0-7) | K (bit 8-15) | prof (bit 16-23)
        modo = 3 | (8 << 8) | (d_max << 16)
        
        body += f'    imprimir "\\nTest {i}: Semilla \'{word}\' con d_max={d_max}"\n'
        body += f'    entero res{i} = propagar_activacion("{word}", {modo})\n'
        body += f'    si res{i} != 0 entonces\n'
        body += f'        imprimir "  Propagacion completada."\n'
        body += f'    sino\n'
        body += f'        imprimir "  No se encontraron asociaciones."\n'
        body += f'    fin_si\n'
    
    footer = """
    cerrar_memoria()
    imprimir "\\n=== TEST MASIVO FINALIZADO ==="
fin_principal
"""
    
    os.makedirs("c:/src/jasboot/tests/production_robustness", exist_ok=True)
    with open("c:/src/jasboot/tests/production_robustness/test_propagar_dmax_massive.jasb", "w", encoding="utf-8") as f:
        f.write(header + body + footer)
    print(f"Generated 300 test cases in c:/src/jasboot/tests/production_robustness/test_propagar_dmax_massive.jasb")

if __name__ == "__main__":
    generate_propagar_dmax_tests(300)
