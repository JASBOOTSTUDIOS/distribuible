#include <stdio.h>

typedef struct {
    int id;
    int total;
    const char *nombre;
} Evento;

int main(void) {
    Evento ev;
    long long acc = 0;

    for (int i = 0; i < 80000; i++) {
        ev.id = i;
        ev.total = i * 2;
        ev.nombre = "evento";
        acc += ev.id + ev.total + (long long)6;
    }

    printf("%lld\n", acc);
    return 0;
}
