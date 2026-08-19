(* Structural verification for the shared optics/calculator bootstrap. *)

ClearAll[bootstrapCells, projectCase, fail];

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

projectCase[expression_Notebook] := FirstCase[
  expression,
  Notebook[_, options___] :> FirstCase[
    {options},
    HoldPattern[TaggingRules -> rules_Association] :>
      Lookup[rules, "RICHProjectCase", Missing["NotFound"]],
    Missing["NotFound"],
    {1}
  ],
  Missing["NotFound"],
  {0}
];

root = DirectoryName[DirectoryName[$InputFileName]];
paths = FileNameJoin[{root, "notebooks", # <> ".nb"}] & /@
  {"optics", "calculator"};
expressions = Quiet @ Check[Get /@ paths, $Failed];
If[expressions === $Failed || ! MatchQ[expressions, {_Notebook, _Notebook}],
  fail["Could not parse both working notebooks."]
];

cells = bootstrapCells /@ expressions;
If[Length /@ cells =!= {1, 1},
  fail["Each notebook must contain exactly one universal bootstrap cell."]
];
bodies = (First[#] /. Cell[content_, ___] :> content) & /@ cells;
If[! SameQ @@ bodies,
  fail["The two universal bootstrap cell bodies are not structurally identical."]
];
If[projectCase /@ expressions =!= {"optics", "calculator"},
  fail["Notebook project-case TaggingRules are missing or incorrect."]
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
