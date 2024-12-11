module Filesystem where

import Control.Exception (IOException, try)
import System.Directory (createDirectory, doesDirectoryExist, removeDirectoryRecursive)

newtype TryIO a = TryIO (IO (Either IOException a))

instance Functor TryIO where
  fmap f (TryIO action) = TryIO $ do
    result <- action
    return $ case result of
      Left e -> Left e
      Right x -> Right (f x)

instance Applicative TryIO where
  pure x = TryIO (return (Right x))
  TryIO f <*> TryIO x = TryIO $ do
    mf <- f
    mx <- x
    return $ case mf of
      Left e -> Left e
      Right f' -> case mx of
        Left e -> Left e
        Right x' -> Right (f' x')

instance Monad TryIO where
  return = pure
  TryIO action >>= f = TryIO $ do
    result <- action
    case result of
      Left e -> return (Left e)
      Right x -> let TryIO nextAction = f x in nextAction

-- Create a directory
createDir :: FilePath -> TryIO ()
createDir path = TryIO $ try (createDirectory path)

-- Test if the directory exists
doesDirExist :: FilePath -> TryIO Bool
doesDirExist path = TryIO $ try (doesDirectoryExist path)

-- Delete a directory
deleteDir :: FilePath -> TryIO ()
deleteDir path = TryIO $ try (removeDirectoryRecursive path)

-- Read a file
readFileContent :: FilePath -> TryIO String
readFileContent path = TryIO $ try (readFile path)

-- Write to a file
writeFileContent :: FilePath -> String -> TryIO ()
writeFileContent path content = TryIO $ try (writeFile path content)