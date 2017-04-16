#!/usr/bin/ghci
module Task2 (
    caesarEncode,
    caesarDecode,
    caesarCEncode,
    caesarCDecode
) where

-- Задание 2 : Шифр Цезаря
{- 
Зашифруйте текст данного задания 
с помощью шифра Цезаря с ключом, 
соответствующим номеру варианта.
Напишите функцию для расшифровки
(можно одну функцию с дополнительным аргументом, 
задающим режим шифровки или расшифровки).
-}

import Data.Char
import Data.List
import Data.Maybe

caesarEncode :: Int -> [Char] -> [Char]
caesarEncode n xs = caesarCipher n xs

caesarDecode :: Int -> [Char] -> [Char]
caesarDecode n xs = caesarCipher (-n) xs

caesarCipher :: Int -> [Char] -> [Char]
caesarCipher _ [] = []
caesarCipher 0 xs =  xs
caesarCipher n xs = map (chr . (+n) . ord) xs

caesarCEncode :: Int -> [Char] -> [Char]
caesarCEncode n xs = caesarCipherCycle n xs

caesarCDecode :: Int -> [Char] -> [Char]
caesarCDecode n xs = caesarCipherCycle (-n) xs

caesarCipherCycle :: Int -> [Char] -> [Char]
caesarCipherCycle _ [] = []
caesarCipherCycle 0 xs = xs
caesarCipherCycle n (x:xs)
	-- | isDigit x = move x n '0' 10 : caesarCipherCycle n xs
	| x `elem` ['A'..'Z'] = move x n 'A' 26 : caesarCipherCycle n xs
	| x `elem` ['a'..'z'] = move x n 'a' 26 : caesarCipherCycle n xs
	| x `elem` ['А'..'Я'] = move x n 'А' 32 : caesarCipherCycle n xs
	| x `elem` ['а'..'я'] = move x n 'а' 32 : caesarCipherCycle n xs
	-- | isJust (pos x) = (move x n) : caesarCipherCycle n xs
	| otherwise = x : caesarCipherCycle n xs
	where
		alphabet = ['A'..'Z'] ++ ['a'..'z'] ++ ['А'..'Я'] ++ ['а'..'я']
		pos y = elemIndex y alphabet
		-- move x n = alphabet !! (((fromJust (pos x)) + n) `mod` length alphabet) 
		move x n b l = chr $ (ord x - ord b + n) `mod` l + ord b

