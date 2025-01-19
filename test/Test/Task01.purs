module Test.Task01 where

--import Prelude (Unit, discard, pure, unit, ($))

import Prelude

import Control.Monad.Free (Free)
import Data.ArrayBuffer.Typed (fromArray)
import Data.Maybe (Maybe(..))
import Data.UInt (fromInt)
import Effect (Effect)
import Effect.Class (liftEffect)
import Tasks.Task01 as T1
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

runSuite :: Effect Unit
runSuite = runTest do
  isValidAsciiTextTest
  toAsciiStringTest

defaultBufferSize :: Int
defaultBufferSize = 8

--_makeUint8Array :: Effect Uint8Array
--_makeUint8Array =
--(whole <$> empty defaultBufferSize) >>= toUint8Array

makeUint8Array :: Array Int -> Effect (T1.AsciiText)
makeUint8Array = fromArray <<< map fromInt

isValidAsciiTextTest :: Free TestF Unit
isValidAsciiTextTest =
  suite "Task01 test suite for isValidAsciiText" do
    test "[1,2,3] is valid ASCII text" do
      let check = makeUint8Array [ 1, 2, 3 ] >>= T1.isValidAsciiText
      Assert.equal true =<< (liftEffect check)
    test "[-1,2,3] is not valid ASCII text but (-1) is concerced into a UInt" do
      let check = makeUint8Array [ -1, 2, 3 ] >>= T1.isValidAsciiText -- 
      Assert.equal true =<< (liftEffect check)
    test "[128,222,233] is not valid ASCII text" do
      let check = makeUint8Array [ 128, 222, 233 ] >>= T1.isValidAsciiText
      Assert.equal false =<< (liftEffect check)

toAsciiStringTest :: Free TestF Unit
toAsciiStringTest =
  suite "Task01 test suite for toAsciiString" do
    test "[97,98,99] is valid ASCII text" do
      let check = makeUint8Array [ 97, 98, 99 ] >>= T1.transformAsciiText
      Assert.equal (Just "abc") =<< (liftEffect check)
    test "[128,222,233] is not valid ASCII text" do
      let check = makeUint8Array [ 128, 228, 238 ] >>= T1.transformAsciiText
      Assert.equal Nothing =<< (liftEffect check)
