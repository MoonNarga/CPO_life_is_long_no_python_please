module Main where

import BST
  ( BST (Empty, Node),
    bstFilter,
    concatBst,
    fromList,
    getIterator,
    getNext,
    hasNext,
    insert,
    insertList,
    isEmpty,
    lchild,
    mapBst,
    member,
    rchild,
    reduceBst,
    remove,
    singleton,
    size,
    toBstList,
    toList,
    value,
  )
import Control.Monad (liftM3)
import Data.List
import qualified Data.Set as Set
import System.Random (Random)
import Test.QuickCheck
import Test.QuickCheck.Arbitrary
import Test.QuickCheck.Gen

instance (Ord a, Bounded a, Random a, Num a, Arbitrary a) => Arbitrary (BST a) where
  arbitrary = gen (-10000) 10000
    where
      gen :: (Ord a, Num a, Random a) => a -> a -> Gen (BST a)
      gen min max | (max - min) <= 3 = return Empty
      gen min max = do
        elt <- choose (min, max)
        frequency
          [ (1, return Empty),
            ( 6,
              liftM3
                Node
                (return elt)
                (gen min (elt - 1))
                (gen (elt + 1) max)
            )
          ]

arg :: Args
arg =
  Args
    { replay = Nothing,
      maxSuccess = 1000,
      maxDiscardRatio = 1,
      maxSize = 1000,
      chatty = True,
      maxShrinks = 0
    }

prop_everyElement :: [Integer] -> Bool
prop_everyElement xs = Set.toList (Set.fromList xs) == toList (fromList xs)

prop_concatBst :: [Integer] -> [Integer] -> Bool
prop_concatBst xs1 xs2 = Set.toList (Set.fromList (xs1 ++ xs2)) == toList (concatBst (fromList xs1) (fromList xs2))

prop_monoid_Int :: [Integer] -> [Integer] -> [Integer] -> Bool
prop_monoid_Int xs1 xs2 xs3 = toList (fromList xs1 <> (fromList xs2 <> fromList xs3)) == toList ((fromList xs1 <> fromList xs2) <> fromList xs3)

prop_monoid_Str :: [String] -> [String] -> [String] -> Bool
prop_monoid_Str xs1 xs2 xs3 = toList (fromList xs1 <> (fromList xs2 <> fromList xs3)) == toList ((fromList xs1 <> fromList xs2) <> fromList xs3)

prop_empty :: BST Int -> Bool
prop_empty a =
  Empty <> a == a
    && a <> Empty == a

runTests :: Args -> IO ()
runTests args = do
  f prop_everyElement "every element ok?"
  f prop_concatBst "concat ok?"
  f prop_empty "empty ok?"
  f prop_monoid_Int "monoid_Int ok?"
  f prop_monoid_Str "monoid_Str ok?"
  where
    f prop str = do
      putStrLn str
      quickCheckWithResult args prop
      return ()

main :: IO ()
main = do
  runTests arg
