(* Project loader for WolframMMAProjectRICH-Git. *)
ClearAll[
  $RICHProjectRoot, $RICHProjectStyleDefinitions, $RICHProjectComponents,
  $RICHPathSettings, $RICHPathConfigFile,
  RICHProjectPath, RICHDefaultPathSettings, RICHNormalizePathSettings,
  RICHLoadPathSettings, RICHSavePathSettings, RICHSetPathSettings,
  RICHPathSetting, RICHEnsureDirectory, RICHPathUnder,
  RICHOutputPath, RICHBackupPath, RICHTemporaryPath,
  RICHFrontEndAvailableQ, RICHPathSettingsPanel, configureRICHPaths,
  $RICHNotebookDefaultSettings,
  RICHBootstrap, RICHNotebookBootstrap,
  LoadRICHFiles, LoadRICHCase, LoadRICHProject
];
$RICHProjectRoot = ParentDirectory[DirectoryName[$InputFileName]];
RICHProjectPath[parts__String] := FileNameJoin[{$RICHProjectRoot, parts}];
$RICHProjectStyleDefinitions = With[
  {localStyleSheet = RICHProjectPath["myStyle.nb"]},
  If[FileExistsQ[localStyleSheet], localStyleSheet, "myStyle.nb"]
];

$RICHPathConfigFile = FileNameJoin[{
  $UserBaseDirectory, "ApplicationData", "WolframMMAProjectRICH", "paths.json"
}];

RICHDefaultPathSettings[] := <|
  "OutputDirectory" -> RICHProjectPath["output"],
  "BackupDirectory" -> RICHProjectPath["backups"],
  "TemporaryDirectory" ->
    FileNameJoin[{$TemporaryDirectory, "WolframMMAProjectRICH"}]
|>;

