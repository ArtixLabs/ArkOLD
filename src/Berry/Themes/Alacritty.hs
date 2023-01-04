{-# LANGUAGE LambdaCase #-}

module Berry.Themes.Alacritty
  ( AlacrittyThemes(..)
  , xInfix
  ) where

import Berry.Database.Themes (getAlacritty)
import Data.List (isInfixOf)
import System.Directory (copyFile, doesFileExist)
import System.Environment (getEnv)

data AlacrittyThemes
  = Onedark
  | Nord
  deriving (Show, Eq)

getConfig' :: IO String
getConfig' =
  getEnv "HOME" >>= \v ->
    return $ v <> "/.config/alacritty/alacritty.yml"

getConfig :: IO String
getConfig =
  getEnv "HOME" >>= \v ->
    return $ v <> "/.config/alacritty/berryfile.yml"

setThemeFile :: AlacrittyThemes -> IO ()
setThemeFile theme =
  case theme of
    Onedark ->
      getConfig >>= \conf ->
        getAlacritty >>= \alacritty ->
          copyFile (alacritty ++ "onedark.yml") conf
    Nord ->
      getConfig >>= \conf ->
        getAlacritty >>= \alacritty ->
          copyFile (alacritty ++ "nord.yml") conf

xInfix :: IO Bool
xInfix =
  getConfig >>= \conf ->
    doesFileExist conf >>= \case
      True ->
        getConfig >>= readFile >>= \x ->
          return $ isInfixOf "berryfile" x
      False -> return False

text :: IO ()
text =
  xInfix >>= \case
    False ->
      getConfig >>= \x ->
        getConfig' >>= \v -> appendFile v $ "import: " ++ x
