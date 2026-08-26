(* Structural verification for all managed source and notebook openings. *)

ClearAll[bootstrapCells, notebookTag, projectCase, notebookRole, fail];

fail[message_String] := (Print["ERROR: ", message]; Exit[2]);

bootstrapCells[expression_] := Cases[
  expression,
  cell : Cell[_, ("Input" | "Code"), options___] /;
    ! FreeQ[
      Unevaluated[Cell[Null, "Input", options]],
      "RICHUniversalBootstrap"
    ] :> cell,
  Infinity
];

notebookTag[expression_Notebook, key_String] := FirstCase[
  expression,
  Notebook[_, options___] :> FirstCase[
    {options},
    HoldPattern[TaggingRules -> rules_Association] :>
      Lookup[rules, key, Missing["NotFound"]],
    Missing["NotFound"],
    {1}
  ],
  Missing["NotFound"],
  {0}
];

projectCase[expression_Notebook] := notebookTag[
  expression, "RICHProjectCase"
];

notebookRole[expression_Notebook] := notebookTag[
  expression, "RICHNotebookRole"
];

root = DirectoryName[DirectoryName[$InputFileName]];
sourceEndLabels = <|
  "myNotebookInit.wl" -> "myNotebookInit",
  "cellStyleDataRules.wl" -> "cellStyleDataRules",
  "base.wl" -> "base",
  "statDataAnal.wl" -> "statDataAnal",
  "physicsGeneral.wl" -> "physicsGeneral",
  "inputDataForRICH.wl" -> "inputDataForRICH",
  "RICH.wl" -> "rich",
  "calculator.wl" -> "calculator",
  "optics.wl" -> "optics",
  "geometricalOptics.wl" -> "geometricalOptics"
|>;
sourceStartMetadata = <|
  "myNotebookInit.wl" -> {
    "myNotebookInit", "infrastructure", "myNotebookInit`",
    "myNotebookInit`versionTAG", "v.08-08-2026"
  },
  "cellStyleDataRules.wl" -> {
    "cellStyleDataRules", "package-bootstrap",
    "Global` (notebook style rules)",
    "cellStyleDataRules`Private`versionTAG", "v.20-08-2026"
  },
  "base.wl" -> {
    "base", "package-bootstrap", "base`",
    "base`Private`versionTAG", "v.08-08-2026"
  },
  "statDataAnal.wl" -> {
    "statDataAnal", "package-bootstrap", "statDataAnal`",
    "statDataAnal`Private`versionTAG", "v.08-08-2026"
  },
  "physicsGeneral.wl" -> {
    "physicsGeneral", "package-bootstrap", "physicsGeneral`",
    "physicsGeneral`Private`versionTAG", "v.08-08-2026"
  },
  "inputDataForRICH.wl" -> {
    "inputDataForRICH", "package-bootstrap", "inputDataForRICH`",
    "inputDataForRICH`Private`versionTAG", "v.08-08-2026"
  },
  "RICH.wl" -> {
    "RICH", "package-bootstrap", "rich`",
    "rich`Private`versionTAG", "v.08-08-2026"
  },
  "calculator.wl" -> {
    "calculator", "interactive-top-level", "calculator`",
    "calculator`Private`versionTAG", "v.08-08-2026"
  },
  "optics.wl" -> {
    "optics", "interactive-top-level",
    "Global` (legacy Optica-compatible source)",
    "optics`Private`versionTAG", "v_16-06-2026"
  },
  "geometricalOptics.wl" -> {
    "geometricalOptics", "interactive-top-level", "geometricalOptics`",
    "geometricalOptics`Private`versionTAG", "v.16-01-2025"
  }
