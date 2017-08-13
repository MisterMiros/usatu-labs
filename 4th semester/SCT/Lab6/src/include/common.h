#ifndef COMMON_FUNCS
#define COMMON_FUNCS

#define TRUE 1
#define FALSE 0

#define M 1024 // thread per block
const size_t MB = 1024*1024; // bytes in megabyte
const size_t MAX_N = (1024*MB)/sizeof(int);

size_t set_n(int,char**);
void check_cuda_errors(const char*, const int);
void random_ints(int*,size_t);
int check_results(int*,int*,int*,size_t);
__global__ void add(int*,int*,int*,size_t);

#endif
