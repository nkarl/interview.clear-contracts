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

runSuite :: Effect Unit
runSuite = runTest do
  test_isCorrectlyParenthesized

defaultBufferSize :: Int
defaultBufferSize = 8

--_makeUint8Array :: Effect Uint8Array
--_makeUint8Array =
--(whole <$> empty defaultBufferSize) >>= toUint8Array

makeUint8Array :: Array Int -> Effect (Task01.AsciiText)
makeUint8Array = fromArray <<< map fromInt

test_isCorrectlyParenthesized :: Free TestF Unit
test_isCorrectlyParenthesized =
  suite "Task02 test suite for isCorrectlyParenthesized" do
    test "[40,222,233] is not correctly paired for `()`" do
      let check = makeUint8Array [ 40, 222, 233 ] >>= Task02.isCorrectlyParenthesized
      Assert.equal false =<< (liftEffect check)
    test "[40,222,233, 41] is correctly paired `()`" do
      let check = makeUint8Array [ 40, 222, 233, 41 ] >>= Task02.isCorrectlyParenthesized
      Assert.equal true =<< (liftEffect check)
    test "[40,222,233, 41] is not correctly paired `[]`" do
      let check = makeUint8Array [ 91, 222, 233 ] >>= Task02.isCorrectlyParenthesized
      Assert.equal false =<< (liftEffect check)
    test "[40,222,233, 41] is correctly paired `[]`" do
      let check = makeUint8Array [ 91, 222, 233, 93 ] >>= Task02.isCorrectlyParenthesized
      Assert.equal true =<< (liftEffect check)
