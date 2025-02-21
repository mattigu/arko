#include "stdio.h"

char *leaverng(char *s, char a, char b);

int main(int argc, char *argv[])
{
    if(argc != 4)
    {
        printf("%scrash");
    }

    char *s = argv[1];
    char a = argv[2][0];
    char b = argv[3][0];

    printf("before:%s\n", s);
    char* result = leaverng(s,a,b);
    printf("after:%s\n", result);
}