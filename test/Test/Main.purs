module Test.Main where

import Prelude

import Effect (Effect)

import Test.Task01 as Task01

main :: Effect Unit
main = do
    Task01.runSuite

