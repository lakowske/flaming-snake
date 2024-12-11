{-# LANGUAGE LambdaCase #-}

module Main where

import Filesystem (TryIO (TryIO), createDir, deleteDir, doesDirExist, readFileContent, writeFileContent)

doSomeIO :: TryIO String
doSomeIO = do
  -- Check if the directory exists
  doesDirExist "test" >>= \case
    True -> deleteDir "test"
    False -> return ()

  -- Create a directory
  createDir "test"

  -- Write to a file
  writeFileContent "test/file.txt" "Hello, world!"

  -- Read a file
  content <- readFileContent "test/file.txt"
  let fileContent = content

  -- Delete the directory
  deleteDir "test"

  return fileContent

runTryIO :: TryIO a -> IO (Either String a)
runTryIO (TryIO action) = do
  result <- action
  return $ case result of
    Left e -> Left (show e)
    Right x -> Right x

main :: IO ()
main = do
  result <- runTryIO doSomeIO
  case result of
    Left e -> putStrLn $ "An error occurred: " ++ show e
    Right _ -> putStrLn "Success!"