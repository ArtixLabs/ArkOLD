module Berry.Database.Themes
  ( getAlacritty
  , getKitty
  ) where

import System.Directory
import System.Environment (getEnv)

getAlacritty :: IO String
getAlacritty =
  getEnv "HOME" >>= \home ->
    return $ home ++ "/.berry/alacritty/"

getKitty :: IO String
getKitty =
  getEnv "HOME" >>= \home ->
    return $ home ++ "/.berry/kitty/"
