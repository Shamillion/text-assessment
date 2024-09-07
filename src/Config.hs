{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Config where

import Data.Aeson (FromJSON)
import Data.Yaml (decodeFileEither)
import GHC.Generics (Generic)
import System.Exit (die)

data Configuration = Configuration
  { url :: Url,
    serverPorts :: [ServerPort]
  }
  deriving (Show, Generic, FromJSON)

newtype Url = Url String
  deriving (Show, Generic, FromJSON)

newtype ServerPort = ServerPort Int
  deriving (Show, Generic, FromJSON)

readConfigFile :: IO Configuration
readConfigFile = do
  content <- decodeFileEither "config.yaml"
  case content of
    Right conf -> pure conf
    Left err -> do
      print err
      die "Error reading the configuration file! Check out config.yaml!"
