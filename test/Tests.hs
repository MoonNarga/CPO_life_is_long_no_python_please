import Test.Hspec        (Spec, it, shouldBe)
import Test.Hspec.Runner (defaultConfig, hspecWith)

import BST
  ( BST
  , value
  , lchild
  , rchild
  , empty
  , isEmpty
  , fromList
  , insert
  , toList
  , size
  , member
  , singleton
  , remove
  , evenFilter
  )

main :: IO ()
main = hspecWith defaultConfig specs

specs :: Spec
specs = do

    let int4   = 4  ::  Int
    let noInts = [] :: [Int]

    it "data is retained" $
      value (singleton int4) `shouldBe` 4

    it "inserting less" $ do
      let t = insert 2 (singleton int4)
      value t `shouldBe` 4
      value (lchild t) `shouldBe` 2

    it "inserting same" $ do
      let t = insert 4 (singleton int4)
      value t `shouldBe` 4
      lchild t `shouldBe` empty 

    it "inserting right" $ do
      let t = insert 5 (singleton int4)
      value t `shouldBe` 4
      value(rchild t) `shouldBe` 5

    it "empty list to tree" $
      fromList noInts `shouldBe` empty

    it "inserting into empty" $ do
      let t = insert int4 empty
      value t `shouldBe` 4

    it "complex tree" $ do
      let t = fromList [int4, 2, 6, 1, 3, 7, 5]
      member   3 t                       `shouldBe` True 
      member   9 t                       `shouldBe` False  
      value  t                        `shouldBe` 5
      value (lchild  t             ) `shouldBe` 3
      value (lchild (lchild  t)   ) `shouldBe` 1
      value (rchild (lchild  t)  ) `shouldBe` 4
      value (rchild t             ) `shouldBe` 7
      value (lchild (rchild t)   ) `shouldBe` 6
      evenFilter t                       `shouldBe` [2, 4, 6]
      toList   (remove 3 t)              `shouldBe` [1, 2, 4, 5, 6, 7]

    it "empty tree to list" $
      length (toList empty) `shouldBe` 0

    it "iterating one element" $
      toList (singleton int4) `shouldBe` [4]

    it "iterating over smaller element" $
      toList (fromList [int4, 2]) `shouldBe` [2, 4]

    it "iterating over larger element" $
      toList (fromList [int4, 5]) `shouldBe` [4, 5]

    it "iterating over complex tree" $
      toList (fromList [int4, 2, 1, 3, 6, 7, 5]) `shouldBe` [1..7]