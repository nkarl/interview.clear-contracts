module Tasks.Task02 where

import Prelude

import Data.ArrayBuffer.Typed (foldl, foldr)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Data.UInt (UInt, toInt)
import Effect (Effect)
import Tasks.Task01 (AsciiText)

{- NOTE:
1. Write a function that validates whether the `AsciiText` is correctly parenthesized. 
   Parentheses to take into account are `()` AND `[]`. There can only be a single pair 
   of parentheses, i.e no other parentheses can be there for it to be valid. 
   Example of a valid parentheses: `A(bxe.)` or `[xyz]a`. 
   Example of invalid: `(abc()` or `abcd]x`
2. Define another function modifying the function from 1. Now the only valid pairs are
   the following: `(]`, `[)`. i.e. starting with `(` must end with `]` and `[` must end 
   with `)`.
   Example of a valid parentheses: `A(bxe.]` or `[xyz)a`.
   Example of a invalid: `A(bxe.)` or `[xyz))a`.
3. Define a new function that extends the functionality accepting any number of paired 
   parentheses.
4. Write tests to ensure correctness.
5. Describe 3 properties, one for each function from 1, 2, 3. Write tests to show the
   implementations do have those properties.
-}

{- TODO:
  1. [ ] define a function that check for A SINGLE PAIR of either parentheses or brackets.
      - [x] implement for `()` first.
      - [x] incorporate `[]`.
      - [x] write tests.
  2. [x] define a new function the extends the implemtation to check for 2 cases `(]` and `[)`.
      - [x] write tests.
  3. [x] define a folding action to check that the correctly paired parentheses reduce to 0.
  4. [ ] describing 3 properties
      - [ ] isomorphic? commutative? properties of input?
-}

-- | A simple coproduct type for the enclosure symbols.
data Enclosure
  = PAREN_LEFT
  | PAREN_RIGHT
  | BRACK_LEFT
  | BRACK_RIGHT
  | NO_SUPPORT

derive instance genericEnclosure :: Generic Enclosure _

derive instance eqEnclosure :: Eq Enclosure

instance showEnclosure :: Show Enclosure where
  show = genericShow

-- | Translates a UInt value to an Enclosure variant.
matchSymbol :: UInt -> Enclosure
matchSymbol = toInt >>> case _ of
  40 -> PAREN_LEFT -- `(`
  41 -> PAREN_RIGHT -- `)`
  91 -> BRACK_LEFT -- `[`
  93 -> BRACK_RIGHT -- `]`
  _ -> NO_SUPPORT

-- | A simple state to capture the accumulated/reduced counts for valid pairs of Enclosure.
-- | A valid State always equalizes to 0 for both counts.
type EnclosureState =
  { parenCount :: Int
  , brackCount :: Int
  }

-- | Checks if an Uint8 ArrayView of a buffer contains the correctly paired Enclosure symbols.
hasCorrectEnclosurePairs :: AsciiText -> Effect Boolean
hasCorrectEnclosurePairs arr = do
  let
    z0 = { parenCount: 0, brackCount: 0 }
  res <- validPairs z0 arr
  pure $ res == z0

  where

  validPairs = foldl (flip check)

  check a s@{ parenCount, brackCount }
    | matchSymbol a == PAREN_LEFT = { parenCount: parenCount + 1, brackCount }
    | matchSymbol a == PAREN_RIGHT = { parenCount: parenCount - 1, brackCount }
    | matchSymbol a == BRACK_LEFT = { parenCount, brackCount: brackCount + 1 }
    | matchSymbol a == BRACK_RIGHT = { parenCount, brackCount: brackCount - 1 }
    | otherwise = s

-- | The same as `hasCorrectEnclosurePairs`, modified to checks for the odd pair `(+.]` and `[.+)`.
hasCorrectEnclosurePairsOdd :: AsciiText -> Effect Boolean
hasCorrectEnclosurePairsOdd arr = do
  let
    z0 = { parenCount: 0, brackCount: 0 }
  res <- validPairs z0 arr
  pure $ res == z0

  where

  validPairs = foldr (check)

  check a s@{ parenCount, brackCount }
    | matchSymbol a == PAREN_LEFT = { parenCount: parenCount + 1, brackCount } -- (
    | matchSymbol a == BRACK_RIGHT = { parenCount: parenCount - 1, brackCount } -- ]
    | matchSymbol a == BRACK_LEFT = { parenCount, brackCount: brackCount + 1 } -- [
    | matchSymbol a == PAREN_RIGHT = { parenCount, brackCount: brackCount - 1 } -- )
    | otherwise = s
