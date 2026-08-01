(* Run one validation case in one fresh Wolfram process.
   Arguments: PROJECT_ROOT MODE CASE_NAME
   MODE is original or restructured. *)

Begin["Validation`Private`"];

ClearAll[flushOutput, exitWithCode, fail, ensureDirectory, logStep, normalizeText, stableHash, preview,
  stripResultCells, dropCellsContaining, truncateAtMarker,
  importCellText, cellTextRecords, timeConstrainedEvaluate,
  symbolRecordHeld, symbolRecord, ignoredSymbolQ, captureSymbols,
  runNotebookTarget, sourceExpressionCount, runScriptTarget, jsonSafe, commandLineArguments, main];

flushOutput[] := Scan[
  (Quiet@Check[Flush[#], Null]) &,
  Flatten[{$Output}]
];

exitWithCode[code_Integer] := (
  WriteString[$Output, "__WOLFRAM_EXIT_CODE__=" <> ToString[code] <> "\n"];
  flushOutput[];
  Exit[code]
);

fail[message_String, code_Integer : 2] := (
  WriteString[$Output, "ERROR: " <> message <> "\n"];
  exitWithCode[code]
);

commandLineArguments[expected_Integer] := Module[
  {scriptArguments, commandArguments, switchPosition, arguments},

  scriptArguments = If[ListQ[$ScriptCommandLine], $ScriptCommandLine, {}];
  If[Length[scriptArguments] >= expected,
    Return[Take[scriptArguments, -expected]]
  ];

  commandArguments = If[ListQ[$CommandLine], $CommandLine, {}];
  switchPosition = FirstPosition[
    commandArguments,
    item_String /; MemberQ[{"-script", "-file"}, ToLowerCase[item]],
    Missing["NotFound"]
  ];

  arguments = If[MissingQ[switchPosition],
    {},
    Drop[commandArguments, First[switchPosition] + 1]
  ];

  If[Length[arguments] >= expected,
    Take[arguments, -expected],
    arguments
  ]
];

ensureDirectory[path_String] := If[! DirectoryQ[path],
  CreateDirectory[path, CreateIntermediateDirectories -> True]
];

logStep[text_String] := (
  WriteString[$Output,
    "[" <> DateString[{"Hour", ":", "Minute", ":", "Second"}] <> "] " <>
      text <> "\n"
  ];
  flushOutput[]
);

normalizeText[text_String, projectRoot_String] := Module[
  {rootForward, rootEscaped, result},
  rootForward = StringReplace[projectRoot, "\\" -> "/"];
  rootEscaped = StringReplace[projectRoot, "\\" -> "\\\\"];
  result = StringReplace[text, {
    projectRoot -> "<PROJECT_ROOT>",
    rootForward -> "<PROJECT_ROOT>",
    rootEscaped -> "<PROJECT_ROOT>",
    RegularExpression["\\$[0-9]+"] -> "$N",
    RegularExpression["\\.__validation_[A-Za-z0-9_-]+\\.nb"] ->
      ".__validation_NOTEBOOK.nb"
  }];
  result
];

stableHash[expr_, projectRoot_String] := Module[{text},
  text = normalizeText[
    ToString[expr, InputForm, PageWidth -> Infinity],
    projectRoot
  ];
  IntegerString[Hash[text, "SHA256"], 16, 64]
];

preview[text_String, count_Integer] := StringTake[
  StringReplace[StringTrim[text], WhitespaceCharacter .. -> " "],
  UpTo[count]
];

stripResultCells[expr_] := DeleteCases[
  expr,
  Cell[_, style_String, ___] /; MemberQ[
    {"Output", "Message", "MSG", "Print", "Echo"}, style
  ],
  Infinity
];

dropCellsContaining[expr_, fragments_List] := If[fragments === {},
  expr,
  DeleteCases[
    expr,
    cell_Cell /; AnyTrue[
      fragments,
      StringContainsQ[ToString[cell, InputForm, PageWidth -> Infinity], #] &
    ],
    Infinity
  ]
];

truncateAtMarker[expr_, marker_String] := Module[
  {found = False, result},
  result = expr /. Notebook[cells_List, opts___] :> Module[
    {position},
    position = FirstPosition[
      cells,
      item_ /; StringContainsQ[
        ToString[item, InputForm, PageWidth -> Infinity], marker
      ],
      Missing["NotFound"],
      {1}
    ];
    If[MissingQ[position],
      Notebook[cells, opts],
      found = True;
      Notebook[Take[cells, First[position]], opts]
    ]
  ];
  If[! TrueQ[found],
    Failure["CutoffMarkerNotFound", <|"Marker" -> marker|>],
    result
  ]
];

importCellText[notebook_, style_String] := Module[{value},
  value = Quiet@Check[
    NotebookImport[notebook, style -> "InputText"],
    {}
  ];
  Which[
    value === $Failed, {},
    StringQ[value], {value},
    ListQ[value], Cases[Flatten[value], _String],
    True, {}
  ]
];

cellTextRecords[texts_List, projectRoot_String, previewCount_Integer] :=
  MapIndexed[
    <|
      "Index" -> First[#2],
      "Hash" -> stableHash[#1, projectRoot],
      "Preview" -> preview[normalizeText[#1, projectRoot], previewCount]
    |> &,
    texts
  ];

timeConstrainedEvaluate[expression_, seconds_] := If[
  seconds === Infinity,
  CheckAbort[expression, $Aborted],
  TimeConstrained[CheckAbort[expression, $Aborted], seconds, $Aborted]
];

SetAttributes[symbolRecordHeld, HoldAllComplete];
symbolRecordHeld[name_String, symbol_, projectRoot_String] := Module[
  {own, down, sub, up, nvalues, format, defaults, attributes, options,
   messages, codeData},
  own = OwnValues[symbol];
  down = DownValues[symbol];
  sub = SubValues[symbol];
  up = UpValues[symbol];
  nvalues = NValues[symbol];
  format = FormatValues[symbol];
  defaults = DefaultValues[symbol];
  attributes = Sort[Attributes[symbol]];
  options = Options[symbol];
  messages = Messages[symbol];
  codeData = {down, sub, up, nvalues, format, defaults, attributes, options, messages};
  <|
    "Name" -> name,
    "OwnValueHash" -> stableHash[own, projectRoot],
    "CodeHash" -> stableHash[codeData, projectRoot],
    "OwnValueByteCount" -> ByteCount[own],
    "CodeByteCount" -> ByteCount[codeData],
    "OwnValueCount" -> Length[own],
    "DownValueCount" -> Length[down],
    "SubValueCount" -> Length[sub],
    "UpValueCount" -> Length[up],
    "NValueCount" -> Length[nvalues],
    "FormatValueCount" -> Length[format],
    "DefaultValueCount" -> Length[defaults],
    "AttributeCount" -> Length[attributes],
    "OptionCount" -> Length[options],
    "MessageCount" -> Length[messages]
  |>
];

symbolRecord[name_String, projectRoot_String] := ToExpression[
  name,
  InputForm,
  Function[symbol, symbolRecordHeld[name, symbol, projectRoot], HoldAllComplete]
];

ignoredSymbolQ[name_String, regularExpressions_List] := AnyTrue[
  regularExpressions,
  StringContainsQ[name, RegularExpression[#]] &
];

captureSymbols[contexts_List, ignorePatterns_List, projectRoot_String] := Module[
  {names, records},
  names = DeleteDuplicates@Flatten[Names[# <> "*"] & /@ contexts];
  names = Select[names, ! ignoredSymbolQ[#, ignorePatterns] &];
  records = Quiet@Check[symbolRecord[#, projectRoot], $Failed] & /@ names;
  records = Cases[records, _Association];
  Association@Map[(#["Name"] -> #) &, records]
];

runNotebookTarget[
  targetPath_String,
  targetSpec_Association,
  mode_String,
  caseName_String,
  projectRoot_String,
  resultRoot_String,
  options_Association
] := UsingFrontEnd@Module[
  {sourceNotebook, expression, cutoff, drops, temporaryPath, notebook,
   runInitialization, evaluationMode, timeConstraint, saveEvaluated, previewCount,
   initializationResult = Null, finalResult = Null, status = "Success",
   outputTexts, messageTexts, printTexts, inputTexts, codeTexts,
   evaluatedPath, record, oldDirectory},

  logStep["Opening source notebook"];
  sourceNotebook = Quiet@Check[
    NotebookOpen[targetPath, Visible -> False],
    $Failed
  ];
  If[sourceNotebook === $Failed,
    Return[Failure["NotebookOpenFailed", <|"Path" -> targetPath|>]]
  ];

  logStep["Reading notebook expression"];
  expression = NotebookGet[sourceNotebook];
  NotebookClose[sourceNotebook, Interactive -> False];
  expression = stripResultCells[expression];

  drops = Lookup[targetSpec, "DropCellsContaining", {}];
  expression = dropCellsContaining[expression, drops];

  cutoff = Lookup[targetSpec, "CutoffMarker", None];
  If[StringQ[cutoff],
    expression = truncateAtMarker[expression, cutoff];
    If[FailureQ[expression], Return[expression]]
  ];

  temporaryPath = FileNameJoin[{
    DirectoryName[targetPath],
    ".__validation_" <> mode <> "_" <> caseName <> "_" <>
      ToString[$ProcessID] <> ".nb"
  }];

  logStep["Creating temporary validation notebook"];
  notebook = NotebookPut[expression, Visible -> False];
  Quiet@Check[NotebookSave[notebook, temporaryPath], Null];
  If[! FileExistsQ[temporaryPath],
    NotebookClose[notebook, Interactive -> False];
    Return[Failure["TemporaryNotebookSaveFailed", <|"Path" -> temporaryPath|>]]
  ];

  runInitialization = TrueQ[Lookup[options, "RunInitializationFirst", True]];
  evaluationMode = Lookup[targetSpec, "EvaluationMode", "InitializationThenAll"];
  timeConstraint = Lookup[targetSpec, "TimeConstraintSeconds",
    Lookup[options, "TimeConstraintSeconds", Infinity]
  ];
  saveEvaluated = TrueQ[Lookup[options, "SaveEvaluatedNotebooks", True]];
  previewCount = Lookup[options, "OutputPreviewCharacters", 240];
  oldDirectory = Directory[];

  Internal`WithLocalSettings[
    SetDirectory[DirectoryName[targetPath]],

    Switch[evaluationMode,
      "InitializationOnly",
        logStep["Evaluating initialization cells"];
        initializationResult = timeConstrainedEvaluate[
          NotebookEvaluate[
            notebook,
            EvaluationElements -> "InitializationCell",
            InsertResults -> True
          ],
          timeConstraint
        ];
        finalResult = initializationResult;
        status = Which[
          initializationResult === $Aborted, "AbortedDuringInitialization",
          initializationResult === $Failed, "ReturnedFailed",
          True, "Success"
        ],

      "AllOnly",
        logStep["Evaluating all evaluatable cells"];
        finalResult = timeConstrainedEvaluate[
          NotebookEvaluate[
            notebook,
            EvaluationElements -> All,
            InsertResults -> True
          ],
          timeConstraint
        ];
        status = Which[
          finalResult === $Aborted, "AbortedDuringFullEvaluation",
          finalResult === $Failed, "ReturnedFailed",
          True, "Success"
        ],

      _,
        If[runInitialization,
          logStep["Evaluating initialization cells"];
          initializationResult = timeConstrainedEvaluate[
            NotebookEvaluate[
              notebook,
              EvaluationElements -> "InitializationCell",
              InsertResults -> True
            ],
            timeConstraint
          ];
          status = Which[
            initializationResult === $Aborted, "AbortedDuringInitialization",
            initializationResult === $Failed, "ReturnedFailed",
            True, "Success"
          ]
        ];

        If[status === "Success",
          logStep["Evaluating all evaluatable cells"];
          finalResult = timeConstrainedEvaluate[
            NotebookEvaluate[
              notebook,
              EvaluationElements -> All,
              InsertResults -> True
            ],
            timeConstraint
          ];
          status = Which[
            finalResult === $Aborted, "AbortedDuringFullEvaluation",
            finalResult === $Failed, "ReturnedFailed",
            True, "Success"
          ]
        ]
    ],

    SetDirectory[oldDirectory]
  ];

  logStep["Collecting generated notebook cells"];
  outputTexts = importCellText[notebook, "Output"];
  messageTexts = Join[
    importCellText[notebook, "Message"],
    importCellText[notebook, "MSG"]
  ];
  printTexts = Join[
    importCellText[notebook, "Print"],
    importCellText[notebook, "Echo"]
  ];
  inputTexts = importCellText[notebook, "Input"];
  codeTexts = importCellText[notebook, "Code"];

  evaluatedPath = FileNameJoin[{
    resultRoot,
    "evaluated-notebooks",
    mode,
    caseName <> ".nb"
  }];
  If[saveEvaluated,
    ensureDirectory[DirectoryName[evaluatedPath]];
    Quiet@Check[NotebookSave[notebook, evaluatedPath], Null]
  ];

  record = <|
    "EvaluationStatus" -> status,
    "InitializationResultHash" -> stableHash[initializationResult, projectRoot],
    "FinalResultHash" -> stableHash[finalResult, projectRoot],
    "InputCellCount" -> Length[inputTexts],
    "CodeCellCount" -> Length[codeTexts],
    "NotebookOutputs" -> cellTextRecords[outputTexts, projectRoot, previewCount],
    "NotebookMessages" -> cellTextRecords[messageTexts, projectRoot, previewCount],
    "NotebookPrints" -> cellTextRecords[printTexts, projectRoot, previewCount],
    "EvaluatedNotebook" -> If[saveEvaluated,
      FileNameJoin[{"evaluated-notebooks", mode, caseName <> ".nb"}],
      None
    ]
  |>;

  NotebookClose[notebook, Interactive -> False];
  If[FileExistsQ[temporaryPath], Quiet@DeleteFile[temporaryPath]];
  record
];

sourceExpressionCount[path_String] := Module[{stream, expressions},
  stream = Quiet@Check[OpenRead[path], $Failed];
  If[stream === $Failed,
    Return[Failure["SourceOpenFailed", <|"Path" -> path|>]]
  ];
  expressions = Quiet@Check[ReadList[stream, Hold[Expression]], $Failed];
  Quiet@Check[Close[stream], Null];
  If[
    expressions === $Failed || MemberQ[expressions, $Failed],
    Failure["SourceSyntaxError", <|"Path" -> path|>],
    Length[expressions]
  ]
];

runScriptTarget[
  targetPath_String,
  targetSpec_Association,
  projectRoot_String,
  resultRoot_String,
  options_Association
] := UsingFrontEnd@Module[
  {workingDirectory, oldDirectory, timeConstraint, result, status,
   sourcePath, extraPathEntries, projectCase, record, syntaxCount},

  workingDirectory = FileNameJoin[
    Prepend[
      Lookup[
        targetSpec,
        "WorkingDirectory",
        Lookup[targetSpec, "NotebookDirectory", {"notebooks"}]
      ],
      projectRoot
    ]
  ];
  If[! DirectoryQ[workingDirectory],
    CreateDirectory[workingDirectory, CreateIntermediateDirectories -> True]
  ];

  sourcePath = DirectoryName[targetPath];
  extraPathEntries = DeleteDuplicates@Select[
    {
      sourcePath,
      FileNameJoin[{projectRoot, "src"}],
      FileNameJoin[{projectRoot, "legacy-original"}],
      workingDirectory
    },
    DirectoryQ
  ];

  oldDirectory = Directory[];
  timeConstraint = Lookup[targetSpec, "TimeConstraintSeconds",
    Lookup[options, "TimeConstraintSeconds", Infinity]
  ];
  projectCase = Lookup[targetSpec, "ProjectCase", None];

  syntaxCount = sourceExpressionCount[targetPath];
  If[FailureQ[syntaxCount],
    logStep["Source preflight failed: the generated file is not valid Wolfram syntax"];
    Return[<|
      "EvaluationStatus" -> "SourceSyntaxError",
      "Failure" -> ToString[syntaxCount, InputForm],
      "SourceExpressionCount" -> 0,
      "InitializationResultHash" -> stableHash[Null, projectRoot],
      "FinalResultHash" -> stableHash[$Failed, projectRoot],
      "InputCellCount" -> 0,
      "CodeCellCount" -> 0,
      "NotebookOutputs" -> {},
      "NotebookMessages" -> {},
      "NotebookPrints" -> {},
      "EvaluatedNotebook" -> Null
    |>]
  ];
  logStep["Source preflight parsed " <> ToString[syntaxCount] <> " held expressions"];
  logStep["Evaluating source directly in the validation kernel"];
  result = Internal`WithLocalSettings[
    SetDirectory[workingDirectory],
    Block[
      {
        $Path = DeleteDuplicates@Join[extraPathEntries, $Path],
        $Context = "Global`",
        $ContextPath = DeleteDuplicates@Join[{"Global`"}, $ContextPath],
        Global`$RICHProjectCase = projectCase
      },
      timeConstrainedEvaluate[Get[targetPath], timeConstraint]
    ],
    SetDirectory[oldDirectory]
  ];

  status = Which[
    result === $Aborted, "AbortedDuringScriptEvaluation",
    result === $Failed, "ReturnedFailed",
    True, "Success"
  ];

  record = <|
    "EvaluationStatus" -> status,
    "SourceExpressionCount" -> syntaxCount,
    "InitializationResultHash" -> stableHash[Null, projectRoot],
    "FinalResultHash" -> stableHash[result, projectRoot],
    "InputCellCount" -> 0,
    "CodeCellCount" -> 0,
    "NotebookOutputs" -> {},
    "NotebookMessages" -> {},
    "NotebookPrints" -> {},
    "EvaluatedNotebook" -> Null
  |>;

  record
];

jsonSafe[expression_] := expression /. {
  Infinity -> "Infinity",
  Indeterminate -> "Indeterminate",
  DirectedInfinity[___] -> "DirectedInfinity",
  None -> Null,
  missing_Missing :> ToString[missing, InputForm],
  failure_Failure :> ToString[failure, InputForm]
};

main[] := Module[
  {arguments, projectRoot, mode, caseName, configPath, cases, options,
   caseSpec, modeKey, targetSpec, targetType, targetPath, resultRoot,
   rawDirectory, contexts, ignorePatterns, executionRecord, symbols,
   finalRecord, wxfPath, jsonPath, startTime},

  arguments = commandLineArguments[3];
  If[Length[arguments] =!= 3,
    WriteString[$Output,
      "Command-line diagnostics:\n" <>
      "  $ScriptCommandLine = " <> ToString[$ScriptCommandLine, InputForm] <> "\n" <>
      "  $CommandLine = " <> ToString[$CommandLine, InputForm] <> "\n"
    ];
    fail["Expected arguments: PROJECT_ROOT MODE CASE_NAME"]
  ];
  {projectRoot, mode, caseName} = arguments;
  projectRoot = ExpandFileName[projectRoot];
  If[! MemberQ[{"original", "restructured"}, mode],
    fail["MODE must be original or restructured"]
  ];

  configPath = FileNameJoin[{projectRoot, "validation", "ValidationConfig.wl"}];
  If[! FileExistsQ[configPath], fail["Missing configuration: " <> configPath]];
  Get[configPath];
  cases = Validation`$ValidationCases;
  options = Validation`$ValidationOptions;

  caseSpec = Lookup[cases, caseName, Missing["UnknownCase"]];
  If[MissingQ[caseSpec], fail["Unknown validation case: " <> caseName]];
  modeKey = If[mode === "original", "Original", "Restructured"];
  targetSpec = Lookup[caseSpec, modeKey, Missing["MissingTarget"]];
  If[MissingQ[targetSpec],
    fail["No " <> modeKey <> " target for case " <> caseName]
  ];

  targetType = Lookup[targetSpec, "Type", "Notebook"];
  targetPath = FileNameJoin[Prepend[Lookup[targetSpec, "Path"], projectRoot]];
  If[! FileExistsQ[targetPath], fail["Target does not exist: " <> targetPath]];

  resultRoot = FileNameJoin[{projectRoot, "validation", "results", "current"}];
  rawDirectory = FileNameJoin[{resultRoot, "raw", mode}];
  ensureDirectory[rawDirectory];
  startTime = AbsoluteTime[];

  WriteString[$Output,
    "Running " <> mode <> " / " <> caseName <> "\n" <>
    "Target: " <> targetPath <> "\n"
  ];
  flushOutput[];

  executionRecord = Switch[targetType,
    "Notebook",
      runNotebookTarget[
        targetPath, targetSpec, mode, caseName,
        projectRoot, resultRoot, options
      ],
    "Script",
      runScriptTarget[targetPath, targetSpec, projectRoot, resultRoot, options],
    _,
      Failure["UnsupportedTargetType", <|"Type" -> targetType|>]
  ];

  If[FailureQ[executionRecord],
    executionRecord = <|
      "EvaluationStatus" -> "HarnessFailure",
      "Failure" -> ToString[executionRecord, InputForm],
      "NotebookOutputs" -> {},
      "NotebookMessages" -> {},
      "NotebookPrints" -> {}
    |>
  ];

  logStep["Capturing symbol state"];
  contexts = Lookup[options, "CaptureContexts", {"Global`"}];
  ignorePatterns = Lookup[options, "IgnoreSymbolRegularExpressions", {}];
  symbols = captureSymbols[contexts, ignorePatterns, projectRoot];

  finalRecord = Join[
    <|
      "SchemaVersion" -> 1,
      "Case" -> caseName,
      "Mode" -> mode,
      "TargetType" -> targetType,
      "TargetFileName" -> FileNameTake[targetPath],
      "CompareNotebookSideEffects" -> TrueQ[
        Lookup[caseSpec, "CompareNotebookSideEffects", True]
      ],
      "StartedAt" -> DateString[],
      "ElapsedSeconds" -> N[AbsoluteTime[] - startTime],
      "WolframVersion" -> $Version,
      "SystemID" -> $SystemID,
      "MachinePrecision" -> $MachinePrecision
    |>,
    executionRecord,
    <|
      "CapturedContexts" -> contexts,
      "CapturedSymbolCount" -> Length[symbols],
      "Symbols" -> symbols
    |>
  ];

  wxfPath = FileNameJoin[{rawDirectory, caseName <> ".wxf"}];
  jsonPath = FileNameJoin[{rawDirectory, caseName <> ".json"}];
  logStep["Writing result files"];
  Export[wxfPath, finalRecord, "WXF"];
  Quiet@Check[Export[jsonPath, jsonSafe[finalRecord], "RawJSON"], Null];

  WriteString[$Output,
    "Status: " <> ToString[Lookup[finalRecord, "EvaluationStatus"]] <> "\n" <>
    "Captured symbols: " <> ToString[Length[symbols]] <> "\n" <>
    "Result: " <> wxfPath <> "\n"
  ];
  flushOutput[];

  exitWithCode[If[Lookup[finalRecord, "EvaluationStatus"] === "Success", 0, 3]]
];

main[];

End[];
