module Tasks.Task01 where

import Prelude

import Data.ArrayBuffer.Typed (filter, foldl, foldr, toString)
import Data.ArrayBuffer.Types (Uint8, Uint8Array)
import Data.Char.Utils (fromCodePoint)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String.Utils (stripChars)
import Data.UInt (UInt, fromInt, toInt)
import Effect (Effect)

{- NOTE:
1. Define a type `AsciiText` which wraps an `ArrayView Uint8` from `arraybuffer-types`, 
   representing packed ASCII text data. 
2. Define `toAsciiString :: AsciiText -> Effect String` function for this type.
3. Write a function which takes an `ArrayView Uint8`, checks if it is valid ASCII, then
   constructs an `AsciiText` if it is, failing otherwise.
4. Write tests to ensure correct functionality in 2 and 3.
-}

{- TODO:
1. [x] create the type `AsciiText` which wraps `ArrayView Uint8` from the `arraybuffer-types` library
2. [x] define a function `toAsciiString :: AsiiText -> Effect String`
    - [x] with tests
3. [x] define a function `isValidAsciiText :: ArrayView Uint8 -> Either ErrorMsg AsciiText`
    - [x] use foldl
    - [x] with tests
4. [x] compose `Data.ArrayBuffer.Typed.toString` with `isValidAsciiText` to create `toAsciiString`
    - [ ] define a function that compose with `String.Utils.Char.fromCodePoint` from a UInt -> String
    - [ ] traverse and create a new Array/List of string
-}

-- | An alias for the type `ArrayView Uint8` FFDI. Identical to:
-- | ```
-- | type AsciiText = ArrayView Uint8
-- | ```
type AsciiText = Uint8Array

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

toAsciiString :: AsciiText -> Effect (Maybe String)
toAsciiString as = do
  isValid <- isValidAsciiText as
  str <- case isValid of
    -- BUG: should map to a new filtered ArrayView without the commas
    true -> Just <$> stripChars "," <$> (toString as)
    false -> pure Nothing
  pure str

-- rewrite
transformAsciiText :: AsciiText -> Effect (Maybe String)
transformAsciiText as = do
  isValid <- isValidAsciiText as
  str <- case isValid of
    false -> pure $ Nothing
    true -> Just <$> (createString as)
  pure $ str

  where
  -- TODO:
  -- - [x] define a function that compose with `String.Utils.Char.fromCodePoint` from a UInt -> String
  --    ```
  --    t :: String -> String 
  --    t = (fromMaybe "") <<< fromCodePoint
  --    ```
  -- for TASK 3
  --  - [ ] traverse and create a new Array/List of string

  g :: UInt -> String
  g = fromMaybe mempty <<< fromCodePoint <<< toInt

  h :: String -> UInt -> String
  h s unsigned = s <> (g unsigned)

  createString :: AsciiText -> Effect String
  createString = foldl h mempty
