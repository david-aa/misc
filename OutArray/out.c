#include <stdio.h>

int main() {
    char *input[] = {"This", "is", "an", "array"};
    int max = 4;
    for (int x=0; x<=max; x++) {
        printf("Index: %d // Value: %s\n", x, input[x]);
    }
    printf("Goodbye, I'm C!\n");

}

