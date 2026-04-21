#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    size_t len = 1;
    char* s = (char*)malloc(16002);
    if (!s) return 1;
    s[0] = 'a';
    s[1] = '\0';
    for (int i = 0; i < 8000; i++) {
        s[len++] = 'b';
        s[len++] = 'c';
        s[len] = '\0';
    }
    printf("%zu\n\n", len);
    free(s);
    return 0;
}
