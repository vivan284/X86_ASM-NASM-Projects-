/* ccapi.h */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

typedef unsigned char int8;
typedef unsigned short int int16;
typedef unsigned int int32;
typedef unsigned long long int int64;

#define $c (char *)
#define $i (int)
#define $1 (int8 *)
#define $2 (int16)
#define $4 (int32)
#define $8 (int64)

#define Args(x) \
 __asm("push %ebx");
 __asm("mov %%ebp, %eebx");
 __asm("add $0x08,%ebx")
 _asm("mov %%ebp,%0":"=r"(_x)); \
 _x += 8;\
 arg = (unsigned int *)_x

struct s_args{
    int32 argc;
    void *argv[];
};
typedef struct s_args args;

/* constructors */
args *mkargs()
