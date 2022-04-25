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
import Test.Hspec (Spec, it, shouldBe)
import Test.Hspec.Runner (defaultConfig, hspecWith)

main :: IO ()
main = hspecWith defaultConfig specs

specs :: Spec
specs = do
  let int4 = 4 :: Int
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
    lchild t `shouldBe` Empty

  it "inserting right" $ do
    let t = insert 5 (singleton int4)
    value t `shouldBe` 4
    value (rchild t) `shouldBe` 5

  it "Empty list to tree" $
    fromList noInts `shouldBe` Empty

  it "inserting into Empty" $ do
    let t = insert int4 Empty
    value t `shouldBe` 4

  it "complex tree" $ do
    let t = fromList [int4, 2, 6, 1, 3, 7, 5]
    member 3 t `shouldBe` True
    member 9 t `shouldBe` False
    value t `shouldBe` 4
    value (lchild t) `shouldBe` 2
    value (lchild (lchild t)) `shouldBe` 1
    value (rchild (lchild t)) `shouldBe` 3
    value (rchild t) `shouldBe` 6
    value (lchild (rchild t)) `shouldBe` 5
    bstFilter even (getIterator t) `shouldBe` [2, 4, 6]
    mapBst (* 2) (getIterator t) `shouldBe` [2, 4, 6, 8, 10, 12, 14]
    reduceBst (+) (getIterator t) 0 `shouldBe` 28
    reduceBst (*) (getIterator t) 1 `shouldBe` 5040
    toList (remove 3 t) `shouldBe` [1, 2, 4, 5, 6, 7]

  it "Empty tree to list" $
    length (toList Empty) `shouldBe` 0

  it "iterating one element" $
    toList (singleton int4) `shouldBe` [4]

  it "iterating over smaller element" $
    toList (fromList [int4, 2]) `shouldBe` [2, 4]

  it "iterating over larger element" $
    toList (fromList [int4, 5]) `shouldBe` [4, 5]

  it "iterating over complex tree" $
    toList (fromList [int4, 2, 1, 3, 6, 7, 5]) `shouldBe` [1 .. 7]

  it "concat" $ do
    let t1 = fromList [2, 4, 3]
    let t2 = fromList [5, 1, 7]
    let t3 = fromList [9, 8]
    toList (concatBst t1 Empty) `shouldBe` [2, 3, 4]
    toList (concatBst t1 t2) `shouldBe` [1, 2, 3, 4, 5, 7]
    toList (concatBst (concatBst t1 t2) t3) == toList (concatBst t1 (concatBst t2 t3)) `shouldBe` True
