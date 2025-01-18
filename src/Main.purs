module Main where

import Prelude

import Tasks.Task01 as AsciiType
import Effect (Effect)

main :: Effect Unit
main = do
    AsciiType.test
