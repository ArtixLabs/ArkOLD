module Berry.Database.Themes
  ( getAlacritty
  ) where

import System.Directory
import System.Environment (getEnv)

getAlacritty :: IO String
getAlacritty =
  getEnv "HOME" >>= \home ->
    return $ home ++ "/.berry/alacritty/"

downloadFiles :: IO ()
downloadFiles = do

