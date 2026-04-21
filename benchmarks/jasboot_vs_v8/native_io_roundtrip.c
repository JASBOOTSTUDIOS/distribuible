#include <stdio.h>
#include <string.h>

int main(void) {
    FILE *f = fopen("v8_io_roundtrip.txt", "wb");
    char line[64];
    long long total;

    if (!f) return 1;
    for (int i = 0; i < 600; i++) {
        int len = snprintf(line, sizeof(line), "fila\n");
        fwrite(line, 1, (size_t)len, f);
    }
    fclose(f);

    f = fopen("v8_io_roundtrip.txt", "rb");
    if (!f) return 1;
    if (fseek(f, 0, SEEK_END) != 0) {
        fclose(f);
        return 1;
    }
    total = (long long)ftell(f);
    fclose(f);

    printf("%lld\n", total);
    return 0;
}
