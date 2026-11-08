(* ::Package:: *)
(* RunCalculatorCheck.wls -- running check of the main code of notebooks/calculator.nb.

   Run in a fresh kernel from the project root:
       wolfram.exe -script validation\RunCalculatorCheck.wls

   1. Starts a helper front end and loads the project as the notebook bootstrap does (LoadProject.wl, "calculator").
   2. Evaluates in this kernel, cell by cell and in notebook order, every evaluatable Input/Code cell of
      notebooks/calculator.nb before the "UNFINISHED - WORK IN PROGRESS" title (bootstrap cell skipped: step 1).
      killStop aborts the current cell (as interactively); each cell is limited to 3600 s.
   3. Writes progress.log, cells.json, report.txt and (if produced) results.csv to
      validation/results/calculator-run-check--<yyyy-mm-dd--HHMM>/.
   Safety: every Export goes into the run folder (exports/); cells that would wait for keyboard/dialog input
   are skipped and reported.
   As in a notebook: the runner's own symbols live in RunCheck` (not Global`), cells are parsed and evaluated
   with $Context = "Global`", % / Out[n] refer to earlier results (In/Out line numbering is emulated), and
   NotebookDirectory[] / NotebookFileName[] answer with a stand-in folder inside the run folder, since the
   notebook is not open in a window (nothing is ever saved over notebooks/calculator.nb).
   Cell numbers (0-based) count the notebook's cells without Output/Print/Message cells; they differ
   slightly from the numbering of docs/CALCULATOR_MAP.md, so use the section path given with each cell. *)

