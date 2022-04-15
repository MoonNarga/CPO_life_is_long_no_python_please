module BST
    ( BST
    , bstLeft
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
    ) where

data BST t = Empty  | Node t (BST t) (BST t) deriving (Show, Eq)

bstValue :: BST a -> Maybe a
bstValue Empty = Nothing
bstValue (Node n l r) = Just n

bstLeft :: BST a -> BST a
bstLeft Empty = Empty
bstLeft (Node n le ri) = le

bstRight :: BST a -> BST a
bstRight Empty = Empty
bstRight (Node n le ri) = ri

empty :: BST a
empty = Empty

isEmpty :: BST a -> Bool
isEmpty Empty = True
isEmpty n = False

size :: BST a -> Int
size Empty = 0
size (Node n le ri) = 1 + size le + size ri

member :: Ord a => a -> BST a -> Bool
member n Empty = False
member n (Node t le ri)
    | n == t = True
    | n < t = member n le
    | n > t = member n ri

insert :: Ord a => a -> BST a -> BST a
insert n Empty = Node n Empty Empty
insert n (Node t le ri)
    | n == t = Node t le ri
    | n < t = Node t (insert n le) ri
    | otherwise = Node t le (insert n ri)

fromList :: Ord a => [a] -> BST a
fromList [] = Empty
fromList (x:xs) = insert x (fromList xs)

toList :: BST a -> [a]
toList Empty = []
toList (Node n le ri) = toList le ++ [n] ++ toList ri

singleton :: a -> BST a
singleton n = Node n Empty Empty

evenFilter :: BST Int -> [Int]
evenFilter Empty = []
evenFilter (Node n le ri)
    | even n = evenFilter le ++ [n] ++ evenFilter ri
    | otherwise = evenFilter le ++ evenFilter ri

unionSubtrees :: BST t -> BST t -> BST t
unionSubtrees left (Node node Empty right) = Node node left right
unionSubtrees l (Node node left right) = Node node (unionSubtrees l left) right

remove :: Ord t => t -> BST t -> BST t
remove n Empty = Empty
remove n (Node node left Empty)
  | n == node = left
  | n < node = Node node (remove n left) Empty
  | n > node = Node node left Empty
remove n (Node node Empty right)
  | n == node = right
  | n < node = Node node Empty (remove n right)
  | n > node = Node node Empty right
remove n (Node node left right)
  | n == node = unionSubtrees left right
  | n < node = Node node (remove n left) right
  | n > node = Node node left (remove n right)
