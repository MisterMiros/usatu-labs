#!/usr/bin/ghci

import Task1
import Task2
import Task3
import Task4

main = do
    task1
    putStrLn "----------------------------------------"
    task2
    putStrLn "----------------------------------------"
    task3
    putStrLn "----------------------------------------"
    task4

task1 = do
    putStrLn "Task 1"
    putStrLn $ showSabit 8

task2 = do
    putStrLn "Task 2"
    putStrLn "Reading from input.txt, writing to output.txt"
    putStrLn "Filtering lines with word \"Haskell\""
    rwf "input.txt" "output.txt" "Haskell"

task3 = do
    putStrLn $ showPrimes 100
    putStrLn $ showPrimes 1000
    putStrLn $ showPrimes 1000000

task4 = do
    putStrLn $ showSumPS 20

showSabit n = "First " ++ show n ++ " of Sabit numbers: "
                ++ show (take n sabit) ++ ", sum equals "
                ++ show (sum $ take n sabit)

showPrimes n = "Longest sum of consecutive primes, below " ++ show n
                ++ " contains " ++ show c ++ " elements and equals to "
                ++ show s
                where (c,s) = sumBelow n

showSumPS n = "Last 9 digits of sum of all n below " ++ show (10^n)
                ++ ", where f(n) is perfect square is "
                ++ show (summa n)
