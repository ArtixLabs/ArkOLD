{-# LANGUAGE LambdaCase #-}

module Ark.Util.Archives
  ( unzip'
  ) where

import Ark.Database.Network (curl, mkdir)
import System.Directory (doesFileExist)
import System.FilePath.Posix (takeExtensions)
import System.Process (callCommand)

verifyFiles :: String -> IO Bool
verifyFiles = doesFileExist

unzip' :: FilePath -> FilePath -> IO ()
unzip' zipfile npath =
  mapM verifyFiles ["/usr/bin/unzip", "/bin/unzip"] >>= \x ->
    if or x
      then doesFileExist zipfile >>= \case
             True ->
               callCommand $
               "unzip " ++ zipfile ++ " -d " ++ npath
             False ->
               putStrLn $
               "File: '" ++ zipfile ++ "' does not exist."
      else putStrLn
             "You need to download the 'unzip' program."

tar' :: FilePath -> FilePath -> IO ()
tar' zipfile npath =
  mapM verifyFiles ["/usr/bin/tar", "/bin/tar"] >>= \x ->
    if or x
      then doesFileExist zipfile >>= \case
             True ->
               case (takeExtensions zipfile) of
                 ".tar.gz" ->
                   callCommand $
                   "tar xvzf " ++ zipfile ++ " -C " ++ npath
                 ".tar" ->
                   callCommand $
                   "tar xvf " ++ zipfile ++ " -C " ++ npath
             False ->
               putStrLn $
               "File: '" ++ zipfile ++ "' does not exist."
      else putStrLn
             "You need to download the 'unzip' program."
