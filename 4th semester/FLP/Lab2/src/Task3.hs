#!/usr/bin/ghci
module Task3 (
    romanToInt,
    isRoman,
    numericToDecimal,
    evalExpr
)
where
-- Задание 3: Вычисление выражения
{-
Записать функцию, вычисляющую значение выражения 
и выводящую ответ в десятичном представлении,
функция должна иметь не более двух аргументов 
строкового (и только строкового!) типа.
*Усложненный вариант – единственный аргумент – строка,
непосредственно записанная в задании варианта.
C5F_16 - CCXCVIII
-}
import Data.Char
import Data.Maybe (fromJust)
import Data.List 
import Debug.Trace

-- Из римского числа в целое
romanToInt :: String -> Int
romanToInt [] = error "Can't parse empty string"
romanToInt xs = romanToInt' (reverse xs) 0

romanToInt' :: String -> Int -> Int
romanToInt' [] _ = 0
romanToInt' (x:xs) p 
    | not $ x `elem` literals = error "Can't parse string to Roman"
    | nx >= p = romanToInt' xs nx + nx
    | otherwise = romanToInt' xs p - nx
    where
        literals = "IVXLCDM"
        zips = zip literals [1,5,10,50,100,500,1000]
        nx = fromJust $ lookup x zips

isRoman :: String -> Bool
isRoman = all (`elem` "IVXLCDM")

-- Из числа в системе счисления b в десятичный Int
numericToDecimal :: String -> Int
numericToDecimal ('0':'b':xs) = numericToDecimal' 2 xs
numericToDecimal ('0':'o':xs) = numericToDecimal' 8 xs
numericToDecimal ('0':'x':xs) = numericToDecimal' 16 xs
numericToDecimal xs = numericToDecimal' 10 xs

numericToDecimal' :: Int -> String -> Int
numericToDecimal' b xs
    | b > 36 = error "Numeric system too big to represent"
    | otherwise = numericToDecimal'' b 0 xs

numericToDecimal'' :: Int -> Int -> String -> Int
numericToDecimal'' _ s [] = s
numericToDecimal'' b s (x:xs) 
    | ux `elem` literals = numericToDecimal'' b (s * b + nx) xs
    where
        literals = take b $ ['0'..'9'] ++ ['A'..'Z']
        zips = zip literals $ [0..35]
        ux = toUpper x
        nx = fromJust $ lookup ux zips

-- Вычисление выражения
evalExpr :: String -> Int
evalExpr [] = 0
evalExpr xs = eval $ breakExpr xs
    where
        eval (a1, op:a2) = case op of
            '+' -> readNum a1 + readNum a2
            '-' -> readNum a1 - readNum a2
            '*' -> readNum a1 * readNum a2
            '/' -> readNum a1 `div` readNum a2
        breakExpr = break (`elem` ['-','+','/','*'])
        readNum xs = if isRoman xs 
                     then romanToInt xs 
                     else numericToDecimal xs
