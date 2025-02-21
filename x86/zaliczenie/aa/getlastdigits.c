#include <stdio.h>
#include <stdlib.h>

char *leavelastndig(char *s, int n);

int main(int argc, char *argv[])
{
    if(argc !=3)
    {
        printf("broke");
    }
    char *s = argv[1];
    int n = atoi(argv[2]);


    printf("before:%s\n", s);
    char* result = leavelastndig(s,n);
    printf("after:%s\n", result);
}