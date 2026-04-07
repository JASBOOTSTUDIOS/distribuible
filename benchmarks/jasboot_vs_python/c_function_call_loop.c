#include <stdio.h>

static int inc(int u) {
    return u + 1;
}

int main(void) {
    int i = 0;
    while (i < 5000) {
        i = inc(i);
    }
    printf("%d\n", i);
    return 0;
}
