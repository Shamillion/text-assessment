module Lib where

import Config (ServerPort)
import Data (Errors (..), Result (..))
import System.Exit (die)

mkResult :: Errors -> Result
mkResult (Errors ls) =
  let num = length ls
   in Result
        { grade = if num >= 5 then 0 else reverse [1 .. 5] !! num,
          errors = Errors ls
        }

-- Checking the list of ports for the presence of elements
checkServerPortList :: [ServerPort] -> IO [ServerPort]
checkServerPortList ls =
  if null ls
    then die "At least one port is required! Check out config.yaml!"
    else pure ls
