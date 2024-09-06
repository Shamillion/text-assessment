module Lib where

import Data ( Errors(..), Result(..) )
import System.Exit (die)


mkResult :: Errors -> Result
mkResult (Errors ls) =
  let num = length ls
   in Result
        { grade = if num >= 5 then 0 else reverse [1 .. 5] !! num,
          errors = Errors ls
        }

checkList :: [a] -> IO [a]
checkList ls = if null ls
  then die "At least one port is required! Check out config.yaml!" 
  else pure ls   
