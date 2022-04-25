module BST
  ( BST (Empty, Node),
    value,
    lchild,
    rchild,
    isEmpty,
    fromList,
    insert,
    toList,
    size,
    member,
    singleton,
    remove,
    toBstList,
    getIterator,
    hasNext,
    getNext,
    bstFilter,
    mapBst,
    reduceBst,
    insertList,
    concatBst,
  )
where

import Data.Monoid ()

data BST t
  = Empty
  | Node
      { value :: t,
        lchild :: BST t,
        rchild :: BST t
      }
  deriving (Show, Eq)

isEmpty :: BST a -> Bool
isEmpty Empty = True
isEmpty _ = False

size :: BST a -> Int
size Empty = 0
size (Node _ le ri) = 1 + size le + size ri

member :: Ord a => a -> BST a -> Bool
member _ Empty = False
member v (Node t le ri)
  | v == t = True
  | v < t = member v le
  | v > t = member v ri
  | otherwise = False

insert :: Ord a => a -> BST a -> BST a
insert n Empty = Node n Empty Empty
insert n (Node t le ri)
  | n == t = Node t le ri
  | n < t = Node t (insert n le) ri
  | otherwise = Node t le (insert n ri)

fromList :: Ord a => [a] -> BST a
fromList [] = Empty
fromList x = insert (last x) (fromList (init x))

toList :: BST a -> [a]
toList Empty = []
toList (Node n le ri) = toList le ++ [n] ++ toList ri

singleton :: a -> BST a
singleton n = Node n Empty Empty

unionSubtrees :: BST t -> BST t -> BST t
unionSubtrees left (Node node Empty right) = Node node left right
unionSubtrees l (Node node left right) = Node node (unionSubtrees l left) right
unionSubtrees _ _ = error "error in union after remove"

remove :: Ord t => t -> BST t -> BST t
remove _ Empty = Empty
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
remove _ _ = error "error in remove"

data IteratorBST a = Iter
  { current :: BST a,
    rest :: [BST a]
  }

toBstList :: BST a -> [BST a]
toBstList Empty = []
toBstList (Node n le ri) = toBstList le ++ [Node n le ri] ++ toBstList ri

getIterator :: BST a -> IteratorBST a
getIterator Empty = error "empty iter"
getIterator (Node n l r) = Iter {current = head $ toBstList (Node n l r), rest = tail $ toBstList (Node n l r)}

hasNext :: IteratorBST a -> Bool
hasNext a
  | null $ rest a = False
  | otherwise = True

getNext :: IteratorBST a -> IteratorBST a
getNext a = Iter {current = head $ rest a, rest = tail $ rest a}

bstFilter :: (a -> Bool) -> IteratorBST a -> [a]
bstFilter f it
  | f $ value $ current it = if hasNext it then value (current it) : bstFilter f (getNext it) else [value (current it)]
  | not $ f $ value $ current it = if hasNext it then bstFilter f (getNext it) else []
  | otherwise = error "error in filter"

mapBst :: (a -> a) -> IteratorBST a -> [a]
mapBst f it
  | hasNext it = f (value (current it)) : mapBst f (getNext it)
  | not $ hasNext it = [f (value (current it))]
  | otherwise = error "error in map"

reduceBst :: (a -> a -> a) -> IteratorBST a -> a -> a
reduceBst f it initValue
  | hasNext it = reduceBst f (getNext it) (f initValue (value (current it)))
  | not $ hasNext it = f initValue (value (current it))
  | otherwise = error "error in reduce"

insertList :: Ord a => BST a -> [a] -> BST a
insertList Empty xs = fromList xs
insertList n [] = n
insertList n (x : xs) = insertList (insert x n) xs

concatBst :: Ord a => BST a -> BST a -> BST a
concatBst Empty n = n
concatBst n Empty = n
concatBst n1 n2 = insertList n1 (toList n2)

instance Ord a => Semigroup (BST a) where
  (<>) = concatBst

instance Ord a => Monoid (BST a) where
  mempty = Empty
  mappend = (<>)
