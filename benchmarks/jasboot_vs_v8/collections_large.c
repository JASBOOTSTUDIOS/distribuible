#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *valores = (int *)malloc(sizeof(int) * 20000);
    int *indices = (int *)malloc(sizeof(int) * 20000);
    long long acc = 0;
    if (!valores || !indices) return 1;

    for (int i = 0; i < 20000; i++) {
        valores[i] = i % 1000;
        indices[i] = i * 3;
    }

    for (int i = 0; i < 20000; i++) {
        acc += valores[i % 1000];
        acc += indices[i];
    }

    printf("%lld\n", acc);
    free(valores);
    free(indices);
    return 0;
}
