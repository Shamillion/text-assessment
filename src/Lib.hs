module Lib where

import Data ( Errors(..), Result(..) )

mkResult :: Errors -> Result
mkResult (Errors ls) =
  let num = length ls
   in Result
        { grade = if num >= 5 then 0 else reverse [1 .. 5] !! num,
          errors = Errors ls
        }
