module Tasks.Task02 where

import Prelude

{- NOTE:
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
-}

{- TODO:
  1. [ ] define a folding action to check that the correctly paired parentheses reduce to 0.
      - [ ] implement for `()` first.
      - [ ] incorporate `[]`.
      - [ ] write tests.
  2. [ ] define a new function the extends the implemtation to check for 2 cases `(]` and `[)`.:w
      - [ ] write tests.
-}

--isCorrectlyParenthesized =

