#include <stdio.h>

typedef struct {
    int base;
} AddCtx;

static int add_ctx(const AddCtx* ctx, int x) {
    return x + ctx->base;
}

static int fact(int n) {
    return n <= 1 ? 1 : (n * fact(n - 1));
}

int main(void) {
    AddCtx ctx = { 7 };
    long long acc = 0;

    for (int i = 0; i < 20000; i++) {
        acc += add_ctx(&ctx, i % 5);
        acc += fact(6);
    }

    printf("%lld\n", acc);
    return 0;
}
