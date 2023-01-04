module Berry.Themes.Alacritty
  ( AlacrittyThemes(..)
  ) where

import Berry.Database.Themes (getAlacritty)
import System.Directory (copyFile)
import System.Environment (getEnv)

data AlacrittyThemes
  = Onedark
  | Nord
  deriving (Show, Eq)

getConfig :: IO String
getConfig =
  getEnv $ "HOME" ++ "/.config/alacritty/berryfile.yml"

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
