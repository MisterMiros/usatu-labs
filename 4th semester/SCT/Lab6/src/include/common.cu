#include "common.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

void random_ints(int* a, size_t size) {
    for (int i = 0; i<size; i++) {
        a[i] = rand() % 101 - 50;
    }
}

int check_results(int* a, int* b, int* c, size_t size) {
    int result = TRUE;
    for (int i = 0; i < size; i++) {
        if (c[i] != a[i]+b[i]) {
            //printf("%d, %d+%d=%d\n",i, a[i],b[i],c[i]);
            result = FALSE;
        }
    }
    return result;
}

__global__ void add(int *a, int *b, int *c, size_t size) {
    size_t index = threadIdx.x + blockIdx.x * blockDim.x;
    if (index < size) { c[index] = a[index] + b[index]; }
}

void check_cuda_errors(const char *filename, const int line_number) {
#ifdef DEBUG
    cudaDeviceSynchronize();
    cudaError_t error = cudaGetLastError();
    if(error != cudaSuccess) {
        printf("CUDA error at %s:%i: %s\n", filename, line_number, cudaGetErrorString(error));
        exit(-1);
    }
#endif
}
