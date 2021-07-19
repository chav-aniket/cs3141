module Art where  

import ShapeGraphics
import Codec.Picture

art :: Picture
art = tree 10 (Point 400 800) (Vector 0 (-100)) red

flake :: Int -> Point -> Vector -> Colour -> Picture
flake depth origin separation colour
  | depth == 0 = drawLine line
  | otherwise
    = drawline line
    ++ flake (depth - 1) nextPoint left nextColour
    ++ flake (depth - 1) nextPoint right nextColour
  where
    drawline

tree :: Int -> Point -> Vector -> Colour -> Picture
tree depth base direction colour
  | depth == 0 = drawLine line
  | otherwise
    =  drawLine line
    ++ tree (depth - 1) nextBase left nextColour -- left tree
    ++ tree (depth - 1) nextBase right nextColour -- left tree
  where
    drawLine :: Line -> Picture
    drawLine (Line start end) =
      [ Path [start, end] colour Solid ]

    line = Line base nextBase
    nextBase = offset direction base

    left = rotateVector (-pi /12) $ scale 0.8 $ direction
    right = rotateVector (pi /12) $ scale 0.8 $ direction

    nextColour =
      colour { redC = (redC colour) - 24, blueC = (blueC colour) + 24 }

-- Offset a point by a vector
offset :: Vector -> Point -> Point
offset (Vector vx vy) (Point px py)
  = Point (px + vx) (py + vy)

-- Scale a vector
scale :: Float -> Vector -> Vector
scale factor (Vector x y) = Vector (factor * x) (factor * y)

-- Rotate a vector (in radians)
rotateVector :: Float -> Vector -> Vector
rotateVector alpha (Vector vx vy)
  = Vector (cos alpha * vx - sin alpha * vy)
           (sin alpha * vx + cos alpha * vy)

-- use 'writeToFile' to write a picture to file "ex01.png" to test your
-- program if you are not using Haskell for Mac
-- e.g., call
-- writeToFile [house, door]

writeToFile pic
  = writePng "art.png" (drawPicture 3 art)
