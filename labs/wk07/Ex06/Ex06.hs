{-# LANGUAGE GADTs #-}

module Ex06 where

-- Datatype of formulas
-- --------------------

data Formula ts where
  Body   :: Term Bool                     -> Formula ()
  Exists :: Show a 
         => [a] -> (Term a -> Formula as) -> Formula (a, as)

data Term t where
  Name    :: String -> Term t    -- to facilitate pretty printing only. 
                                 -- don't use this in actual formulae.

  Con     :: t -> Term t -- Constant values

  -- Logical operators
  And     :: Term Bool -> Term Bool -> Term Bool
  Or      :: Term Bool -> Term Bool -> Term Bool

  -- Comparison operators
  Smaller :: Term Int  -> Term Int  -> Term Bool

  -- Arithmetic operators
  Plus    :: Term Int  -> Term Int  -> Term Int


-- Pretty printing formulas
-- ------------------------

instance Show t => Show (Term t) where
  show (Con v)       = show v
  show (And p q)     = "(" ++ show p ++ " && " ++ show q ++ ")"
  show (Or p q)      = "(" ++ show p ++ " || " ++ show q ++ ")"
  show (Smaller n m) = "(" ++ show n ++ " < "  ++ show m ++ ")"
  show (Plus n m)    = "(" ++ show n ++ " + "  ++ show m ++ ")"
  show (Name name)   = name

instance Show (Formula ts) where
  show = show' ['x' : show i | i <- [0..]]
    where
      show' :: [String] -> Formula ts' -> String
      show' ns     (Body body)   = show body
      show' (n:ns) (Exists vs p) = "exists " ++ n ++ "::" ++ show vs ++ ". " ++ show' ns (p (Name n))


-- Example formulas
-- ----------------

ex1 :: Formula ()
ex1 = Body (Con True)

ex2 :: Formula (Int, ())
ex2 = Exists [1..10] $ \n ->
        Body $ n `Smaller` (n `Plus` Con 1)

ex3 :: Formula (Bool, (Int, ()))
ex3 = Exists [False, True] $ \p -> 
      Exists [0..2] $ \n -> 
        Body $ p `Or` (Con 0 `Smaller` n)

-- Evaluating terms
-- ----------------
eval :: Term t -> t
eval (Con x) = x
eval (And a1 a2) = eval a1 && eval a2
eval (Or o1 o2) = eval o1 || eval o2
eval (Smaller s1 s2) = eval s1 < eval s2
eval (Plus p1 p2) = eval p1 + eval p2

-- the Name constructor is not relevant for evaluation
-- just throw an error if it is encountered:
eval (Name _) = error "eval: Name"   


-- Checking formulas
-- -----------------

satisfiable :: Formula ts -> Bool
satisfiable (Body b) = eval b
satisfiable (Exists xs f) = any (satisfiable . f . Con) xs

-- Enumerating solutions of formulae
-- ---------------------------------

solutions :: Formula ts -> [ts]
solutions (Body b) = [() | eval b]
solutions (Exists xs f) =
  [(m,n)
    | m <- xs
    , n <- (solutions . f . Con) m]
