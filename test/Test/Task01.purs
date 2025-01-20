module Test.Task01 where

import Prelude

import Control.Monad.Free (Free)
import Data.ArrayBuffer.Typed (fromArray)
import Data.Maybe (Maybe(..))
import Data.UInt (fromInt)
import Effect (Effect)
import Effect.Class (liftEffect)
import Tasks.Task01 as Task01
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

runSuites :: Effect Unit
runSuites = runTest do
  test_isValidAsciiText
  test_toAsciiString

defaultBufferSize :: Int
defaultBufferSize = 8

--_makeUint8Array :: Effect Uint8Array
--_makeUint8Array =
--(whole <$> empty defaultBufferSize) >>= toUint8Array

makeUint8Array :: Array Int -> Effect (Task01.AsciiText)
makeUint8Array = fromArray <<< map fromInt

test_isValidAsciiText :: Free TestF Unit
test_isValidAsciiText =
  let
    testFn = Task01.isValidAsciiText
    checkArr arr = makeUint8Array arr >>= testFn # liftEffect
  in
    suite "Task01 test suite for isValidAsciiText" do
      test "should     validate for the case [1,2,3]" do
        Assert.equal true =<< checkArr [ 1, 2, 3 ]
      test "should     validate for the case [-1,2,3]; (-1) cast to UInt" do
        Assert.equal true =<< checkArr [ -1, 2, 3 ]
      test "should NOT validate for the case [128,222,233]" do
        Assert.equal false =<< checkArr [ 128, 222, 233 ]

test_toAsciiString :: Free TestF Unit
test_toAsciiString =
  let
    testFn = Task01.toAsciiString
    checkArr arr = makeUint8Array arr >>= testFn # liftEffect
  in
    suite "Task01 test suite for toAsciiString" do
      test "should     validate for the case [97,98,99]" do
        Assert.equal (Just "abc") =<< checkArr [ 97, 98, 99 ]
      test "should NOT validate for the case [128,222,233]" do
        Assert.equal Nothing =<< checkArr [ 128, 228, 238 ]
