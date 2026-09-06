/* ccapi.c */
#include <ccapi.h>
#include <stdarg.h>

import(encrypt);

void zero(int8* buf, int16 size) {
    __asm__ volatile (
        "cld\n\t"
        "rep stosb"
        : "+D"(buf), "+c"(size)
        : "a"(0)
        : "memory"
    );
}

args *mkargs(int32 count, ...) {
    if (count <= 0) return NULL;

    va_list ap;
    int16 size = (count * sizeof(void*)) + sizeof(struct s_args);
    args *a = (args *)malloc(size);
    if (!a) return NULL;

    zero((int8*)a, size);
    a->argc = count;

    va_start(ap, count);
    for (int32 i = 0; i < count; i++) {
        a->argv[i] = va_arg(ap, void*);
    }
    va_end(ap);

    return a;
}

void printargs_(int8 *ident, args *a) {
    if (!a) return;
    printf("%s:\n   argc   = %d\n", $c ident, a->argc);
    for (int32 n = 0; n < a->argc; n++) {
        printf("   argv[%d] = %p\n", $i n, a->argv[n]);
    }
}

int main() {
    int32 output = 0;
    
    /* Explicitly passing argument count removes stack scraping crashes */
    asmcall(encrypt, output, 2, (void*)3, (void*)6);
    printf("output = %d\n", $i output);

    return 0;
}