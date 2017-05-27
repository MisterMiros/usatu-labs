#!/usr/bin/ghci

import Task1
import Task2
import Task3
import Task4
import Task5
import Task6

main = do
    task1
    putStrLn "--------------------------------"
    task2
    putStrLn "--------------------------------"
    task3
    putStrLn "--------------------------------"
    task4
    putStrLn "--------------------------------"
    task5
    putStrLn "--------------------------------"
    task6

task1 = do
    putStrLn "Task 1"
    putStrLn $ showCheckList [1,2,3]
    putStrLn $ showCheckList [4,5,6]
    putStrLn $ showCheckList [12,16,23]
    putStrLn $ showCheckList [666,10,20]

task2 = do
    putStrLn "Task 2"
    putStrLn $ showTransformList ["hello", ",", "world", "1234"]
    putStrLn $ showTransformList ["abc", "defg ka", "hi wi"]
    putStrLn $ showTransformList ["a", "defs", "ka", "qds"]
task3 = do
    putStrLn "Task 3"
    putStrLn $ "P = " ++ show p
    putStrLn $ "///////////////////////////"
    putStrLn $ "P^-1 = " ++ show (rev p)
    putStrLn $ "///////////////////////////"
    putStrLn $ "P . P = " ++ show (comp p p)
    putStrLn $ "///////////////////////////"
    putStrLn $ "P^-1 . P = " ++ show (comp (rev p) p)
    putStrLn $ "///////////////////////////"
    putStrLn $ "(P^-1 . P) x (P . P) = "
        ++ show (mult (comp (rev p) p) (comp p p))

task4 = do
    putStrLn "Task 4"
    putStrLn $ showCalculatePredicates [(1,2),(3,4),(5,6)]
    putStrLn $ showCalculatePredicates [(3,7),(7,15),(35,23)]
    putStrLn $ showCalculatePredicates [(3,-2),(4,1),(3,-4)]

task5 = do
    putStrLn "Task 5"
    putStrLn $ showCustomWords "Hello, World!"
    putStrLn $ showCustomWords "Valar Morgulis"
    putStrLn $ showCustomWords "Too, ,Many, ,Colons,,"

task6 = do
    putStrLn "Task 6"
    putStrLn $ showCombinate coins

showCheckList xs = "List: " ++ show xs
                    ++ ", checkLista = " ++ show (checkLista xs)
                    ++ ", checkListb = " ++ show (checkListb xs)

showTransformList xs = "transfromList " ++ show xs
    ++ " = " ++ show (transformList xs)
showCalculatePredicates ts = "calculatePredicates " ++ show ts
    ++ " = " ++ show (calculatePredicates ts predicates)
showCustomWords xs = "customWords " ++ show xs ++ show (customWords xs)
showCombinate xs = "combinate " ++ show xs ++ " = " ++ (show combo)
                        ++ "\nlength = " ++ show (length combo)
    where combo = combinate xs
