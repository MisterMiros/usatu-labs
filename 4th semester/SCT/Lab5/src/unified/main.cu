#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <stdint.h>
#include "../include/common.h"

int main(int argc, char** argv) {
    size_t N = set_n(argc,argv);
    printf("N = %lu\n",N);
    srand(time(NULL));
    clock_t start_c = clock();
    int *a, *b, *c; // host copies of a, b, c
    size_t size = N * sizeof(int);
    // Alloc space for a, b, c
    cudaMallocManaged((void **)&a, size);
    check_cuda_errors(__FILE__,__LINE__);
    random_ints(a, N);
    cudaMallocManaged((void **)&b, size);
    check_cuda_errors(__FILE__,__LINE__);
    random_ints(b, N);
    cudaMallocManaged((void **)&c, size);
    check_cuda_errors(__FILE__,__LINE__);

    float calc_time = add_calc_time(a,b,c,N);
    printf("GPU time: %.4f ms\n", calc_time);

    printf(check_results(a, b, c, N) ? "Result is correct\n" : "Result is wrong\n");
    // Cleanup
    cudaFree(a); cudaFree(b); cudaFree(c);
    clock_t end_c = clock();
    printf("Total time: %.4f ms \n", ((double)(end_c-start_c)) * 1000 / CLOCKS_PER_SEC);
    return 0;
}
