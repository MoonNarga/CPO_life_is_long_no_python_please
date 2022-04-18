module BST
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
    ) where

data BST t = Empty
  | Node
  { value :: t
  , lchild :: BST t
  , rchild :: BST t
  }
  deriving (Show, Eq)

empty :: BST a
empty = Empty

isEmpty :: BST a -> Bool
isEmpty Empty = True
isEmpty n = False

size :: BST a -> Int
size Empty = 0
size (Node n le ri) = 1 + size le + size ri

member :: Ord a => a -> BST a -> Bool
member v Empty = False
member v (Node t le ri)
    | v == t = True
    | v < t = member v le
    | v > t = member v ri

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

evenFilter :: Integral a => BST a -> [a]
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

toBstList :: BST a -> [BST a]
toBstList Empty = []
toBstList (Node n le ri) = [Node n le ri] ++ toBstList le ++ toBstList ri

-- iterator :: BST a -> [BST a]
-- iterator Empty = []
-- iterator (Node n le ri) = [Node n le ri] ++ iterator le ++ iterator ri

-- map ::  