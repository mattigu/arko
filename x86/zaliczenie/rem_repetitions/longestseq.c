#include "stdio.h"

char *leavelongestnum(char *s);

int main(int argc, char *argv[])
{
    char *s = argv[1];

    printf("before:%s\n", s);
    char* result = leavelongestnum(s);
    printf("after:%s\n", result);
}