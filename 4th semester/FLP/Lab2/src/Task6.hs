#!/usr/bin/ghci
module Task6 (
    romanToInt,
    isRoman,
    numericToDecimal,
    evalExpr
)
where
-- Задание 6: Отладка
{-
Подключите модуль Trace к модулю,
в котором определены функции из задания 3.
Запросите в интерпретаторе, объясните тип
и проверьте поведение на примерах
входных данных для функции trace.
-}
import Data.Char
import Data.Maybe (fromJust)
import Data.List
import Debug.Trace

-- Из римского числа в целое
romanToInt :: String -> Int
romanToInt xs
    | trace ("Calling romanToInt on \""
            ++ xs ++ "\"") False = undefined
romanToInt [] = error "Can't parse empty string"
romanToInt xs = romanToInt' (reverse xs) 0

-------------------------------------------------------

romanToInt' :: String -> Int -> Int
romanToInt' [] _ = 0
romanToInt' (x:xs) p
    | trace ("Calling romanToInt' on \""
                ++ x:xs ++ "\", prev = " ++ show p) False = undefined
    | not $ x `elem` literals = error "Can't parse string to Roman"
    | nx >= p = romanToInt' xs nx + nx
    | otherwise = romanToInt' xs p - nx
    where
        literals = "IVXLCDM"
        zips = zip literals [1,5,10,50,100,500,1000]
        nx = fromJust $ lookup x zips

-------------------------------------------------------

isRoman :: String -> Bool
isRoman [] = True
isRoman xs
    | trace ("Calling isRoman on \"" ++ xs ++ "\"") False = undefined
isRoman (x:xs) = x `elem` "IVXLCDM" && isRoman xs

-------------------------------------------------------

-- Из числа в системе счисления b в десятичный Int
numericToDecimal :: String -> Int
numericToDecimal xs
    | trace ("Calling numericToDecimal on \""
                ++ xs ++ "\"") False = undefined
numericToDecimal ('0':'b':xs) = numericToDecimal' 2 xs
numericToDecimal ('0':'o':xs) = numericToDecimal' 8 xs
numericToDecimal ('0':'x':xs) = numericToDecimal' 16 xs
numericToDecimal xs = numericToDecimal' 10 xs

-------------------------------------------------------

numericToDecimal' :: Int -> String -> Int
numericToDecimal' b xs
    | trace ("Calling numericToDecimal' on \""
                ++ xs ++ "\", with base " ++ show b) False = undefined
numericToDecimal' b xs
    | b > 36 = error "Numeric system too big to represent"
    | otherwise = numericToDecimal'' b 0 xs

-------------------------------------------------------

numericToDecimal'' :: Int -> Int -> String -> Int
numericToDecimal'' _ s [] = s
numericToDecimal'' b s (x:xs)
    | trace ("Calling numericToDecimal'' on \""
                ++ x:xs ++ "\", with base " ++ show b) False = undefined
    | ux `elem` literals = numericToDecimal'' b (s * b + nx) xs
    | otherwise = error $ "Not a number of base " ++ show b
    where
        literals = take b $ ['0'..'9'] ++ ['A'..'Z']
        zips = zip literals $ [0..35]
        ux = toUpper x
        nx = fromJust $ lookup ux zips

-------------------------------------------------------

-- Вычисление выражения
evalExpr :: String -> Int
evalExpr [] = 0
evalExpr xs
    | trace ("Calling evalExpr on \""
                ++ xs ++ "\"") False = undefined
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
