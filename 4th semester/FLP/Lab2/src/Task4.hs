#!/usr/bin/ghci
module Task4 (
    calcSet
) where

-- Задание 4: Вычисление множества
{-
Дано универсальное множество U={1,2,…,10} 
и некоторые его подмножества A,B,C.
Найти множество D, заданное в варианте. 
(Реализовать множества списками).
D=-(A * B)-C
-}
import Data.List

calcSet :: [Int] -> [Int] -> [Int] -> [Int]
calcSet a b c = (u \\ (a `intersect` b)) \\ c 
    where u = [1..10]
