{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}

module Ark.Util.Shell
  ( detectShell
  , appendToShellConfig
  ) where

import Data.Function ((&))
import Data.Text (Text, pack, splitOn, unpack)
import qualified Data.Text.IO as T
import System.Directory (doesFileExist)
import System.Environment (getEnv)
import System.IO (appendFile, writeFile)

data Shells
  = Zsh
  | Bash
  | Fish
  | UndefinedShell
  deriving (Show, Eq)

detectShell :: IO Shells
detectShell =
  getEnv "SHELL" >>= \x ->
    splitOn "/" (pack x) & \shell ->
      case last shell of
        "zsh" -> return Zsh
        "bash" -> return Bash
        "fish" -> return Fish
        _ -> return UndefinedShell

appendToShellConfig :: Text -> Shells -> IO ()
appendToShellConfig str Zsh =
  getEnv "HOME" >>= \home ->
    doesFileExist (home <> "/.zshrc") >>= \case
      True -> appendFile (home ++ "/.zshrc") (unpack str)
      False -> writeFile (home ++ "/.zshrc") (unpack str)
appendToShellConfig str Bash =
  getEnv "HOME" >>= \home ->
    doesFileExist (home <> "/.bashrc") >>= \case
      True -> appendFile (home ++ "/.bashrc") (unpack str)
      False -> writeFile (home ++ "/.bashrc") (unpack str)
appendToShellConfig str Fish =
  getEnv "HOME" >>= \home ->
    doesFileExist (home <> "/.config/fish/config.fish") >>= \case
      True ->
        appendFile
          (home ++ "/.config/fish/config.fish")
          (unpack str)
      False ->
        writeFile
          (home ++ "/.config/fish/config.fish")
          (unpack str)
