/* ccapi.h */
#ifndef CCAPI_H
#define CCAPI_H

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>

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

#define import(x) extern int32 x(args*)

#define asmcall(f, o, count, ...) do { \
    int32 (*_p)(args*); \
    args *_args; \
    _p = &((f)); \
    _args = mkargs((count), ##__VA_ARGS__); \
    if (!_args) \
        (o) = 0; \
    else \
        (o) = _p(_args); \
} while(0)

struct s_args {
    int32 argc;
    void *argv[];
};
typedef struct s_args args;

args *mkargs(int32 count, ...);
void printargs_(int8 *ident, args *a);
void zero(int8 *buf, int16 size);

#endif