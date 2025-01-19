module Test.Task02 where

import Prelude

import Control.Monad.Free (Free)
import Data.ArrayBuffer.Typed (fromArray)
import Data.UInt (fromInt)
import Effect (Effect)
import Tasks.Task01 as Task01
import Test.Unit (TestF, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

runSuite :: Effect Unit
runSuite = runTest do
  test_hassValidEnclosurePairs

defaultBufferSize :: Int
defaultBufferSize = 8

--_makeUint8Array :: Effect Uint8Array
--_makeUint8Array =
--(whole <$> empty defaultBufferSize) >>= toUint8Array

makeUint8Array :: Array Int -> Effect (Task01.AsciiText)
makeUint8Array = fromArray <<< map fromInt

test_hassValidEnclosurePairs :: Free TestF Unit
test_hassValidEnclosurePairs =
    test "[40,222,233] is not correctly paired" do
      Assert.equal false true
