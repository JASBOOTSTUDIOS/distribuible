#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    const char* left = " ab ";
    const char* right = "Jefry Astacio";
    const size_t left_len = 4;
    const size_t right_len = 13;
    size_t len = 1;
    char* s = (char*)malloc(1615002);
    char tmp[121];
    if (!s) return 1;
    s[0] = 'x';
    s[1] = '\0';
    for (int i = 0; i < 95000; i++) {
        memcpy(s + len, left, left_len);
        len += left_len;
        memcpy(s + len, right, right_len);
        len += right_len;
        s[len] = '\0';
    }
    for (int j = 0; j < 3000000; j++) {
        memcpy(tmp, s, 120);
        tmp[120] = '\0';
    }
    printf("%zu\n\n%s\n", len, tmp);
    free(s);
    return 0;
}
