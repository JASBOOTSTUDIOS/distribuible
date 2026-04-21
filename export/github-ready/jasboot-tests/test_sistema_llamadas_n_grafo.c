/**
 * Verifica que todas las funciones n_* del glosario estén en SISTEMA_LLAMADAS.
 * Desde raíz: run_tests_sistema_llamadas.bat
 */
#include "sistema_llamadas.h"
#include <stdio.h>
#include <string.h>

/* Lista esperada según CHECKLIST_CONCEPTOS_OPTIMIZADOS_V1.md glosario */
static const char* N_GRAFO_ESPERADAS[] = {
    "n_abrir_grafo", "n_cerrar_grafo", "n_grafo_valido",
    "n_obtener_id", "n_obtener_texto", "n_existe_concepto",
    "n_recordar", "n_recordar_peso", "n_recordar_triple_texto",
    "n_buscar_objeto", "n_buscar_objetos", "n_buscar_objeto_texto",
    "n_buscar_sujeto", "n_buscar_sujetos", "n_buscar_predicados",
    "n_buscar_donde_aparece", "n_lista_triples", "n_tamano_grafo",
    "n_olvidar_triple", "n_configurar_cache_lru", "n_configurar_bloom",
    "n_heredar", "n_heredar_texto"
};
#define N_N_GRAFO (sizeof(N_GRAFO_ESPERADAS) / sizeof(N_GRAFO_ESPERADAS[0]))

static int tiene_llamada(const char* name) {
    size_t len = strlen(name);
    return is_sistema_llamada(name, len);
}

int main(void) {
    int fails = 0;
    for (size_t i = 0; i < N_N_GRAFO; i++) {
        if (!tiene_llamada(N_GRAFO_ESPERADAS[i])) {
            printf("FALTA en SISTEMA_LLAMADAS: %s\n", N_GRAFO_ESPERADAS[i]);
            fails++;
        }
    }
    if (fails == 0) {
        printf("OK: Las %zu funciones n_* del glosario estan registradas.\n", N_N_GRAFO);
        return 0;
    }
    printf("Faltan %d funciones n_* en sistema_llamadas.c\n", fails);
    return 1;
}
