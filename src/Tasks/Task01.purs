module Tasks.Task01 where

import Prelude

import Data.ArrayBuffer.Typed (foldr, toString)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.UInt (UInt, fromInt)
import Effect (Effect)

{- | TODO: Task 1:
    1. [x] create the type `AsciiText` which wraps `ArrayView Uint8` from the `arraybuffer-types` library
    2. [x] define a function `toAsciiString :: AsiiText -> Effect String`
        - [x] with tests
    3. [x] define a function `isValidAsciiText :: ArrayView Uint8 -> Either ErrorMsg AsciiText`
        - [x] use foldl
        - [x] with tests
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
isValidAsciiText :: Uint8Array -> Effect Boolean
isValidAsciiText = foldr (isValid) (false)
  where
  isValid :: UInt -> Boolean -> Boolean
  isValid a b
    | a >= (fromInt 0) && a <= (fromInt 127) = true
    | otherwise = b
