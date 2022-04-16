import Test.Hspec        (Spec, it, shouldBe)
import Test.Hspec.Runner (defaultConfig, hspecWith)

import BST
  ( bstLeft
  , bstRight
  , bstValue
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
      bstValue (singleton int4) `shouldBe` Just 4

    it "inserting less" $ do
      let t = insert 2 (singleton int4)
      bstValue t `shouldBe` Just 4
      bstValue (bstLeft t) `shouldBe` Just 2

    it "inserting same" $ do
      let t = insert 4 (singleton int4)
      bstValue t `shouldBe` Just 4
      bstValue (bstLeft t) `shouldBe` Nothing

    it "inserting right" $ do
      let t = insert 5 (singleton int4)
      bstValue t `shouldBe` Just 4
      bstValue(bstRight t) `shouldBe` Just 5

    it "empty list to tree" $
      fromList noInts `shouldBe` empty

    it "empty list has no value" $
      bstValue (fromList noInts) `shouldBe` Nothing

    it "inserting into empty" $ do
      let t = insert int4 empty
      bstValue t `shouldBe` Just 4

    it "complex tree" $ do
      let t = fromList [int4, 2, 6, 1, 3, 7, 5]
      member   3 t                       `shouldBe` True 
      member   9 t                       `shouldBe` False  
      bstValue  t                        `shouldBe` Just 5
      bstValue (bstLeft  t             ) `shouldBe` Just 3
      bstValue (bstLeft (bstLeft  t)   ) `shouldBe` Just 1
      bstValue (bstRight (bstLeft  t)  ) `shouldBe` Just 4
      bstValue (bstRight t             ) `shouldBe` Just 7
      bstValue (bstLeft (bstRight t)   ) `shouldBe` Just 6
      bstValue (bstRight (bstRight t)  ) `shouldBe` Nothing
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