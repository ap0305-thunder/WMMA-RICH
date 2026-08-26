(* Install one shared bootstrap opening in every managed working notebook.
   Case, role, and source metadata live in TaggingRules, so the executable
   bootstrap block is byte-for-byte identical in every notebook. *)

ClearAll[
  topLevelTitleItemQ, notebookHeaderCell, setupCell, bootstrapCell,
  mergeTaggingRules, removeTopLevelTitleSectionContaining,
  replaceLeadingTitleSections,
  stripPackageInitializationItem, normalizePackageNotebook,
  installOne, installPackageOne
];

notebookHeaderCell[projectCase_String, role_String] := Cell[
  "RICH project notebook: " <> projectCase <> ". Role: " <> role <>
    ". Runtime source: src/" <> projectCase <> ".wl.",
  "Text",
  Background -> If[
    role === "interactive-top-level",
    RGBColor[1., 1., 0.6],
    RGBColor[0.92, 0.97, 1.]
  ],
  CellTags -> {"RICHNotebookHeader"}
];

setupCell[] := Cell[
  "---... SETUP",
  "Title",
  InitializationCell -> False,
  Background -> RGBColor[0.88, 1, 0.88],
  CellTags -> {"RICHNotebookSetup"}
];

topLevelTitleItemQ[Cell[_, "Title", ___]] := True;
topLevelTitleItemQ[
  Cell[CellGroupData[{Cell[_, "Title", ___], ___}, ___], ___]
] := True;
topLevelTitleItemQ[_] := False;

