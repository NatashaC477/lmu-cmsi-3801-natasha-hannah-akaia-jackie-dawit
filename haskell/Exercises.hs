module Exercises
  ( change,
    firstThenApply,
    powers,
    meaningfulLineCount,
    volume,
    surfaceArea,
    Shape(..),
    is_approx,
    BST(..),
    insert,
    contains,
    size,
    inorder
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
data Shape = Box Double Double Double
           | Sphere Double
           deriving (Show, Eq)

volume :: Shape -> Double
volume (Box w h d) = w * h * d
volume (Sphere r)  = (4 / 3) * pi * r^3

surfaceArea :: Shape -> Double
surfaceArea (Box w h d) = 2 * (w * h + h * d + d * w)
surfaceArea (Sphere r)  = 4 * pi * r^2

is_approx :: Double -> Double -> Bool
is_approx a b = abs (a - b) < 1e-6

-- Write your binary search tree algebraic type here
data BST a = Empty
           | Node a (BST a) (BST a)
           deriving (Eq)

instance (Show a, Eq a) => Show (BST a) where
    show Empty = "()"
    show (Node x left right) =
        let leftStr = if left == Empty then "" else show left
            rightStr = if right == Empty then "" else show right
        in "(" ++ leftStr ++ show x ++ rightStr ++ ")"

insert :: (Ord a) => a -> BST a -> BST a
insert x Empty = Node x Empty Empty
insert x (Node y left right)
    | x < y     = Node y (insert x left) right
    | x > y     = Node y left (insert x right)
    | otherwise = Node y left right  

contains :: (Ord a) => a -> BST a -> Bool
contains _ Empty = False
contains x (Node y left right)
    | x < y     = contains x left
    | x > y     = contains x right
    | otherwise = True

size :: BST a -> Int
size Empty = 0
size (Node _ left right) = 1 + size left + size right

inorder :: BST a -> [a]
inorder Empty = []
inorder (Node x left right) = inorder left ++ [x] ++ inorder right
