module Main where

import Berry.Themes.Alacritty
  ( AlacrittyThemes(..)
  , setThemeFile
  )
import Options.Applicative

data Args =
  Args
    { system :: Maybe Bool
    , program :: Maybe String
    , theme :: String
    , update :: Maybe Bool
    }

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
  strOption
    (long "theme" <>
     short 't' <>
     metavar "TARGET" <> help "Select the theme.") <*>
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
themeMGR (Args (Just False) (Just x) str (Just False)) =
  case x of
    "alacritty" ->
      setThemeFile $
      case str of
        "nord" -> Nord
        "onedark" -> Onedark
        _ -> Undefined
themeMGR (Args (Just False) Nothing str (Just False)) =
  putStrLn $ "You need to specify a program, or use system."
