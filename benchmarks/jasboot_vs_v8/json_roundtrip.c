#include <stdio.h>
#include <string.h>

int main(void) {
    const char *payload = "{\"user\":\"ana\",\"hits\":[1,2,3,4],\"ok\":true,\"value\":12}";
    long long acc = 0;

    for (int i = 0; i < 2000; i++) {
        char user[16] = {0};
        char ok[8] = {0};
        int h0 = 0, h1 = 0, h2 = 0, h3 = 0, value = 0;
        char out[128];
        int out_len;
        if (sscanf(payload,
                   "{\"user\":\"%15[^\"]\",\"hits\":[%d,%d,%d,%d],\"ok\":%7[^,],\"value\":%d}",
                   user, &h0, &h1, &h2, &h3, ok, &value) != 7) {
            return 1;
        }
        out_len = snprintf(out, sizeof(out),
                           "{\"user\":\"%s\",\"hits\":[%d,%d,%d,%d],\"ok\":%s,\"value\":%d}",
                           user, h0, h1, h2, h3, ok, value);
        acc += h0;
        acc += h3;
        acc += strcmp(ok, "true") == 0 ? 1 : 0;
        acc += value;
        acc += (long long)strlen(user);
        acc += out_len;
    }

    printf("%lld\n", acc);
    return 0;
}
