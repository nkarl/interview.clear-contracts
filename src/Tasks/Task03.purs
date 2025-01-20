module Tasks.Task03 where

import Data.ArrayBuffer.ArrayBuffer (empty)
import Data.ArrayBuffer.DataView (set)
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
  1. [ ] compose `insert`
      - set
      - setTyped: stores multiple values in an ArrayView, reading input from a second ArrayView
      - slice: copy a chunk of an ArrayView between [i,j] into a new Buffer
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

type Target = AsciiText
type Source = AsciiText
type Result = AsciiText
--insert :: Target -> Int -> Source -> Result
--insert = empty
