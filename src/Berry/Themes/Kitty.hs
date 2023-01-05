{-# LANGUAGE LambdaCase #-}

module Berry.Themes.Kitty
  ( KittyThemes(..)
  ) where

import System.Directory (copyFile, doesFileExist)
import System.Environment (getEnv)

data KittyThemes
  = Onedark
  | Nord
  | Undefined
  deriving (Show, Eq)

getConfig' :: IO String
getConfig' =
  getEnv "HOME" >>= \v ->
    return $ v <> "/.config/kitty/kitty.conf"

getConfig :: IO String
getConfig =
  getEnv "HOME" >>= \v ->
    return $ v <> "/.config/kitty/berryfile.conf"

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
        getConfig' >>= \v -> appendFile v $ "include " ++ x
    True -> return ()

kittyThemeFile :: KittyThemes -> IO ()
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
