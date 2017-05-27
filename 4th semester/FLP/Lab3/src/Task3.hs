#!/usr/bin/ghci

module Task3 (
    p,
    rev,
    comp,
    mult
) where

-- Задание 3 : Вычисление отображений
{-
Для заданного отображения Р найти
(можно использовать функции
zip, unzip, zipWith в дополнение
к предыдущим, также допускается
использование генератора списков).
(e,b), (b,c), (c,c), (c,e), (e,e)
-}
import Data.List

p :: [(Char,Char)]
p = [('e','b'),('b','c'),('c','c'),('c','e'),('e','e')]

rev :: [(Char,Char)]->[(Char,Char)]
rev ts = [(b,a) | (a,b) <- ts]
-- rev ts = (\(xs,ys) -> zip ys xs) $ unzip ts

comp :: [(Char,Char)]->[(Char,Char)]->[(Char,Char)]
comp xs ys = nub [(a,y) | (a,b) <- xs, (x,y) <- ys, b == x]

mult :: [(Char,Char)]->[(Char,Char)]->[(Char,Char)]
mult xs ys = nub [(a,b) | a <- snd $ unzip xs, b <- fst $ unzip ys]

{-comp xs ys = nub $ foldr (\x s -> s ++ compt ys x) [] xs
    where
        compt ts xt = foldr (cht xt) [] ts
        cht (x,y) (a,b) s = if y == a then (x,b) : s else s-}
