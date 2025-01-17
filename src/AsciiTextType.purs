module AsciiTextType where

import Prelude

import Data.ArrayBuffer.Types (ArrayBuffer, ArrayView, ArrayViewType, Uint8)
import Effect (Effect)
import Effect.Class.Console (error, log)

-- NOTE: requirement

-- | This type represents an 8-bit unsigned integer
newtype AsciiText a = AsciiText (ArrayView a)

toAsciiString :: AsciiText Uint8 -> Effect String
toAsciiString _ = pure "Not Implemented"

test :: Effect Unit
test = do
    --let a = AsciiText (0x23 :: Uint8)
    error "ERROR: AsciiText test not implemented"
