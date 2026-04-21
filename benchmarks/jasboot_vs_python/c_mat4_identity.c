#include <stdio.h>

static void mat4_mul(const double* a, const double* b, double* out) {
    for (int r = 0; r < 4; r++) {
        int base = r * 4;
        for (int c = 0; c < 4; c++) {
            out[base + c] =
                a[base + 0] * b[c + 0] +
                a[base + 1] * b[c + 4] +
                a[base + 2] * b[c + 8] +
                a[base + 3] * b[c + 12];
        }
    }
}

int main(void) {
    const double identity[16] = {
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
    };
    double acc[16];
    double tmp[16];
    for (int i = 0; i < 16; i++) {
        acc[i] = identity[i];
        tmp[i] = identity[i];
    }
    for (int i = 0; i < 50000; i++) {
        mat4_mul(acc, identity, tmp);
        mat4_mul(tmp, identity, acc);
    }
    printf("%.4f\n\n", acc[0]);
    return 0;
}
