module Main (main) where
import Network.HTTP.Simple (httpLBS, parseRequest_)
import Config (Configuration(url), readConfigFile, serverPort)

import Lib
import Network.Wai.Handler.Warp (run)
import Server (app)



main :: IO ()
main = do
    conf <- readConfigFile
    let port = serverPort conf
    putStrLn "Server is started."
    run port $ app conf 
