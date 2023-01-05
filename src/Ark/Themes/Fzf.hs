{-# LANGUAGE OverloadedStrings #-}

module Ark.Themes.Fzf
  ( fzfSetTheme
  ) where

import Ark.Themes.Options (Themes(..))
import Ark.Util.Shell (appendToShellConfig, detectShell)
import Data.Text (Text)

fzfSetTheme :: Themes -> IO ()
fzfSetTheme Onedark =
  detectShell >>= \shell ->
    appendToShellConfig
      "export FZF_DEFAULT_OPTS='--color=fg:#abb2bf,bg:#21252b,hl:#61afef --color=fg+:#abb2bf,bg+:#21252b,hl+:#61afef --color=info:#e5c07b,prompt:#e06c75,pointer:#e06c75 --color=marker:#98c379,spinner:#c678dd,header:#56b6c2'\n"
      shell
fzfSetTheme Nord =
  detectShell >>= \shell ->
    appendToShellConfig
      "export FZF_DEFAULT_OPTS='--color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1 --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1 --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'\n"
      shell
fzfSetTheme Undefined = return ()
