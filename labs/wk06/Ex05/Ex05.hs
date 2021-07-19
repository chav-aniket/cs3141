module Ex05 where

import Text.Read (readMaybe)

data Token = Number Int | Operator (Int -> Int -> Int)

parseToken :: String -> Maybe Token
parseToken "+" = Just (Operator (+))
parseToken "-" = Just (Operator (-))
parseToken "/" = Just (Operator div)
parseToken "*" = Just (Operator (*))
parseToken str = fmap Number (readMaybe str)

tokenise :: String -> Maybe [Token]
tokenise = mapM parseToken . words


newtype Calc a = C ([Int] -> Maybe ([Int], a))


pop :: Calc Int
pop = C f
  where
    f :: [a] -> Maybe ([a], a)
    f [] = Nothing
    f (x:xs) = Just (xs, x)

push :: Int -> Calc ()
push i = C (\x -> Just ((i:x), ()))


instance Functor Calc where
  fmap f (C sa) = C $ \s ->
      case sa s of 
        Nothing      -> Nothing
        Just (s', a) -> Just (s', f a)

instance Applicative Calc where
  pure x = C (\s -> Just (s,x))
  C sf <*> C sx = C $ \s -> 
      case sf s of 
          Nothing     -> Nothing
          Just (s',f) -> case sx s' of
              Nothing      -> Nothing
              Just (s'',x) -> Just (s'', f x)

instance Monad Calc where
  return = pure
  C sa >>= f = C $ \s -> 
      case sa s of 
          Nothing     -> Nothing
          Just (s',a) -> unwrapCalc (f a) s'
    where unwrapCalc (C a) = a

evaluate :: [Token] -> Calc Int
evaluate ts = evaluated ts >> pop
  where
    evaluated :: [Token] -> Calc Int
    evaluated [] = pure 0
    evaluated ((Number i):xs) = push i >> evaluated xs
    evaluated ((Operator o): xs) = do
      x <- pop
      y <- pop
      push (o y x) >> evaluated xs

calculate :: String -> Maybe Int
calculate s = do
  let tokens = tokenise s
  case tokens of
    Nothing -> Nothing
    Just tokens -> do
      let evalTokens = evaluate tokens
      value <- let (C f) = evalTokens in f []
      Just (snd value)
