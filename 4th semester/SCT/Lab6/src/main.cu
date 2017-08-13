#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <stdint.h>
#include "include/common.h"

#define CUDA_MALLOC(a,s) \
    cudaMalloc((void **)&a,s); \
    check_cuda_errors(__FILE__,__LINE__);

#define CUDA_MALLOC_HOST(a,s) \
    cudaMallocHost((void**)&a,s); \
    check_cuda_errors(__FILE__,__LINE__);

int main(int argc, char** argv) {
    int nStreams = 32;
    size_t N = MAX_N;
    if (argc > 1) { nStreams = atoi(argv[1]); }
    if (argc > 2) {
        N = atoi(argv[2]);
        N = N > MAX_N ? MAX_N : N;
    }
    printf("N = %lu\n",N);
    printf("Stream Count = %d\n", nStreams);
    srand(time(NULL));
    clock_t start_c = clock();
    int *a, *b, *c; // host copies of a, b, c
    int *d_a, *d_b, *d_c; // device copies of a, b, c
    size_t size = N * sizeof(int);
    // Alloc space for device copies of a, b, c
    CUDA_MALLOC(d_a,size);
    CUDA_MALLOC(d_b,size);
    CUDA_MALLOC(d_c,size);
    // Alloc space for host copies of a, b, c
    // and setup input values
    CUDA_MALLOC_HOST(a,size);
    random_ints(a, N);
    CUDA_MALLOC_HOST(b,size);
    random_ints(b, N);
    CUDA_MALLOC_HOST(c,size);

    cudaStream_t* streams =
        (cudaStream_t *)malloc(nStreams*sizeof(cudaStream_t));
    for (int i = 0; i < nStreams; i++) {
        cudaStreamCreate(&streams[i]);
    }

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaDeviceSynchronize();
    cudaEventRecord(start, 0);

    size_t width = N / nStreams;
    for (int i = 0; i < nStreams; i++) {
        size_t offset = i*width;
        cudaMemcpyAsync(&d_a[offset], &a[offset],
            width*sizeof(int), cudaMemcpyHostToDevice, streams[i]);
        cudaMemcpyAsync(&d_b[offset], &b[offset],
            width*sizeof(int), cudaMemcpyHostToDevice, streams[i]);
        add<<<(width+M-1)/M,M,0,streams[i]>>>
            (&d_a[offset],&d_b[offset],&d_c[offset], width);
    }
    for (int i = 0; i < nStreams; i++) {
        size_t offset = i*width;
        cudaMemcpyAsync(&c[offset],&d_c[offset],
            width*sizeof(int), cudaMemcpyDeviceToHost, streams[i]);
    }

    cudaDeviceSynchronize();
    check_cuda_errors(__FILE__,__LINE__);
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    float calc_time = 0;
    cudaEventElapsedTime(&calc_time, start, stop);
    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    printf("GPU time: %.4f ms\n", calc_time);

    printf(check_results(a, b, c, N) ? "Result is correct\n" : "Result is wrong\n");
    // Cleanup
    for(int i = 0; i < nStreams; i++) {
        cudaStreamDestroy(streams[i]);
    }

    cudaFreeHost(a); cudaFreeHost(b); cudaFreeHost(c);
    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
    clock_t end_c = clock();
    printf("Total time: %.4f ms \n", ((double)(end_c-start_c)) * 1000 / CLOCKS_PER_SEC);
    return 0;
}
