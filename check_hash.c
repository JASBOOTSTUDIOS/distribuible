#include <stdio.h>
#include <stdint.h>
#include <string.h>

uint32_t hash_texto(const char* s) {
    uint32_t hash = 5381;
    int c;
    while ((c = *s++))
        hash = ((hash << 5) + hash) + c;
    return hash;
}

int main() {
    printf("Hash de 'como': 0x%08X\n", hash_texto("como"));
    printf("Hash de 'como ': 0x%08X\n", hash_texto("como "));
    printf("Hash de 'como estas': 0x%08X\n", hash_texto("como estas"));
    return 0;
}
