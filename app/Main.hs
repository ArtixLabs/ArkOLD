module Main where

import Ark.Database.Network (downloadFiles)
import Ark.Themes
  ( Themes(..)
  , alacrittyThemeFile
  , kittyThemeFile
  )

import Options.Applicative

data Args =
  Args
    { system :: Maybe Bool
    , program :: Maybe String
    , theme :: Maybe String
    , update :: Maybe Bool
    }

setSystemTheme :: Themes -> IO ()
setSystemTheme theme =
  case theme of
    Onedark ->
      alacrittyThemeFile Onedark >> kittyThemeFile Onedark
    Nord -> alacrittyThemeFile Nord >> kittyThemeFile Nord
    Undefined -> return ()

parseArgs :: Parser Args
parseArgs =
  Args <$>
  (optional $
   switch
     (long "system" <>
      short 's' <> help "Change the system's theme.")) <*>
  (optional $
   strOption
     (long "program" <>
      short 'p' <>
      metavar "TARGET" <> help "Change the program's theme.")) <*>
  (optional $
   strOption
     (long "theme" <>
      short 't' <>
      metavar "TARGET" <> help "Select the theme.")) <*>
  (optional $
   switch
     (long "update" <>
      short 'u' <>
      help "Downloads the needed configuration files."))

main :: IO ()
main = themeMGR =<< execParser opts
  where
    opts =
      info
        (parseArgs <**> helper)
        (fullDesc <> progDesc "Make your system beautiful!")

themeMGR :: Args -> IO ()
themeMGR (Args (Just False) (Just x) (Just str) (Just False)) =
  case x of
    "alacritty" ->
      alacrittyThemeFile $
      case str of
        "nord" -> Nord
        "onedark" -> Onedark
        _ -> Undefined
    "kitty" ->
      kittyThemeFile $
      case str of
        "nord" -> Nord
        "onedark" -> Onedark
        _ -> Undefined
themeMGR (Args (Just False) Nothing (Just str) (Just False)) =
  putStrLn $ "You need to specify a program, or use system."
themeMGR (Args (Just False) Nothing Nothing (Just True)) =
  downloadFiles
themeMGR (Args Nothing Nothing Nothing Nothing) =
  putStrLn $ "You need to specify some flags."
themeMGR (Args (Just True) Nothing (Just str) (Just False)) =
  case str of
    "nord" -> setSystemTheme Nord
    "onedark" -> setSystemTheme Onedark
    _ -> setSystemTheme Undefined
themeMGR Args {} =
  putStrLn $ "You need to specify some flags."
