Run Nix flake first and wait to get into a Nix shell:
```sh
nix develop
```

Then run the tests:
```sh
spago test
```

## Work Status

1. [x] Task 01 (4/4)
2. [x] Task 02 (4/5)
3. [x] Task 03 (1/5)

## Assignment

```markdown
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
```

## Report

### Task 01

This task is really straight forward.

### Task 02

I misread the problem statement for T2#1 and didn't implement the function.

However, the 3 properties *reflexivity*, *symmetry* and *transitive closure* all can be described with the same tests for the 3 functions.

First, we define a paring relation $R$ and a set of `Enclosure` symbols.

1. reflexivity
    - the 3 functions are not reflexive because for any `Enclosure` symbol $a$ there is another `Enclosure` symbol $a' \neq a$ satifying the pairing relation $aRa'$.
    - Example, `()` or `[]` or `[)` or `(]`.
2. symmetry
    - the 3 functions are not symmetric because the pairing relation $R$ is binary with a strict pair of left and right operand symbols $a$ and $a'$, where $a\neq a'$ and $aRa'\neq a'Ra$.
    - Example, `()` works but `)(` would not.
3. transitive closure
    - the 3 functions are not transitive because $a$ and $a'$ are strictly pairwise (by the symmetric property).

### Task 03

I didn't have enough time and the technical depth to complete this task, so I will write a few notes to address the questions.

I had the following initial assumptions:

1. the V8 engine that powers Nodejs is written in C++. It is the abstraction underlying JavaScript which PureScript compiles to.
2. I learned back in my first few semesters of college that for high frequency insertion, arrays/vectors is not efficient because there is too much dynamic allocation and copying of data.

Therefore, either a map or a linked list would be a better alternative. A map would have O(1) access. However, when I was reading the requirements, my mind immediately went to linked list because it is the recommended structure when working with sequencing data in PureScript. I thought I could map the `DataView` to string and then convert back to a view as needed. However, it turned out that there are a few problems with this idea.

1. I ran out of time.
2. There is a problem with *cache misses* due to heap allocation for linked lists.

I ended up abandoning this idea and just went for the buffer ops found in the `arraybuffer` package.

The simple tests I wrote work for the crude implementation of `insert`. However, I ended up struggling with setting up benchmarks for it. This is because I am not familiar enough with the PureScript idiomatic practices for benchmarking. I am also not yet familiar with using the `StateT` monad (and generally monad transformers) in order to implement a state machine to track a global buffer for a (theoretical) performance improvement in reasonable time.

As for the property that `insert` should have, I can make a guess based on the fact that an array buffer (which is a contiguous collection of memory cells) is a monoid. Because of this property, we can define a relation $R_{ins}$ that should have the transitive closure property at least, because inserting multiple contiguous "chunks" should produce the same result as inserting a single "chunk".
