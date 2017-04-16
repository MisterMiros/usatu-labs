#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <mpi.h>
#include <math.h>

//#define N 3 //800000000
//#define S 2

int N = 800000000;
int S = 2;

double series(int,int,int);
void main_process();
void sub_process();

int procs_num, rank;

int main(int argc, char** argv) {
    if (argc > 1) {  N = atoi(argv[1]); }
    if (argc > 2) {  S = atoi(argv[2]); }
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &procs_num);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if (rank == 0) {
		main_process();
    }
    else {
        sub_process();
    }
    MPI_Finalize();

}

void main_process() {
	MPI_Barrier(MPI_COMM_WORLD);
	double start_time = MPI_Wtime();
	printf("Calculating series...\n");
	printf("Calculating on process 0...\n");
	double sum = series(S, N, procs_num);
	printf("sum0 = %f\n", sum);
	int i;
	for (i = 1; i < procs_num; i++) {
	    double part;
	    printf("Receiving from proccess %d... ", i);
	    MPI_Recv(&part, 1, MPI_DOUBLE, i, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
	    printf("Done! part = %f\n", part);
	    sum += part;
	}
	MPI_Barrier(MPI_COMM_WORLD);
	double end_time = MPI_Wtime();
	printf("sum = %f\n", sum);
	printf("Time spent: %f\n", end_time - start_time);

}

void sub_process() {
	MPI_Barrier(MPI_COMM_WORLD);
    double sum = series(S + rank, N, procs_num);
    MPI_Send(&sum, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD);
    MPI_Barrier(MPI_COMM_WORLD);
}

double series(int start, int end, int step) {
    if (start < 2) {
        return 0;
    }
    double sum = 0;
    int i;
    for (i = start; i <= end; i+=step) {
        double ln = log(i);
        sum += 1 / (ln*ln*i);
    }
    return sum;
}
