import random
import os

CATEGORIES = [
    {"name": "Atencion Medica", "profile": "analitico", "h_mode": 2, "h_lambda": 0.8, "h_kappa": 0.05, "taus": [(3, 1.5), (9, 1.2)], "masks": [(11, 0.0)]},
    {"name": "Investigacion Legal", "profile": "analitico", "h_mode": 1, "h_lambda": 0.5, "h_kappa": 0.1, "taus": [(27, 2.0), (14, 1.5)], "masks": [(1, 1.0)]},
    {"name": "Escritura Creativa", "profile": "explorador", "h_mode": 0, "h_lambda": 0.9, "h_kappa": 0.2, "taus": [(1, 1.8), (2, 1.4)], "masks": []},
    {"name": "Soporte Tecnico", "profile": "analitico", "h_mode": 3, "h_lambda": 0.7, "h_kappa": 0.15, "taus": [(22, 1.9), (30, 1.3)], "masks": [(22, 1.0)]}
]

os.makedirs('c:/src/jasboot/tests/profiles', exist_ok=True)
with open('c:/src/jasboot/tests/profiles/perfil_medico.txt', 'w') as f: f.write("3 1.5\n9 1.2\n11 0.0\n")
with open('c:/src/jasboot/tests/profiles/perfil_legal.txt', 'w') as f: f.write("27 2.0\n14 1.5\n1 1.0\n")

with open('c:/src/jasboot/tests/stress_test_g_tau.jasb', 'w', encoding='utf-8') as f:
    f.write("// Stress Test Final - 400 casos de uso reales\n\n")
    
    for b in range(10):
        f.write(f"funcion lote_{b}() retorna entero\n")
        for i in range(40):
            cat = random.choice(CATEGORIES)
            f.write(f"    cargar_perfil_g(\"{cat['profile']}\")\n")
            f.write(f"    configurar_h_modo({cat['h_mode']})\n")
            f.write(f"    configurar_h_lambda({cat['h_lambda']})\n")
            f.write(f"    configurar_h_kappa({cat['h_kappa']})\n")
            for tau, peso in cat['taus']: f.write(f"    configurar_peso_g({tau}, {peso:.2f})\n")
            for tau, mask in cat['masks']: f.write(f"    configurar_mascara_g({tau}, {mask:.1f})\n")
        f.write("    normalizar_pesos_g()\n")
        f.write(f"    imprimir \"Lote {b} OK.\"\n")
        f.write("    retornar 0\n")
        f.write("fin_funcion\n\n")

    f.write("principal\n")
    f.write("    imprimir \"[TEST] Iniciando validacion de 400 escenarios...\"\n")
    for b in range(10):
        f.write(f"    lote_{b}()\n")
    f.write("    imprimir \"[TEST] Stress test finalizado con exito.\"\n")
    f.write("fin_principal\n")
