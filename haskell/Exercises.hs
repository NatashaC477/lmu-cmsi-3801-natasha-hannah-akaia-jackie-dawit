module Exercises
  ( change,
    firstThenApply,
    powers,
    meaningfulLineCount,
  -- put the proper exports here
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

-- Write your first then apply function here
firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply xs predicate f = f <$> find predicate xs -- fmap implemented

-- Write your infinite powers generator here
powers :: (Integral a) => a -> [a] -- integral implemented to handle floats
powers base = iterate (* base) 1 -- section implemented
-- Write your line count function here
meaningfulLineCount :: FilePath -> IO Int 
meaningfulLineCount path = do
  contents <- readFile path
  return $ length $ filter meaningfulLine $ lines contents
  where 
    meaningfulLine line = not (all isSpace line) && not ("--" `isPrefixOf` line)

-- Write your shape data type here

-- Write your binary search tree algebraic type here
