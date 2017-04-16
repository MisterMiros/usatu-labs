#!/usr/bin/ghci
module Task5 (
    commentTemperature
) where

-- Задание 5: Функция с show, read, error, undefined
{-
Используя функции show, read, error, undefined
напишите функцию, выполняющую указанные действия.
По вводимой температуре наружного воздуха
в градусах выводит сообщения о реакции человека
(реакции написать самостоятельно – например, «Лютый мороз»,
«Немного жарко» и т.п.). Выводит соответствующие сообщения об
ошибках в данных. 
-}

import Data.Char
import Data.List

type Temperature = (Double, String)

wrongInput = error "Input is not temperature"

-- Читаем температуру в tuple
getTemperature :: String -> Temperature
getTemperature [] = error "Can't parse empty string"
getTemperature xs
    | length xs < 3 = wrongInput
    | length parts == 2 = (read $ head parts, last parts)
    | otherwise = wrongInput
    where 
        parts = words xs

-- Конвертируем температуру в Кельвины
convertToKelvin :: Temperature -> Double
convertToKelvin (v, t)
    | t == "K" = v
    | t == "C" = fromCelcius v
    | t == "F" = fromFahrenheit v
    | otherwise = wrongInput
    where 
        fromCelcius v = v + 273
        fromFahrenheit v = (v + 459.67) * 5 / 9

commentTemperature' :: Double -> String
commentTemperature' tempKelvin
    | tempKelvin == 0 = "Absolute zero!"
    | tempKelvin >= 33 && tempKelvin <= 55 = "Living on Pluto."
    | tempKelvin >= 82 && tempKelvin <= 123 = "Living on Saturn."
    | tempKelvin >= 213 && tempKelvin <= 223 = "Arctic or Antarctic?"
    | tempKelvin >= 238 && tempKelvin <= 242 = "Don't let your kids go to school."
    | tempKelvin >= 258 && tempKelvin <= 268 = "Sweet winter."
    | tempKelvin == 273 = "Ice time!"
    | tempKelvin > 288 && tempKelvin <= 298 = "Sweet summer."
    | tempKelvin >= 308 && tempKelvin <= 323 = "Meanwhile in Africa."
    | tempKelvin == 373 = "Boiling point!"
    | tempKelvin >= 4100 && tempKelvin <= 15600000 = "You're on Sun!"
    | otherwise = undefined

commentTemperature xs = prefix ++ commentTemperature' tempKelvin
    where 
         prefix = "The temperature is " ++ show tempKelvin ++ " degrees of Kelvin (" ++ xs ++ ")."
         tempKelvin = convertToKelvin $ getTemperature xs