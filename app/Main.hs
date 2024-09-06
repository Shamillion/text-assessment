module Main (main) where

import Config (Configuration(url, serverPorts), readConfigFile, )

import Lib
import Network.Wai.Handler.Warp (run)
import Server (app)
import Control.Concurrent (forkIO)



main :: IO ()
main = do
    conf <- readConfigFile
    (firstPort : portLs) <- checkList $ serverPorts conf
    let scr = url conf
        buildThread port = do
            putStrLn $ "Server on port " ++ show port ++ " is started."
            run port $ app scr
    mapM_ (forkIO . buildThread) portLs
    buildThread firstPort
    
     
