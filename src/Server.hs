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
  case eitherResp of
    Left e -> do
      let err = show (e :: HttpException)
      processingError err "Connection Failure" "Trying to set a connection... "
    Right resp -> do
      let eitherObj = eitherDecode $ getResponseBody resp
      case eitherObj of
        Left e -> processingError e "Decode error" "Trying again... "
        Right obj -> do
          _ <- liftIO $ printMessage "The request was processed successfully."
          pure . mkResult $ obj
  where
    printMessage str = putStrLn $ mconcat ["On port ", show port, ": ", str]
    processingError err msg1 msg2 = do
      _ <- liftIO $ do
        mapM_ printMessage [err, msg1, msg2]
        threadDelay 1000000
      handler ul sp text

api :: Proxy API
api = Proxy

server :: Url -> ServerPort -> Server API
server = handler

app :: Url -> ServerPort -> Application
app src = serve api . server src
