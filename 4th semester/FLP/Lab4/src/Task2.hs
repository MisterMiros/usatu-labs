#!/usr/bin/ghci

module Task2 (
    rwf
) where

{-
Написать функцию, которая читает входной текстовой файл
и выводит в выходной файл указанную информацию.
Строки исходного файла, содержащие заданное слово.
-}

import Data.List

rwf :: FilePath -> FilePath -> [Char] -> IO ()
rwf i o word = do
    contents <- readFile i
    let result = (unlines $ filter (isInfixOf word) $ lines contents)
            in writeFile o result
