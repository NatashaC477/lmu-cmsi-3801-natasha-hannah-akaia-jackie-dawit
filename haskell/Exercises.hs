module Exercises
  ( change,
    firstThenApply,
    powers,
    meaningfulLineCount,
  )
where

import Data.Char (isSpace)
import Data.List (find, isPrefixOf)
import qualified Data.Map as Map
import Data.Text (pack, replace, unpack)

change :: Integer -> Either String (Map.Map Integer Integer)
change amount
  | amount < 0 = Left "amount cannot be negative"
  | otherwise = Right $ changeHelper [25, 10, 5, 1] amount Map.empty
  where
    changeHelper [] remaining counts = counts
    changeHelper (d : ds) remaining counts =
      changeHelper ds newRemaining newCounts
      where
        (count, newRemaining) = remaining `divMod` d
        newCounts = Map.insert d count counts

firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply xs predicate f = f <$> find predicate xs

powers :: (Integral a) => a -> [a]
powers base = iterate (* base) 1

meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount filePath = do
  document <- readFile filePath
  let allWhiteSpace = all isSpace
      trimStart = dropWhile isSpace
      isMeaningfulLine line = 
        not (allWhiteSpace line) && 
        not ("#" `isPrefixOf` (trimStart line))
  return $ length $ filter isMeaningfulLine $ lines document

-- Write your shape data type here

-- Write your binary search tree algebraic type here
