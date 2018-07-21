{-# LANGUAGE TemplateHaskell #-}
module Main where

import Control.Lens

data FooBar = Foo { _x :: [Int], _y :: String } deriving (Show)

makeLenses ''FooBar

foo = Foo [1, 2, 3] "hello world"

main :: IO ()
main = putStrLn $ foo ^. y
