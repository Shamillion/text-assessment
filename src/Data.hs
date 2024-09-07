{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module Data where

import Data.Aeson
  ( FromJSON,
    ToJSON,
  )
import GHC.Generics (Generic)

data Result = Result
  { grade :: Int,
    errors :: Errors
  }
  deriving (Show, Generic, ToJSON)

newtype Errors = Errors [Error]
  deriving (Show, Generic, FromJSON, ToJSON)

newtype Error = Error
  {word :: String}
  deriving (Show, Generic, FromJSON, ToJSON)
