(* User-editable configuration for the Wolfram 15 behavioural validation. *)

Validation`$ValidationCases = <|
  "base" -> <|
    "CompareNotebookSideEffects" -> False,
    "EquivalentSymbolContextPatterns" -> {"base`"},
    "EquivalentSymbolContextSourcePaths" -> {{"src", "base.wl"}},
    (* The legacy dependency diagnostic is attached to Global`base, while the
       successful packaged load does not retain an equivalent stateful symbol. *)
    "IgnoreSymbolRegularExpressions" -> {"^(base|base`base)$"},
    "Original" -> <|
      "Type" -> "Notebook",
      "Path" -> {"legacy-original", "base.nb"},
      "EvaluationMode" -> "InitializationOnly",
      "TimeConstraintSeconds" -> 180
    |>,
    "Restructured" -> <|
      "Type" -> "Script",
      "Path" -> {"src", "LoadProject.wl"},
      "ProjectCase" -> "base",
      "NotebookDirectory" -> {"notebooks"},
      "TimeConstraintSeconds" -> 180
    |>
  |>,

  "physics-general" -> <|
    "CompareNotebookSideEffects" -> False,
    "Original" -> <|
      "Type" -> "Notebook",
      "Path" -> {"legacy-original", "physics-general.nb"},
      "EvaluationMode" -> "InitializationOnly"
    |>,
    "Restructured" -> <|
      "Type" -> "Notebook",
      "Path" -> {"notebooks", "physics-general.nb"},
      "EvaluationMode" -> "InitializationOnly"
    |>
  |>,

  "statDataAnal" -> <|
    "CompareNotebookSideEffects" -> False,
    (* These are randomly generated demonstration samples. Their exact values
       differ between clean kernels even when the defining code is identical. *)
    "IgnoreSymbolRegularExpressions" -> {
      "^(ests|statDataAnal`ests|thisDataHisto|statDataAnal`thisDataHisto)$"
    },
    "Original" -> <|
      "Type" -> "Notebook",
      "Path" -> {"legacy-original", "statDataAnal.nb"},
      "EvaluationMode" -> "InitializationOnly"
    |>,
    "Restructured" -> <|
      "Type" -> "Notebook",
      "Path" -> {"notebooks", "statDataAnal.nb"},
      "EvaluationMode" -> "InitializationOnly"
    |>
  |>,

  "inputDataForRICH" -> <|
    "CompareNotebookSideEffects" -> False,
    "Original" -> <|
      "Type" -> "Notebook",
      "Path" -> {"legacy-original", "inputDataForRICH.nb"},
      "EvaluationMode" -> "InitializationOnly"
    |>,
    "Restructured" -> <|
      "Type" -> "Notebook",
      "Path" -> {"notebooks", "inputDataForRICH.nb"},
      "EvaluationMode" -> "InitializationOnly"
    |>
  |>,

  "calculator-reboot" -> <|
    "CompareNotebookSideEffects" -> False,
    (* These aliases intentionally describe the notebook currently being
       evaluated, so the legacy and restructured paths cannot be identical. *)
    "IgnoreSymbolRegularExpressions" -> {
      "^(nbFileBaseName|nbFileDirectory|myNotebookInit`nbFileBaseName|myNotebookInit`nbFileDirectory)$"
    },
    "Original" -> <|
      "Type" -> "Notebook",
      "Path" -> {"legacy-original", "calculator-reboot.nb"},
      "CutoffMarker" -> "CALCULATOR BODY",
      "DropCellsContaining" -> {"LHCb-optics.m"},
      "EvaluationMode" -> "InitializationOnly",
      "TimeConstraintSeconds" -> 300
    |>,
    "Restructured" -> <|
      "Type" -> "Notebook",
      "Path" -> {"notebooks", "calculator-reboot.nb"},
      "CutoffMarker" -> "CALCULATOR BODY",
      "EvaluationMode" -> "InitializationOnly",
      "TimeConstraintSeconds" -> 300
    |>
  |>,

  "RICH-source" -> <|
    "CompareNotebookSideEffects" -> False,
    (* Notebook parsing created the complete public RICH symbol set in
       Global`; the regenerated source explicitly and correctly owns that
       same set in rich`. Discover the actual names after evaluation so local
       pattern/module symbols used inside definitions are normalized too. *)
    (* Native Save As source preserves dependency calls while explicitly
       qualifying the few RICH-owned names that collide with dependencies.
       Record those ownership decisions before dynamic canonicalization. *)
    "EquivalentSymbolContexts" -> <|
      "rich`" -> {"debugPrint", "debugPrintEnabledFlag"},
      "base`" -> {"nf", "nf1", "nf2", "nf3", "nfPad", "nfpm2", "window"},
      "statDataAnal`" -> {"descriptivestatistics", "displayHistoStats"}
    |>,
    "EquivalentSymbolContextPatterns" -> {"base`", "rich`"},
    "EquivalentSymbolContextSourcePaths" -> {
      {"src", "RICH.wl"}, {"src", "base.wl"}
    },
    "IgnoreSymbolRegularExpressions" -> {
      "^(symbolsNew|symbolsSave|rich`symbolsNew|rich`symbolsSave)$"
    },
    "Original" -> <|
      "Type" -> "Notebook",
      "Path" -> {"legacy-original", "RICH.nb"},
      "EvaluationMode" -> "InitializationOnly"
    |>,
    "Restructured" -> <|
      "Type" -> "Script",
      "Path" -> {"src", "LoadProject.wl"},
      "ProjectCase" -> "RICH-source",
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
      "ProjectCase" -> "CellStyleDataRules-source",
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

  (* The original notebooks pre-create these unqualified symbols in Global`
     before loading myNotebookInit`. The restructured package correctly owns
     them in myNotebookInit`. Canonicalize only this audited migration list;
     all other context changes remain visible as comparison differences. *)
  "EquivalentSymbolContexts" -> <|
    "myNotebookInit`" -> {
      "applySettings", "availableSettings", "bannerLine", "bigBanner",
      "cellsByStyle", "cellStylesEditorPalette", "cellStylesScannerPalette",
      "checkProtection", "clearLoadLog", "deleteAllEmptyCellsInNotebook",
      "endEvalPrintOut", "ensureNotebookSaved", "exportGraphicsToPDF",
      "initialContexts", "listInitializationCells", "loadMyFile",
      "killStop", "loadNeeds", "loadSavedLog", "manageMyStyleNotebook",
      "markInputCellsAsInitialization", "midBanner", "miniBanner", "nb",
      "nbFileBaseName", "nbFileDirectory", "nbFileName", "nb$",
      "notebookPathInfo", "prettyPrintedCellStyleNumber", "printA", "printD", "printMsgCell",
      "removeSettings", "safeNotebookBaseName", "safeNotebookDirectory",
      "safeNotebookFileName", "saveAsPdfAllOutputCells",
      "saveAsPngAllOutputCells", "saveLoadLog", "saveNotebookTextCopy",
      "saveVersionedCopy", "selectInitializationCells", "setProtection",
      "showDiagnostics", "showIt", "smallBanner", "summarizeLoads",
      "superClearSet", "timeBanner", "timeStamp",
      "timeStamp$", "validStylesheetReport", "checkNewCreatedSymbols",
      "showContextInfo"
    },
    "base`" -> {"versionTAG"}
  |>,

  (* Automatically generated symbols are intentionally excluded because their
     numeric suffixes can change between clean kernels. *)
  "IgnoreSymbolRegularExpressions" -> {
    "\\$[0-9]+$",
    "^Global`\\$.*",
    "^Validation`.*",
    "killStop",

    (* Runtime bookkeeping depends on timestamps, load order, and the exact
       validation notebook. It is diagnostic state, not project behaviour. *)
    "^(initialContexts|Global`initialContexts|myNotebookInit`initialContexts)$",
    "^myNotebookInit`Private`checkNewCreatedSymbolsSnapshot$",
    "^myNotebookInit`Private`\\$LoadLog$",
    "^myNotebookInit`Private`\\$settingActions$",

    (* These compatibility aliases resolve the current evaluation notebook.
       Their definitions/values can contain the disposable validation
       NotebookObject or its generated filename, not project behavior. *)
    "^(nb|nbFileName|myNotebookInit`nb|myNotebookInit`nbFileName)$",

    (* The legacy Global`versionTAG conflates myNotebookInit` usage metadata
       with base`'s assigned version. The packaged project correctly keeps
       those as two distinct symbols, so no one-to-one alias is valid. *)
    "^versionTAG$"
  },

  "OutputPreviewCharacters" -> 240,
  "MaximumDifferencesShown" -> 80
|>;