Begin["RunCheck`"];   (* runner symbols (data, k, p, x, b, ...) must not exist in Global`: they would shadow package symbols *)

root = DirectoryName[$InputFileName, 2];
stamp = DateString[{"Year", "-", "Month", "-", "Day", "--", "Hour", "Minute"}];
outDir = FileNameJoin[{root, "validation", "results", "calculator-run-check--" <> stamp}];
Quiet @ CreateDirectory[FileNameJoin[{outDir, "exports"}], CreateIntermediateDirectories -> True];
logStream = OpenWrite[FileNameJoin[{outDir, "progress.log"}], CharacterEncoding -> "UTF-8", PageWidth -> 200];
$Output = {logStream}; $Messages = {logStream};   (* cell prints and messages go to progress.log *)
logLine[s__] := (WriteString[logStream, "\n##### " <> DateString[{"Hour", ":", "Minute", ":", "Second"}] <> "  " <>
    StringJoin[ToString /@ {s}] <> "\n"]; Flush[logStream]);
nbFile = FileNameJoin[{root, "notebooks", "calculator.nb"}];
logLine["run check started; kernel ", $Version, "; notebook MD5 ", FileHash[nbFile, "MD5", All, "HexString"]];

(* ---------- every file the run exports stays inside the run folder ---------- *)
redirectDir = FileNameJoin[{outDir, "exports"}];
(* the rule is put first: appended with :=, it would come after the built-in Export[name_String, ...] rules
   and never fire (as happened up to 2026-10-29) *)
Unprotect[Export];
DownValues[Export] = Prepend[DownValues[Export],
  HoldPattern[Export[f_String /; ! TrueQ[$inRedirect] && ! StringStartsQ[ExpandFileName[f], outDir, IgnoreCase -> True], rest___]] :>
    Block[{$inRedirect = True}, logLine["redirected export ", f]; Export[FileNameJoin[{redirectDir, FileNameTake[f]}], rest]]];
Protect[Export];

(* ---------- the notebook is not open in a window: answer with a stand-in inside the run folder ---------- *)
(* a real path would let notebook-saving helpers (e.g. saveVersionedCopy) write over notebooks/calculator.nb *)
standInDir = FileNameJoin[{outDir, "notebook-stand-in"}];
Quiet @ CreateDirectory[standInDir];
(* explicit [] and [_] rules: they replace / precede the built-in ones (a [___] rule alone is tried after them) *)
Unprotect[NotebookDirectory, NotebookFileName];
NotebookDirectory[] := standInDir; NotebookDirectory[_] := standInDir;
NotebookFileName[] := FileNameJoin[{standInDir, "calculator.nb"}]; NotebookFileName[_] := FileNameJoin[{standInDir, "calculator.nb"}];
Protect[NotebookDirectory, NotebookFileName];

(* ---------- 1+2. load the project and evaluate the main code, cell by cell, in this kernel ---------- *)
(* A front end is started as a helper (UsingFrontEnd) so that the Notation package and front-end calls work,
   but cells are evaluated by the kernel itself: driving them with NotebookEvaluate deadlocks as soon as a cell
   asks the front end for something (killStop, Cells[...], ...). The project is loaded as the bootstrap cell
   does (LoadProject.wl, case "calculator"); killStop aborts the current cell, as it does interactively. *)
levels = <|"Title" -> 1, "Subtitle" -> 2, "Subsubtitle" -> 3, "Section" -> 4, "Subsection" -> 5, "Subsubsection" -> 6|>;
leaf[Cell[CellGroupData[l_List, ___], ___]] := leaf /@ l;
leaf[c_Cell] := c;
leaf[_] := Nothing;
styleOf[Cell[_, s_String, ___]] := s;
styleOf[_] := None;
headText[Cell[c_, ___]] := StringTrim @ StringReplace[If[StringQ[c], c, ToString[c /. TextData[x_] :> x, InputForm]], "\n" -> " "];
(* Cell -> held expressions. As in a notebook, the front end produces the input text (comments removed,
   linear syntax for typeset input, like Copy As > Input Text), which is then parsed. Fallback: kernel parse of
   the boxes with comment boxes removed. *)
(* parse failures only: harmless messages while parsing (e.g. General::shdw) are not failures, as in a notebook *)
(* read from a string stream: ImportString[..., "Package"] goes through a temporary file and mis-reads
   non-ASCII characters (γ, \[Distributed], ...) *)
heldFromText[t_String] := Module[{st = StringToStream[t], r},
  r = Quiet @ ReadList[st, Hold[Expression]]; Close[st];
  If[ListQ[r] && FreeQ[r, $Failed, {1}], r, {$Failed}]];
feText[c_Cell] := Module[{r},
  r = Quiet @ FrontEndExecute[ExportPacket[c, "InputText"]];
  Which[ListQ[r] && StringQ[First[r]], First[r], StringQ[r], r,
    True, r = Quiet @ NotebookImport[Notebook[{c}], _ -> "InputText"];
      Which[StringQ[r], r, ListQ[r] && r =!= {} && AllTrue[r, StringQ], StringRiffle[r, "\n"], True, $Failed]]];
noComments[b_] := b //. {RowBox[{"(*", ___, "*)"}] :> Sequence[], "(*" | "*)" -> Sequence[]};
toHeld1[b_] := Module[{e = Quiet @ MakeExpression[noComments[b], StandardForm]}, If[MatchQ[e, _HoldComplete], {e}, {$Failed}]];
toHeld[c : Cell[s_String, ___]] := heldFromText[s];
toHeld[c : Cell[BoxData[b_], ___]] := Module[{t = feText[c], r},
  r = If[StringQ[t], heldFromText[t], {$Failed}];
  If[MemberQ[r, $Failed],
    r = If[ListQ[b], Flatten[toHeld1 /@ Select[b, ! (StringQ[#] && StringMatchQ[#, (WhitespaceCharacter | "\[IndentingNewLine]") ...]) &], 1], toHeld1[b]]];
  r];
toHeld[_] := {$Failed};
interactiveQ[h_] := ! FreeQ[h, Input | InputString | DialogInput | ChoiceDialog | SystemDialogInput | CreateDialog | NotebookEvaluate, {0, Infinity}, Heads -> True];
records = {}; t0run = AbsoluteTime[];

UsingFrontEnd @ Module[{nbExpr, cells, stop, path = ConstantArray["", 6]},
  logLine["front end available: ", $FrontEnd =!= Null];
  Global`$RICHProjectCase = "calculator";
  loadData = Block[{$Context = "Global`"}, EvaluationData[Get[FileNameJoin[{root, "src", "LoadProject.wl"}]]]];
  logLine["project load: ", Length[loadData["MessagesText"]], " messages; packages ",
    Select[$Packages, MemberQ[{"myNotebookInit`", "base`", "statDataAnal`", "physicsGeneral`", "inputDataForRICH`", "rich`", "calculator`"}, #] &]];
  Unprotect[myNotebookInit`killStop]; ClearAll[myNotebookInit`killStop];
  myNotebookInit`killStop := (Print["killStop reached: cell aborted"]; Abort[]);
  nbExpr = Get[nbFile];
  cells = Select[Flatten[{leaf /@ First[nbExpr]}], ! MemberQ[{"Output", "Print", "Message", "MSG", "Echo", "EchoTiming", "EchoBefore", "EchoAfter", "PrintTemporary", None}, styleOf[#]] &];
  stop = SelectFirst[Range[Length[cells]], styleOf[cells[[#]]] === "Title" && StringContainsQ[headText[cells[[#]]], "UNFINISHED"] &, Length[cells] + 1];
  logLine["cells before the UNFINISHED title: ", stop - 1];
  $Line = 1; Unprotect[Out];   (* % and Out[n] work as in a notebook (in a script kernel $Line is 0 and % recurses) *)
  Do[
    With[{c = cells[[k]], s = styleOf[cells[[k]]]},
      If[KeyExistsQ[levels, s], path[[levels[s]]] = headText[c]; If[levels[s] < 6, path[[levels[s] + 1 ;;]] = ""]];
      If[MemberQ[{"Input", "Code"}, s],
        Module[{skip = Null, held, data, msgs = {}, fails = {}, t = 0, p = StringRiffle[Select[path, # =!= "" &], " > "]},
          Which[
            ! FreeQ[c, "RICHNotebookBootstrap"], skip = "bootstrap (project loaded directly above)",
            MemberQ[List @@ c, Evaluatable -> False], skip = "Evaluatable->False"];
          If[skip === Null,
            held = Block[{$Context = "Global`"}, toHeld[c]];
            Which[MemberQ[held, $Failed], skip = "could not parse", interactiveQ[held], skip = "waits for interactive input"]];
          If[skip === Null,
            logLine["cell ", k - 1, "  [", p, "]"];
            Do[
              (* as the notebook main loop: "expr;" prints nothing but % still refers to the value of expr *)
              With[{hh = Replace[h, HoldPattern[(hd : Hold | HoldComplete)[CompoundExpression[a___, Null]]] :> hd[CompoundExpression[a]]]},
                data = TimeConstrained[
                  CheckAbort[Block[{$Context = "Global`"}, EvaluationData[ReleaseHold[hh]]], <|"Result" -> $Aborted, "MessagesText" -> {}, "AbsoluteTiming" -> 0|>],
                  3600, <|"Result" -> Failure["TimedOut", <|"Seconds" -> 3600|>], "MessagesText" -> {}, "AbsoluteTiming" -> 3600|>]];
              If[data["Result"] =!= Null, Out[$Line] = data["Result"]]; $Line++;
              t += data["AbsoluteTiming"]; msgs = Join[msgs, data["MessagesText"]];
              If[data["Result"] === $Aborted || FailureQ[data["Result"]], AppendTo[fails, ToString[Short[data["Result"], 2], InputForm]]],
              {h, held}];
            logLine["      done in ", Round[t, 0.1], " s; messages ", Length[msgs], If[fails =!= {}, "; FAILED/ABORTED", ""]],
            logLine["cell ", k - 1, " skipped: ", skip]];
          AppendTo[records, <|"cell" -> k - 1, "path" -> p, "skipped" -> skip, "seconds" -> Round[t, 0.01],
            "messages" -> Take[msgs, UpTo[25]], "messageCount" -> Length[msgs], "failures" -> fails|>]
        ]]],
    {k, 1, stop - 1}];
];
logLine["main code evaluated in ", Round[AbsoluteTime[] - t0run], " s"];

