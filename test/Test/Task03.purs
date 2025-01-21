module Test.Task03 where

import Prelude

import Control.Monad.Free (Free)
import Control.Monad.ST (while)
import Control.Monad.State (state)
import Data.ArrayBuffer.Typed (length)
import Data.ArrayBuffer.Typed as BuffTyped
import Data.UInt (fromInt)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Random (randomInt)
import Performance.Minibench (bench)
import Tasks.Task01 as Task01
import Tasks.Task03 as Task03
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)

runSuites :: Effect Unit
runSuites = runTest do
  test_insert

defaultBufferSize :: Int
defaultBufferSize = 1_000_000

makeArrayView :: Array Int -> Effect (Task01.AsciiText)
makeArrayView = BuffTyped.fromArray <<< map fromInt

test_insert :: Free TestF Unit
test_insert =
  suite "Task03 test suite for case insert" do
    let
      makeView arr = makeArrayView arr # liftEffect
      isSame a b = BuffTyped.eq a b # liftEffect
    test "should NOT be equal to the input array" do
      arr1 <- makeView [ 1, 2, 3 ]
      arr2 <- makeView []
      Assert.equal false =<< (isSame arr1 arr2)
    test "should     be equal to the input array" do
      let idx = 2
      insertee <- makeView [ 40, 222, 233, 41 ]
      inserter <- makeView [ 1, 2, 3 ]
      expected <- Task03.insert inserter idx insertee # liftEffect
      __actual <- makeView [ 40, 222, 1, 2, 3, 233, 41 ]
      Assert.equal true =<< (isSame expected __actual)
      --expected' <- Task03.insert inserter idx insertee # liftEffect
      --__actual' <- makeView [ 40, 222, 1, 2, 3, 233, 41 ]
      --Assert.equal true =<< (isSame expected' __actual')

{--
  - we create a  
--}

bench_insert1000Times :: Effect Unit
bench_insert1000Times = do
  {- TODO: need a StateT monad transformer to keep the latest copy of the new buffer.
  -}
  let
    makeView arr = makeArrayView arr # liftEffect

    randomPos :: Task01.AsciiText -> Effect Int
    randomPos = randomInt 1 <<< length

  insertee <- makeView [ 40, 222, 233, 41 ]
  inserter <- makeView [ 1, 2, 3 ]
  bench
    ( \_ -> do
        idx <- randomPos insertee
        _ <- Task03.insert inserter idx insertee
        pure unit
    )
