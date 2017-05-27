#!/usr/bin/ghci

module Task4 (
    fn,
    summa
) where

{-
Для положительного целого числа n,
пусть f(n) будет суммой квадратов его цифр (по основанию 10), т.е.
f(3) = 32 = 9,
f(25) = 22 + 52 = 4 + 25 = 29,
f(442) = 42 + 42 + 22 = 16 + 16 + 4 = 36
Найдите последние девять цифр суммы всех n,
0 < n < 1020, таких, что f(n) является квадратом целого числа.
-}

import Debug.Trace
import Data.Maybe
import Data.List (groupBy, sort)

type SumsTuple = ((Integer,Integer),(Integer,Integer))

lim :: Integer->Integer
lim n = (9^2)*n

fn :: Integer->Integer
fn 0 = 0
fn n = (n `mod` 10) ^ 2 + fn (n `div` 10)

squares :: [Integer]
squares = map (^2) [0..]

isps :: Integer->Bool
isps n = (sq n)^2 == n
sq :: Integer->Integer
sq n = floor $ sqrt $ (fromIntegral n::Double)

group :: [SumsTuple]->[SumsTuple]
group = map (foo . unzip)
        . groupBy (cmp)
        . sort
    where
        cmp :: SumsTuple->SumsTuple->Bool
        cmp x y = fst x == fst y
        foo (keys, vals) = (head keys, foldl (add) (0,0) vals)
        add (cs,ss) (c,s) = (cs+c,ss+s)

num' :: Integer->[SumsTuple]
num' 0 = [((0,0),(1,0))] -- first - n, second - sum
num' n
    | otherwise = cur ++ prev
    where
        prev = num' (n - 1)
        cur = group $ cur' 0 0
        cur' j k
            | j > 9 = []
            | i > (lim n) = cur' (j+1) 0
            | cs == (0,0) = cur' j (k+1)
            | otherwise = ((n,i),cs) : cur' j (k+1)
            where
                i = k + j^2
                zIfN :: (Maybe (Integer,Integer))->(Integer,Integer)
                zIfN m = if isNothing m then (0,0) else fromJust m
                cs = cs' $ zIfN $ lookup (n-1,k) prev
                cs' (a,b) = (a `mod` 10^9, (b + j*a*(10^(n-1))) `mod` 10^9)

summa n = (sum ([snd y| (x,y) <- num' n, fst x == n, isps (snd x)])) `mod` 10^9

{--numn :: Integer->Integer
numn n
    | otherwise = foldl (\su sq -> (su + snd (num' n sq) + (trace (show sq) 0)) `mod` 10^9) 0 sqrsl
    where sqrsl = takeWhile (<=((9^2)*n)) squares

num' :: Integer->Integer->(Integer,Integer)
num' 1 s
    | s `elem` (take 10 squares) = (1, sq s)
    | otherwise = (0,0)
num' n s
    | s < 0 = (0,0)
    | s > ((9^2)*n) = (0,0)
    | otherwise = foldl (\ss x -> l x (ss) (rr x)) (0,0) [0..9]
    where
        rr x = num' (n-1) (s-x^2)
        l k (cs,su) (c,x) = (c + cs `mod` 10^9, (su + k*c*(10^(n-1)) + x) `mod` 10^9)
--}