RICHNormalizePathSettings[settings_] := Module[{defaults, supplied},
  defaults = RICHDefaultPathSettings[];
  supplied = If[AssociationQ[settings], KeyTake[settings, Keys[defaults]], <||>];
  supplied = Association @ KeyValueMap[
    If[StringQ[#2] && StringLength[StringTrim[#2]] > 0,
      #1 -> ExpandFileName[#2],
      Nothing
    ] &,
    supplied
  ];
  Join[defaults, supplied]
];

RICHLoadPathSettings[] := Module[{stored},
  stored = If[FileExistsQ[$RICHPathConfigFile],
    Quiet @ Check[Import[$RICHPathConfigFile, "RawJSON"], <||>],
    <||>
  ];
  $RICHPathSettings = RICHNormalizePathSettings[stored]
];

RICHSavePathSettings[] := Module[{configDirectory, result},
  configDirectory = DirectoryName[$RICHPathConfigFile];
  If[! DirectoryQ[configDirectory],
    Quiet @ Check[
      CreateDirectory[configDirectory, CreateIntermediateDirectories -> True],
      Return[$Failed]
    ]
  ];
  result = Quiet @ Check[
    Export[$RICHPathConfigFile, $RICHPathSettings, "RawJSON"],
    $Failed
  ];
  If[result === $Failed, $Failed, $RICHPathConfigFile]
];

RICHSetPathSettings[settings_Association, persist_: True] := Module[{saveResult},
  $RICHPathSettings = RICHNormalizePathSettings[settings];
  Scan[RICHEnsureDirectory, Keys[$RICHPathSettings]];
  saveResult = If[TrueQ[persist], RICHSavePathSettings[], None];
  If[TrueQ[persist] && saveResult === $Failed, Return[$Failed]];
  $RICHPathSettings
];

RICHPathSetting[key_String] := Lookup[
  $RICHPathSettings,
  key,
  Missing["UnknownRICHPathSetting", key]
];

RICHEnsureDirectory::mkdir = "Could not create the configured `1` directory: `2`.";
RICHEnsureDirectory[key_String] := Module[{directory},
  directory = RICHPathSetting[key];
  If[! StringQ[directory], Return[$Failed]];
  If[! DirectoryQ[directory],
    Quiet @ Check[
      CreateDirectory[directory, CreateIntermediateDirectories -> True],
      Message[RICHEnsureDirectory::mkdir, key, directory];
      Return[$Failed]
    ]
  ];
  directory
];

RICHPathUnder[key_String, parts_List] := Module[{root, path, parent},
  root = RICHEnsureDirectory[key];
  If[! StringQ[root], Return[$Failed]];
  path = FileNameJoin[Join[{root}, parts]];
  parent = DirectoryName[path];
  If[! DirectoryQ[parent],
    Quiet @ Check[
      CreateDirectory[parent, CreateIntermediateDirectories -> True],
      Return[$Failed]
    ]
  ];
  path
];

RICHOutputPath[parts__String] :=
  RICHPathUnder["OutputDirectory", {parts}];
RICHBackupPath[parts__String] :=
  RICHPathUnder["BackupDirectory", {parts}];
RICHTemporaryPath[parts__String] :=
  RICHPathUnder["TemporaryDirectory", {parts}];

RICHFrontEndAvailableQ[] := TrueQ[$Notebooks] && MatchQ[
  Quiet @ Check[EvaluationNotebook[], $Failed],
  _NotebookObject
];

RICHPathSettingsPanel[] := Panel @ Column[{
  Style["RICH project paths", Bold],
  Grid[{
    {"Output:", Dynamic @ RICHPathSetting["OutputDirectory"]},
    {"Backups:", Dynamic @ RICHPathSetting["BackupDirectory"]},
    {"Temporary:", Dynamic @ RICHPathSetting["TemporaryDirectory"]}
  }, Alignment -> Left],
  Row[{
    Button["Configure paths...", configureRICHPaths[], Method -> "Queued"],
    Spacer[8],
    Button[
      "Open output",
      With[{directory = RICHEnsureDirectory["OutputDirectory"]},
        If[StringQ[directory], SystemOpen[directory]]
      ],
      Method -> "Queued"
    ]
  }]
}];

configureRICHPaths[] := Module[{},
  If[! RICHFrontEndAvailableQ[],
    Print["configureRICHPaths[] requires the Wolfram Front End."];
    Return[$Failed]
  ];
  CreatePalette[
    DynamicModule[{settings = Association[$RICHPathSettings], status = ""},
      Column[{
        Style["RICH project path settings", 16, Bold],
        Grid[{
          {
            "Output", InputField[Dynamic[settings["OutputDirectory"]], String, FieldSize -> 48],
            Button["Choose...",
              With[{chosen = SystemDialogInput["Directory", settings["OutputDirectory"]]},
                If[StringQ[chosen], settings["OutputDirectory"] = chosen]
              ], Method -> "Queued"]
          },
          {
            "Backups", InputField[Dynamic[settings["BackupDirectory"]], String, FieldSize -> 48],
            Button["Choose...",
              With[{chosen = SystemDialogInput["Directory", settings["BackupDirectory"]]},
                If[StringQ[chosen], settings["BackupDirectory"] = chosen]
              ], Method -> "Queued"]
          },
          {
            "Temporary", InputField[Dynamic[settings["TemporaryDirectory"]], String, FieldSize -> 48],
            Button["Choose...",
              With[{chosen = SystemDialogInput["Directory", settings["TemporaryDirectory"]]},
                If[StringQ[chosen], settings["TemporaryDirectory"] = chosen]
              ], Method -> "Queued"]
          }
        }, Alignment -> Left],
        Row[{
          Button["Project defaults",
            settings = RICHDefaultPathSettings[];
            status = "Project defaults selected."],
          Spacer[8],
          Button["Use Wolfram temporary output",
            settings["OutputDirectory"] =
              FileNameJoin[{$TemporaryDirectory, "WolframMMAProjectRICH", "output"}];
            status = "Temporary output selected."],
          Spacer[8],
          Button["Save",
            If[AssociationQ[RICHSetPathSettings[settings, True]],
              status = "Saved to " <> $RICHPathConfigFile,
              status = "Could not save path settings."
            ], Method -> "Queued"]
        }],
        Dynamic @ Style[status, Darker[Green]],
        Style[
          "Choices are stored per user; the project defaults remain portable.",
          Smaller, Gray
        ]
      }, Spacings -> 1.2]
    ],
    WindowTitle -> "RICH paths",
    Saveable -> False
  ]
];

RICHLoadPathSettings[];
Scan[RICHEnsureDirectory, Keys[$RICHPathSettings]];

Unprotect[$dirBackup, $dirSWRoot, $dirSW, $dirSave, $dirOut];
ClearAll[$dirBackup, $dirSWRoot, $dirSW, $dirSave, $dirOut];
$dirBackup := RICHPathSetting["BackupDirectory"];
$dirSWRoot := $RICHProjectRoot;
$dirSW := RICHProjectPath["src"];
$dirSave := RICHPathSetting["BackupDirectory"];
$dirOut := RICHPathSetting["OutputDirectory"];
Protect[$dirBackup, $dirSWRoot, $dirSW, $dirSave, $dirOut];

If[RICHFrontEndAvailableQ[], Print[RICHPathSettingsPanel[]]];

$RICHProjectComponents = <|
  "base" -> {
    "myNotebookInit.wl", "CellStyleDataRules.wl", "base.wl"
  },
  "physicsGeneral" -> {
    "myNotebookInit.wl", "CellStyleDataRules.wl", "base.wl",
    "physicsGeneral.wl"
  },
  "statDataAnal" -> {
    "myNotebookInit.wl", "CellStyleDataRules.wl", "base.wl",
    "statDataAnal.wl"
  },
  "inputDataForRICH" -> {
    "myNotebookInit.wl", "CellStyleDataRules.wl", "base.wl",
    "inputDataForRICH.wl"
  },
  "RICH-source" -> {
    "myNotebookInit.wl", "myDockedCells.wl", "CellStyleDataRules.wl",
    "base.wl", "statDataAnal.wl", "physicsGeneral.wl",
    "inputDataForRICH.wl", "RICH.wl"
  },
  "calculator" -> {
    "myNotebookInit.wl", "myDockedCells.wl", "CellStyleDataRules.wl",
    "base.wl", "statDataAnal.wl", "physicsGeneral.wl",
    "inputDataForRICH.wl", "RICH.wl"
  },
  "optics" -> {
    "myDockedCells.wl", "CellStyleDataRules.wl",
    "base.wl", "statDataAnal.wl", "physicsGeneral.wl",
    "inputDataForRICH.wl", "RICH.wl", "optics.wl"
  },
  "CellStyleDataRules-source" -> {
    "CellStyleDataRules.wl"
  }
|>;

$RICHNotebookDefaultSettings = {
  "visual", "window", "title", "privateNotebookOptions",
  "showCellLabelOff", "autoGeneratedPackageNone",
  "autoMultiplicationSymbol", "initializationCellHandling",
  "outputSizeLimit", "dynamicUpdatingNotebook"
};

LoadRICHFiles::load = "Project component failed while loading: `1`.";
LoadRICHFiles[files_List] := Module[
  {oldDirectory = Directory[], src, requested, missing, loadResult,
   frontEndAvailable, componentPath, trackerReady, componentResult},
  src = RICHProjectPath["src"];
  frontEndAvailable = RICHFrontEndAvailableQ[];
  (* RICHBootstrap loads myNotebookInit first. Avoid evaluating that package a
     second time when a case also lists it as a direct dependency: reloading it
     resets its explicit load log and other session bookkeeping. *)
  requested = If[
    MemberQ[$Packages, "myNotebookInit`"],
    DeleteCases[files, "myNotebookInit.wl"],
    files
  ];
  (* Docked cells and cell-style rules are Front End concerns and fail in
     standalone kernels even on installations where $Notebooks is True. *)
  If[! frontEndAvailable,
    requested = DeleteCases[
      requested,
      "myDockedCells.wl" | "CellStyleDataRules.wl"
    ]
  ];
  missing = Select[FileNameJoin[{src, #}] & /@ requested, Not@*FileExistsQ];
  If[missing =!= {}, Print["Project load aborted. Missing files:", Column[missing]]; Return[$Failed]];
  Internal`WithLocalSettings[
    SetDirectory[src]; If[! MemberQ[$Path, src], AppendTo[$Path, src]],
    (* Some legacy-derived components change Directory[] while loading.
       Re-anchor each component at src so later dependency lookups stay local. *)
    Block[{
      Global`$RICHProjectManagedLoad = True,
      $Notebooks = frontEndAvailable
    },
      loadResult = Catch[
        Scan[
          Function[file,
            SetDirectory[src];
            componentPath = FileNameJoin[{src, file}];
            trackerReady = NameQ["myNotebookInit`recordExternalLoad"];
            If[trackerReady,
              myNotebookInit`recordExternalLoad["Get", componentPath]
            ];
            (* Ordinary messages from legacy components remain visible but do
               not imply load failure. Only the actual Get result or an abort
               determines whether this component failed. *)
            componentResult = CheckAbort[
              Get[componentPath],
              $Aborted
            ];
            If[
              MemberQ[{$Failed, $Aborted}, componentResult],
              Message[LoadRICHFiles::load, file];
              Throw[$Failed]
            ]
          ],
          requested
        ];
        True
      ]
    ],
    SetDirectory[oldDirectory]
  ];
  loadResult
];

RICHBootstrap[] := Module[{loaded},
  loaded = LoadRICHFiles[{"myNotebookInit.wl"}];
  If[loaded =!= True, Return[$Failed]];
  If[RICHFrontEndAvailableQ[],
    $HistoryLength = 100;
    myNotebookInit`applySettings[$RICHNotebookDefaultSettings];
    SetOptions[EvaluationNotebook[], StyleDefinitions -> $RICHProjectStyleDefinitions]
  ];
  True
];

RICHNotebookBootstrap::badcase =
  "The notebook project case `1` is not a non-empty string.";
RICHNotebookBootstrap[case_] /; ! (StringQ[case] && StringLength[StringTrim[case]] > 0) := (
  Message[RICHNotebookBootstrap::badcase, HoldForm[case]];
  $Failed
);

RICHNotebookBootstrap[case_String] := Module[{loaded},
  Global`$RICHProjectCase = case;

  loaded = RICHBootstrap[];
  If[loaded =!= True, Return[$Failed]];

  loaded = LoadRICHCase[case];
  If[loaded =!= True, Return[$Failed]];

  (* These defaults were common to the legacy optics and calculator setup
     blocks. Apply them only for interactive notebooks, after dependencies
     have loaded, so component-local defaults cannot silently replace them. *)
  If[RICHFrontEndAvailableQ[],
    SetOptions[
      {LogPlot, Plot, Graphics, ListPlot, Histogram},
      Ticks -> {Automatic, Automatic},
      AxesOrigin -> {0, 0}
    ];
    SetOptions[
      {LogPlot, Plot, ListPlot, Histogram},
      Frame -> True,
      FrameStyle -> Directive[Black, 12],
      ImageSize -> Scaled[0.8]
    ];
    SetOptions[{Plot, ListPlot}, PlotRange -> All];
  ];

  (* Backward-compatible run tags used by both notebooks' export cells. *)
  Global`theTimeStamp = myNotebookInit`timeStamp;
  Global`t0 = AbsoluteTime[];
  Global`thisTimeStamp :=
    Global`theTimeStamp <> "--" <>
      ToString[Round[1000000 (1000000 + (AbsoluteTime[] - Global`t0))]];

  If[RICHFrontEndAvailableQ[],
    myNotebookInit`timeBanner["RICH notebook ready: " <> case]
  ];
  True
];

LoadRICHCase[case_String] := Module[{files},
  files = Lookup[$RICHProjectComponents, case, Missing["UnknownCase", case]];
  If[MissingQ[files],
    Print[
      "Unknown RICH project case: ", case,
      ". Available cases: ", Keys[$RICHProjectComponents]
    ];
    Return[$Failed]
  ];
  LoadRICHFiles[files]
];

LoadRICHProject[] := LoadRICHCase["RICH-source"];

If[! TrueQ[Global`$RICHProjectSkipAutoLoad],
  RICHNotebookBootstrap[
    SelectFirst[
      ToExpression /@ Names["*`$RICHProjectCase"],
      StringQ,
      "RICH-source"
    ]
  ]
];
