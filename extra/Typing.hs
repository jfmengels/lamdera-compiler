{-# LANGUAGE OverloadedStrings #-}

module Typing (annotate) where

import Text.Read (readMaybe)
import qualified Text.PrettyPrint.ANSI.Leijen as P
import qualified Data.List as List

import Terminal hiding (args)
import Terminal.Helpers
import qualified Develop -- has Develop.run for live
import qualified Lamdera.CLI.Annotate


annotate :: Terminal.Command
annotate =
  let
    summary =
      "Lookup and print out the type annotation for the given file:expression."

    details =
      "The project should compile successfully before this command works consistently."

    example =
      reflow
        "It will attempt to load the artifacts cache for the given filename, and then \
        \ attempt to load the inferred annotation and display it as text."

    args =
      oneOf
        [ require2 Lamdera.CLI.Annotate.Args elmFile Lamdera.CLI.Annotate.expressionName
        ]
  in
  Terminal.Command "annotate" (Common summary) details example args noFlags Lamdera.CLI.Annotate.run

-- HELPERS


reflow :: String -> P.Doc
reflow string =
  P.fillSep $ map P.text $ words string
