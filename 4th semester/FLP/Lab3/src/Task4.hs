#!/usr/bin/ghci
module Task4 (
    predicates,
    calculatePredicates
) where

-- Задание 4 : Вычисление логического выражения
{-
Дан список предикатов двух переменных:
    Р1(х,у)=”x+y – четное число”,
    P2 (х,у)=”x>y”,
    P3 (х,у)=”x и y имеют одинаковые остатки от деления на 4”,
    P4 (х,у)=”x+2y<8”,
    P5 (х,у)=”max{x,y} – нечетное число”,
и список кортежей [(x,y)].
Написать функцию, имеющую аргументами
эти два списка и решающую задачу.
Рекомендуется использовать функции
map, foldl, foldr, and, or.
Возвращает список  логических значений
выражения all x all y P(x,y) для каждого из предикатов.
-}

import Data.List

type Predicate = Int -> Int -> Bool
predicates :: [Predicate]
predicates = [
    (\x y -> even (x + y)),
    (\x y -> x > y),
    (\x y -> x `mod` 4 == y `mod`4),
    (\x y -> (x + 2 * y) < 8),
    (\x y -> not . even $ max x y) ]

calculatePredicates :: [(Int,Int)] -> [Predicate] -> [Bool]
calculatePredicates [] _ = []
calculatePredicates _ [] = []
calculatePredicates ts ps = map (allx'ally ts) ps

allx'ally :: [(Int,Int)] -> Predicate -> Bool
allx'ally ts p = all (\(x,y) -> p x y) ts
