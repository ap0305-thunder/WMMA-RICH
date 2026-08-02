(* Regenerate notebook-derived .wl sources using held Wolfram expressions.
   Arguments: PROJECT_ROOT and optional comma-separated case names. *)

Begin["Validation`SourceGeneration`Private`"];

ClearAll[
  flushOutput, exitWithCode, fail, commandLineArguments, truncateAtMarker,
  cellStyle, explicitInitializationCellQ, explicitlyNonEvaluatableQ,
  initializationCodeCells, contextCommands, advanceImportContext,
  heldExpressionsForCell, heldExpressionsForCells, heldExpressionText,
  directContextSymbolNames, usageSymbolNames, packageUsageSymbolNames,
  dependencyContextOwners, reassignDependencyContexts,
  repairGeneratedSourceText,
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
contextCommands[held_HoldComplete] := Join[
  Cases[
    held,
    HoldPattern[BeginPackage[context_String, dependencies___]] :>
      {"BeginPackage", context, Flatten@{dependencies}},
    Infinity
  ],
  Cases[
    held,
    HoldPattern[Begin[context_String]] :>
      {"Begin", context},
    Infinity
  ],
  Cases[
    held,
    HoldPattern[End[]] :>
      {"End"},
    Infinity
  ],
  Cases[
    held,
    HoldPattern[EndPackage[]] :>
      {"EndPackage"},
    Infinity
  ]
];

advanceImportContext[
  command_List,
  currentContext_String,
  currentPath_List,
  contextStack_List,
  packageStack_List
] := Switch[
  First[command],

  "BeginPackage",
    {
      command[[2]],
      DeleteDuplicates@Join[
        {command[[2]]},
        Select[Flatten@{command[[3]]}, StringQ],
        currentPath
      ],
      contextStack,
      Append[packageStack, {currentContext, currentPath, contextStack}]
    },

  "Begin",
    {
      If[
        StringStartsQ[command[[2]], "`"],
        currentContext <> StringDrop[command[[2]], 1],
        command[[2]]
      ],
      currentPath,
      Append[contextStack, currentContext],
      packageStack
    },

  "End",
    If[
      contextStack === {},
      {currentContext, currentPath, contextStack, packageStack},
      {
        Last[contextStack],
        currentPath,
        Most[contextStack],
        packageStack
      }
    ],

  "EndPackage",
    If[
      packageStack === {},
      {currentContext, currentPath, contextStack, packageStack},
      Join[Last[packageStack], {Most[packageStack]}]
    ],

  _,
    {currentContext, currentPath, contextStack, packageStack}
];

heldExpressionsForCell[
  cell_Cell,
  currentContext_String,
  currentPath_List
] := Module[{style, imported},
  style = cellStyle[cell];
  imported = Block[
    {
      $Context = currentContext,
      $ContextPath = currentPath
    },
    Quiet@Check[
      NotebookImport[Notebook[{cell}], style],
      $Failed
    ]
  ];
  If[imported === $Failed, Return[$Failed]];
  Cases[Flatten[{imported}], held_HoldComplete :> held, {1}]
];

heldExpressionsForCells[cells_List] := Module[
  {
    currentContext = "Global`",
    currentPath = DeleteDuplicates@Join[{"Global`"}, $ContextPath],
    contextStack = {},
    packageStack = {},
    scratchPrefix =
      "Validation`SourceGeneration`Scratch`S" <>
      ToString[$SessionID] <> "M" <> ToString[$ModuleNumber] <> "`",
    imported,
    importedByCell,
    state
  },
  importedByCell = Table[
    imported = heldExpressionsForCell[
      cell,
      scratchPrefix <> currentContext,
      Replace[
        currentPath,
        context_String /; context =!= "System`" :> scratchPrefix <> context,
        {1}
      ]
    ];
    If[imported =!= $Failed,
      Scan[
        (
          state = advanceImportContext[
            #,
            currentContext,
            currentPath,
            contextStack,
            packageStack
          ];
          {
            currentContext,
            currentPath,
            contextStack,
            packageStack
          } = state
        ) &,
        Flatten[contextCommands /@ imported, 1]
      ]
    ];
    imported,
    {cell, cells}
  ];
  <|
    "Expressions" -> importedByCell,
    "ScratchPrefix" -> scratchPrefix
  |>
];

(* Convert the held arguments to an explicit, per-cell CompoundExpression
   without evaluating them. Serialize with only System` on $ContextPath so
   every non-System symbol keeps its fully qualified context. This is required
   for notebook cells: their boxes can already identify Global` symbols even
   when an earlier initialization cell evaluates BeginPackage or Begin.
   NotebookImport can return HoldComplete with more than one
   argument for a single cell; stripping HoldComplete alone would leave an
   invalid top-level comma sequence. FullForm avoids InputForm's semicolon
   shorthand, which is ambiguous when nested inside the explicit wrapper. *)
heldExpressionText[held_HoldComplete, scratchPrefix_String] := Module[
  {text, prefix = "HoldComplete[", start},
  text = Block[
    {
      $Context = "Validation`SourceGeneration`Serialization`",
      $ContextPath = {"System`"}
    },
    ToString[FullForm[held], OutputForm, PageWidth -> Infinity]
  ];
  text = StringReplace[text, scratchPrefix -> ""];
  start = StringLength[prefix] + 1;
  If[
    StringStartsQ[text, prefix] && StringEndsQ[text, "]"],
    "CompoundExpression[" <> StringTake[text, {start, -2}] <> "]",
    $Failed
  ]
];

(* Return only symbols directly in context, excluding symbols in nested
   contexts such as base`Private`. Earlier generated files have already been
   syntax-read by the time a dependent package is repaired, so their explicit
   package symbols are present in the generator kernel without having executed
   any project initialization code. *)
directContextSymbolNames[context_String] := Select[
  Names[context <> "*"],
  ! StringContainsQ[StringDrop[#, StringLength[context]], "`"] &
];

(* myNotebookInit.wl is maintained source rather than a regenerated FullForm
   file. Its public API is therefore obtained from usage declarations. *)
usageSymbolNames[path_String, context_String] := Module[{sourceText, names},
  If[! FileExistsQ[path], Return[{}]];
  sourceText = Quiet@Check[Import[path, "Text"], $Failed];
  If[sourceText === $Failed, Return[{}]];
  names = StringCases[
    sourceText,
    RegularExpression["([A-Za-z$][A-Za-z0-9$]*)::usage"] -> "$1"
  ];
  (context <> #) & /@ DeleteDuplicates[names]
];

(* FullForm writes usage declarations as MessageName[symbol, "usage"]. These
   declarations are authoritative: even if a legacy notebook box still carries
   Global`, the declared public symbol belongs to the package being generated. *)
packageUsageSymbolNames[text_String] := DeleteDuplicates @ StringCases[
  text,
  RegularExpression[
    "MessageName\\[(?:Global|[A-Za-z$][A-Za-z0-9$]*)`" <>
    "([A-Za-z$][A-Za-z0-9$]*), \\\"usage\\\"\\]"
  ] -> "$1"
];

(* Reconstruct the resolution that BeginPackage would have performed if all
   dependencies had already existed when NotebookImport parsed each cell.
   Dependency order is significant: the first context on $ContextPath owns an
   ambiguous bare name. *)
dependencyContextOwners[destinationPath_String] := Module[
  {fileName, srcDirectory, dependencyContexts, dependencyNames, owners = <||>},
  fileName = FileNameTake[destinationPath];
  srcDirectory = DirectoryName[destinationPath];
  dependencyContexts = Switch[fileName,
    "base.wl", {"myNotebookInit`"},
    "statDataAnal.wl", {"myNotebookInit`", "base`"},
    "RICH.wl", {"myNotebookInit`", "base`", "statDataAnal`"},
    "calculator-reboot.wl",
      {"myNotebookInit`", "base`", "statDataAnal`", "rich`"},
    _, {}
  ];
  Scan[
    Function[context,
      dependencyNames = If[context === "myNotebookInit`",
        usageSymbolNames[
          FileNameJoin[{srcDirectory, "myNotebookInit.wl"}],
          context
        ],
        directContextSymbolNames[context]
      ];
      Scan[
        Function[fullName,
          With[{name = StringDrop[fullName, StringLength[context]]},
            If[! KeyExistsQ[owners, name], AssociateTo[owners, name -> context]]
          ]
        ],
        dependencyNames
      ]
    ],
    dependencyContexts
  ];
  owners
];

reassignDependencyContexts[text_String, destinationPath_String] := Module[
  {fileName, currentContext, packageNames, owners, packageRules, dependencyRules,
   normalizedText},
  fileName = FileNameTake[destinationPath];
  currentContext = Switch[fileName,
    "base.wl", "base`",
    "statDataAnal.wl", "statDataAnal`",
    "RICH.wl", "rich`",
    "calculator-reboot.wl", "calculator`",
    _, Return[text]
  ];
  packageNames = packageUsageSymbolNames[text];
  packageRules = Function[name,
      RegularExpression[
        "Global`\\Q" <> name <> "\\E(?![\\p{L}\\p{N}$\\\\])"
      ] -> currentContext <> name
    ] /@ packageNames;
  normalizedText = StringReplace[text, packageRules];
  owners = dependencyContextOwners[destinationPath];
  owners = KeyDrop[owners, packageNames];
  dependencyRules = KeyValueMap[
    Function[{name, ownerContext},
      RegularExpression[
        "(?:Global|" <> StringDrop[currentContext, -1] <> ")`\\Q" <>
        name <> "\\E(?![\\p{L}\\p{N}$\\\\])"
      ] -> ownerContext <> name
    ],
    owners
  ];
  StringReplace[normalizedText, dependencyRules]
];

(* NotebookImport interprets the escaped quotes inside two RICH StyleBox label
   strings as expression boundaries. Repair those audited artifacts after
   context-preserving serialization. The legacy notebook also resolves the two
   bare killStop references through myNotebookInit`; make that ownership
   explicit in the generated package. *)
repairGeneratedSourceText[text_String, destinationPath_String] := Module[
  {fileName, repairedText, oldEnergy, newEnergy, oldWavelength, newWavelength},
  fileName = FileNameTake[destinationPath];
  repairedText = StringReplace[
    If[
      MemberQ[{"physics-general.wl", "inputDataForRICH.wl"}, fileName],
      StringReplace[text, "Global`" -> ""],
      reassignDependencyContexts[text, destinationPath]
    ], {
    "myNotebookInit`loadMyFile[\"CellStyleDataRules.m\"]" ->
      "If[TrueQ[Global`$RICHProjectManagedLoad], Null, myNotebookInit`loadMyFile[\"CellStyleDataRules.wl\", DirectoryName[$InputFileName]]]",
    "myNotebookInit`loadMyFile[\"CellStyleDataRules.wl\"]" ->
      "If[TrueQ[Global`$RICHProjectManagedLoad], Null, myNotebookInit`loadMyFile[\"CellStyleDataRules.wl\", DirectoryName[$InputFileName]]]"
  }];
  If[fileName === "calculator-reboot.wl",
    Return @ StringReplace[repairedText, {
      "loadMyFile[\"myDockedCells.wl\"]" ->
        "If[TrueQ[Global`$RICHProjectManagedLoad], Null, myNotebookInit`loadMyFile[\"myDockedCells.wl\", DirectoryName[$InputFileName]]]",
      "myNotebookInit`loadMyFile[\"myDockedCells.wl\"]" ->
        "If[TrueQ[Global`$RICHProjectManagedLoad], Null, myNotebookInit`loadMyFile[\"myDockedCells.wl\", DirectoryName[$InputFileName]]]",
      "myNotebookInit`loadMyFile[\"RICH.m\", NotebookDirectory[]]" ->
        "If[TrueQ[Global`$RICHProjectManagedLoad], Null, myNotebookInit`loadMyFile[\"RICH.wl\", DirectoryName[$InputFileName]]]",
      "myNotebookInit`loadMyFile[\"RICH.m\",NotebookDirectory[]]" ->
        "If[TrueQ[Global`$RICHProjectManagedLoad], Null, myNotebookInit`loadMyFile[\"RICH.wl\",DirectoryName[$InputFileName]]]",
      "myNotebookInit`loadMyFile[\"RICH.wl\", NotebookDirectory[]]" ->
        "If[TrueQ[Global`$RICHProjectManagedLoad], Null, myNotebookInit`loadMyFile[\"RICH.wl\", DirectoryName[$InputFileName]]]",
      "myNotebookInit`loadMyFile[\"RICH.wl\",NotebookDirectory[]]" ->
        "If[TrueQ[Global`$RICHProjectManagedLoad], Null, myNotebookInit`loadMyFile[\"RICH.wl\",DirectoryName[$InputFileName]]]"
    }]
  ];
  If[fileName =!= "RICH.wl", Return[repairedText]];
  oldEnergy =
    "myNotebookInit`bigBanner[Times[\" integral yield function \\!\\(\\*StyleBox[\", rich`per, \",Background->RGBColor[1, 1, 0]]\\)\\!\\(\\*StyleBox[\", \",Background->RGBColor[1, 1, 0]]\\)\\!\\(\\*StyleBox[\", rich`meter, \",Background->RGBColor[1, 1, 0]]\\) all effects included (via ene calculation) \"]]";
  newEnergy =
    "myNotebookInit`bigBanner[\" integral yield function \\!\\(\\*StyleBox[\\\"per\\\",Background->RGBColor[1, 1, 0]]\\)\\!\\(\\*StyleBox[\\\" \\\",Background->RGBColor[1, 1, 0]]\\)\\!\\(\\*StyleBox[\\\"meter\\\",Background->RGBColor[1, 1, 0]]\\) all effects included (via ene calculation) \"]";
  oldWavelength = StringReplace[oldEnergy, "ene calculation" -> "lam calculation"];
  newWavelength = StringReplace[newEnergy, "ene calculation" -> "lam calculation"];
  repairedText = StringReplace[repairedText, {
    oldEnergy -> newEnergy,
    oldWavelength -> newWavelength,
    "CellStyleDataRules.m" -> "CellStyleDataRules.wl",
    "base.m" -> "base.wl",
    "statDataAnal.m" -> "statDataAnal.wl",
    "physics-general.m" -> "physics-general.wl",
    "inputDataForRICH.m" -> "inputDataForRICH.wl",
    "rich`killStop" -> "myNotebookInit`killStop"
  }];
  StringReplace[repairedText, {
    "myNotebookInit`loadMyFile[\"base.wl\"]" ->
      "If[TrueQ[Global`$RICHProjectManagedLoad], 1, myNotebookInit`loadMyFile[\"base.wl\", DirectoryName[$InputFileName]]]",
    "myNotebookInit`loadMyFile[\"statDataAnal.wl\"]" ->
      "If[TrueQ[Global`$RICHProjectManagedLoad], 1, myNotebookInit`loadMyFile[\"statDataAnal.wl\", DirectoryName[$InputFileName]]]",
    "myNotebookInit`loadMyFile[\"physics-general.wl\"]" ->
      "myNotebookInit`loadMyFile[\"physics-general.wl\", DirectoryName[$InputFileName]]",
    "myNotebookInit`loadMyFile[\"inputDataForRICH.wl\"]" ->
      "myNotebookInit`loadMyFile[\"inputDataForRICH.wl\", DirectoryName[$InputFileName]]"
  }]
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
   importResult, heldByCell, scratchPrefix, failedCells, textByCell,
    failedTexts, blocks, header, generatedText,
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

  importResult = heldExpressionsForCells[cells];
  heldByCell = Lookup[importResult, "Expressions", $Failed];
  scratchPrefix = Lookup[importResult, "ScratchPrefix", ""];
  (* A notebook expression may legitimately contain the symbol $Failed.
     Only an entire per-cell import result equal to $Failed indicates that
     NotebookImport itself failed. *)
  failedCells = Flatten@Position[heldByCell, $Failed, {1}];
  If[failedCells =!= {},
    Return[Failure["HeldExpressionImportFailed", <|
      "Path" -> sourcePath,
      "FailedCellIndices" -> failedCells
    |>]]
  ];

  textByCell = (heldExpressionText[#, scratchPrefix] & /@ #) & /@ heldByCell;
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
    "(* Each source cell was imported under HoldComplete, serialized in context-preserving FullForm, and syntax-checked without evaluation. *)\n\n";

  If[! DirectoryQ[DirectoryName[destinationPath]],
    CreateDirectory[
      DirectoryName[destinationPath],
      CreateIntermediateDirectories -> True
    ]
  ];
  generatedText = repairGeneratedSourceText[
    header <> StringRiffle[blocks, "\n\n"],
    destinationPath
  ];
  Export[destinationPath, generatedText, "Text"];

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
    <|"Key" -> "RICH-source", "Source" -> {"legacy-original", "RICH.nb"}, "Destination" -> {"src", "RICH.wl"}, "Cutoff" -> None|>,
    <|"Key" -> "calculator-reboot", "Source" -> {"legacy-original", "calculator-reboot.nb"}, "Destination" -> {"src", "calculator-reboot.wl"}, "Cutoff" -> "CALCULATOR BODY"|>
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
