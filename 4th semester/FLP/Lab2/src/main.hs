#!/usr/bin/hugs
import Task1
import Task2
import Task3
import Task4
import Task5
import qualified Task6
import Control.Exception as CE

main = do
    putStrLn "----------------------------------------"
    task1
    putStrLn "----------------------------------------"
    task2
    putStrLn "----------------------------------------"
    task3
    putStrLn "----------------------------------------"
    task4
    putStrLn "----------------------------------------"
    task5
    putStrLn "----------------------------------------"
    task6

task1 = do
    putStrLn "Task 1"
    putStrLn $ showPassCheck "qwerty"
    putStrLn $ showPassCheck "klmnop"
    putStrLn $ showPassCheck "kl."
    putStrLn $ showPassCheck "kl.1"
    putStrLn $ showPassCheck "kl.1a"
    putStrLn $ showPassCheck "kl.1A"
    putStrLn $ showPassCheck ".2kl."
    putStrLn $ showPassCheck ".2kl.12x"

task2 = do
    putStrLn "Task 2"
    putStrLn "Encoded string: "
    putStrLn . caesarCEncode 7 $ "В задании описаны правила составления \
    \некоторого пароля. Написать функцию, проверяющую \
    \удовлетворяет ли заданная строка данным правилам."
    putStrLn "Decoded string: "
    putStrLn . caesarCDecode 7 $ "Й озлзфпп хцпшзфв цчзйптз шхшщзйтмфпж \
    \фмсхщхчхкх цзчхтж. Фзцпшзщг ыъфсэпе, цчхймчжеаъе \
    \ълхйтмщйхчжмщ тп озлзффзж шщчхсз лзффву цчзйптзу."

task3 = do
    putStrLn "Task 3"
    putStrLn $ showEvalExpr "0xC5F-CCXCVIII"
    putStrLn $ showEvalExpr "MMXV+0b100001"
    putStrLn $ showEvalExpr "0o2403-MXLII"
    putStrLn $ showEvalExpr "0o524+CCXCI"
    putStrLn $ showEvalExpr "CLIII-0b111010"

task4 = do
    putStrLn "Task 4"
    putStrLn $ showCalcSet [1,2,3] [2,3,4] [4,5,6]
    putStrLn ""
    putStrLn $ showCalcSet [1,2,3] [2,3,4] [4,5,6]
    putStrLn ""
    putStrLn $ showCalcSet [1,2,3,4] [2,3,4] [7,4,5,6]
    putStrLn ""
    putStrLn $ showCalcSet [1,2,3] [3,4] [4,6]

task5 = do
    putStrLn "Task 5"
    putStrLn (commentTemperature "0 K")         `CE.catch` handler
    putStrLn (commentTemperature "-273 C")      `CE.catch` handler
    putStrLn (commentTemperature "14 F")        `CE.catch` handler
    putStrLn (commentTemperature "-47 F")       `CE.catch` handler
    putStrLn (commentTemperature "not valid")   `CE.catch` handler
    putStrLn (commentTemperature "4F")          `CE.catch` handler
    putStrLn (commentTemperature "")            `CE.catch` handler
    putStrLn (commentTemperature "321 S")       `CE.catch` handler

task6 = do
    putStrLn "Task 6"
    putStrLn (showEvalExprTrace "0xC5F-CCXCVIII") `CE.catch` handler

handler :: Exception -> IO ()
handler ex = putStrLn $ "Exception: " ++ show ex

showPassCheck xs =
    "Password \"" ++ xs ++ "\" check result: " ++ (show . passCheck) xs

showCalcSet a b c =
    " A=" ++ show a
    ++ ", B=" ++ show b
    ++ ", C=" ++ show c
    ++ "\n(not (A intersec B)) diff C = " ++ (show (calcSet a b c))

showEvalExpr xs =
    xs ++ " = " ++ show (evalExpr xs)

showEvalExprTrace xs =
    xs ++ " = " ++ show (Task6.evalExpr xs)
