/* Copyright 2019 Kis Imre */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    FILE *fp = NULL;
    uint32_t checksum = 0;
    uint32_t temp = 0;
    uint32_t i = 0;

    if (argc < 2) {
        fprintf(stderr, "Usage: %s [binary file]\n", argv[0]);

        return EXIT_FAILURE;
    }

    if ((fp = fopen(argv[1], "r+")) == NULL) {
        fprintf(stderr, "Cannot open file: %s\n", argv[1]);
        return EXIT_FAILURE;
    }

    for (i = 0; i < 7; i++) {
        if (fread(&temp, 1, sizeof(temp), fp) != sizeof(temp)) {
            fprintf(stderr, "Failed to read file: %d %s\n", argv[1]);

            fclose(fp);
            return EXIT_FAILURE;
        }

        checksum += temp;
    }

    checksum = -checksum;

    if (fwrite(&checksum, 1, sizeof(checksum), fp) != sizeof(checksum)) {
        fprintf(stderr, "Failed to write file: %s\n", argv[1]);

        fclose(fp);
        return EXIT_FAILURE;
    }

    fclose(fp);

    return EXIT_SUCCESS;
}
