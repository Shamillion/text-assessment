{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Server where

import Config (ServerPort (..), Url (..))
import Control.Concurrent (threadDelay)
import Control.Exception (try)
import Control.Monad.IO.Class (liftIO)
import Data (Result)
import Data.Aeson (eitherDecode)
import Lib (mkResult)
import Network.HTTP.Simple
  ( HttpException,
    getResponseBody,
    httpLBS,
    parseRequest_,
  )
import Servant (Application, Capture, Get, Handler, JSON, Proxy (..), Server, serve, (:>))

type API =
  Capture "text" String
    :> Get '[JSON] Result

handler :: Url -> ServerPort -> String -> Handler Result
handler ul@(Url src) sp@(ServerPort port) text = do
  eitherResp <- liftIO . try . httpLBS . parseRequest_ $ src ++ text
  _ <- liftIO $ print eitherResp
  case eitherResp of
    Left e -> processingHttpError e
    Right resp -> do
      let eitherObj = eitherDecode $ getResponseBody resp
      _ <- liftIO $ print eitherObj
      case eitherObj of
        Left e -> processingDecodeError e
        Right obj -> pure . mkResult $ obj
  where
    printMessage str = putStrLn $ mconcat ["On port ", show port, ": ", str]
    processingHttpError err = do
      _ <- liftIO $ do
        print (err :: HttpException)
        printMessage "Connection Failure"
        printMessage "Trying to set a connection... "
        threadDelay 1000000
      handler ul sp text
    processingDecodeError err = do
      _ <- liftIO $ do
        print err
        printMessage "Decode error"
        printMessage "Trying again... "
        threadDelay 1000000
      handler ul sp text

api :: Proxy API
api = Proxy

server :: Url -> ServerPort -> Server API
server = handler

app :: Url -> ServerPort -> Application
app src = serve api . server src 
