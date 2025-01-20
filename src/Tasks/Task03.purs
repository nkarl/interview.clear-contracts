module Tasks.Task03 where

import Prelude

import Data.ArrayBuffer.ArrayBuffer (empty)
import Data.ArrayBuffer.Cast (toUint8Array)
import Data.ArrayBuffer.DataView (whole)
import Data.ArrayBuffer.Typed (fromArray, length, setTyped, slice)
import Data.Maybe (Maybe(..))
import Data.UInt (fromInt)
import Effect (Effect)
import Tasks.Task01 (AsciiText)

{- NOTE:
1. Define a function `insert` that takes an `AsciiText` from Task 1 (the
   'target'), an `Int` (the insert position) and another `AsciiText` (the
   thing to be inserted) and produces another `AsciiText` where all data at any
   (zero-based) index in the result less than the insert position come from the
   'target', followed by all the data in the thing to be inserted, followed by
   what remains of the 'target' (if anything). Handle failures in any way you
   see suitable.
2. Describe a property (in the sense of equational reasoning) that `insert` from
   1 should have. Write tests to show that your implementation in 1 has that
   property.
3. Explain why `insert` is inefficient in the case when we have to do many of
   them in a row.
4. Describe and define an auxilliary data structure designed to allow many uses
   of `insert` (or an equivalent operation) efficiently. Also define a way of
   converting this auxilliary data structure back into an `AsciiText`. Write
   tests to show that its corresponding operation matches `insert`.
5. Define a benchmark showing that your optimized version from 4 provides an
   actual improvement over the original function from 1. Justify, and use,
   realistic data sizes and inputs. Execute the benchmark and show the results
   as part of your answer.
-}

{-
  TASK 3

  1. OBSERVATION
  ---
  Considering that dynamically allocating new memory buffer (i.e. resizing) is not ideal for rapid and high frequency
  insertion at random index, it might be better to keep a state of string as a list and traverse its length in O(N) to
  insert and join the two monoids.

  2. INVESTIGATION
  ---
  1. [std::vector vs std::list](https://dzone.com/articles/c-benchmark-%E2%80%93-stdvector-vs) 
  2. [cache misses happen because every proc context has a copy of a chunk of the main memory](https://stackoverflow.com/a/18559358)
    - for every new thread, some kernel-CPU coordination is required to keep data up to date (liveness).
    - this is a synchronous op; has a performance cost.

  My original assumption is that list is more efficient than smart referenced array buffers (vectors). However, a cursory
  investigation shows that my assumption was faulty because it failed to account for cache misses.

  3. TEST DESIGN
  ---
  1. Assumes an input of 1-million-token long ASCII string. This corresponds to 1-million-cell array buffer.
  2. Assumes 0.001, 0.01, and 0.1 rates of random insertions over input length.
  3. This is a simplified simulation for the consensus resolution on the Cardano chain, where a blockchain of length N
      might require some amount of time for all SPO to resolve the block oreder.

  4. BENCHMARK
  ---
  Use `hyperfine` to benchmark performance.
-}

{- TODO:
  1. [x] compose `insert`
      - [x] setTyped: stores multiple values in an ArrayView, reading input from a second ArrayView
      - [x] empty
      - [x] length
  2. [ ] set up tests for 1-million-token long buffers.
      - [ ] fn to generate an insertee buffer and fill with random values
      - [ ] fn to repeatedly insert a smaller inserter buffer at some random position K for N times.
          - $N \in (0.001, 0.01, 0.1)$ times the length of the insertee buffer.
-}

{-
1. `insert` takes
    - an `AsciiText` from Task 1 (the 'target'),
    - an `Int` (the insert position), and
    - another `AsciiText` (the thing to be inserted), and
    - produces another `AsciiText` where
        - all data at any index in the result less than the insert position come from
          the 'target', followed by all the data in the thing to be inserted, followed by what remains
          of the 'target' (if anything). Handle failures in any way you see suitable.
-}

type Inserter = AsciiText
type Idx = Int
type Insertee = AsciiText
type Result = AsciiText

makeAsciiBuffer :: Int -> Effect AsciiText
makeAsciiBuffer size =
  (whole <$> empty size) >>= toUint8Array

makeArrayView :: Array Int -> Effect (AsciiText)
makeArrayView = fromArray <<< map fromInt

insert :: Inserter -> Idx -> Insertee -> Effect Result
insert inserter idx insertee = do
  prefix <- slice 0 idx insertee
  _infix <- slice 0 (length inserter) inserter
  suffix <- slice idx (length insertee) insertee
  new <- makeAsciiBuffer (length inserter + length insertee)
  _ <- setTyped new (Just 0) $ prefix
  _ <- setTyped new (Just idx) $ _infix
  _ <- setTyped new (Just $ idx + length inserter) $ suffix
  pure new
