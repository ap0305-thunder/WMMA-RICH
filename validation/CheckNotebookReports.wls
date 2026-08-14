(* Headless structural check for the focused myNotebookInit notebook reports. *)

ClearAll[fail];
fail[message_String] := (Print["ERROR: ", message]; Exit[2]);

root = DirectoryName[DirectoryName[$InputFileName]];
packagePath = FileNameJoin[{root, "src", "myNotebookInit.wl"}];

If[Quiet @ Check[Get[packagePath], $Failed] === $Failed,
  fail["Could not load myNotebookInit.wl."]
];

reportNames = {
  "myNotebookInit`reportNotebookPaths",
  "myNotebookInit`reportCellStyleInventory",
  "myNotebookInit`reportMessageCellList"
};

If[! And @@ (NameQ /@ reportNames),
  fail["One or more public notebook-report functions are missing."]
];

If[! TrueQ[$Notebooks],
  headlessResults = Quiet[{
    myNotebookInit`reportNotebookPaths[],
    myNotebookInit`reportCellStyleInventory[],
    myNotebookInit`reportMessageCellList[]
  }];
  If[headlessResults =!= {$Failed, $Failed, $Failed},
    fail["Notebook-report functions did not fail safely without a front end."]
  ]
];

Print["Notebook report check passed."];
