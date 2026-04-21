#include <stdio.h>
#include <time.h>

int main() {
    time_t t = time(NULL);
    printf("Timestamp: %ld\n", (long)t);
    struct tm *tm_info = localtime(&t);
    char buf[128];
    strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M:%S", tm_info);
    printf("Formatted: %s\n", buf);
    return 0;
}
