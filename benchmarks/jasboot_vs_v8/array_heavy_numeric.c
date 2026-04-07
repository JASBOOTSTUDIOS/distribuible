#include <stdio.h>

int main(void) {
    int datos[2048];
    long long acc = 0;

    for (int i = 0; i < 2048; i++) {
        datos[i] = (i * 7) % 997;
    }

    for (int i = 0; i < 300000; i++) {
        acc += (datos[i % 2048] * 3) + (i % 11);
    }

    printf("%lld\n", acc);
    return 0;
}
