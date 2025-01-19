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

runSuite :: Effect Unit
runSuite = runTest do
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
  suite "Task01 test suite for isValidAsciiText" do
    test "[1,2,3] is valid ASCII text" do
      let check = makeUint8Array [ 1, 2, 3 ] >>= Task01.isValidAsciiText
      Assert.equal true =<< (liftEffect check)
    test "[-1,2,3] is not valid ASCII text but (-1) is concerced into a UInt" do
      let check = makeUint8Array [ -1, 2, 3 ] >>= Task01.isValidAsciiText -- 
      Assert.equal true =<< (liftEffect check)
    test "[128,222,233] is not valid ASCII text" do
      let check = makeUint8Array [ 128, 222, 233 ] >>= Task01.isValidAsciiText
      Assert.equal false =<< (liftEffect check)

test_toAsciiString :: Free TestF Unit
test_toAsciiString =
  suite "Task01 test suite for toAsciiString" do
    test "[97,98,99] is valid ASCII text" do
      let check = makeUint8Array [ 97, 98, 99 ] >>= Task01.toAsciiString
      Assert.equal (Just "abc") =<< (liftEffect check)
    test "[128,222,233] is not valid ASCII text" do
      let check = makeUint8Array [ 128, 228, 238 ] >>= Task01.toAsciiString
      Assert.equal Nothing =<< (liftEffect check)
