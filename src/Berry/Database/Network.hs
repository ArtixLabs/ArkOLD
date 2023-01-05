{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}

module Berry.Database.Network
  ( downloadFiles
  ) where

import Control.Monad (forM_)
import qualified Data.ByteString.Lazy as BL
import Network.HTTP.Simple
import System.Directory
  ( createDirectory
  , doesDirectoryExist
  )
import System.Environment (getEnv)

files =
  [ ( "/.berry/alacritty/nord.yml"
    , "https://raw.githubusercontent.com/Cobalt-Inferno/berry/master/SOURCE/alacritty/nord.yml")
  , ( "/.berry/alacritty/onedark.yml"
    , "https://raw.githubusercontent.com/Cobalt-Inferno/berry/master/SOURCE/alacritty/onedark.yml")
  , ( "/.berry/kitty/nord.conf"
    , "https://raw.githubusercontent.com/Cobalt-Inferno/berry/master/SOURCE/kitty/nord.conf")
  , ( "/.berry/kitty/onedark.conf"
    , "https://raw.githubusercontent.com/Cobalt-Inferno/berry/master/SOURCE/kitty/onedark.conf")
  ]

curl :: Request -> FilePath -> IO ()
curl link path =
  httpLBS link >>= \r ->
    getEnv "HOME" >>= \home ->
      BL.writeFile (home ++ path) $ getResponseBody r

neededDirs = ["/.berry/alacritty", "/.berry/kitty"]

mkdir :: FilePath -> IO ()
mkdir path =
  getEnv "HOME" >>= \home ->
    doesDirectoryExist (home ++ path) >>= \case
      True -> return ()
      False -> createDirectory $ home ++ path

verifyDirs :: IO ()
verifyDirs =
  getEnv "HOME" >>= \home ->
    doesDirectoryExist (home ++ "/.berry") >>= \case
      True -> mapM_ mkdir neededDirs
      False ->
        createDirectory (home ++ "/.berry") >>
        mapM_ mkdir neededDirs

downloadFiles :: IO ()
downloadFiles =
  verifyDirs >> mapM_ (\(x, y) -> curl y x) files
