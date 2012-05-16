{-# LANGUAGE NoImplicitPrelude, ExtendedDefaultRules, TypeSynonymInstances, FlexibleInstances #-}
module Prelude.PHP where

import Data.List (group)
import Prelude hiding (foldr, foldl, subtract, elem, notElem)

instance Num String where
  fromInteger = show

  (+) x y = show (read x + read y)
  (-) x y = show (read x - read y)
  (*) x y = show (read x * read y)

  abs ('-':x) = x
  abs x = x

  signum x = if abs x == x then 1 else -1

instance Real String where
  toRational = toRational . read

instance Enum String where
  toEnum = show
  fromEnum = read

instance Integral String where
  quot x y = show (read x `quot` read y)
  rem x y = show (read x `rem` read y)
  div x y = show (read x `div` read y)
  mod x y = show (read x `mod` read y)

  quotRem x y = (quot x y, rem x y)

  toInteger = read

instance Fractional String where
  (/) x y = show (read x / read y)
  recip x = show (recip (read x))
  fromRational = show

instance Floating String where
  pi = "3.14"
  exp x = show (exp (read x))
  sqrt x = show (sqrt (read x))
  log x = show (log (read x))

  sin x = show (sin (read x))
  cos x = sin (x + 90)
  sinh x = show (sinh (read x))
  cosh x = sinh (x + 90)
  asin x = show (asin (read x))
  acos x = asin (x + 90)
  atan x = asin x / acos x
  asinh x = show (asinh (read x))
  acosh x = asinh (x + 90)
  atanh x = asinh x / acosh x

instance RealFrac String where
  properFraction x = (proper, frac) where proper = fromInteger (read (takeWhile (/= '.') x)); frac = tail (dropWhile (/= '.') x)

-- TODO - RealFloat

sort = sortBy compare

-- sort function, optimized for lists
-- TODO - profiling
sortBy compare = head . head . dropWhile (not . null . drop 1) . group . iterate bubble
  where
    bubble [] = []
    bubble [x] = [x]
    bubble (x:y:ys) = if compare x y == GT then y:x:(bubble ys) else if compare x y == EQ then x:(bubble (y:ys)) else if compare x y == LT then x:(bubble (y:ys)) else x:y:(bubble ys)

foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f z [] = z
foldr f z (x:xs) = f x (foldr f z xs)

foldl :: (a -> b -> a) -> a -> [b] -> a
foldl f z xs = foldr (flip f) z (reverse xs)

foldl' f z xs = xs `seq` foldl f z xs

subtract :: Num a => a -> a -> a
subtract = (-)

elem x [] = False
elem x (y:ys) = if x == y then True else elem x ys

notElem x ys = elem (not x) ys
