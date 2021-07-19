module TortoiseCombinators
       ( andThen 
       , loop 
       , invisibly 
       , retrace 
       , overlay 
       ) where

import Tortoise

-- See Tests.hs or the assignment spec for specifications for each
-- of these combinators.

andThen :: Instructions -> Instructions -> Instructions
andThen i1 Stop = i1
andThen Stop i2 = i2
andThen (Move m i1) i2 = Move m (i1 `andThen` i2)
andThen (Turn r i1) i2 = Turn r (i1 `andThen` i2)
andThen (SetStyle l i1) i2 = SetStyle l (i1 `andThen` i2)
andThen (SetColour c i1) i2 = SetColour c (i1 `andThen` i2)
andThen (PenDown i1) i2 = PenDown (i1 `andThen` i2)
andThen (PenUp i1) i2 = PenUp (i1 `andThen` i2)

loop :: Int -> Instructions -> Instructions
loop n i
    | (n > 0) = i `andThen` loop (n - 1) i
    | otherwise = Stop

invisibly :: Instructions -> Instructions
invisibly i = (invisiblyHelpr i True)
    where
        invisiblyHelpr :: Instructions -> Bool -> Instructions
        invisiblyHelpr (Move m i) penState = PenUp (Move m (invisiblyHelpr i penState))
        invisiblyHelpr (Turn r i) penState = PenUp (Turn r (invisiblyHelpr i penState))
        invisiblyHelpr (SetStyle l i) penState = PenUp (SetStyle l (invisiblyHelpr i penState))
        invisiblyHelpr (SetColour c i) penState = PenUp (SetColour c (invisiblyHelpr i penState))
        invisiblyHelpr (PenDown i) penState = (invisiblyHelpr i True)
        invisiblyHelpr (PenUp i) penState = (invisiblyHelpr i False)
        invisiblyHelpr Stop i
            | i == True = PenDown Stop
            | otherwise = PenUp Stop

retrace :: Instructions -> Instructions
retrace i = retraceHelpr i Stop (Solid 1) white True
    where
        retraceHelpr :: Instructions -> Instructions -> LineStyle -> Colour -> Bool -> Instructions
        retraceHelpr (Move m i) a l c b = retraceHelpr i (Move (-m) a) l c b
        retraceHelpr (Turn r i) a l c b = retraceHelpr i (Turn (-r) a) l c b
        retraceHelpr (SetStyle ll i) a l c b = retraceHelpr i (SetStyle l a) ll c b
        retraceHelpr (SetColour cc i) a l c b = retraceHelpr i (SetColour c a) l cc b
        retraceHelpr (PenUp i) a l c b
            | b == True = retraceHelpr i (PenDown a) l c False
            | otherwise = retraceHelpr i (PenUp a) l c False
        retraceHelpr (PenDown i) a l c b
            | b == True = retraceHelpr i (PenDown a) l c True
            | otherwise = retraceHelpr i (PenUp a) l c True
        retraceHelpr Stop a l c b = a

overlay :: [Instructions] -> Instructions
overlay [] = Stop
overlay (x:xs) = x `andThen` (invisibly (retrace x)) `andThen` (overlay xs)
