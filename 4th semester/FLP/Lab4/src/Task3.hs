#!/usr/bin/ghci

module Task3 (
    sumBelow,
    primes,
    primesSum
) where

{-
Простое число 41 можно записать в виде
суммы шести последовательных простых чисел:
41 = 2 + 3 + 5 + 7 + 11 + 13
Это - самая длинная сумма последовательных простых чисел,
в результате которой получается простое число меньше одной сотни.
Самая длинная сумма последовательных простых чисел,
в результате которой получается простое число меньше одной тысячи,
содержит 21 слагаемое и равна 953.
Какое из простых чисел меньше одного миллиона
 можно записать в виде суммы
 наибольшего количества последовательных простых чисел?
-}
import Data.List
import Debug.Trace
import Data.Function (on)

primes = 2 : 3 : 5 : primes'
  where
    primes' = 7 : filter (isPrime' primes')
                (scanl (+) 11 $ cycle [2,4,2,4,6,2,6,4])

isPrime :: Int->Bool
isPrime n = isPrime' primes n
isPrime' (p:ps) n = p*p > n || n `rem` p /= 0 && isPrime' ps n

primesSum :: [(Int,Int)]
primesSum = scanl (\(xn,xs) p -> (xn+1,xs+p)) (0,0) primes

sumBelow l = sumBelow' l (0,0) primesSum
sumBelow' l (n,s) ((cn,cs):ps)
    | l < snd (head sums) = (n,s)
    | otherwise = sumBelow' l maxsums ps
    where
        sums = map (\(xn,xs) -> (xn-cn,xs-cs)) $
                dropWhile (\(xn,xs) -> (xn-cn) <= n) primesSum
        allsums = filter (isPrime.snd) $
                    takeWhile (\(xn,xs) -> xs < l) sums
        maxsums = if allsums == [] then (n,s) else last allsums
