(* Install the shared bootstrap cell in the working top-level notebooks.
   The project case lives in notebook TaggingRules, so the executable block is
   byte-for-byte identical in every notebook. *)

ClearAll[
  topLevelTitleItemQ, bootstrapCell, mergeTaggingRules,
  replaceLeadingTitleSections, installOne
];

topLevelTitleItemQ[Cell[_, "Title", ___]] := True;
topLevelTitleItemQ[
  Cell[CellGroupData[{Cell[_, "Title", ___], ___}, ___], ___]
] := True;
topLevelTitleItemQ[_] := False;

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

mergeTaggingRules[options_List, projectCase_String] := Module[
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
  Join[association, <|"RICHProjectCase" -> projectCase|>]
];

replaceLeadingTitleSections[
  expression_Notebook,
  projectCase_String,
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
      Take[cells, positions[[1]] - 1],
      {
        Cell[
          "---... SETUP",
          "Title",
          InitializationCell -> False,
          Background -> RGBColor[0.88, 1, 0.88]
        ],
        bootstrapCell[]
      },
      Drop[cells, finish]
    ]
  ];
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
  optionList = {options};
  taggingRules = mergeTaggingRules[optionList, projectCase];
  Notebook[
    retained,
    Sequence @@ DeleteCases[optionList, HoldPattern[TaggingRules -> _], {1}],
    TaggingRules -> taggingRules
  ]
];

installOne[path_String, projectCase_String, sectionCount_Integer] := Module[
  {original, updated, verified, verifiedCase},
  Print["Installing universal bootstrap: ", path, " -> ", projectCase];
  original = Quiet @ Check[Get[path], $Failed];
  If[original === $Failed, Return[$Failed]];
  updated = replaceLeadingTitleSections[original, projectCase, sectionCount];
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

root = DirectoryName[DirectoryName[$InputFileName]];
results = {
  installOne[
    FileNameJoin[{root, "notebooks", "calculator.nb"}],
    "calculator",
    1
  ],
  installOne[
    FileNameJoin[{root, "notebooks", "optics.nb"}],
    "optics",
    2
  ]
};

If[results === {True, True},
  Print["Universal bootstrap installed in both notebooks."],
  Print["Bootstrap installation failed: ", results];
  Exit[2]
];
