module Main where

import BST
  ( BST,
    bstFilter,
    concatBst,
    empty,
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
import Data.List
import qualified Data.Set as Set
import Test.QuickCheck
import Test.QuickCheck.Arbitrary
import Test.QuickCheck.Gen

-- instance Arbitrary BST where
--   arbitrary =
--     oneof
--       [ return Empty,
--         liftM Node {value = Int, lchild = arbitrary, rchild = arbitrary}
--       ]

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
prop_everyElement xs = sort xs == toList (fromList xs)

prop_concatBst :: [Integer] -> [Integer] -> Bool
prop_concatBst xs1 xs2 = sort (xs1 ++ xs2) == toList (concatBst (fromList xs1) (fromList xs2))

prop_monoid :: [Integer] -> [Integer] -> [Integer] -> Bool
prop_monoid xs1 xs2 xs3 = toList (fromList xs1 <> (fromList xs2 <> fromList xs3)) == toList ((fromList xs1 <> fromList xs2) <> fromList xs3)

runTests :: Args -> IO ()
runTests args = do
  f prop_everyElement "every element ok?"
  f prop_concatBst "concat ok?"
  f prop_monoid "monoid ok?"
  where
    f prop str = do
      putStrLn str
      quickCheckWithResult args prop
      return ()

main :: IO ()
main = do
  runTests arg
