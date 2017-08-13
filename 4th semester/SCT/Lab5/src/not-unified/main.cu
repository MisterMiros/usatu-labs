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
    int *d_a, *d_b, *d_c; // device copies of a, b, c
    size_t size = N * sizeof(int);
    // Alloc space for device copies of a, b, c
    cudaMalloc((void **)&d_a, size);
    check_cuda_errors(__FILE__,__LINE__);
    cudaMalloc((void **)&d_b, size);
    check_cuda_errors(__FILE__,__LINE__);
    cudaMalloc((void **)&d_c, size);
    check_cuda_errors(__FILE__,__LINE__);
    //Alloc space for host copies of a, b, c
	//and setup input values
    a = (int *)malloc(size); random_ints(a, N);
    b = (int *)malloc(size); random_ints(b, N);
    c = (int *)calloc(N, sizeof(int));
    // Copy inputs to device
    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    check_cuda_errors(__FILE__,__LINE__);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);
    check_cuda_errors(__FILE__,__LINE__);

    float calc_time = add_calc_time(d_a,d_b,d_c,N);
    printf("GPU time: %.4f ms\n", calc_time);

	// Copy result back to host
    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);
    check_cuda_errors(__FILE__,__LINE__);

    printf(check_results(a, b, c, N) ?
		"Result is correct\n" : "Result is wrong\n");
    // Cleanup
    free(a); free(b); free(c);
    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
    clock_t end_c = clock();
    printf("Total time: %.4f ms \n",
		((double)(end_c-start_c)) * 1000 / CLOCKS_PER_SEC);
    return 0;
}
