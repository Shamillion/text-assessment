{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Server where

import Config
import Data
import Data.Aeson (eitherDecode)
import Lib
import Network.HTTP.Simple
    ( parseRequest_, getResponseBody, httpLBS )
import Servant (Capture, Get, Handler, JSON, (:>), Server, Proxy (..), Application, serve)
import Control.Monad.IO.Class (liftIO)

type API =
  Capture "text" String
    :> Get '[JSON] (Either String Result)

handler :: Configuration -> String -> Handler (Either String Result)
handler conf text = do
  let req = parseRequest_ $ url conf ++ text
  ans <- eitherDecode . getResponseBody <$> httpLBS req
  _ <- liftIO $ print ans 
  pure $ mkResult <$> ans

api :: Proxy API
api = Proxy

server :: Configuration -> Server API
server = handler 

app :: Configuration -> Application
app = serve api . server  
