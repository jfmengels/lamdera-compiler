{-# LANGUAGE ForeignFunctionInterface #-}
module WasmMain where

import qualified Data.ByteString.Builder
import qualified Data.ByteString.Lazy
import qualified Data.ByteString.Lazy.UTF8 -- from utf8-string
import qualified Data.ByteString.UTF8 -- from utf8-string
import Debug.Trace
import qualified GHC.Wasm.Prim as Wasm -- See https://gitlab.haskell.org/ghc/ghc/-/commit/317a915bc46fee2c824d595b0d618057bf7fbbf1#82b5a034883a3ede9540d6423738da627660f860
import Json.Encode ((==>))
import qualified Json.Encode
import ToStringHelper
import qualified Ulm.Repl

main :: IO ()
main = mempty

foreign export javascript "check"
  checkJs :: Wasm.JSString -> IO Wasm.JSString

checkJs :: Wasm.JSString -> IO Wasm.JSString
checkJs jsString =
  fmap encodeJson $
    Json.Encode.object
      [ "type" ==> Json.Encode.chars "some-type"
      , "name" ==> Json.Encode.chars "some-name"
      ]

encodeJson :: Json.Encode.Value -> Wasm.JSString
encodeJson value =
  builderToJsString $ Json.Encode.encode value

builderToJsString :: Data.ByteString.Builder.Builder -> Wasm.JSString
builderToJsString builder =
  let lazyStr :: Data.ByteString.Lazy.LazyByteString
      lazyStr = Data.ByteString.Builder.toLazyByteString builder
      str :: String
      str = Data.ByteString.Lazy.UTF8.toString lazyStr
   in Wasm.toJSString str