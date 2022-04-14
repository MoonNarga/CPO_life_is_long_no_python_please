module BST
    ( BST
    , bstLeft
    , bstRight
    , bstValue
    , empty
    , fromList
    , insert
    , toList
    , size
    , member
    , singleton
    ) where

data BST t = Empty  | Node t (BST t) (BST t) deriving Show

bstValue :: BST a -> Maybe a
bstValue Empty = Nothing
bstValue (Node n l r) = Just n

bstLeft :: BST a -> BST a
bstLeft Empty = Empty
bstLeft (Node n le ri) = le

bstRight :: BST a -> BST a
bstRight Empty = Empty
bstRight (Node n le ri) = ri

empty :: BST a -> Bool
empty Empty = True
empty n = False

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

-- remove :: Int -> BST a -> Bool
-- remove n Empty = False
-- remove n (Node t Empty Empty)
--     | n == t = Empty
--     | otherwise = False
-- remove n (Node t le Empty)

-- remove n (Node t Empty ri)

-- remove n (Node t le ri)