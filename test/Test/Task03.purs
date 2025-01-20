module Test.Task03 where

import Prelude

import Control.Monad.Free (Free)
import Data.ArrayBuffer.Typed (fromArray, eq)
import Data.UInt (fromInt)
import Effect (Effect)
import Effect.Class (liftEffect)
import Tasks.Task01 as Task01
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

runSuites :: Effect Unit
runSuites = runTest do
  test_insert

defaultBufferSize :: Int
defaultBufferSize = 8

--_makeUint8Array :: Effect Uint8Array
--_makeUint8Array =
--(whole <$> empty defaultBufferSize) >>= toUint8Array

makeArrayView :: Array Int -> Effect (Task01.AsciiText)
makeArrayView = fromArray <<< map fromInt

test_insert :: Free TestF Unit
test_insert =
  suite "Task03 test suite for case insert" do
    let
      makeView arr = makeArrayView arr # liftEffect
      isSame a b = eq a b # liftEffect
    test "should NOT be equal to the input array" do
      arr1 <- makeView [ 1, 2, 3 ]
      arr2 <- makeView []
      Assert.equal true =<< (isSame arr1 arr2)
