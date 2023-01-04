module Berry.Database.Themes
  ( getAlacritty
  ) where

import System.Environment (getEnv)

getAlacritty :: IO String
getAlacritty =
  getEnv "HOME" >>= \home ->
    return $ home ++ "/.berry/alacritty/"
