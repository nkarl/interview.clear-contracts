module Main where

import Prelude

import AsciiTextType as AsciiType
import Effect (Effect)

main :: Effect Unit
main = do
    AsciiType.test
