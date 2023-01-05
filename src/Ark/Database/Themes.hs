module Ark.Database.Themes
  ( getAlacritty
  , getKitty
  ) where

import System.Directory
import System.Environment (getEnv)

getAlacritty :: IO String
getAlacritty =
  getEnv "HOME" >>= \home ->
    return $ home ++ "/.ark/alacritty/"

getKitty :: IO String
getKitty =
  getEnv "HOME" >>= \home -> return $ home ++ "/.ark/kitty/"
