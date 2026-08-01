(* Project loader for WolframMMAProjectRICH-Git. *)
ClearAll[$RICHProjectRoot, RICHProjectPath, LoadRICHProject];
$RICHProjectRoot = ParentDirectory[DirectoryName[$InputFileName]];
RICHProjectPath[parts__String] := FileNameJoin[{$RICHProjectRoot, parts}];

LoadRICHProject[] := Module[{oldDirectory = Directory[], src, files, missing},
  src = RICHProjectPath["src"];
  files = {
    "myNotebookInit.wl", "myDockedCells.wl", "CellStyleDataRules.wl",
    "base.wl", "statDataAnal.wl", "physics-general.wl",
    "inputDataForRICH.wl", "RICH.wl", "calculator-reboot.wl"
  };
  missing = Select[FileNameJoin[{src, #}] & /@ files, Not@*FileExistsQ];
  If[missing =!= {}, Print["Project load aborted. Missing files:", Column[missing]]; Return[$Failed]];
  Internal`WithLocalSettings[
    SetDirectory[src]; If[! MemberQ[$Path, src], AppendTo[$Path, src]],
    Scan[Get[FileNameJoin[{src, #}]] &, files],
    SetDirectory[oldDirectory]
  ];
  True
];
LoadRICHProject[];
