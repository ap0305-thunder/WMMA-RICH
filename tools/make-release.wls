#!/usr/bin/env wolframscript
(* ::Package:: *)

(* make-release.wls -- FIX 2026-11-12
   Builds a clean copy of the project for distribution, leaving the working
   copy untouched:
     - copies README.md, myStyle.nb, src/, notebooks/, data/, docs/, tests/,
       tools/ (without _save folders, *-save.nb copies, *.bak, *.xlsx,
       _to_delete folders);
     - in every copied notebook (the stylesheet myStyle.nb is copied as is) deletes the saved output (Output, Print,
       Message, Echo cells), removes the cached "NotebookPersistence" option
       and makes the myStyle.nb stylesheet reference relative to the notebook
       folder;
     - scans the copy for absolute paths and the current user's home folder
       and prints what it finds;
     - optionally zips the copy.

   Usage from a notebook:
     Get[FileNameJoin[{ParentDirectory[NotebookDirectory[]], "tools", "make-release.wls"}]];
     RICHRelease`MakeRelease[]                       (* -> output/release--<date>--<time>/ *)
     RICHRelease`MakeRelease["Zip" -> True]
     RICHRelease`MakeRelease["Destination" -> "D:\\somewhere\\RICH-release"]
   Usage from a terminal (project root):
     wolframscript -file tools/make-release.wls [destination] [-zip]
*)

BeginPackage["RICHRelease`"];

MakeRelease::usage = "MakeRelease[opts] copies the project into a release folder with notebook outputs stripped. Options: \"Destination\" (default output/release--<date>--<time>), \"Zip\" (default False), \"Include\".";
StripNotebookFile::usage = "StripNotebookFile[in, out] writes a copy of notebook in without saved output cells and cached persistence data.";
ScanForPaths::usage = "ScanForPaths[dir] lists files under dir containing absolute paths or the user's home folder.";

Begin["`Private`"];

$projectRoot = ParentDirectory[DirectoryName[$InputFileName]];

$include = {"README.md", "myStyle.nb", "src", "notebooks", "data", "docs", "tests", "tools"};

excludedQ[path_String] := Or[
  StringContainsQ[path, {"_save", "_to_delete"}],
  StringEndsQ[path, {"-save.nb", ".bak", ".xlsx", ".log"}]
];

$outputStyles = "Output" | "Print" | "Message" | "Echo" | "PrintTemporary";

relativeStyle[sd_String] /; StringEndsQ[sd, "myStyle.nb"] := FrontEnd`FileName[{ParentDirectory}, "myStyle.nb"];
relativeStyle[sd_] := sd;

stripRules = {
  Cell[_, $outputStyles, ___] :> Nothing,
  Cell[CellGroupData[{}, ___], ___] :> Nothing,
  Cell[CellGroupData[{c_Cell}, ___], ___] :> c,
  CellGroupData[c_List, {__Integer}] :> CellGroupData[c, Closed]
};

StripNotebookFile[in_String, out_String] := Module[{nb, cells, opts, n0, n1},
  nb = Import[in, "NB"];
  If[Head[nb] =!= Notebook, Return[$Failed]];
  cells = First[nb]; opts = Rest[List @@ nb];
  n0 = Count[cells, Cell[_, _String, ___], Infinity];
  cells = FixedPoint[ReplaceAll[stripRules], cells];
  n1 = Count[cells, Cell[_, _String, ___], Infinity];
  opts = DeleteCases[opts, ("NotebookPersistence" | NotebookPersistence) -> _];
  opts = Replace[opts, (StyleDefinitions -> sd_) :> (StyleDefinitions -> relativeStyle[sd]), {1}];
  Quiet[CreateDirectory[DirectoryName[out], CreateIntermediateDirectories -> True]];
  If[Export[out, Notebook[cells, Sequence @@ opts], "NB"] === $Failed, Return[$Failed]];
  <|"File" -> FileNameTake[in], "CellsBefore" -> n0, "CellsAfter" -> n1|>
];

(* drive-letter paths to user/temp folders (any number of escaped backslashes)
   and macOS/Linux home folders *)
$pathPattern := RegularExpression[
  "[A-Za-z]:(\\\\+|/)(Users|TEMP|Temp|Documents and Settings)\\b|/(Users|home)/[^/\"\\s]+/"
];

ScanForPaths[dir_String] := Module[{files, hits},
  files = Select[FileNames[{"*.wl", "*.wls", "*.m", "*.nb", "*.md", "*.json", "*.wlt", "*.py", "*.txt"}, dir, Infinity], FileType[#] === File &];
  hits = Map[
    Function[f, With[{txt = Quiet@Import[f, "Text"]},
      If[StringQ[txt],
        f -> StringCases[txt, $pathPattern | $HomeDirectory, IgnoreCase -> True],
        f -> {}
      ]]],
    files];
  Select[hits, Last[#] =!= {} &] /. (f_ -> l_) :> (StringDrop[f, StringLength[dir] + 1] -> Length[l])
];

Options[MakeRelease] = {"Destination" -> Automatic, "Zip" -> False, "Include" -> Automatic};
MakeRelease[OptionsPattern[]] := Module[
  {dest, include, sources, copied = {}, stripped = {}, rel, target, scan, zip = None},
  dest = Replace[OptionValue["Destination"], Automatic :> FileNameJoin[{$projectRoot, "output",
    "release" <> DateString[{"--", "Year", "-", "Month", "-", "Day", "--", "Hour", "Minute"}]}]];
  If[FileExistsQ[dest], Print["Destination already exists, nothing done: ", dest]; Return[$Failed]];
  include = Replace[OptionValue["Include"], Automatic -> $include];
  sources = Flatten@Map[
    With[{p = FileNameJoin[{$projectRoot, #}]},
      Which[DirectoryQ[p], Select[FileNames["*", p, Infinity], FileType[#] === File &],
        FileExistsQ[p], {p}, True, {}]] &,
    include];
  sources = Select[sources, ! excludedQ[StringDrop[#, StringLength[$projectRoot]]] &];
  CreateDirectory[dest, CreateIntermediateDirectories -> True];
  Do[
    rel = StringDrop[src, StringLength[$projectRoot] + 1];
    target = FileNameJoin[{dest, rel}];
    Quiet[CreateDirectory[DirectoryName[target], CreateIntermediateDirectories -> True]];
    If[StringEndsQ[src, ".nb"] && FileNameTake[src] =!= "myStyle.nb",
      Print["  stripping ", rel];
      AppendTo[stripped, StripNotebookFile[src, target]],
      CopyFile[src, target]; AppendTo[copied, rel]
    ],
    {src, sources}];
  scan = ScanForPaths[dest];
  If[TrueQ[OptionValue["Zip"]], zip = CreateArchive[dest, dest <> ".zip", OverwriteTarget -> False]];
  Print["Release folder: ", dest];
  Print["Notebooks stripped: ", Length[stripped], "   other files copied: ", Length[copied]];
  If[scan === {}, Print["No absolute paths found."],
    Print["Files still containing absolute paths (file -> number of matches):"]; Print[Column[scan]]];
  If[zip =!= None, Print["Archive: ", zip]];
  <|"Destination" -> dest, "Notebooks" -> stripped, "Copied" -> copied, "PathScan" -> scan, "Archive" -> zip|>
];

End[];
EndPackage[];

(* command-line entry point *)
If[Length[$ScriptCommandLine] > 0 && StringEndsQ[First[$ScriptCommandLine], "make-release.wls"],
  With[{args = Rest[$ScriptCommandLine]},
    RICHRelease`MakeRelease[
      "Destination" -> Replace[Select[args, ! StringStartsQ[#, "-"] &], {{d_, ___} :> d, {} -> Automatic}],
      "Zip" -> MemberQ[args, "-zip"]
    ]
  ]
];