removeTopLevelTitleSectionContaining[
  expression_Notebook,
  marker_String
] := expression /. Notebook[cells_List, options___] :> Module[
  {titlePositions, matchingSections, ranges, removalIndices},
  titlePositions = Flatten @ Position[topLevelTitleItemQ /@ cells, True, {1}];
  matchingSections = Select[
    Range[Length[titlePositions]],
    StringContainsQ[
      ToString[
        cells[[titlePositions[[#]]]],
        InputForm,
        PageWidth -> Infinity
      ],
      marker
    ] &
  ];
  If[matchingSections === {}, Return[Notebook[cells, options]]];
  ranges = Function[section,
    With[{
      start = titlePositions[[section]],
      finish = If[
        section < Length[titlePositions],
        titlePositions[[section + 1]] - 1,
        Length[cells]
      ]
    },
      Range[start, finish]
    ]
  ] /@ matchingSections;
  removalIndices = DeleteDuplicates @ Flatten[ranges];
  Notebook[Delete[cells, List /@ removalIndices], options]
];

bootstrapCell[] := Module[{held, boxes},
  held = HoldComplete[
    Module[
      {notebook, notebookDirectory, projectCase, loader, loadResult},
      notebook = EvaluationNotebook[];
      projectCase = CurrentValue[
        notebook,
        {TaggingRules, "RICHProjectCase"}
      ];
      notebookDirectory = Quiet @ Check[
        NotebookDirectory[notebook],
        $Failed
      ];
      If[! StringQ[notebookDirectory],
        Print[
          "RICH bootstrap failed: save the notebook inside the project's ",
          "notebooks directory before evaluating initialization cells."
        ];
        Return[$Failed]
      ];
      loader = FileNameJoin[{
        ParentDirectory[notebookDirectory], "src", "LoadProject.wl"
      }];
      If[! FileExistsQ[loader],
        Print["RICH bootstrap failed: project loader not found at ", loader];
        Return[$Failed]
      ];
      loadResult = Block[
        {$RICHProjectSkipAutoLoad = True},
        Check[Get[loader], $Failed]
      ];
      If[loadResult === $Failed, Return[$Failed]];
      RICHNotebookBootstrap[projectCase]
    ]
  ];
  boxes = held /. HoldComplete[expression_] :>
    ToBoxes[Unevaluated[expression], StandardForm];
  Cell[
    BoxData[boxes],
    "Input",
    InitializationCell -> True,
    CellTags -> {"RICHUniversalBootstrap", "i:1"}
  ]
];

mergeTaggingRules[
  options_List,
  projectCase_String,
  role_String
] := Module[
  {old, association},
  old = FirstCase[
    options,
    HoldPattern[TaggingRules -> value_] :> value,
    <||>,
    {1}
  ];
  association = Which[
    AssociationQ[old], old,
    MatchQ[old, {(_Rule | _RuleDelayed) ...}], Association[old],
    True, <||>
  ];
  Join[association, <|
    "RICHProjectCase" -> projectCase,
    "RICHNotebookRole" -> role,
    "RICHSourceFile" -> FileNameJoin[{"src", projectCase <> ".wl"}]
  |>]
];

replaceLeadingTitleSections[
  expression_Notebook,
  projectCase_String,
  role_String,
  sectionCount_Integer?Positive
] := expression /. Notebook[cells_List, options___] :> Module[
  {positions, finish, retained, optionList, taggingRules},
  retained = If[! FreeQ[cells, "RICHUniversalBootstrap"],
    cells,
    positions = Flatten @ Position[topLevelTitleItemQ /@ cells, True, {1}];
    If[Length[positions] <= sectionCount,
      Return[Failure[
        "InsufficientTitleSections",
        <|"Found" -> Length[positions], "Requested" -> sectionCount|>
      ]]
    ];
    finish = positions[[sectionCount + 1]] - 1;
    Join[
      DeleteCases[
        stripPackageInitializationItem /@
          Take[cells, positions[[1]] - 1],
        Nothing
      ],
      {
        setupCell[],
        bootstrapCell[]
      },
      Drop[cells, finish]
    ]
  ];
  (* Reinstall the canonical box tree even when a tagged bootstrap already
     exists. Front-end edits can preserve identical executable code with
     different whitespace RowBox nodes, defeating the strict structural check. *)
  retained = retained /. cell : Cell[_, ("Input" | "Code"), cellOptions___] /;
      ! FreeQ[
        Unevaluated[Cell[Null, "Input", cellOptions]],
        "RICHUniversalBootstrap"
      ] :> bootstrapCell[];
  retained = retained /. Cell[
      text_String /; StringStartsQ[
        text,
        "The first initialization cell bootstraps this notebook"
      ],
      "Text",
      cellOptions___
    ] :> Cell[
      "The universal initialization cell reads this notebook's project case " <>
      "from TaggingRules, loads src/LoadProject.wl, applies the shared " <>
      "notebook defaults, and then loads the case dependencies. The " <>
      "CALCULATOR BODY remains interactive.",
      "Text",
      cellOptions
    ];
  retained = DeleteCases[
    retained,
    item_ /; ! FreeQ[item, Alternatives[
      "RICHUniversalBootstrap", "RICHNotebookHeader", "RICHNotebookSetup"
    ]],
    {1}
  ];
  positions = Flatten @ Position[topLevelTitleItemQ /@ retained, True, {1}];
  If[positions =!= {},
    retained = Join[
      DeleteCases[
        stripPackageInitializationItem /@
          Take[retained, First[positions] - 1],
        Nothing
      ],
      Drop[retained, First[positions] - 1]
    ]
  ];
  retained = Join[
    {notebookHeaderCell[projectCase, role], setupCell[], bootstrapCell[]},
    retained
  ];
  optionList = {options};
  taggingRules = mergeTaggingRules[optionList, projectCase, role];
  Notebook[
    retained,
    Sequence @@ DeleteCases[optionList, HoldPattern[TaggingRules -> _], {1}],
    TaggingRules -> taggingRules
  ]
];

stripPackageInitializationItem[
  Cell[_, ("Input" | "Code"), cellOptions___]
] /; ! FreeQ[{cellOptions}, InitializationCell -> True] := Nothing;

stripPackageInitializationItem[
  Cell[CellGroupData[groupCells_List, state___], cellOptions___]
] := Module[{retained},
  retained = DeleteCases[
    stripPackageInitializationItem /@ groupCells,
    Nothing
  ];
  If[
    retained === {},
    Nothing,
    Cell[CellGroupData[retained, state], cellOptions]
  ]
];

stripPackageInitializationItem[item_] := item;

normalizePackageNotebook[
  expression_Notebook,
  projectCase_String,
  role_String
] := expression /. Notebook[cells_List, options___] :> Module[
  {retained, optionList, taggingRules},
  retained = DeleteCases[
    stripPackageInitializationItem /@ cells,
    Nothing
  ];
  retained = DeleteCases[
    retained,
    item_ /; ! FreeQ[item, Alternatives[
      "RICHUniversalBootstrap", "RICHNotebookHeader", "RICHNotebookSetup"
    ]],
    {1}
  ];
  optionList = {options};
  taggingRules = mergeTaggingRules[optionList, projectCase, role];
  Notebook[
    Join[
      {notebookHeaderCell[projectCase, role], setupCell[], bootstrapCell[]},
      retained
    ],
    Sequence @@ DeleteCases[
      optionList,
      HoldPattern[TaggingRules -> _],
      {1}
    ],
    TaggingRules -> taggingRules
  ]
];

installOne[
  path_String,
  projectCase_String,
  role_String,
  sectionCount_Integer,
  removeSectionMarker_: None
] := Module[
  {original, updated, verified, verifiedCase},
  Print["Installing universal bootstrap: ", path, " -> ", projectCase];
  original = Quiet @ Check[Get[path], $Failed];
  If[original === $Failed, Return[$Failed]];
  If[StringQ[removeSectionMarker],
    original = removeTopLevelTitleSectionContaining[
      original,
      removeSectionMarker
    ]
  ];
  updated = replaceLeadingTitleSections[
    original, projectCase, role, sectionCount
  ];
  If[FailureQ[updated], Print[updated]; Return[$Failed]];
  Put[updated, path];
  verified = Quiet @ Check[Get[path], $Failed];
  verifiedCase = If[MatchQ[verified, _Notebook],
    FirstCase[
      verified,
      Notebook[_, notebookOptions___] :> FirstCase[
        {notebookOptions},
        HoldPattern[TaggingRules -> rules_Association] :>
          Lookup[rules, "RICHProjectCase", Missing["NotFound"]],
        Missing["NotFound"],
        {1}
      ],
      Missing["NotFound"],
      {0}
    ],
    Missing["NotFound"]
  ];
  If[
    MatchQ[verified, _Notebook] &&
      ! FreeQ[verified, "RICHUniversalBootstrap"] &&
      verifiedCase === projectCase,
    True,
    Print["Written notebook failed verification: ", path];
    $Failed
  ]
];

installPackageOne[
  path_String,
  projectCase_String,
  sourcePath_String
] := Module[{original, updated, verified, bootstrapCellsForVerification},
  Print["Installing package bootstrap: ", path, " -> ", projectCase];
  original = Quiet @ Check[
    Get[If[FileExistsQ[path], path, sourcePath]],
    $Failed
  ];
  If[original === $Failed, Return[$Failed]];
  updated = normalizePackageNotebook[
    original,
    projectCase,
    "package-bootstrap"
  ];
  Put[updated, path];
  verified = Quiet @ Check[Get[path], $Failed];
  If[
    MatchQ[verified, _Notebook] &&
      Length[bootstrapCellsForVerification = Cases[
        verified,
        cell : Cell[_, ("Input" | "Code"), cellOptions___] /;
          ! FreeQ[
            Unevaluated[Cell[Null, "Input", cellOptions]],
            "RICHUniversalBootstrap"
          ] :> cell,
        Infinity
      ]] === 1,
    True,
    Print["Written package notebook failed verification: ", path];
    $Failed
  ]
];

root = DirectoryName[DirectoryName[$InputFileName]];
results = {
  installOne[
    FileNameJoin[{root, "notebooks", "calculator.nb"}],
    "calculator",
    "interactive-top-level",
    1,
    "CALCULATOR INIT"
  ],
  installOne[
    FileNameJoin[{root, "notebooks", "optics.nb"}],
    "optics",
    "interactive-top-level",
    2
  ],
  installOne[
    FileNameJoin[{root, "notebooks", "geometricalOptics.nb"}],
    "geometricalOptics",
    "interactive-top-level",
    2
  ],
  installPackageOne[
    FileNameJoin[{root, "notebooks", "cellStyleDataRules.nb"}],
    "cellStyleDataRules",
    FileNameJoin[{root, "legacy-original", "cellStyleDataRules.nb"}]
  ],
  installPackageOne[
    FileNameJoin[{root, "notebooks", "base.nb"}],
    "base",
    FileNameJoin[{root, "legacy-original", "base.nb"}]
  ],
  installPackageOne[
    FileNameJoin[{root, "notebooks", "statDataAnal.nb"}],
    "statDataAnal",
    FileNameJoin[{root, "legacy-original", "statDataAnal.nb"}]
  ],
  installPackageOne[
    FileNameJoin[{root, "notebooks", "physicsGeneral.nb"}],
    "physicsGeneral",
    FileNameJoin[{root, "legacy-original", "physicsGeneral.nb"}]
  ],
  installPackageOne[
    FileNameJoin[{root, "notebooks", "inputDataForRICH.nb"}],
    "inputDataForRICH",
    FileNameJoin[{root, "legacy-original", "inputDataForRICH.nb"}]
  ],
  installPackageOne[
    FileNameJoin[{root, "notebooks", "RICH.nb"}],
    "RICH",
    FileNameJoin[{root, "legacy-original", "RICH.nb"}]
  ]
};

If[results === ConstantArray[True, 9],
  Print["Universal bootstrap opening installed in all managed notebooks."],
  Print["Bootstrap installation failed: ", results];
  Exit[2]
];
