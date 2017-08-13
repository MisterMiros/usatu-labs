#include "common.h"
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

size_t set_n(int argc, char** argv) {
    size_t N = MAX_N;
    if (argc == 2) {
        N = atoi(argv[1]);
    }
    if (argc == 3) {
        if (strcmp(argv[1],"-n") == 0) {
            N = atoi(argv[2]);
        }
        else if (strcmp(argv[1],"-mb") == 0) {
            N = (atoi(argv[2])*MB)/sizeof(int);
        }
    }
    return N > MAX_N ? MAX_N : N;
}

void random_ints(int* a, size_t size) {
    for (int i = 0; i<size; i++) {
        a[i] = rand() % 101 - 50;
    }
}

int check_results(int* a, int* b, int* c, size_t size) {
    int result = TRUE;
    for (int i = 0; i < size; i++) {
        if (c[i] != a[i]+b[i]) {
            result = FALSE;
        }
    }
    return result;
}

float add_calc_time(int* a,int* b,int* c,size_t N) {
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start, 0);

    add<<<(N+M-1)/M, M>>>(a, b, c, N); // Launch add() kernel on GPU with N blocks

    cudaDeviceSynchronize();
    check_cuda_errors(__FILE__,__LINE__);
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    float calc_time = 0;
    cudaEventElapsedTime(&calc_time, start, stop);
    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    return calc_time;
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
