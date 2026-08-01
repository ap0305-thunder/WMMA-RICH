(* Project loader for WolframMMAProjectRICH-Git. *)
ClearAll[
  $RICHProjectRoot, $RICHProjectComponents,
  RICHProjectPath, LoadRICHFiles, LoadRICHCase, LoadRICHProject
];
$RICHProjectRoot = ParentDirectory[DirectoryName[$InputFileName]];
RICHProjectPath[parts__String] := FileNameJoin[{$RICHProjectRoot, parts}];

$RICHProjectComponents = <|
  "base" -> {
    "myNotebookInit.wl", "CellStyleDataRules.wl", "base.wl"
  },
  "physics-general" -> {
    "myNotebookInit.wl", "CellStyleDataRules.wl", "base.wl",
    "physics-general.wl"
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
    "base.wl", "statDataAnal.wl", "physics-general.wl",
    "inputDataForRICH.wl", "RICH.wl"
  },
  "calculator-reboot" -> {
    "myNotebookInit.wl", "myDockedCells.wl", "CellStyleDataRules.wl",
    "base.wl", "statDataAnal.wl", "physics-general.wl",
    "inputDataForRICH.wl", "RICH.wl", "calculator-reboot.wl"
  },
  "CellStyleDataRules-source" -> {
    "CellStyleDataRules.wl"
  }
|>;

LoadRICHFiles[files_List] := Module[
  {oldDirectory = Directory[], src, missing},
  src = RICHProjectPath["src"];
  missing = Select[FileNameJoin[{src, #}] & /@ files, Not@*FileExistsQ];
  If[missing =!= {}, Print["Project load aborted. Missing files:", Column[missing]]; Return[$Failed]];
  Internal`WithLocalSettings[
    SetDirectory[src]; If[! MemberQ[$Path, src], AppendTo[$Path, src]],
    Scan[Get[FileNameJoin[{src, #}]] &, files],
    SetDirectory[oldDirectory]
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

LoadRICHCase[
  SelectFirst[
    ToExpression /@ Names["*`$RICHProjectCase"],
    StringQ,
    "RICH-source"
  ]
];
