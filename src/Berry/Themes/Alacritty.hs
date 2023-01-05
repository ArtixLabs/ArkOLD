{-# LANGUAGE LambdaCase #-}

module Berry.Themes.Alacritty
  ( AlacrittyThemes(..)
  , setThemeFile
  ) where

import Berry.Database.Themes (getAlacritty)
import Control.Monad ((>=>))
import Data.List (isInfixOf)
import System.Directory (copyFile, doesFileExist)
import System.Environment (getEnv)

data AlacrittyThemes
  = Onedark
  | Nord
  | Undefined
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
          return $ isInfixOf "berryfile" x
      False -> return False))

constructApplfile :: IO ()
constructApplfile =
  xInfix >>= \case
    False ->
      getConfig >>= \x ->
        getConfig' >>= \v ->
          appendFile v $ "import: \n - " ++ x
    True -> return ()
