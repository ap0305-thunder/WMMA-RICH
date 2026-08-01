(* User-editable configuration for the Wolfram 15 behavioural validation. *)

Validation`$ValidationCases = <|
  "base" -> <|
    "CompareNotebookSideEffects" -> False,
    "Original" -> <|
      "Type" -> "Notebook",
      "Path" -> {"legacy-original", "base.nb"},
      "EvaluationMode" -> "InitializationOnly",
      "TimeConstraintSeconds" -> 180
    |>,
    "Restructured" -> <|
      "Type" -> "Script",
      "Path" -> {"src", "base.wl"},
      "NotebookDirectory" -> {"notebooks"},
      "TimeConstraintSeconds" -> 180
    |>
  |>,

  "physics-general" -> <|
    "Original" -> <|
      "Type" -> "Notebook",
      "Path" -> {"legacy-original", "physics-general.nb"}
    |>,
    "Restructured" -> <|
      "Type" -> "Notebook",
      "Path" -> {"notebooks", "physics-general.nb"}
    |>
  |>,

  "statDataAnal" -> <|
    "Original" -> <|
      "Type" -> "Notebook",
      "Path" -> {"legacy-original", "statDataAnal.nb"}
    |>,
    "Restructured" -> <|
      "Type" -> "Notebook",
      "Path" -> {"notebooks", "statDataAnal.nb"}
    |>
  |>,

  "inputDataForRICH" -> <|
    "Original" -> <|
      "Type" -> "Notebook",
      "Path" -> {"legacy-original", "inputDataForRICH.nb"}
    |>,
    "Restructured" -> <|
      "Type" -> "Notebook",
      "Path" -> {"notebooks", "inputDataForRICH.nb"}
    |>
  |>,

  "calculator-reboot" -> <|
    "Original" -> <|
      "Type" -> "Notebook",
      "Path" -> {"legacy-original", "calculator-reboot.nb"},
      "CutoffMarker" -> "CALCULATOR BODY",
      "DropCellsContaining" -> {"LHCb-optics.m"}
    |>,
    "Restructured" -> <|
      "Type" -> "Notebook",
      "Path" -> {"notebooks", "calculator-reboot.nb"},
      "CutoffMarker" -> "CALCULATOR BODY"
    |>
  |>,

  "RICH-source" -> <|
    "CompareNotebookSideEffects" -> False,
    "Original" -> <|
      "Type" -> "Notebook",
      "Path" -> {"legacy-original", "RICH.nb"},
      "EvaluationMode" -> "InitializationOnly"
    |>,
    "Restructured" -> <|
      "Type" -> "Script",
      "Path" -> {"src", "LoadProject.wl"},
      "NotebookDirectory" -> {"notebooks"}
    |>
  |>,

  "CellStyleDataRules-source" -> <|
    "CompareNotebookSideEffects" -> False,
    "Original" -> <|
      "Type" -> "Notebook",
      "Path" -> {"legacy-original", "CellStyleDataRules.nb"},
      "EvaluationMode" -> "InitializationOnly"
    |>,
    "Restructured" -> <|
      "Type" -> "Script",
      "Path" -> {"src", "LoadProject.wl"},
      "NotebookDirectory" -> {"notebooks"}
    |>
  |>
|>;

Validation`$ValidationOptions = <|
  (* Evaluate each notebook once. EvaluationElements -> All already includes
     initialization cells; a separate initialization pass would evaluate them
     twice and can trigger non-idempotent notebook setup code. *)
  "RunInitializationFirst" -> False,

  (* Default per-case safety limit. Individual targets may override it. *)
  "TimeConstraintSeconds" -> 900,

  (* Evaluated copies are useful for visual inspection but may be large. *)
  "SaveEvaluatedNotebooks" -> True,

  (* Contexts whose symbol definitions and assigned values are compared. *)
  "CaptureContexts" -> {
    "Global`",
    "myNotebookInit`", "myNotebookInit`Private`",
    "base`", "base`Private`",
    "statDataAnal`", "statDataAnal`Private`",
    "rich`", "rich`Private`",
    "calculator`", "calculator`Private`"
  },

  (* Automatically generated symbols are intentionally excluded because their
     numeric suffixes can change between clean kernels. *)
  "IgnoreSymbolRegularExpressions" -> {
    "\\$[0-9]+$",
    "^Global`\\$.*",
    "^Validation`.*",
    "killStop"
  },

  "OutputPreviewCharacters" -> 240,
  "MaximumDifferencesShown" -> 80
|>;
