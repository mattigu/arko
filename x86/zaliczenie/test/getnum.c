#include <stdio.h>

unsigned int scandec(const char *s);

int main(int argc, char *argv[])
{
    for (int i = 1; i < argc; i++)
    {
        printf("%d: %s -> %u\n", i, argv[i], scandec(argv[i]));
    }
}
