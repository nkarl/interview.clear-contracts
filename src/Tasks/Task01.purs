module Tasks.Task01 where

import Prelude

import Data.ArrayBuffer.ArrayBuffer (empty)
import Data.ArrayBuffer.Typed (toString, whole, foldr)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.UInt (toInt)
import Effect (Effect)

{-
    TODO: TASK 1: `ArrayBuffer -> Dataview Uint8`
        - either the `ArrayView` or `DataView` type might have already been implemented as a monad
            - that means that it they can used as is without too much implementation.

    ArrayBuffer -> DataView Uint8 -> Effect String
-}

{- | TODO: task 1:
    1. [x] create the type `AsciiText` which wraps `ArrayView Uint8` from the `arraybuffer-types` library
    2. [x] define a function `toAsciiString :: AsiiText -> Effect String`
        - [ ] with tests
    3. [ ] define a function `isValidAsciiText :: ArrayView Uint8 -> Either ErrorMsg AsciiText`
        - [ ] use foldl
        - [ ] with tests
-}

-- | An alias for the type `ArrayView Uint8` FFDI. Identical to:
-- | ```
-- | type AsciiText = ArrayView Uint8
-- | ```
type AsciiText = Uint8Array

-- | An alias for the library function `Data.ArrayBuffer.Typed.toString`
toAsciiString :: AsciiText -> Effect String
toAsciiString = toString

-- | A type to represent error messages.
type ErrorMsg = String

-- | Takes a packed Uint8 array and check that its celluar values are bound between 0 and 127.
--isValidAsciiText :: Uint8Array -> Either ErrorMsg AsciiText
--isValidAsciiText _ = Left "the function isValidAsciiText not implemented" -- DONE: implement checks

isValidAsciiText :: Uint8Array -> Effect Boolean
isValidAsciiText = foldr ((isValid) <<< toInt) (false)
  where
  isValid :: Int -> Boolean -> Boolean
  isValid a b
    | a >= 0 && a <= 127 = true
    | otherwise = b

-- | a simple eye-balling test for drafting and type hole checks.
test :: Effect Unit
test = do
  arrBuf <- empty 8
  arrView <- whole arrBuf
  _discard <- pure $ isValidAsciiText $ arrView
  pure unit