|>;
invalidSourceStarts = Select[
  Keys[sourceStartMetadata],
  Function[fileName,
    metadata = sourceStartMetadata[fileName];
    sourceText = Quiet @ Check[
      Import[FileNameJoin[{root, "src", fileName}], "Text"],
      $Failed
    ];
    expectedHeader = StringRiffle[{
      "(* ::Package:: *)",
      "",
      "(* ===== RICH managed source =====",
      "   Name: " <> metadata[[1]],
      "   Role: " <> metadata[[2]],
      "   Context: " <> metadata[[3]],
      "   Version symbol: " <> metadata[[4]],
      "*)",
      metadata[[4]] <> " = \"" <> metadata[[5]] <> "\";"
    }, "\n"];
    sourceText === $Failed ||
      ! StringStartsQ[sourceText, expectedHeader] ||
      Length @ StringCases[
        sourceText,
        RegularExpression[
          "(?m)^[ \\t]*\\Q" <> metadata[[4]] <>
            "\\E[ \\t]*=[ \\t]*\"[^\"]*\";?[ \\t]*$"
        ]
      ] =!= 1
  ]
];
If[
  invalidSourceStarts =!= {},
  fail[
    "Managed source headers are missing or inconsistent: " <>
      StringRiffle[invalidSourceStarts, ", "]
  ]
];
myNotebookInitText = Import[
  FileNameJoin[{root, "src", "myNotebookInit.wl"}],
  "Text"
];
publicUsageBlock = StringTake[
  myNotebookInitText,
  {
    StringPosition[
      myNotebookInitText,
      "(* ===== Public API (lowercase-first) ===== *)"
    ][[1, 2]] + 1,
    StringPosition[myNotebookInitText, "Begin[\"`Private`\"]"][[1, 1]] - 1
  }
];
usageLines = StringCases[
  publicUsageBlock,
  RegularExpression[
    "(?m)^([^\\s:]+)::usage = \"(?:\\\\.|[^\"])*\";$"
  ]
];
usageNames = Flatten @ StringCases[
  usageLines,
  RegularExpression["^([^\\s:]+)::usage"] -> "$1"
];
If[
  Length[usageLines] =!= StringCount[publicUsageBlock, "::usage"] ||
    ! DuplicateFreeQ[usageNames] ||
    usageNames =!= SortBy[
      usageNames,
      ToLowerCase @ StringDelete[
        Last @ StringSplit[#, "`"],
        StartOfString ~~ "$"
      ] &
    ],
  fail[
    "myNotebookInit usage declarations must be unique, single-line, and alphabetically sorted."
  ]
];
invalidSourceEndings = Select[
  Keys[sourceEndLabels],
  Function[fileName,
    sourceText = Quiet @ Check[
      Import[FileNameJoin[{root, "src", fileName}], "Text"],
      $Failed
    ];
    expectedFooter =
      "myNotebookInit`endEvalPrintOut[];\n\n" <>
      "myNotebookInit`packageBanner[\"END " <>
        sourceEndLabels[fileName] <> "\"];";
    sourceText === $Failed ||
      ! StringEndsQ[StringTrim[sourceText], expectedFooter]
  ]
];
If[
  invalidSourceEndings =!= {},
  fail[
    "Managed source lifecycle endings are missing or inconsistent: " <>
      StringRiffle[invalidSourceEndings, ", "]
  ]
];
calculatorSourceText = Import[
  FileNameJoin[{root, "src", "calculator.wl"}],
  "Text"
];
If[
  StringContainsQ[calculatorSourceText, "(*---... CALCULATOR BODY*)"] ||
    ! StringContainsQ[calculatorSourceText, "(*---... CALCULATOR*)"],
  fail[
    "calculator.wl must contain calculator initialization and stop before " <>
      "CALCULATOR BODY."
  ]
];
If[
  AnyTrue[
    {
      "Unprotect[Get]", "Unprotect[Needs]", "myDockedCells.wl",
      "loadMyFile[\"RICH.m\""
    },
    StringContainsQ[calculatorSourceText, #] &
  ],
  fail[
    "calculator.wl retained an unsafe or obsolete legacy setup hook."
  ]
];
unterminatedContextClosures = Select[
  Keys[sourceEndLabels],
  Function[fileName,
    sourceText = Quiet @ Check[
      Import[FileNameJoin[{root, "src", fileName}], "Text"],
      ""
    ];
    StringContainsQ[
      sourceText,
      RegularExpression[
        "(?m)^[ \\t]*(?:End|EndPackage)\\[\\](?!;)"
      ]
    ]
  ]
];
If[
  unterminatedContextClosures =!= {},
  fail[
    "Package/context closures must be semicolon-terminated: " <>
      StringRiffle[unterminatedContextClosures, ", "]
  ]
];
notebookCases = {
  "calculator", "optics", "geometricalOptics",
  "cellStyleDataRules", "base", "statDataAnal", "physicsGeneral",
  "inputDataForRICH", "RICH"
};
expectedNotebookRoles = Join[
  ConstantArray["interactive-top-level", 3],
  ConstantArray["package-bootstrap", 6]
];
paths = FileNameJoin[{root, "notebooks", # <> ".nb"}] & /@ notebookCases;
expressions = Quiet @ Check[Get /@ paths, $Failed];
If[
  expressions === $Failed ||
    Length[expressions] =!= Length[notebookCases] ||
    ! And @@ (MatchQ[#, _Notebook] & /@ expressions),
  fail["Could not parse all managed working notebooks."]
];

cells = bootstrapCells /@ expressions;
If[
  Length /@ cells =!= ConstantArray[1, Length[notebookCases]],
  fail["Each notebook must contain exactly one universal bootstrap cell."]
];
bodies = (First[#] /. Cell[content_, ___] :> content) & /@ cells;
If[! SameQ @@ bodies,
  fail["Universal bootstrap cell bodies are not structurally identical."]
];
If[
  projectCase /@ expressions =!= notebookCases,
  fail["Notebook project-case TaggingRules are missing or incorrect."]
];
If[
  notebookRole /@ expressions =!= expectedNotebookRoles,
  fail["Notebook role TaggingRules are missing or incorrect."]
];
If[
  notebookTag[#, "RICHSourceFile"] & /@ expressions =!=
    (FileNameJoin[{"src", # <> ".wl"}] & /@ notebookCases),
  fail["Notebook source-file TaggingRules are missing or incorrect."]
];
If[
  ! And @@ Map[
    Function[expression,
      MatchQ[First[expression], cells_List /; Length[cells] >= 3] &&
        ! FreeQ[First[First[expression]], "RICHNotebookHeader"] &&
        ! FreeQ[First[expression][[2]], "RICHNotebookSetup"] &&
        ! FreeQ[First[expression][[3]], "RICHUniversalBootstrap"]
    ],
    expressions
  ],
  fail["A managed notebook does not begin with the canonical three-cell opening."]
];
packageInitializationCells = Cases[
    #,
    Cell[_, ("Input" | "Code"), cellOptions___] /;
      ! FreeQ[{cellOptions}, InitializationCell -> True],
    Infinity
  ] & /@ Pick[expressions, expectedNotebookRoles, "package-bootstrap"];
If[
  Length /@ packageInitializationCells =!= ConstantArray[1, 6],
  fail["A package-bootstrap notebook contains executable initialization beyond the universal bootstrap."]
];
interactiveInitializationCells = Cases[
    #,
    Cell[_, ("Input" | "Code"), cellOptions___] /;
      ! FreeQ[{cellOptions}, InitializationCell -> True],
    Infinity
  ] & /@ Take[expressions, 3];
If[
  Length /@ interactiveInitializationCells =!= ConstantArray[1, 3],
  fail[
    "An interactive top-level notebook contains executable initialization " <>
      "beyond the universal bootstrap."
  ]
];
calculatorNotebookText = ToString[
  First[expressions],
  InputForm,
  PageWidth -> Infinity
];
If[
  StringContainsQ[calculatorNotebookText, "CALCULATOR INIT"] ||
    ! StringContainsQ[calculatorNotebookText, "CALCULATOR BODY"] ||
    ! StringContainsQ[
      calculatorNotebookText,
      "UNFINISHED - WORK IN PROGRESS"
    ],
  fail[
    "calculator.nb must omit calculator initialization while retaining " <>
      "CALCULATOR BODY and every later top-level section."
  ]
];
If[
  ! FreeQ[expressions, "RICHProjectEarlyLoad"] ||
    ! FreeQ[expressions, "RICHOpticsInitialization"],
  fail["An obsolete notebook-specific bootstrap cell is still present."]
];

loader = FileNameJoin[{root, "src", "LoadProject.wl"}];
loadResult = Block[
  {$RICHProjectSkipAutoLoad = True},
  Quiet @ Check[Get[loader], $Failed]
];
If[loadResult === $Failed || ! NameQ["RICHNotebookBootstrap"],
  fail["LoadProject.wl did not define the universal bootstrap API."]
];
If[
  ! FreeQ[
    DownValues[LoadRICHFiles],
    HoldPattern[Check[Get[___], $Failed]],
    Infinity
  ],
  fail["LoadRICHFiles still converts ordinary component messages to failure."]
];
If[Quiet @ Check[RICHBootstrap[], $Failed] =!= True,
  fail["The common package bootstrap failed in a clean kernel."]
];
If[! MemberQ[$Packages, "myNotebookInit`"],
  fail["RICHBootstrap[] did not load myNotebookInit`."]
];
If[
  Last @ Lookup[$RICHProjectComponents, "calculator", {}] =!=
    "calculator.wl",
  fail["The calculator loader profile does not end with calculator.wl."]
];
If[
  ! And @@ (NameQ /@ {
    "myNotebookInit`installDockedCells",
    "myNotebookInit`removeDockedCells",
    "myNotebookInit`pushHistory",
    "myNotebookInit`goBack"
  }),
  fail["The merged myNotebookInit docked-cell API is incomplete."]
];
If[AnyTrue[{"Global`navHistory", "Global`pushHistory", "Global`goBack"}, NameQ],
  fail["Loading myNotebookInit leaked docked-cell navigation symbols into Global`."]
];
If[! FreeQ[$RICHProjectComponents, "myDockedCells.wl"],
  fail["A project profile still loads the retired myDockedCells.wl file."]
];
If[
  Sort[richDockedCellCases] =!=
    Sort[{"calculator", "optics", "geometricalOptics"}],
  fail["The optional docked-cell case list is incorrect."]
];
toolbarCell = Quiet @ Check[
  myNotebookInit`Private`dockedCellsToolbar[],
  $Failed
];
If[
  toolbarCell === $Failed ||
    ! MatchQ[toolbarCell, _Cell] ||
    FreeQ[toolbarCell, HoldPattern[myNotebookInit`cellStylesScannerPalette], Heads -> True] ||
    FreeQ[toolbarCell, HoldPattern[myNotebookInit`cellStylesEditorPalette], Heads -> True] ||
    FreeQ[toolbarCell, HoldPattern[myNotebookInit`pushHistory], Heads -> True] ||
    FreeQ[toolbarCell, HoldPattern[myNotebookInit`goBack], Heads -> True],
  fail["The merged docked-cell toolbar is malformed or has unqualified navigation callbacks."]
];
If[
  ! RICHFrontEndAvailableQ[] &&
    Quiet[myNotebookInit`installDockedCells[]] =!= $Failed,
  fail["installDockedCells[] did not reject a headless kernel."]
];
(* Exercise explicit tracking with an inert fixture. Native Save As baselines
   are archival validation inputs and must never be evaluated. *)
If[
  Quiet @ Check[
    LoadRICHFiles[{FileNameJoin[{"validation", "load-tracker-fixture.wls"}]}],
    $Failed
  ] =!= True,
  fail["LoadRICHFiles could not load the tracker test component."]
];
trackerRows = Quiet @ Check[
  Normal[myNotebookInit`summarizeLoads[]],
  {}
];
trackerTargets = Lookup[trackerRows, "Target", {}];
trackerCounts = Counts[FileNameTake /@ Select[trackerTargets, StringQ]];
If[
  Lookup[trackerCounts, "myNotebookInit.wl", 0] =!= 1 ||
    Lookup[trackerCounts, "load-tracker-fixture.wls", 0] =!= 1,
  fail[
    "LoadRICHFiles did not explicitly record both bootstrap and component loads."
  ]
];
If[Quiet[RICHNotebookBootstrap[""]] =!= $Failed,
  fail["RICHNotebookBootstrap accepted an empty project case."]
];

ClearAll[Global`universalBootstrapScratch];
Global`universalBootstrapScratch = 42;
Protect[Global`universalBootstrapScratch];
If[
  myNotebookInit`clearAllProtected[Global`universalBootstrapScratch] =!= Null ||
    OwnValues[Global`universalBootstrapScratch] =!= {} ||
    MemberQ[Attributes[Global`universalBootstrapScratch], Protected],
  fail["clearAllProtected did not safely clear a protected project symbol."]
];
If[
  Quiet[myNotebookInit`clearAllProtected[System`Plot]] =!= $Failed ||
    ! MemberQ[Attributes[System`Plot], Protected],
  fail["clearAllProtected did not reject a protected System symbol."]
];
ClearAll[
  Global`universalBootstrapScratchA,
  Global`universalBootstrapScratchB
];
Global`universalBootstrapScratchA = 1;
Global`universalBootstrapScratchB = 2;
Protect[
  Global`universalBootstrapScratchA,
  Global`universalBootstrapScratchB
];
If[
  myNotebookInit`clearAllProtected[{
    Global`universalBootstrapScratchA,
    Global`universalBootstrapScratchB
  }] =!= {Null, Null} ||
    OwnValues[Global`universalBootstrapScratchA] =!= {} ||
    OwnValues[Global`universalBootstrapScratchB] =!= {},
  fail["clearAllProtected did not preserve legacy list threading."]
];

Print["Universal bootstrap check passed."];
