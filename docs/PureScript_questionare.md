# Important notes

Use good practices throughout. This includes commenting (both documentation and
otherwise), error handling and idiomatic PureScript practices. Define whatever
additional functionality you feel you need to complete these tasks successfully.

Use only the following packages for arraybuffer specific work (manipulating 
`ArrayBuffer`s, `ArrayView`s or `DataView`s):
- `arraybuffer-types` (https://github.com/purescript-contrib/purescript-arraybuffer-types) 
- `arraybuffer` (https://github.com/purescript-contrib/purescript-arraybuffer)

Many of the functions for manipulating the above mentioned types are in the `Effect` monad, 
i.e. most of your defined functions are expected to be using the `Effect` monad, too.

You're allowed (and, in fact, required) to use any other packages.

# Task 1

1. Define a type `AsciiText` which wraps an `ArrayView Uint8` from `arraybuffer-types`, 
   representing packed ASCII text data. 
2. Define `toAsciiString :: AsciiText -> Effect String` function for this type.
3. Write a function which takes an `ArrayView Uint8`, checks if it is valid ASCII, then
   constructs an `AsciiText` if it is, failing otherwise.
4. Write tests to ensure correct functionality in 2 and 3.

# Task 2

1. Write a function that validates whether the `AsciiText` is correctly parenthesized. 
   Parentheses to take into account are `()` and `[]`. There can only be a single pair 
   of parentheses, i.e no other parentheses can be there for it to be valid. 
   Example of a valid parentheses: `A(bxe.)` or `[xyz]a`. 
   Example of invalid: `(abc()` or `abcd]x`
2. Define another function modifying the function from 1. Now the only valid pairs are
   the following: `(]`, `[)`. i.e. starting with `(` must end with `]` and `[` must end 
   with `)`.
   Example of a valid parentheses: `A(bxe.]` or `[xyz)a`.
   Example of a invalid: `A(bxe.)` or `[xyz))a`.
3. Define a new function that extends the functionality accepting any number of paired 
   parentheses.
4. Write tests to ensure correctness.
5. Describe 3 properties, one for each function from 1, 2, 3. Write tests to show the
   implementations do have those properties.

# Task 3

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
