module Tasks.Task03 where

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

