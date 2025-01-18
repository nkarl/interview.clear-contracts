module Test.Task01 where

--import Prelude (Unit, discard, pure, unit, ($))

import Prelude

import Control.Monad.Free (Free)
import Data.ArrayBuffer.Typed (fromArray)
import Data.UInt (fromInt)
import Effect (Effect)
import Effect.Class (liftEffect)
import Tasks.Task01 as T1
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

runSuite :: Effect Unit
runSuite = runTest do
  makeSuite

defaultBufferSize :: Int
defaultBufferSize = 8

--_makeUint8Array :: Effect Uint8Array
--_makeUint8Array =
--(whole <$> empty defaultBufferSize) >>= toUint8Array

makeUint8Array :: Array Int -> Effect (T1.AsciiText)
makeUint8Array = fromArray <<< map fromInt

makeSuite :: Free TestF Unit
makeSuite =
  suite "Task01 test suite" do
    test "42 == 42" do
      Assert.equal 42 42
    test "[1,2,3] is valid ASCII text" do
      let check = makeUint8Array [ 1, 2, 3 ] >>= T1.isValidAsciiText
      Assert.equal true =<< (liftEffect check)
    test "[-1,2,3] is not valid ASCII text" do
      let check = makeUint8Array [ -1, 2, 3 ] >>= T1.isValidAsciiText
      Assert.equal false =<< (liftEffect check)
