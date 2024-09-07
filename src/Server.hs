{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Server where

import Config
import Control.Concurrent (threadDelay)
import Control.Exception (try)
import Control.Monad.IO.Class (liftIO)
import Data
import Data.Aeson (eitherDecode)
import Lib
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

handler :: Url -> String -> Handler Result 
handler (Url scr) text = do
  eitherResp <- liftIO . try . httpLBS . parseRequest_ $ scr ++ text
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
    processingHttpError err = do
      _ <- liftIO $ do
        print (err :: HttpException)
        putStrLn "Connection Failure"
        putStrLn "Trying to set a connection... "
        threadDelay 1000000
      handler (Url scr) text
    processingDecodeError err = do
      _ <- liftIO $ do
        print err
        putStrLn "Decode error"
        putStrLn "Trying to set a connection... "
        threadDelay 1000000
      handler (Url scr) text   

--undefined

api :: Proxy API
api = Proxy

server :: Url -> Server API
server = handler

app :: Url -> Application
app = serve api . server
