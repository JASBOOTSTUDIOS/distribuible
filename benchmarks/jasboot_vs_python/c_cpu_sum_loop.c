#include <stdio.h>
#include <stdint.h>

int main(void) {
    const uint64_t N = 5000000ULL;
    uint64_t s = 0;
    uint64_t i = 0;
    while (i < N) {
        s += i;
        i += 1;
    }
    printf("%llu\n", (unsigned long long)s);
    return 0;
}
