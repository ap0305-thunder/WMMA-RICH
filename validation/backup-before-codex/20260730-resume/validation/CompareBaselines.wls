(* Compare selected original/restructured result pairs.
   Arguments: PROJECT_ROOT and optional comma-separated case names. *)

Begin["Validation`Private`"];

ClearAll[flushOutput, exitWithCode, ensureDirectory, loadRecord, recordHashes, firstDifference,
  symbolEntry, compareCase, markdownEscape, bulletList, statusRank, makeReport,
  jsonSafe, commandLineArguments, main];


flushOutput[] := Scan[(Quiet@Check[Flush[#], Null]) &, Flatten[{$Output}]];

exitWithCode[code_Integer] := (
  WriteString[$Output, "__WOLFRAM_EXIT_CODE__=" <> ToString[code] <> "\n"];
  flushOutput[];
  Exit[code]
);

ensureDirectory[path_String] := If[! DirectoryQ[path],
  CreateDirectory[path, CreateIntermediateDirectories -> True]
];

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

loadRecord[path_String] := If[FileExistsQ[path],
  Quiet@Check[Import[path, "WXF"], $Failed],
  Missing["NotRun"]
];

recordHashes[records_] := If[ListQ[records],
  Lookup[Select[records, AssociationQ], "Hash", {}],
  {}
];

symbolEntry[symbols_Association, name_String] := Lookup[symbols, name, <||>];
symbolEntry[_, _] := <||>;

firstDifference[left_List, right_List] := Module[{limit, flags, position},
  limit = Min[Length[left], Length[right]];
  flags = MapThread[UnsameQ, {Take[left, limit], Take[right, limit]}];
  position = FirstPosition[flags, True, Missing["NoDifference"]];
  Which[
    ! MissingQ[position], First[position],
    Length[left] =!= Length[right], limit + 1,
    True, None
  ]
];

compareCase[caseName_String, original_, restructured_] := Module[
  {originalStatus, restructuredStatus, originalSymbols, restructuredSymbols,
   originalNames, restructuredNames, commonNames, missingNames, extraNames,
   codeDifferences, ownValueDifferences, outputHashesOriginal,
   outputHashesRestructured, messageHashesOriginal, messageHashesRestructured,
   printHashesOriginal, printHashesRestructured, compareSideEffects,
   outputsMatch, messagesMatch, printsMatch, status, reason},

  If[MissingQ[original] || MissingQ[restructured] ||
     original === $Failed || restructured === $Failed,
    Return[<|
      "Case" -> caseName,
      "Status" -> "NOT RUN",
      "Reason" -> "One or both result files are missing or unreadable."
    |>]
  ];

  originalStatus = Lookup[original, "EvaluationStatus", "Unknown"];
  restructuredStatus = Lookup[restructured, "EvaluationStatus", "Unknown"];
  originalSymbols = Lookup[original, "Symbols", <||>];
  restructuredSymbols = Lookup[restructured, "Symbols", <||>];
  If[! AssociationQ[originalSymbols], originalSymbols = <||>];
  If[! AssociationQ[restructuredSymbols], restructuredSymbols = <||>];
  originalNames = Keys[originalSymbols];
  restructuredNames = Keys[restructuredSymbols];
  commonNames = Intersection[originalNames, restructuredNames];
  missingNames = Complement[originalNames, restructuredNames];
  extraNames = Complement[restructuredNames, originalNames];

  codeDifferences = Select[
    commonNames,
    Lookup[symbolEntry[originalSymbols, #], "CodeHash", None] =!=
      Lookup[symbolEntry[restructuredSymbols, #], "CodeHash", None] &
  ];
  ownValueDifferences = Select[
    commonNames,
    Lookup[symbolEntry[originalSymbols, #], "OwnValueHash", None] =!=
      Lookup[symbolEntry[restructuredSymbols, #], "OwnValueHash", None] &
  ];

  outputHashesOriginal = recordHashes[Lookup[original, "NotebookOutputs", {}]];
  outputHashesRestructured = recordHashes[Lookup[restructured, "NotebookOutputs", {}]];
  messageHashesOriginal = recordHashes[Lookup[original, "NotebookMessages", {}]];
  messageHashesRestructured = recordHashes[Lookup[restructured, "NotebookMessages", {}]];
  printHashesOriginal = recordHashes[Lookup[original, "NotebookPrints", {}]];
  printHashesRestructured = recordHashes[Lookup[restructured, "NotebookPrints", {}]];

  compareSideEffects = TrueQ[
    Lookup[original, "CompareNotebookSideEffects", True]
  ];
  outputsMatch = ! compareSideEffects ||
    outputHashesOriginal === outputHashesRestructured;
  messagesMatch = ! compareSideEffects ||
    messageHashesOriginal === messageHashesRestructured;
  printsMatch = ! compareSideEffects ||
    printHashesOriginal === printHashesRestructured;

  {status, reason} = Which[
    originalStatus =!= "Success" || restructuredStatus =!= "Success",
      {"FAIL", "At least one evaluation did not complete successfully."},
    missingNames =!= {} || codeDifferences =!= {} || ownValueDifferences =!= {},
      {"FAIL", "Captured symbol definitions or assigned values differ."},
    ! outputsMatch || ! messagesMatch || ! printsMatch,
      {"WARNING", "Symbol state matches, but notebook outputs/messages/prints differ."},
    True,
      If[compareSideEffects,
        {"PASS", "Captured symbol state and notebook side effects match exactly."},
        {"PASS", "Captured symbol state matches; notebook side effects were intentionally not compared."}
      ]
  ];

  <|
    "Case" -> caseName,
    "Status" -> status,
    "Reason" -> reason,
    "OriginalEvaluationStatus" -> originalStatus,
    "RestructuredEvaluationStatus" -> restructuredStatus,
    "OriginalSymbolCount" -> Length[originalNames],
    "RestructuredSymbolCount" -> Length[restructuredNames],
    "CommonSymbolCount" -> Length[commonNames],
    "MissingSymbols" -> missingNames,
    "ExtraSymbols" -> extraNames,
    "CodeDifferences" -> codeDifferences,
    "OwnValueDifferences" -> ownValueDifferences,
    "OriginalOutputCount" -> Length[outputHashesOriginal],
    "RestructuredOutputCount" -> Length[outputHashesRestructured],
    "CompareNotebookSideEffects" -> compareSideEffects,
    "OutputsMatch" -> outputsMatch,
    "FirstOutputDifference" -> firstDifference[
      outputHashesOriginal, outputHashesRestructured
    ],
    "OriginalMessageCount" -> Length[messageHashesOriginal],
    "RestructuredMessageCount" -> Length[messageHashesRestructured],
    "MessagesMatch" -> messagesMatch,
    "FirstMessageDifference" -> firstDifference[
      messageHashesOriginal, messageHashesRestructured
    ],
    "OriginalPrintCount" -> Length[printHashesOriginal],
    "RestructuredPrintCount" -> Length[printHashesRestructured],
    "PrintsMatch" -> printsMatch,
    "FirstPrintDifference" -> firstDifference[
      printHashesOriginal, printHashesRestructured
    ],
    "OriginalElapsedSeconds" -> Lookup[original, "ElapsedSeconds", Missing[]],
    "RestructuredElapsedSeconds" -> Lookup[restructured, "ElapsedSeconds", Missing[]],
    "WolframVersion" -> Lookup[restructured, "WolframVersion", "Unknown"]
  |>
];

markdownEscape[text_] := StringReplace[ToString[text], {
  "|" -> "\\|", "`" -> "\\`", "\n" -> " "
}];

bulletList[items_List, maximum_Integer] := If[items === {},
  "- None\n",
  StringRiffle[
    ("- `" <> markdownEscape[#] <> "`") & /@ Take[items, UpTo[maximum]],
    "\n"
  ] <> If[Length[items] > maximum,
    "\n- ... and " <> ToString[Length[items] - maximum] <> " more",
    ""
  ] <> "\n"
];

statusRank[status_String] := Switch[status,
  "FAIL", 3,
  "WARNING", 2,
  "NOT RUN", 1,
  _, 0
];

makeReport[comparisons_List, options_Association] := Module[
  {maximum, summaryRows, details, overall, counts},
  maximum = Lookup[options, "MaximumDifferencesShown", 80];
  overall = First@MaximalBy[Lookup[comparisons, "Status"], statusRank];
  counts = Counts[Lookup[comparisons, "Status"]];

  summaryRows = StringRiffle[
    Map[
      "| " <> markdownEscape[Lookup[#, "Case"]] <>
      " | **" <> Lookup[#, "Status"] <> "**" <>
      " | " <> ToString[Lookup[#, "OriginalSymbolCount", 0]] <>
      " | " <> ToString[Lookup[#, "RestructuredSymbolCount", 0]] <>
      " | " <> ToString[Length[Lookup[#, "MissingSymbols", {}]]] <>
      " | " <> ToString[Length[Lookup[#, "CodeDifferences", {}]]] <>
      " | " <> ToString[Length[Lookup[#, "OwnValueDifferences", {}]]] <>
      " | " <> If[TrueQ[Lookup[#, "OutputsMatch", False]], "yes", "no"] <>
      " |" &,
      comparisons
    ],
    "\n"
  ];

  details = StringRiffle[
    Map[
      Function[comparison,
        "## " <> Lookup[comparison, "Case"] <> " - " <>
        Lookup[comparison, "Status"] <> "\n\n" <>
        Lookup[comparison, "Reason", ""] <> "\n\n" <>
        "- Original evaluation: `" <>
          ToString[Lookup[comparison, "OriginalEvaluationStatus", "Unknown"]] <> "`\n" <>
        "- Restructured evaluation: `" <>
          ToString[Lookup[comparison, "RestructuredEvaluationStatus", "Unknown"]] <> "`\n" <>
        "- Outputs: " <> ToString[Lookup[comparison, "OriginalOutputCount", 0]] <>
          " original, " <> ToString[Lookup[comparison, "RestructuredOutputCount", 0]] <>
          " restructured; first difference: `" <>
          ToString[Lookup[comparison, "FirstOutputDifference", None], InputForm] <> "`\n" <>
        "- Messages: " <> ToString[Lookup[comparison, "OriginalMessageCount", 0]] <>
          " original, " <> ToString[Lookup[comparison, "RestructuredMessageCount", 0]] <>
          " restructured; first difference: `" <>
          ToString[Lookup[comparison, "FirstMessageDifference", None], InputForm] <> "`\n" <>
        "- Prints: " <> ToString[Lookup[comparison, "OriginalPrintCount", 0]] <>
          " original, " <> ToString[Lookup[comparison, "RestructuredPrintCount", 0]] <>
          " restructured; first difference: `" <>
          ToString[Lookup[comparison, "FirstPrintDifference", None], InputForm] <> "`\n\n" <>
        "### Missing symbols\n\n" <>
          bulletList[Lookup[comparison, "MissingSymbols", {}], maximum] <> "\n" <>
        "### Different definitions\n\n" <>
          bulletList[Lookup[comparison, "CodeDifferences", {}], maximum] <> "\n" <>
        "### Different assigned values\n\n" <>
          bulletList[Lookup[comparison, "OwnValueDifferences", {}], maximum] <> "\n" <>
        "### Extra restructured symbols\n\n" <>
          bulletList[Lookup[comparison, "ExtraSymbols", {}], maximum]
      ],
      comparisons
    ],
    "\n"
  ];

  "# Wolfram behavioural validation report\n\n" <>
  "Generated: " <> DateString[] <> "\n\n" <>
  "Overall strict status: **" <> overall <> "**\n\n" <>
  "- PASS: " <> ToString[Lookup[counts, "PASS", 0]] <> "\n" <>
  "- WARNING: " <> ToString[Lookup[counts, "WARNING", 0]] <> "\n" <>
  "- FAIL: " <> ToString[Lookup[counts, "FAIL", 0]] <> "\n" <>
  "- NOT RUN: " <> ToString[Lookup[counts, "NOT RUN", 0]] <> "\n\n" <>
  "The strict comparison checks captured symbol definitions and assigned values. " <>
  "It separately compares generated Output, Message and Print cells. Automatically " <>
  "generated symbols ending in `$<digits>` are excluded.\n\n" <>
  "| Case | Status | Original symbols | Restructured symbols | Missing | Definition differences | Value differences | Outputs identical |\n" <>
  "|---|---:|---:|---:|---:|---:|---:|---:|\n" <>
  summaryRows <> "\n\n" <>
  details
];

jsonSafe[expression_] := expression /. {
  Infinity -> "Infinity",
  Indeterminate -> "Indeterminate",
  DirectedInfinity[___] -> "DirectedInfinity",
  None -> Null,
  missing_Missing :> ToString[missing, InputForm]
};

main[] := Module[
  {arguments, projectRoot, requestedCases, configPath, cases, options, resultRoot,
   comparisons, originalPath, restructuredPath, original, restructured,
   reportPath, jsonPath, report, worstStatus},

  arguments = commandLineArguments[2];
  If[Length[arguments] < 1,
    WriteString[$Output,
      "Command-line diagnostics:\n" <>
      "  $ScriptCommandLine = " <> ToString[$ScriptCommandLine, InputForm] <> "\n" <>
      "  $CommandLine = " <> ToString[$CommandLine, InputForm] <> "\n" <>
      "ERROR: Expected PROJECT_ROOT and optional comma-separated cases.\n"
    ];
    exitWithCode[2]
  ];
  projectRoot = ExpandFileName[First[arguments]];
  requestedCases = If[Length[arguments] >= 2,
    DeleteCases[StringSplit[Last[arguments], ","], ""],
    {}
  ];
  configPath = FileNameJoin[{projectRoot, "validation", "ValidationConfig.wl"}];
  If[! FileExistsQ[configPath],
    WriteString[$Output, "ERROR: Missing configuration.\n"];
    exitWithCode[2]
  ];
  Get[configPath];
  cases = Validation`$ValidationCases;
  If[requestedCases =!= {},
    cases = KeyTake[cases, requestedCases]
  ];
  options = Validation`$ValidationOptions;
  resultRoot = FileNameJoin[{projectRoot, "validation", "results", "current"}];
  ensureDirectory[resultRoot];

  comparisons = KeyValueMap[
    Function[{caseName, ignored},
      originalPath = FileNameJoin[{resultRoot, "raw", "original", caseName <> ".wxf"}];
      restructuredPath = FileNameJoin[{resultRoot, "raw", "restructured", caseName <> ".wxf"}];
      original = loadRecord[originalPath];
      restructured = loadRecord[restructuredPath];
      compareCase[caseName, original, restructured]
    ],
    cases
  ];

  report = makeReport[comparisons, options];
  reportPath = FileNameJoin[{resultRoot, "VALIDATION_REPORT.md"}];
  jsonPath = FileNameJoin[{resultRoot, "comparison.json"}];
  Export[reportPath, report, "Text"];
  Export[jsonPath, jsonSafe[comparisons], "RawJSON"];

  WriteString[$Output,
    "Comparison report: " <> reportPath <> "\n"
  ];

  worstStatus = Max[statusRank /@ Lookup[comparisons, "Status"]];
  exitWithCode[If[worstStatus >= 3, 4, 0]]
];

main[];

End[];
