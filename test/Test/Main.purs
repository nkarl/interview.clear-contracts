module Test.Main where

import Prelude

import Effect (Effect)

import Test.Task01 as Task01
import Test.Task02 as Task02
import Test.Task03 as Task03

main :: Effect Unit
main = do
  Task01.runSuites
  Task02.runSuites
  Task03.runSuites

