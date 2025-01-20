module Test.Task02 where

import Prelude

import Control.Monad.Free (Free)
import Data.ArrayBuffer.Typed (fromArray)
import Data.UInt (fromInt)
import Effect (Effect)
import Effect.Class (liftEffect)
import Tasks.Task01 as Task01
import Tasks.Task02 as Task02
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

runSuites :: Effect Unit
runSuites = runTest do
  test_isCorrectlyParenthesized
  test_isCorrectlyParenthesizedOdd

defaultBufferSize :: Int
defaultBufferSize = 8

--_makeUint8Array :: Effect Uint8Array
--_makeUint8Array =
--(whole <$> empty defaultBufferSize) >>= toUint8Array

makeUint8Array :: Array Int -> Effect (Task01.AsciiText)
makeUint8Array = fromArray <<< map fromInt

test_isCorrectlyParenthesized :: Free TestF Unit
test_isCorrectlyParenthesized =
  let
    testFn = Task02.hasCorrectEnclosurePairs
    checkArr arr = makeUint8Array arr >>= testFn # liftEffect
  in
    suite "Task02 test suite for case hasCorrectEnclosurePairs" do
      test "should NOT correctly pair for the case `(.+`" do
        Assert.equal false =<< checkArr [ 40, 222, 233 ]
      test "should     correctly pair for the case `(.+)`" do
        Assert.equal true =<< checkArr [ 40, 222, 233, 41, 128 ]
      test "should NOT correctly pair for the case `.+)`" do
        Assert.equal false =<< checkArr [ 222, 233, 41 ]
      test "should NOT correctly pair for the case `((.+)`" do
        Assert.equal false =<< checkArr [ 40, 40, 222, 233, 41 ]
      test "should NOT correctly pair for the case `[.+`" do
        Assert.equal false =<< checkArr [ 91, 222, 233 ]
      test "should     correctly pair for the case `[.+]`" do
        Assert.equal true =<< checkArr [ 91, 222, 233, 93 ]
      test "should NOT correctly pair for the case `[.+]]`" do
        Assert.equal false =<< checkArr [ 91, 222, 233, 93, 93 ]

test_isCorrectlyParenthesizedOdd :: Free TestF Unit
test_isCorrectlyParenthesizedOdd =
  let
    testFn = Task02.hasCorrectEnclosurePairsOdd
    checkArr arr = makeUint8Array arr >>= testFn # liftEffect
  in
    suite "Task02 test suite for case hasCorrectEnclosurePairsOdd" do
      test "should NOT correctly pair for the case `(.+)`" do
        Assert.equal false =<< checkArr [ 40, 222, 233, 41, 128 ]
      test "should     correctly pair for the case `[.+)`" do
        Assert.equal true =<< checkArr [ 91, 222, 233, 41 ]
      test "should NOT correctly pair for the case `[.+]`" do
        Assert.equal false =<< checkArr [ 91, 222, 233, 93 ]
      test "should     correctly pair for the case `(.+]`" do
        Assert.equal true =<< checkArr [ 40, 222, 233, 93 ]
