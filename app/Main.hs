module Main (main) where

import Config (Configuration (serverPorts, url), ServerPort (ServerPort), readConfigFile)
import Control.Concurrent (forkIO)
import Lib (checkServerPortList)
import Network.Wai.Handler.Warp (run)
import Server (app)

main :: IO ()
main = do
  conf <- readConfigFile
  (firstPort : portLs) <- checkServerPortList $ serverPorts conf
  let src = url conf
      buildThread sp@(ServerPort port) = do
        putStrLn $ "Server on port " ++ show port ++ " is started."
        run port $ app src sp
  mapM_ (forkIO . buildThread) portLs
  buildThread firstPort
