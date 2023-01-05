{-# LANGUAGE LambdaCase #-}

module Ark.Themes.Alacritty
  ( alacrittyThemeFile
  ) where

import Ark.Database.Themes (getAlacritty)
import Ark.Themes.Options (Themes(..))
import Control.Monad ((>=>))
import Data.List (isInfixOf)
import System.Directory (copyFile, doesFileExist)
import System.Environment (getEnv)

getConfig' :: IO String
getConfig' =
  getEnv "HOME" >>= \v ->
    return $ v <> "/.config/alacritty/alacritty.yml"

getConfig :: IO String
getConfig =
  getEnv "HOME" >>= \v ->
    return $ v <> "/.config/alacritty/arkfile.yml"

alacrittyThemeFile :: Themes -> IO ()
alacrittyThemeFile theme =
  case theme of
    Onedark ->
      getConfig >>= \conf ->
        getAlacritty >>= \alacritty ->
          copyFile (alacritty ++ "onedark.yml") conf >>
          constructApplfile
    Nord ->
      getConfig >>= \conf ->
        getAlacritty >>= \alacritty ->
          copyFile (alacritty ++ "nord.yml") conf >>
          constructApplfile

xInfix :: IO Bool
xInfix =
  getConfig >>=
  (doesFileExist >=>
   (\case
      True ->
        getConfig' >>= readFile >>= \x ->
          return $ isInfixOf "arkfile" x
      False -> return False))

constructApplfile :: IO ()
constructApplfile =
  xInfix >>= \case
    False ->
      getConfig >>= \x ->
        getConfig' >>= \v ->
          appendFile v $ "import: \n - " ++ x
    True -> return ()
