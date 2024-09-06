{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Server where

import Config
import Data
import Data.Aeson (eitherDecode)
import Lib
import Network.HTTP.Simple
    ( parseRequest_, getResponseBody, httpLBS, HttpException )
import Servant (Capture, Get, Handler, JSON, (:>), Server, Proxy (..), Application, serve)
import Control.Monad.IO.Class (liftIO)
import Control.Concurrent (threadDelay)

type API =
  Capture "text" String
    :> Get '[JSON] (Either String Result)           -- <-- Change to Result

handler :: Url -> String -> Handler (Either String Result)  -- <-- try-catch
handler (Url scr) text = do
  resp <- httpLBS . parseRequest_ $ scr ++ text
  let ans = eitherDecode $ getResponseBody resp
  _ <- liftIO $ print ans 
  pure $ mkResult <$> ans
  -- where
  --   errorProcessing err  = do
  --     _ <- liftIO $ do
  --                     print (err :: HttpException)
  --                     putStrLn "Connection Failure"
  --                     putStrLn "Trying to set a connection... "
  --     threadDelay 1000000
  --     handler (Url scr) text

api :: Proxy API
api = Proxy

server :: Url -> Server API
server = handler 

app :: Url -> Application
app = serve api . server  
