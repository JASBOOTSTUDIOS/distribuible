#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    const char *linea = "usuario=42|accion=abrir|estado=ok\n";
    const char *accion_pat = "accion=";
    size_t linea_len = strlen(linea);
    size_t total_len = linea_len * 2500;
    char *s = (char *)malloc(total_len + 1);
    char *despues;
    char *barra;
    char *fin_linea;
    long long acc;

    if (!s) return 1;

    for (int i = 0; i < 2500; i++) {
        memcpy(s + (i * linea_len), linea, linea_len);
    }
    s[total_len] = '\0';

    despues = strstr(s, accion_pat);
    if (!despues) {
        free(s);
        return 1;
    }
    despues += strlen(accion_pat);
    barra = strchr(despues, '|');
    if (!barra) {
        free(s);
        return 1;
    }

    acc = (long long)total_len;
    acc += strstr(s, "estado=ok") ? 1 : 0;
    fin_linea = strchr(s, '\n');
    if (!fin_linea) {
        free(s);
        return 1;
    }
    acc += (fin_linea - s >= 2 && strncmp(fin_linea - 2, "ok", 2) == 0) ? 1 : 0;
    acc += (long long)(barra - despues);

    printf("%lld\n", acc);
    free(s);
    return 0;
}