(* ---------- 3. outputs ---------- *)
Export[FileNameJoin[{outDir, "cells.json"}], records, "RawJSON", "Compact" -> False];
If[ListQ[Global`allExperimentResultsHeader] && ListQ[Global`allExperimentResultsData] && Global`allExperimentResultsData =!= {},
  Quiet @ Check[Export[FileNameJoin[{outDir, "results.csv"}],
    Map[If[StringQ[#], #, ToString[#, InputForm]] &, Transpose[Join[Global`allExperimentResultsHeader, Global`allExperimentResultsData]], {2}], "CSV"],
    logLine["results.csv not written (rows of different length)"]]];
evaluated = Select[records, #["skipped"] === Null &];
scriptOnlyQ[m_String] := StringContainsQ[m, "Infinity::indet"];
report = StringRiffle[Flatten[{
  "Running check of notebooks/calculator.nb (main code, UNFINISHED part excluded)  " <> DateString[],
  "Kernel: " <> $Version,
  "Project load: " <> ToString[Length[loadData["MessagesText"]]] <> " messages",
  Map["   load message: " <> # <> If[scriptOnlyQ[#], "\n      [script kernel only: the FullForm display lines with \[Sigma]R\[Infinity] in src/calculator.wl; not raised when the notebook loads the project]", ""] &,
    Take[DeleteDuplicates[loadData["MessagesText"]], UpTo[30]]],
  "Input cells: " <> ToString[Length[records]] <> " (evaluated " <> ToString[Length[evaluated]] <> ", skipped " <> ToString[Length[records] - Length[evaluated]] <> ")",
  "Cells with messages: " <> ToString[Count[evaluated, r_ /; r["messageCount"] > 0]] <> "; cells with failures/aborts: " <> ToString[Count[evaluated, r_ /; r["failures"] =!= {}]],
  "Total evaluation time: " <> ToString[Round[Total[#["seconds"] & /@ evaluated]]] <> " s",
  "useChromaticRatioOne = " <> ToString[Global`useChromaticRatioOne],
  "Experiments recorded: " <> ToString[If[ListQ[Global`allExperimentResultsData], Length[Global`allExperimentResultsData], 0]],
  "", "---- skipped cells ----",
  Map["cell " <> ToString[#["cell"]] <> ": " <> #["skipped"] <> "   [" <> #["path"] <> "]" &, Select[records, #["skipped"] =!= Null &]],
  "", "---- cells with failures or messages ----",
  Map[{"cell " <> ToString[#["cell"]] <> "  (" <> ToString[#["seconds"]] <> " s)  [" <> #["path"] <> "]",
       Map["     FAILURE: " <> # &, #["failures"]],
       Map["     " <> # &, DeleteDuplicates[#["messages"]]]} &,
    Select[evaluated, #["messageCount"] > 0 || #["failures"] =!= {} &]],
  "", "---- slowest cells ----",
  Map["cell " <> ToString[#["cell"]] <> ": " <> ToString[#["seconds"]] <> " s   [" <> #["path"] <> "]" &, Take[ReverseSortBy[evaluated, #["seconds"] &], UpTo[10]]]
}], "\n"];
Export[FileNameJoin[{outDir, "report.txt"}], report, "Text", CharacterEncoding -> "UTF-8"];
logLine["RUN CHECK DONE: ", outDir];
Close[logStream];
Exit[0];
