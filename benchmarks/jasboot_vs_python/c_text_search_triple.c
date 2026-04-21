#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    char* s = (char*)malloc(1602);
    int acc = 0;
    size_t len = 1;
    if (!s) return 1;
    s[0] = 'x';
    s[1] = '\0';
    for (int i = 0; i < 800; i++) {
        s[len++] = 'a';
        s[len++] = 'b';
        s[len] = '\0';
    }
    for (int j = 0; j < 5000; j++) {
        acc += strstr(s, "ab") ? 1 : 0;
        acc += (int)(strstr(s, "ab") - s);
        acc += (len >= 1 && s[len - 1] == 'b') ? 1 : 0;
    }
    printf("%zu\n\n%d\n\n", len, acc);
    free(s);
    return 0;
}
