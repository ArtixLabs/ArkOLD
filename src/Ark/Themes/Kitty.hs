{-# LANGUAGE LambdaCase #-}

module Ark.Themes.Kitty
  ( kittyThemeFile
  ) where

import Ark.Database.Themes (getKitty)
import Ark.Themes.Options (Themes(..))
import Control.Monad ((>=>))
import Data.List (isInfixOf)
import System.Directory (copyFile, doesFileExist)
import System.Environment (getEnv)

getConfig' :: IO String
getConfig' =
  getEnv "HOME" >>= \v ->
    return $ v <> "/.config/kitty/kitty.conf"

getConfig :: IO String
getConfig =
  getEnv "HOME" >>= \v ->
    return $ v <> "/.config/kitty/arkfile.conf"

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
        getConfig' >>= \v -> appendFile v $ "include " ++ x
    True -> return ()

kittyThemeFile :: Themes -> IO ()
kittyThemeFile theme =
  case theme of
    Onedark ->
      getConfig >>= \conf ->
        getKitty >>= \kitty ->
          copyFile (kitty ++ "onedark.conf") conf >>
          constructApplfile
    Nord ->
      getConfig >>= \conf ->
        getKitty >>= \kitty ->
          copyFile (kitty ++ "nord.conf") conf >>
          constructApplfile
