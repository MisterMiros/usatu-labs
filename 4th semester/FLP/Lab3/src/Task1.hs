#!/usr/bin/ghci
module Task1 (
	checkLista,
	checkListb
) where

-- Задание 1 : Проверка списка
{-
Используя функции any и all
проверьте условия в интерпретаторе.
а) в списке есть числа, кратные 6,
б) все числа в списке меньше 100
-}

import Data.List

checkLista :: [Int] -> Bool
checkLista [] = True
checkLista xs = (all (<100) xs)
checkListb :: [Int] -> Bool
checkListb [] = True
checkListb xs = (any ((==0).(`mod`6)) xs)
