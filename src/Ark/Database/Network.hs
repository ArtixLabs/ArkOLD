{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}

module Ark.Database.Network
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
  [ ( "/.ark/alacritty/nord.yml"
    , "https://raw.githubusercontent.com/Cobalt-Inferno/ark/master/SOURCE/alacritty/nord.yml")
  , ( "/.ark/alacritty/onedark.yml"
    , "https://raw.githubusercontent.com/Cobalt-Inferno/ark/master/SOURCE/alacritty/onedark.yml")
  , ( "/.ark/kitty/nord.conf"
    , "https://raw.githubusercontent.com/Cobalt-Inferno/ark/master/SOURCE/kitty/nord.conf")
  , ( "/.ark/kitty/onedark.conf"
    , "https://raw.githubusercontent.com/Cobalt-Inferno/ark/master/SOURCE/kitty/onedark.conf")
  ]

curl :: Request -> FilePath -> IO ()
curl link path =
  httpLBS link >>= \r ->
    getEnv "HOME" >>= \home ->
      BL.writeFile (home ++ path) $ getResponseBody r

neededDirs = ["/.ark/alacritty", "/.ark/kitty"]

mkdir :: FilePath -> IO ()
mkdir path =
  getEnv "HOME" >>= \home ->
    doesDirectoryExist (home ++ path) >>= \case
      True -> return ()
      False -> createDirectory $ home ++ path

verifyDirs :: IO ()
verifyDirs =
  getEnv "HOME" >>= \home ->
    doesDirectoryExist (home ++ "/.ark") >>= \case
      True -> mapM_ mkdir neededDirs
      False ->
        createDirectory (home ++ "/.ark") >>
        mapM_ mkdir neededDirs

downloadFiles :: IO ()
downloadFiles =
  verifyDirs >> mapM_ (\(x, y) -> curl y x) files
