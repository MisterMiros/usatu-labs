#!/bin/bash

rm -f output.txt
for i in {0..5}
do
    S=$(echo 2^$i | bc)
    for j in {5..8}
    do
        N=$(echo 10^$j | bc)
        echo "Running with $S streams, $N size"
        ./main $S $N >> output.txt
        printf "\n" >> output.txt
    done
    echo "Running with $S streams, MAX size"
    ./main $S >> output.txt
done
