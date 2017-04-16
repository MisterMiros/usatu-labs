#!/usr/bin/ghci
module Task1 (
    passCheck
) where

--Задание 1 : Проверка пароля
{-
В задании описаны правила составления некоторого пароля.
Написать функцию, проверяющую 
удовлетворяет ли заданная строка данным правилам. 
а) не содержит символов строчных латинских букв, предшествующих ‘k’;  
б) сразу после символа точки должна следовать цифра.
-}

import Data.Char
import Data.List

passCheck :: [Char] -> Bool
passCheck [] = True
passCheck ['.'] = False
passCheck [x] = not . elem x $ ['a'..'j']
passCheck (x:y:xs)
    | x `elem` ['a'..'j'] = False
    | x == '.' && not (isDigit y) = False
    | otherwise = passCheck (y:xs)

{-
passCheck :: [Char] -> Bool
passCheck [] = False
passCheck xs = after'k xs && digitAfterDot xs

-- Проверяем, что строка не содержит 
-- символов строчных латинских букв, предшествующих ‘k’
after'k :: [Char] -> Bool
after'k = all (\x -> not . elem x $ ['a'..'j'])

-- Проверяем, что в строке сразу после 
-- символа точки должна следует цифра
digitAfterDot :: [Char] -> Bool
digitAfterDot [] = True
digitAfterDot ['.'] = False
digitAfterDot (x:y:xs) 
    | x == '.' && (not . isDigit) y = False
    | otherwise = digitAfterDot . dropWhile (/='.') $ y:xs
-}
