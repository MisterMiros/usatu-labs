#!/usr/bin/ghci
module Task5 (
    customWords
) where

-- Задание 5 : Реализация words
{-
Используя ранее изученные функции,
написать функцию(-ии), решающую задачу.
Заданную строку разделить на список слов,
считая разделителями пробелы или знаки пунктуации,
их в список не включать.
-}

import Data.Char

customWords :: String -> [String]
customWords [] = []
customWords cs = foldr prepend [] cs
    where
        prepend c [] = if isPorS c then [] else [[c]]
        prepend c (a:as)
            | isPorS c = if a == [] then (a:as) else ([]:a:as)
            | otherwise = (c:a):as
        isPorS c = isPunctuation c || isSpace c
