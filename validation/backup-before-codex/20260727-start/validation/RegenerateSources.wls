(* Regenerate notebook-derived .wl sources using held Wolfram expressions.
   Arguments: PROJECT_ROOT and optional comma-separated case names. *)

Begin["Validation`SourceGeneration`Private`"];

ClearAll[
  flushOutput, exitWithCode, fail, commandLineArguments, truncateAtMarker,
  cellStyle, explicitInitializationCellQ, explicitlyNonEvaluatableQ,
  initializationCodeCells, heldExpressionsForCell, heldExpressionText,
  generatedFileExpressionCount, regenerateOne, main
];

flushOutput[] := Scan[(Quiet@Check[Flush[#], Null]) &, Flatten[{$Output}]];

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
  arguments = If[MissingQ[switchPosition], {},
    Drop[commandArguments, First[switchPosition] + 1]
  ];
  If[Length[arguments] >= expected, Take[arguments, -expected], arguments]
];

truncateAtMarker[expr_, marker_String] := Module[{found = False, result},
  result = expr /. Notebook[cells_List, opts___] :> Module[{position},
    position = FirstPosition[
      cells,
      item_ /; StringContainsQ[
        ToString[item, InputForm, PageWidth -> Infinity], marker
      ],
      Missing["NotFound"],
      {1}
    ];
    If[MissingQ[position], Notebook[cells, opts],
      found = True;
      Notebook[Take[cells, First[position]], opts]
    ]
  ];
  If[TrueQ[found], result,
    Failure["CutoffMarkerNotFound", <|"Marker" -> marker|>]
  ]
];

cellStyle[cell_Cell] := Replace[
  cell,
  Cell[_, style_String, ___] :> style,
  {0}
];

explicitInitializationCellQ[cell_Cell] :=
  Cases[
    List @@ cell,
    HoldPattern[InitializationCell -> True] |
      HoldPattern[InitializationCell :> True],
    {1}
  ] =!= {};

explicitlyNonEvaluatableQ[cell_Cell] :=
  Cases[
    List @@ cell,
    HoldPattern[Evaluatable -> False] |
      HoldPattern[Evaluatable :> False],
    {1}
  ] =!= {};

initializationCodeCells[notebookExpression_] := Module[{codeCells},
  codeCells = Cases[
    notebookExpression,
    cell : Cell[_, ("Input" | "Code"), ___] :> cell,
    Infinity
  ];
  Select[
    codeCells,
    explicitInitializationCellQ[#] && ! explicitlyNonEvaluatableQ[#] &
  ]
];

(* NotebookImport without an explicit form returns Input-cell expressions held
   in HoldComplete. This preserves the actual expression boundaries in cells
   that contain several independently evaluatable rows. *)
heldExpressionsForCell[cell_Cell] := Module[{style, imported},
  style = cellStyle[cell];
  imported = Quiet@Check[
    NotebookImport[Notebook[{cell}], style],
    $Failed
  ];
  If[imported === $Failed, Return[$Failed]];
  Cases[Flatten[{imported}], held_HoldComplete :> held, {1}]
];

(* Convert HoldComplete[expr] to InputForm text without evaluating expr. *)
heldExpressionText[held_HoldComplete] := Module[
  {text, prefix = "HoldComplete[", start},
  text = ToString[held, InputForm, PageWidth -> Infinity];
  start = StringLength[prefix] + 1;
  If[
    StringStartsQ[text, prefix] && StringEndsQ[text, "]"],
    StringTake[text, {start, -2}],
    $Failed
  ]
];

(* Parse every generated expression without evaluating it. Read[..., Hold[Expression]]
   is used so that package initialization code is never executed during this check. *)
generatedFileExpressionCount[path_String] := Module[
  {stream, expressions},
  stream = Quiet@Check[OpenRead[path], $Failed];
  If[stream === $Failed,
    Return[Failure["GeneratedFileOpenFailed", <|"Path" -> path|>]]
  ];
  expressions = Quiet@Check[
    ReadList[stream, Hold[Expression]],
    $Failed
  ];
  Quiet@Check[Close[stream], Null];
  If[
    expressions === $Failed || MemberQ[expressions, $Failed],
    Failure["GeneratedFileSyntaxError", <|"Path" -> path|>],
    Length[expressions]
  ]
];

regenerateOne[
  projectRoot_String,
  sourceRelative_List,
  destinationRelative_List,
  cutoff_: None
] := UsingFrontEnd@Module[
  {sourcePath, destinationPath, sourceNotebook, expression, cells,
   heldByCell, failedCells, textByCell, failedTexts, blocks, header,
   parsedExpressionCount},

  sourcePath = FileNameJoin[Prepend[sourceRelative, projectRoot]];
  destinationPath = FileNameJoin[Prepend[destinationRelative, projectRoot]];
  If[! FileExistsQ[sourcePath],
    Return[Failure["MissingSourceNotebook", <|"Path" -> sourcePath|>]]
  ];

  WriteString[$Output, "Regenerating " <> destinationPath <> "\n"];
  flushOutput[];

  sourceNotebook = Quiet@Check[NotebookOpen[sourcePath, Visible -> False], $Failed];
  If[sourceNotebook === $Failed,
    Return[Failure["NotebookOpenFailed", <|"Path" -> sourcePath|>]]
  ];
  expression = NotebookGet[sourceNotebook];
  NotebookClose[sourceNotebook, Interactive -> False];

  If[StringQ[cutoff],
    expression = truncateAtMarker[expression, cutoff];
    If[FailureQ[expression], Return[expression]]
  ];

  cells = initializationCodeCells[expression];
  WriteString[$Output,
    "  selected initialization Input/Code cells: " <>
      ToString[Length[cells]] <> "\n"
  ];
  flushOutput[];
  If[cells === {},
    Return[Failure["NoInitializationCodeCells", <|
      "Path" -> sourcePath,
      "InputOrCodeCellCount" -> Length@Cases[
        expression, Cell[_, ("Input" | "Code"), ___], Infinity
      ],
      "InitializationCellTrueCount" -> Length@Cases[
        expression,
        HoldPattern[InitializationCell -> True] |
          HoldPattern[InitializationCell :> True],
        Infinity
      ]
    |>]]
  ];

  heldByCell = heldExpressionsForCell /@ cells;
  failedCells = Flatten@Position[heldByCell, $Failed];
  If[failedCells =!= {},
    Return[Failure["HeldExpressionImportFailed", <|
      "Path" -> sourcePath,
      "FailedCellIndices" -> failedCells
    |>]]
  ];

  textByCell = (heldExpressionText /@ #) & /@ heldByCell;
  failedTexts = Position[textByCell, $Failed];
  If[failedTexts =!= {},
    Return[Failure["HeldExpressionSerializationFailed", <|
      "Path" -> sourcePath,
      "FailedCellExpressionIndices" -> failedTexts
    |>]]
  ];

  blocks = Flatten@MapIndexed[
    Function[{cellTexts, cellIndex},
      MapIndexed[
        Function[{sourceText, expressionIndex},
          "(* ---- initialization cell " <> ToString[First[cellIndex]] <>
          ", expression " <> ToString[First[expressionIndex]] <> " ---- *)\n" <>
          sourceText
        ],
        cellTexts
      ]
    ],
    textByCell
  ];

  If[blocks === {},
    Return[Failure["NoHeldExpressionsImported", <|"Path" -> sourcePath|>]]
  ];

  header =
    "(* Regenerated from " <> FileNameTake[sourcePath] <>
    " using NotebookImport without a text conversion. *)\n" <>
    "(* Each source expression was imported under HoldComplete, serialized in InputForm, and syntax-checked without evaluation. *)\n\n";

  If[! DirectoryQ[DirectoryName[destinationPath]],
    CreateDirectory[
      DirectoryName[destinationPath],
      CreateIntermediateDirectories -> True
    ]
  ];
  Export[destinationPath, header <> StringRiffle[blocks, "\n\n"], "Text"];

  parsedExpressionCount = generatedFileExpressionCount[destinationPath];
  If[FailureQ[parsedExpressionCount], Return[parsedExpressionCount]];

  WriteString[$Output,
    "  imported held expressions: " <> ToString[Length[blocks]] <> "\n" <>
    "  parsed expressions in generated file: " <>
      ToString[parsedExpressionCount] <> "\n"
  ];
  flushOutput[];

  <|
    "Source" -> sourcePath,
    "Destination" -> destinationPath,
    "CellCount" -> Length[cells],
    "ExpressionCount" -> Length[blocks],
    "ParsedExpressionCount" -> parsedExpressionCount
  |>
];

main[] := Module[
  {arguments, projectRoot, requestedCases, mappings, selectedMappings,
   needsAllSources, results, failures},

  arguments = commandLineArguments[2];
  If[Length[arguments] < 1,
    fail["Expected PROJECT_ROOT and optional comma-separated cases"]
  ];
  projectRoot = ExpandFileName[First[arguments]];
  requestedCases = If[Length[arguments] >= 2,
    DeleteCases[StringSplit[Last[arguments], ","], ""],
    {}
  ];

  mappings = {
    <|"Key" -> "CellStyleDataRules-source", "Source" -> {"legacy-original", "CellStyleDataRules.nb"}, "Destination" -> {"src", "CellStyleDataRules.wl"}, "Cutoff" -> None|>,
    <|"Key" -> "base", "Source" -> {"legacy-original", "base.nb"}, "Destination" -> {"src", "base.wl"}, "Cutoff" -> None|>,
    <|"Key" -> "physics-general", "Source" -> {"legacy-original", "physics-general.nb"}, "Destination" -> {"src", "physics-general.wl"}, "Cutoff" -> None|>,
    <|"Key" -> "statDataAnal", "Source" -> {"legacy-original", "statDataAnal.nb"}, "Destination" -> {"src", "statDataAnal.wl"}, "Cutoff" -> None|>,
    <|"Key" -> "inputDataForRICH", "Source" -> {"legacy-original", "inputDataForRICH.nb"}, "Destination" -> {"src", "inputDataForRICH.wl"}, "Cutoff" -> None|>,
    <|"Key" -> "calculator-reboot", "Source" -> {"legacy-original", "calculator-reboot.nb"}, "Destination" -> {"src", "calculator-reboot.wl"}, "Cutoff" -> "CALCULATOR BODY"|>,
    <|"Key" -> "RICH-source", "Source" -> {"legacy-original", "RICH.nb"}, "Destination" -> {"src", "RICH.wl"}, "Cutoff" -> None|>
  };

  needsAllSources = requestedCases === {} || AnyTrue[requestedCases, # =!= "base" &];
  selectedMappings = If[
    needsAllSources,
    mappings,
    Select[
      mappings,
      MemberQ[{"base", "CellStyleDataRules-source"}, Lookup[#, "Key"]] &
    ]
  ];

  results = regenerateOne[
      projectRoot,
      Lookup[#, "Source"],
      Lookup[#, "Destination"],
      Lookup[#, "Cutoff", None]
    ] & /@ selectedMappings;

  failures = Cases[results, _Failure];
  If[failures =!= {},
    Scan[
      WriteString[$Output, "SOURCE GENERATION FAILURE: " <>
        ToString[#, InputForm] <> "\n"] &,
      failures
    ];
    exitWithCode[5]
  ];

  Scan[
    WriteString[$Output,
      "  " <> FileNameTake[Lookup[#, "Destination"]] <> ": " <>
      ToString[Lookup[#, "CellCount"]] <> " cells, " <>
      ToString[Lookup[#, "ExpressionCount"]] <> " expressions\n"] &,
    results
  ];
  WriteString[$Output, "Source regeneration completed successfully.\n"];
  exitWithCode[0]
];

main[];
End[];
