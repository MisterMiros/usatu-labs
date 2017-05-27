#!/usr/bin/ghci
module Task2 (
	transformList
) where

-- Задание 2 : Преобразование списка
{-
Используя функци
map, filter, foldl, foldr, takeWhile,
dropWhile, break, span, splitAt
напишите функцию, решающую задачу.
а) по заданному списку строк
все начальные прописные символы преобразовать в строчные
б) полученный список отсортировать по длине слов
-}

import Data.List
import Data.Char

transformList :: [String] ->[String]
transformList [] = []
transformList xs = sortBy compLength $ map capitalize xs
    where
        compLength x y = compare (length x) (length y)
        up x [] = [x]
        up x (y:ys)
            | isSpace x || isPunctuation x = x:(toUpper y):ys
            | otherwise = x:y:ys
        capitalize [] = []
    	capitalize xs = (\(y:ys) -> toUpper y : ys) $ foldr up [] xs
