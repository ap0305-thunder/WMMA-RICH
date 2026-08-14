(* ::Package::"Tags"-><|"NoVariables" -> <|"Module" -> <|Enabled -> False|>|>|>:: *)

BeginPackage["myNotebookInit`"];
versionTAG = "v.08-08-2026";

(* ===== Public API (lowercase-first) ===== *)



prettyPrintedCellStyleNumber::usage = "prettyPrintedCellStyleNumber prints counts for common cell styles and the total number of cells in the current notebook; it requires a notebook front end.";
cellStylesEditorPalette::usage = "cellStylesEditorPalette creates and returns the interactive Cell Style Editor palette for the current input notebook. Temporary preview backgrounds are restored when the preview is cleared or the palette closes.";
cellStylesScannerPalette::usage = "cellStylesScannerPalette creates and returns the interactive Cell Style Scanner palette for the current input notebook. It scans by style or exact Boolean cell property and restores its temporary highlight when the scan changes or the palette closes.";
manageMyStyleNotebook::usage = "manageMyStyleNotebook[] checks for myStyle.nb in the user's front-end StyleSheets directory and, if absent, copies the canonical stylesheet there from the project root. It prints the outcome and requires a saved notebook front end.";
checkProtection::usage = "checkProtection[symbol] returns an Association describing the held symbol's name, context, and Protected state. checkProtection[{symbols...}] operates elementwise. Invalid input produces a message and returns $Failed.";
clearAllProtected::usage = "clearAllProtected[symbol] unprotects and ClearAll-clears one non-System symbol, returning Null. A list of symbols is handled elementwise. It holds its argument and refuses System symbols; invalid input returns $Failed.";
setProtection::usage = "setProtection[symbol, state] protects or unprotects a held non-System symbol when state is True or False and returns an Association describing the change. A list of symbols is handled elementwise; invalid input or a System` symbol returns $Failed.";
applySettings::usage = "applySettings[name] or applySettings[{names...}] applies named notebook/front-end setting blocks from availableSettings[] and returns True after scanning the requests. Unknown names are printed and skipped.";
availableSettings::usage = "availableSettings[] returns the list of names accepted by applySettings and removeSettings.";
bannerLine::usage = "bannerLine[char:\"-\", width:98] returns char repeated width times (at least once) as a String and does not print.";
bigBanner::usage = "bigBanner[msg:\"\", char:\"=\", width:98] prints two banner lines above and below an optional message and returns msg.";
cellsByStyle::usage = "cellsByStyle[styles] returns CellObject expressions from the evaluation notebook whose current CellStyle is a member of the supplied list of style names.";
checkNewCreatedSymbols::usage = "checkNewCreatedSymbols[pattern:\"Global`*\"] returns symbol-name Strings newly matching pattern since the previous call. The first call initializes the private snapshot and returns {}.";
deleteAllEmptyCellsInNotebook::usage = "deleteAllEmptyCellsInNotebook deletes non-generated cells in the current notebook whose content is empty or whitespace-only. It is a delayed symbol, not a function call, and requires a notebook front end.";
ensureNotebookSaved::usage = "ensureNotebookSaved[] returns the expanded full path of the current saved notebook. If no notebook front end is available, the notebook is unsaved, or its file does not exist, it emits a message and returns $Failed.";
killStop::usage = "killStop prints a stop banner and the current MSG/Message cells, then requests EvaluatorAbort through the front end. It is a delayed symbol and is not a reliable headless kernel control-flow mechanism.";
listInitializationCells::usage = "listInitializationCells[] returns InputForm Strings for Input or Code cells marked as initialization cells in the evaluation notebook.";
loadMyFile::usage = StringJoin[
  "loadMyFile[file, dir:Automatic] loads dir/file exclusively when dir is an ",
  "explicit directory String. With Automatic it tries Directory[]/file and then ",
  "the evaluation notebook directory/file. It evaluates the resolved file with ",
  "Get and returns its full path on success. Messages emitted by Get remain ",
  "visible but do not by themselves cause failure. A missing file, aborted Get, ",
  "or Get result of $Failed emits a detailed loadMyFile message, prints ",
  "diagnostics, and returns $Failed; definitions created before a failure are ",
  "not rolled back."
];

loadMyFile::nofile = StringJoin[
  "Cannot find requested file `1`. ",
  "Directory mode: `2`; ",
  "current directory: `3`; ",
  "reference directory: `4`; ",
  "current-directory candidate: `5`; ",
  "reference candidate: `6`. ",
  "No file was loaded; initialization may be incomplete."
];

loadMyFile::getfail = StringJoin[
  "Get returned $Failed while loading `1` (requested as `2`). ",
  "Current directory: `3`; ",
  "reference directory: `4`. ",
  "The loaded file may have emitted earlier messages. ",
  "Initialization may be incomplete."
];

loadMyFile::getabort = StringJoin[
  "Loading `1` (requested as `2`) was aborted. ",
  "Current directory: `3`; ",
  "reference directory: `4`. ",
  "Initialization may be incomplete."
];
loadNeeds::usage = "loadNeeds[context, file:Automatic] records an explicit package request and calls the unmodified System`Needs. With Automatic it uses Needs[context]; with a file String it uses Needs[context, file]. Ordinary messages remain visible. An aborted call or result of $Failed/$Aborted returns $Failed.";
recordExternalLoad::usage = "recordExternalLoad[type, target] records one load performed by trusted external loader code without calling Get or Needs. Both arguments must be strings; success returns Null.";
markInputCellsAsInitialization::usage = "markInputCellsAsInitialization[tf:True] sets InitializationCell -> tf on every Input-style cell in the evaluation notebook and returns the number of affected cells; tf must be True or False.";
midBanner::usage = "midBanner[msg:\"\", char:\"-\", width:98] prints one banner line above and below an optional message and returns msg.";
miniBanner::usage = "miniBanner[msg:\"\", char:\"=\", width:98] prints one banner line above and below an optional starred message and returns msg.";
nb::usage = "nb[] returns EvaluationNotebook[] and therefore requires a notebook front end for useful operation.";
nbFileBaseName::usage = "nbFileBaseName is a delayed compatibility alias for safeNotebookBaseName[].";
nbFileDirectory::usage = "nbFileDirectory is a delayed compatibility alias for safeNotebookDirectory[].";
nbFileName::usage = "nbFileName is a delayed compatibility alias for safeNotebookFileName[].";
notebookPathInfo::usage = "notebookPathInfo[] returns an Association with keys \"FileName\", \"Directory\", and \"BaseName\" for the evaluation notebook, using the safe notebook-path fallbacks.";
reportNotebookPaths::usage = "reportNotebookPaths[] prints the evaluation notebook object, filename, directory, and base name, and returns those values as an Association. An unsaved notebook is reported with Missing values; without a notebook front end it returns $Failed.";
reportCellStyleInventory::usage = "reportCellStyleInventory[] prints a dynamically generated count of every cell style in the evaluation notebook and the total cell count. It returns an Association containing \"Counts\" and \"TotalCells\"; without a notebook front end it returns $Failed.";
reportMessageCellList::usage = "reportMessageCellList[] prints an indexed list of all Message- and MSG-style CellObject expressions in the evaluation notebook and returns the CellObject list. Without a notebook front end it returns $Failed.";
printA::usage = "printA[symbol] holds symbol, prints its unqualified name and evaluated value, and returns Null.";
printD::usage = "printD[expr] is a HoldAll alias for showIt[expr]; it evaluates expr once, prints the held expression and value, and returns the value.";
removeSettings::usage = "removeSettings[name] or removeSettings[{names...}] applies the registered remove action for each named setting block and returns True after scanning the requests. Some settings, such as setDirectoryToNotebook, have no undo action.";
safeNotebookBaseName::usage = "safeNotebookBaseName[] returns FileBaseName of the evaluation notebook when its filename is a String, otherwise \"UnsavedNotebook\".";
safeNotebookDirectory::usage = "safeNotebookDirectory[] returns DirectoryName of the evaluation notebook when its filename is a String, otherwise $HomeDirectory.";
safeNotebookFileName::usage = "safeNotebookFileName[] quietly returns NotebookFileName[EvaluationNotebook[]]; for an unsaved or unavailable notebook the front end's failure result is returned.";
saveAsPdfAllOutputCells::usage = "saveAsPdfAllOutputCells[dir:Automatic, imageSize:Scaled[.8]] exports every Output cell in the evaluation notebook to sequentially named PDF files and returns their full paths. Automatic uses the configured RICH output/notebook-cells directory.";
saveAsPngAllOutputCells::usage = "saveAsPngAllOutputCells[dir:Automatic, imageSize:Scaled[.8]] exports every Output cell in the evaluation notebook to sequentially named PNG files and returns their full paths. Automatic uses the configured RICH output/notebook-cells directory.";
saveNotebookTextCopy::usage = "saveNotebookTextCopy[suffix:\"-output\", ext:\"txt\"] exports NotebookGet[EvaluationNotebook[]] as Text beside the saved notebook and returns the output path, or $Failed when the notebook is not saved.";
saveVersionedCopy::usage = "saveVersionedCopy[tag:\"\", whereDir:Automatic] saves one validated EvaluationNotebook[] to its original path, copies that saved .nb file to a timestamped destination, and exports Text from NotebookGet of the same NotebookObject. Automatic uses the configured RICH backup directory. It never uses InputNotebook[] or renames the active notebook. Success returns <|\"Notebook\" -> nbPath, \"Text\" -> textPath|>; failure returns $Failed.";
selectInitializationCells::usage = "selectInitializationCells[] visits each initialization cell with NotebookLocate and SelectCell, then returns the corresponding CellObject list. Because selections are made sequentially, the last visited cell is the final front-end selection.";
showContextInfo::usage = "showContextInfo[] prints current context diagnostics and returns an Association containing $Context, $ContextPath, lowercase loaded packages, recently created lowercase contexts, and loaded lowercase packages absent from $ContextPath.";
showDiagnostics::usage = "showDiagnostics[mode:\"full\"] prints notebook/session diagnostics and returns True. Supported modes are \"minimal\", \"session\", \"cells\", \"frontend\", and \"full\"; an invalid mode emits a message and returns $Failed.";
showIt::usage = "showIt[expr] has attribute HoldAll, evaluates expr once, prints the held expression with its value, and returns that value.";
smallBanner::usage = "smallBanner[msg:\"\", char:\"-\", width:98] prints msg when it is nonempty; otherwise it prints a line made from char and width. It returns msg.";
superClearSet::usage = "superClearSet[symbol, short:True, value:\"n/a\", pad:21, numDigits:3, resetMonitoring:False] holds symbol, clears its definitions, assigns value, and installs Experimental`ValueFunction monitoring. With resetMonitoring -> True it removes monitoring only. This is destructive and accepts one symbol at a time.";
startHeartbeat::usage = "startHeartbeat[seconds:60, label:\"calculation\"] starts a lightweight preemptive task that prints the local timestamp and elapsed time every specified number of seconds. Starting a new heartbeat replaces any existing heartbeat.";
stopHeartbeat::usage = "stopHeartbeat[] removes the active heartbeat task, prints its final elapsed time, and returns Null. It is safe to call when no heartbeat is active.";
timeBanner::usage = "timeBanner[msg:\"\", char:\"-\", width:98] prints a timestamped banner and returns <|\"Message\" -> msg, \"Timestamp\" -> string|>.";
timeStamp::usage = "timeStamp is a delayed symbol that returns the current local date and time as a compact String of the form -DYYMMDDTHHMMSS.";
withHeartbeat::usage = "withHeartbeat[expr, seconds:60, label:\"calculation\"] evaluates expr while printing a timestamp and elapsed time at the requested interval, and always removes the heartbeat task when evaluation finishes or is aborted. It holds expr unevaluated until monitoring has started.";
versionTAG::usage = "versionTAG is the package version String reported when myNotebookInit loads.";
initialContexts::usage = "initialContexts is the de-duplicated list of contexts observed when myNotebookInit initializes; showContextInfo[] uses it as its baseline.";
exportGraphicsToPDF::usage = "exportGraphicsToPDF[graphics, what:\"what\", type:\"type\", tag:\"tag\", dateTimeYesNo:True, baseOutputDir:Automatic] exports graphics as a PDF whose filename is assembled from what, type, tag, and an optional timestamp. Automatic uses the configured RICH output directory and the Export result is returned.";
endEvalPrintOut::usage = "endEvalPrintOut[] prints an end-of-evaluation banner, timestamp, MSG/Message cells, context information, newly created Global` symbol names, and the external-load summary; it returns the result of summarizeLoads[].";
summarizeLoads::usage = "summarizeLoads[] prints totals recorded explicitly by loadMyFile, loadNeeds, and trusted external loaders using recordExternalLoad, and returns the log as a Dataset. When the log is empty it prints a notice and returns Null.";
loadSavedLog::usage = "loadSavedLog[path:Automatic] imports a saved load log into the package tracker and prints the number of entries. Automatic uses load_log.wdx in safeNotebookDirectory[]; a missing file returns $Failed, while success returns Null.";
clearLoadLog::usage = "clearLoadLog[] empties the package's external-load log, prints confirmation, and returns Null.";
saveLoadLog::usage = "saveLoadLog[path:Automatic] exports the package's external-load log and prints the resolved path. Automatic uses load_log.wdx in safeNotebookDirectory[]; the current implementation returns Null after a successful print.";
validStylesheetReport::usage = "validStylesheetReport[file] reads file with Get and returns an Association describing whether it is a Notebook expression and likely stylesheet, including StyleData counts, parent-style presence, ordinary Input cells, a Salvaged tag, and problem descriptions.";
printMsgCell::usage = "printMsgCell[text] sends a red MSG-style cell containing text to the current front end and returns the FrontEndExecute result; text must be a String.";


Begin["`Private`"];

(* FIX: top banner is now guarded so it only prints on the first load, not on every reload *)
If[!TrueQ[$myNotebookInitLoaded],
  Print["*==================================================================================================*"];
  Print["*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*"];
  Print["***----------------------------------- myNotebookInit ---------------------------------------------***"];
  Print["*==================================================================================================*"];
];
(* ============================================================
   Load confirmation (guarded \[LongDash] only prints on first load)
   ============================================================ *)

If[! TrueQ[$myNotebookInitLoaded],
  Print["============================================================"];
  Print[" myNotebookInit  loaded  |  Version: ", versionTAG];
  Print[" Kernel: ", $Version];
  Print[" Context: ", $Context];
  Print["============================================================"];
  $myNotebookInitLoaded = True;
];


(* ============================================================
   Context snapshot (taken once at load time)
   ============================================================ *)

initialContexts = DeleteDuplicates[Context /@ Names["*`*"]];


ClearAll[printMsgCell];

printMsgCell[text_String] :=
  FrontEndExecute[
    FrontEnd`CellPrint[
      Cell[text, "MSG",
        CellFrame -> {{2, 0}, {0, 0}},
        CellFrameColor -> RGBColor[0.8, 0.2, 0.2],
        FontColor -> RGBColor[0.8, 0.2, 0.2],
        Background -> RGBColor[1, 0.95, 0.95]
      ]
    ]
  ];


(* ::Input::Initialization:: *)
ClearAll[validStylesheetReport];

validStylesheetReport[file_String]:=Module[{nb,cells,styleDataCells,parentCells,badInputCells,salvaged},nb=Quiet@Check[Get[file],$Failed];
If[nb===$Failed||!MatchQ[nb,Notebook[__]],Return[<|"ValidNotebookExpression"->False,"LikelyStylesheet"->False,"Problems"->{"File does not read as a Notebook[...] expression."}|>]];
cells=Cases[nb,Cell[__],Infinity];
styleDataCells=Cases[cells,Cell[StyleData[__],___],Infinity];
parentCells=Cases[cells,Cell[StyleData[StyleDefinitions->_],___],Infinity];
badInputCells=Cases[cells,Cell[_,"Input",___],Infinity];
salvaged=!FreeQ[nb,TaggingRules->rules_/;MatchQ[rules,KeyValuePattern["Salvaged"->True]]];
<|"ValidNotebookExpression"->True,"LikelyStylesheet"->styleDataCells=!={},"NumberOfStyleDataCells"->Length[styleDataCells],"HasParentStyleDefinition"->parentCells=!={},"NumberOfOrdinaryInputCells"->Length[badInputCells],"HasSalvagedTag"->salvaged,"Problems"->DeleteCases[{If[styleDataCells==={},"No active Cell[StyleData[...]] cells found.",Nothing],If[parentCells==={},"No parent StyleDefinitions cell found.",Nothing],If[badInputCells=!={},"Contains ordinary Input cells; these should usually not be in a clean stylesheet.",Nothing],If[salvaged,"Notebook has TaggingRules -> {\"Salvaged\" -> True}; rebuild/resave cleanly.",Nothing]},Nothing]|>]


(* Explicit load tracker: the built-in Get and Needs remain unmodified. *)
$LoadLog={};

(* Logger used only by loadMyFile and loadNeeds. *)
logLoad[type_String, target_String] := AppendTo[$LoadLog,
  <|"Type" -> type, "Target" -> target,
    "caller nb" -> myNotebookInit`nbFileName,
    "Time" -> DateString[], "AbsTime" -> AbsoluteTime[]|>
];

logLoad[_,_]:=Null;

ClearAll[recordExternalLoad];
recordExternalLoad::arg = "Expected two String arguments; received `1` and `2`.";
recordExternalLoad[type_String, target_String] := (
  logLoad[type, target];
  Null
);
recordExternalLoad[type_, target_] := (
  Message[recordExternalLoad::arg, HoldForm[type], HoldForm[target]];
  $Failed
);

(* No external tracker exists before this package is loaded, so register the
   bootstrap Get from inside the package once its log and public API exist. *)
If[StringQ[$InputFileName] && StringLength[$InputFileName] > 0,
  recordExternalLoad["Get", ExpandFileName[$InputFileName]]
];

ClearAll[loadNeeds];
loadNeeds[context_String, file : (_String | Automatic) : Automatic] := Module[
  {result, aborted = False},
  logLoad["Needs", If[file === Automatic, context, context <> " via " <> file]];
  result = CheckAbort[
    If[file === Automatic, Needs[context], Needs[context, file]],
    aborted = True;
    $Aborted
  ];
  If[aborted || result === $Aborted || result === $Failed, $Failed, result]
];
saveLoadLog[path_String : Automatic] := Module[{p},
  p = Replace[path,
    Automatic :> FileNameJoin[{safeNotebookDirectory[], "load_log.wdx"}]];
  Export[p, $LoadLog];
  Print["Log saved to: ", p]
];

loadSavedLog[path_String : Automatic] := Module[{p},
  p = Replace[path,
    Automatic :> FileNameJoin[{safeNotebookDirectory[], "load_log.wdx"}]];
  If[! FileExistsQ[p],
    Print["Log file not found: ", p];
    Return[$Failed]
  ];
  $LoadLog = Import[p];
  Print["Loaded ", Length[$LoadLog], " entries from: ", p]
];







(*\[HorizontalLine]\[HorizontalLine] Summary report \[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]*)
summarizeLoads[]:=Module[{ds,byType,rows},If[$LoadLog==={},Print["No loads recorded."];Return[]];
ds=Dataset[$LoadLog];
(*Print["\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501"];*)
Print["  External Load Summary"];
(*Print["\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501"];*)
Print["  Total calls : ",Length[$LoadLog]];
(*Use Counts directly on raw list\[LongDash]no Dataset keys issues*)byType=Counts[$LoadLog[[All,"Type"]]];
Print["  By type:"];
KeyValueMap[Print["    ",#1," -> ",#2," call(s)"]&,byType];
(*Tally {target,type} pairs directly\[LongDash]no association key unpacking*)rows=ReverseSortBy[Tally[{#["Target"],#["Type"]}&/@$LoadLog],Last];
Print["\n  Calls per target (sorted by frequency):"];
Scan[Print["    ",#[[1,1]],"  [",#[[1,2]],"]  *",#[[2]]]&,rows];
Print["\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501"];
Print["\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501\:2501"];
ds   (*Dataset renders nicely in the notebook output*)
]

(*\[HorizontalLine]\[HorizontalLine] Reset \[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]*)
clearLoadLog[]:=($LoadLog={};Print["Log cleared."]);
(*\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550\:2550*)
Print["Explicit Load Tracker ready. Functions: loadMyFile[], loadNeeds[], recordExternalLoad[], summarizeLoads[], ","saveLoadLog[], loadSavedLog[], clearLoadLog[]"];
(*clearLoadLog[]*)
(* $LoadLog *)
(* Dataset[$LoadLog]*)


ClearAll[endEvalPrintOut];

endEvalPrintOut[]:=Module[{messageCells},
messageCells = If[
  TrueQ[$Notebooks],
  Quiet @ Check[Cells[CellStyle -> {"MSG", "Message"}], {}],
  {}
];
bigBanner[" endEvalPrintOut "];
Print[" timeStamp            ===>>>   ",timeStamp];
smallBanner[];
Print[" Cells[MSG,Message}]      ===>>> \n", messageCells];
smallBanner[];
Print[" $Context                 ===>>>  ",$Context ];
smallBanner[];
Print[" $ContextPath             ===>>>  ",Column@$ContextPath];
smallBanner[];
Print[" checkNewCreatedSymbols   ===>>>  ",checkNewCreatedSymbols[]];
smallBanner[];
summarizeLoads[]
];



ClearAll[configuredProjectDirectory];
configuredProjectDirectory[key_String, fallbackLeaf_String] := Module[
  {configured, projectRoot, directory},
  configured = If[NameQ["Global`RICHPathSetting"],
    Quiet @ Check[Global`RICHPathSetting[key], $Failed],
    $Failed
  ];
  projectRoot = If[
    StringQ[Global`$RICHProjectRoot],
    Global`$RICHProjectRoot,
    $Failed
  ];
  directory = Which[
    StringQ[configured] && configured =!= "", configured,
    StringQ[projectRoot], FileNameJoin[{projectRoot, fallbackLeaf}],
    True, FileNameJoin[{$HomeDirectory, "WolframMMAProjectRICH", fallbackLeaf}]
  ];
  If[! DirectoryQ[directory],
    Quiet @ Check[
      CreateDirectory[directory, CreateIntermediateDirectories -> True],
      Return[$Failed]
    ]
  ];
  directory
];


ClearAll[exportGraphicsToPDF];
exportGraphicsToPDF[
  graphics_,
  what_String   : "what",
  type_String   : "type",
  tag_String    : "tag",
  dateTimeYesNo : (True | False) : True,
  baseOutputDir : (_String | Automatic) : Automatic
] := Module[{what2, type2, tag2, timeStamp, outDir},

  (* resolve output directory *)
  outDir = Replace[baseOutputDir,
    Automatic :> configuredProjectDirectory["OutputDirectory", "output"]];
  If[! DirectoryQ[outDir],
    CreateDirectory[outDir, CreateIntermediateDirectories -> True]];

  timeStamp = StringReplace[
    DateString[Date[], "ISODateTime"], {":"->"-", "T"->"--"}];

  what2 = what;

  type2 = If[type == "", "", "-" <> type];

  tag2 = Which[
    tag == "" &&  dateTimeYesNo, "---" <> timeStamp,
    tag == "" && !dateTimeYesNo, "",
    tag != "" &&  dateTimeYesNo, "-" <> tag <> "---" <> timeStamp,
    tag != "" && !dateTimeYesNo, "-" <> tag
  ];

  Export[
    FileNameJoin[{outDir, what2 <> type2 <> tag2 <> ".pdf"}],
    graphics,
    "PDF"
  ]
];


Clear[manageMyStyleNotebook];

manageMyStyleNotebook[] := Module[{target, source},
  target = FileNameJoin[{$UserBaseDirectory, "SystemFiles", "FrontEnd",
     "StyleSheets", "myStyle.nb"}];
  source = If[
    StringQ[Global`$RICHProjectStyleDefinitions],
    Global`$RICHProjectStyleDefinitions,
    FileNameJoin[{ParentDirectory[NotebookDirectory[]], "myStyle.nb"}]
  ];
  If[FileExistsQ[target],
    Print["OK -- myStyle.nb already in StyleSheets: ", target]
    ,
    If[FileExistsQ[source],
      CopyFile[source, target]; Print["COPIED -- myStyle.nb from: ", 
        source]; Print["      --> to:   ", target]
      ,
      Print["ERROR -- canonical myStyle.nb not found in the project root: ",
         source]
    ]
  ]
];


(* ============================================================
   showContextInfo
   FIX: `recent` was used but never computed (the line was commented out).
        Also `$InitialContexts` (with $) was inconsistent with `initialContexts`.
   ============================================================ *)

ClearAll[showContextInfo];

showContextInfo[] := Module[
  {ctx = $Context, path = $ContextPath, allContexts, myContexts,
   recent, unreachable, myPackages},

  allContexts = DeleteDuplicates[Context /@ Names["*`*"]];
  myContexts  = Select[allContexts, StringMatchQ[#, RegularExpression["^[a-z].*`$"]] &];

  (* FIX: compute `recent` properly using the package-level `initialContexts` *)
  recent = If[ListQ[initialContexts],
    Select[
      Complement[allContexts, initialContexts],
      StringMatchQ[#, RegularExpression["^[a-z].*`$"]] &
    ],
    {}
  ];

  myPackages  = Select[$Packages, StringMatchQ[#, RegularExpression["^[a-z].*`$"]] &];
  unreachable = Select[myPackages, ! MemberQ[path, #] &];

  Print["---------------- Context Diagnostics ----------------"];
  Print["$Context        : ", ctx];
  Print["\n$ContextPath    :"];
  Print /@ ("   " <> # & /@ path);
  Print["\nYour loaded packages (lowercase only):"];
  If[myPackages === {}, Print["   (none)"], Print /@ ("   " <> # & /@ myPackages)];
  Print["\nRecently created lowercase contexts:"];
  If[recent === {}, Print["   (none detected or baseline not set)"], Print /@ ("   " <> # & /@ recent)];
  Print["\nLoaded lowercase packages NOT on $ContextPath:"];
  If[unreachable === {}, Print["   (none)"], Print /@ ("   " <> # & /@ unreachable)];
  Print["------------------------------------------------------"];

  <|
    "$Context"                   -> ctx,
    "$ContextPath"               -> path,
    "MyPackages"                 -> myPackages,
    "RecentContexts"             -> recent,
    "UnreachableLoadedPackages"  -> unreachable
  |>
];


(* ============================================================
   checkProtection / setProtection
   ============================================================ *)

ClearAll[checkProtection, setProtection];

checkProtection::sym  = "Argument `1` is not a symbol (did it evaluate to a string/number?).";
setProtection::sym    = "Argument `1` is not a symbol (did it evaluate to a string/number?).";
setProtection::system = "Refusing to change protection state of System` symbol `1`.";
setProtection::bad    = "Second argument must be True (protect) or False (unprotect). Got: `1`.";

SetAttributes[{checkProtection, setProtection}, HoldFirst];
(* List inputs are threaded over the scalar definitions by Listable. *)
SetAttributes[{checkProtection, setProtection}, Listable];

checkProtection[s_Symbol] := Module[
  {name = SymbolName[Unevaluated[s]], ctx = Context[s], isProt},
  isProt = MemberQ[Attributes[s], Protected];
  <| "Symbol" -> Unevaluated[s], "Name" -> name, "Context" -> ctx, "Protected" -> isProt |>
];

checkProtection[x_] := (Message[checkProtection::sym, HoldForm[x]]; $Failed);

(* 1 \[LongDash] bad state argument, any symbol *)
setProtection[s_Symbol, state_] /; ! MemberQ[{True, False}, state] :=
  (Message[setProtection::bad, state]; $Failed);

(* 2 \[LongDash] main worker, one symbol *)
setProtection[s_Symbol, state : (True | False)] := Module[
  {name = SymbolName[Unevaluated[s]], ctx = Context[s], wasProtected, action},
  If[ctx === "System`",
    Message[setProtection::system, name];
    Return[$Failed]
  ];
  wasProtected = MemberQ[Attributes[s], Protected];
  action = Which[
    state === True  && !wasProtected, Protect[s];   "Protected",
    state === True  &&  wasProtected,               "AlreadyProtected",
    state === False &&  wasProtected, Unprotect[s]; "Unprotected",
    state === False && !wasProtected,               "AlreadyUnprotected"
  ];
  Print["[setProtection] ", name, " : ",
    If[wasProtected, "Protected", "Unprotected"], " -> ",
    If[state, "Protected", "Unprotected"], " (", action, ")"];
  <|
    "Symbol"           -> Unevaluated[s],
    "Name"             -> name,
    "Context"          -> ctx,
    "WasProtected"     -> wasProtected,
    "NowProtected"     -> MemberQ[Attributes[s], Protected],
    "RequestedProtected" -> state,
    "Action"           -> action
  |>
];
(* 3 \[LongDash] non-symbol fallback *)
setProtection[x_, _] := (Message[setProtection::sym, HoldForm[x]]; $Failed);


(* ============================================================
   clearAllProtected (legacy optics compatibility)
   ============================================================ *)

ClearAll[clearAllProtected];
clearAllProtected::sym = "Argument `1` is not a symbol.";
clearAllProtected::system = "Refusing to clear System` symbol `1`.";
SetAttributes[clearAllProtected, {HoldAll, Listable}];

clearAllProtected[s_Symbol] := Module[{context = Context[Unevaluated[s]]},
  If[context === "System`",
    Message[clearAllProtected::system, HoldForm[s]];
    Return[$Failed]
  ];
  Unprotect[s];
  ClearAll[s];
  Null
];

clearAllProtected[other_] := (
  Message[clearAllProtected::sym, HoldForm[other]];
  $Failed
);


(* ============================================================
   superClearSet
   ============================================================ *)

ClearAll[superClearSet];
SetAttributes[superClearSet, HoldAll];

superClearSet[
  xVar_,
  short_: True,
  xVal_: "n/a",
  pad_: 21,
  numDigits_: 3,
  resetMonitoring_: False
] :=
  Module[{v, xOld},

    v = ToString[Unevaluated[xVar]];

    If[MemberQ[Attributes[xVar], Protected],
      Print[" === VARIABLE is protected : ", HoldForm[xVar], " DO NOTHING! "];
      Return[]
    ];

    If[resetMonitoring === True,
      Quiet[
        Experimental`ValueFunction[xVar] =.,
        {Unset::norep}
      ];
      Print[" === MONITORING RESET for symbol : ", v];
      Return[]
    ];

    xOld = xVar;                         (* capture old value *)

    (* remove previous monitoring, if any *)
    Quiet[
      Experimental`ValueFunction[xVar] =.,
      {Unset::norep}
    ];

    ClearAll[xVar];

    xVar = Evaluate @ xVal;

    Print[
      " === MONITORED SYMBOL (one symbol at a time!) : ", v,
      "       before ", xOld,
      "       after  ", xVar
    ];

    If[short === True,

      Experimental`ValueFunction[xVar] :=
        Print[" !!! ", v, " : ", #1, " -->> ", #2] &,

      Experimental`ValueFunction[xVar] :=
        Print[
          " === CHANGED : " <> v <>
            StringRepeat[
              " ",
              Max[1, pad - StringLength[" ! CHANGED : " <> v]]
            ] <>
            " value before : ",
          PaddedForm[#1, {Round[pad/3], numDigits}],
          " -->> value after : ",
          PaddedForm[#2, {Round[pad/3], numDigits}]
        ] &
    ];
  ];


(* ============================================================
   superClearSet
   ============================================================ *)

ClearAll[superClearSetOLD];
SetAttributes[superClearSetOLD, HoldAll];

superClearSetOLD[xVar_, short_: True, xVal_: "n/a", pad_: 21, numDigits_: 3] :=
  Module[{v,xOld},
    If[MemberQ[Attributes[xVar], Protected],
      Print[" === VARIABLE is protected : ", xVar, " DO NOTHING! "];
      Return[]
    ];   
(*safer*) Quiet[    Experimental`ValueFunction[xVar] =.,    {Unset::norep}];
    ClearAll[xVar];
    
    v = ToString @ xVar;
    xOld = xVar;                         (* capture old value *)
    xVar = Evaluate @ xVal;
   
    Print[" === MONITORED SYMBOL (one symbol at a time!) : ", v,      "       before ", xOld, "       after  ",  xVar];
    If[short === True,
      Experimental`ValueFunction[xVar] := Print[" !!! ", v, " : ", #1, " -->> ", #2] &
     (*Experimental`ValueFunction[xVar] := Print[" !!! ", v, " : ", #1, " -->> ", If[ValueQ[#2]==True,#2," CLEARED "]] &*)
     
      ,
      Experimental`ValueFunction[xVar] :=
        Print[" === CHANGED : " <> v <>
          StringRepeat[" ", Max[1, pad - StringLength[" ! CHANGED : " <> v]]] <>
          " value before : ",     PaddedForm[#1, {Round[pad/3], numDigits}],
          " -->> value after : ", PaddedForm[#2, {Round[pad/3], numDigits}]] &
    ];
  ];


(* ============================================================
   ensureNotebookSaved
   FIX: was defined twice \[LongDash] second (one-liner) silently overwrote the first
        (robust) definition. Kept only the robust version.
   ============================================================ *)

ClearAll[ensureNotebookSaved];

ensureNotebookSaved::unsaved =
  "This notebook has not been saved yet. Save it (File \[RightArrow] Save) and retry.";
ensureNotebookSaved::nofe =
  "No notebook is available in the current FrontEnd session.";

ensureNotebookSaved[] := Module[{nbk, path},
  If[! TrueQ[$Notebooks],
    Message[ensureNotebookSaved::nofe];
    Return[$Failed]
  ];
  nbk  = EvaluationNotebook[];
  path = Quiet @ Check[NotebookFileName[nbk], $Failed];
  If[path === $Failed || path === "" || ! StringQ[path],
    Message[ensureNotebookSaved::unsaved];
    Return[$Failed]
  ];
  path = ExpandFileName[path];
  If[! FileExistsQ[path],
    Message[ensureNotebookSaved::unsaved];
    Return[$Failed]
  ];
  path
];


(* ============================================================
   timeStamp
   ============================================================ *)

ClearAll[timeStamp];
timeStamp := DateString[DateList[],
  {"-D", "YearShort", "", "Month", "", "Day", "", "T", "Hour", "", "Minute", "", "Second"}];


(* ============================================================
   Preemptive heartbeat for long calculations
   ============================================================ *)

ClearAll[
  startHeartbeat, stopHeartbeat, withHeartbeat,
  removeHeartbeatTask, $heartbeatTask, $heartbeatStartedAt, $heartbeatLabel
];

$heartbeatTask = None;
$heartbeatStartedAt = None;
$heartbeatLabel = "calculation";

startHeartbeat::badinterval =
  "Heartbeat interval `1` must be a positive number of seconds.";

removeHeartbeatTask[] := Module[{},
  If[MatchQ[$heartbeatTask, _TaskObject],
    Quiet @ Check[TaskRemove[$heartbeatTask], Null]
  ];
  $heartbeatTask = None;
  Null
];

startHeartbeat[seconds_: 60, label_: "calculation"] := Module[
  {interval = Quiet @ Check[N[seconds], $Failed]},
  If[interval === $Failed || ! NumericQ[interval] || ! TrueQ[interval > 0],
    Message[startHeartbeat::badinterval, seconds];
    Return[$Failed]
  ];

  removeHeartbeatTask[];
  $heartbeatStartedAt = AbsoluteTime[];
  $heartbeatLabel = If[StringQ[label], label, ToString[label, InputForm]];

  $heartbeatTask = SessionSubmit[
    ScheduledTask[
      Print[
        "[heartbeat ",
        DateString[{"Year", "-", "Month", "-", "Day", " ",
                    "Hour", ":", "Minute", ":", "Second"}],
        "] ", $heartbeatLabel,
        " | elapsed ", Round[N[AbsoluteTime[] - $heartbeatStartedAt]], " s"
      ],
      interval
    ],
    Method -> Automatic
  ];

  Print[
    "Heartbeat started for ", $heartbeatLabel,
    " every ", interval, " s at ",
    DateString[{"Year", "-", "Month", "-", "Day", " ",
                "Hour", ":", "Minute", ":", "Second"}]
  ];
  $heartbeatTask
];

stopHeartbeat[] := Module[
  {activeQ = MatchQ[$heartbeatTask, _TaskObject], elapsed},
  elapsed = If[NumberQ[$heartbeatStartedAt],
    Round[N[AbsoluteTime[] - $heartbeatStartedAt]],
    0
  ];
  removeHeartbeatTask[];
  If[activeQ,
    Print[
      "Heartbeat stopped for ", $heartbeatLabel,
      " after ", elapsed, " s at ",
      DateString[{"Year", "-", "Month", "-", "Day", " ",
                  "Hour", ":", "Minute", ":", "Second"}]
    ]
  ];
  Null
];

SetAttributes[withHeartbeat, HoldFirst];
withHeartbeat[expr_, seconds_: 60, label_: "calculation"] := Module[
  {started = False},
  Internal`WithLocalSettings[
    started = startHeartbeat[seconds, label] =!= $Failed,
    If[started, expr, $Failed],
    If[started, stopHeartbeat[]]
  ]
];


(* ============================================================
   Banners
   FIX: miniBanner now respects a width parameter, consistent with the others.
   ============================================================ *)

ClearAll[bannerLine, bigBanner, midBanner, miniBanner, smallBanner, timeBanner];

bannerLine[char_: "-", width_: 98] :=
  StringJoin @ ConstantArray[char, Max[1, width]];

bigBanner[msg_: "", char_: "=", width_: 98] := Module[{line = bannerLine[char, width]},
  Print[line];  Print[line];
  If[StringLength@ToString[msg] > 0, Print[" ", msg]];
  Print[line];  Print[line];
  msg
];

midBanner[msg_: "", char_: "-", width_: 98] :=
  Module[{line = bannerLine[char, width]},
    Print[line];
    If[StringLength @ ToString[msg] > 0, Print[" ", msg]];
    Print[line];
    msg
  ];

(* FIX: was a fixed-width hardcoded string; now uses bannerLine for consistency *)
miniBanner[msg_: "", char_: "=", width_: 98] :=
  Module[{line = bannerLine[char, width]},
    Print[line];
    If[StringLength @ ToString[msg] > 0, Print["   *** ", msg, " *** "]];
    Print[line];
    msg
  ];

smallBanner[msg_: "", char_: "-", width_: 98] :=
  Module[{line = bannerLine[char, width]},
    Print[If[StringLength @ ToString[msg] > 0, " " <> ToString[msg], line]];
    msg
  ];

timeBanner[msg_: "", char_: "-", width_: 98] :=
  Module[{ts, line = bannerLine[char, width]},
    ts = DateString[{"Year", "-", "Month", "-", "Day", "  ",
                     "Hour", ":", "Minute", ":", "Second"}];
    Print[line];
    Print[" ", msg, If[StringLength @ ToString[msg] > 0, "  |  ", ""], ts];
    Print[line];
    <| "Message" -> msg, "Timestamp" -> ts |>
  ];


(* ============================================================
   loadMyFile  \[LongDash] simplified: no message interception
   ============================================================ *)
Clear[loadMyFile];
loadMyFile[file_String, dir : (_String | Automatic) : Automatic] := Module[
  {explicitDirQ, nbDir, cwd, local, ref, chosen, t0, t1, before, after,
   getResult, aborted = False},

  t0  = AbsoluteTime[];
  cwd = ExpandFileName @ Directory[];
  explicitDirQ = StringQ[dir];

  (* resolve reference directory *)
  nbDir = If[explicitDirQ,
    ExpandFileName[dir],
    Quiet @ Check[NotebookDirectory[EvaluationNotebook[]], $Failed]
  ];
  If[! StringQ[nbDir], nbDir = cwd];

  local = ExpandFileName @ FileNameJoin[{cwd, file}];
  ref   = ExpandFileName @ FileNameJoin[{nbDir, file}];

  Print["============================================================"];
  Print["[loadMyFile] START"];
  Print["  timestamp:  ", DateString[{"Year","-","Month","-","Day","  ","Hour",":","Minute",":","Second"}]];
  Print["  requested:  ", file];
  Print["  dir mode:   ", If[explicitDirQ, "explicit (authoritative)", "Automatic"]];
  Print["  cwd:        ", cwd];
  Print["  nb dir:     ", nbDir];
  Print["  local path: ", local];
  Print["  ref path:   ", ref];

  chosen = Which[
    explicitDirQ && FileExistsQ[ref], ref,
    explicitDirQ,                     $Failed,
    FileExistsQ[local], local,
    FileExistsQ[ref],   ref,
    True,               $Failed
  ];

  If[chosen === $Failed,
    Message[
      loadMyFile::nofile,
      file,
      If[explicitDirQ, "explicit (authoritative)", "Automatic"],
      cwd,
      nbDir,
      local,
      ref
    ];
    Print["  WARNING: REQUIRED FILE NOT FOUND"];
    Print["  requested: ", file];
    Print["  The kernel was not quit; the session may be only partially initialized."];
    Print["[loadMyFile] END"];
    Print["============================================================"];
    Return[$Failed]
  ];

  Print["  resolved:   ", chosen];
  Print["  loading..."];

  before = Names["Global`*"];
  logLoad["Get", chosen];
  getResult = CheckAbort[
    Get[chosen],
    aborted = True;
    $Aborted
  ];

  If[aborted || getResult === $Aborted,
    Message[
      loadMyFile::getabort,
      chosen,
      file,
      cwd,
      nbDir
    ];
    Print["  WARNING: Get[] WAS ABORTED"];
    Print["  chosen: ", chosen];
    Print["  The kernel was not quit; the session may be only partially initialized."];
    Print["[loadMyFile] END"];
    Print["============================================================"];
    Return[$Failed]
  ];

  If[getResult === $Failed,
    Message[
      loadMyFile::getfail,
      chosen,
      file,
      cwd,
      nbDir
    ];
    Print["  WARNING: Get[] RETURNED $Failed"];
    Print["  chosen: ", chosen];
    Print["  The kernel was not quit; the session may be only partially initialized."];
    Print["[loadMyFile] END"];
    Print["============================================================"];
    Return[$Failed]
  ];

  after = Names["Global`*"];
  t1 = AbsoluteTime[];
  Print["  new symbols: ", Column @ Complement[after, before]];
  Print["  elapsed (s): ", NumberForm[t1 - t0, {6, 3}]];
  Print["[loadMyFile] END  |  ", chosen];
  Print["============================================================"];
  chosen
];






(* ============================================================
   checkNewCreatedSymbols
   FIX: checkNewCreatedSymbolsSnapshot was leaking into Global`.
        Initialised here in Private context so it stays package-private.
   ============================================================ *)

ClearAll[checkNewCreatedSymbols];
checkNewCreatedSymbolsSnapshot = Null;   (* private context, not Global` *)

checkNewCreatedSymbols[pattern_: "Global`*"] := Module[{current, prev, new},
  current = Names[pattern];
  prev    = checkNewCreatedSymbolsSnapshot;
  If[! ListQ[prev],
    checkNewCreatedSymbolsSnapshot = current;
    Return[{}]
  ];
  new = Complement[current, prev];
  checkNewCreatedSymbolsSnapshot = current;
  new
];


ClearAll[
  availableSettings, applySettings, removeSettings,
  $settingActions, applyOneSetting, removeOneSetting
];

$settingActions = <|

  "visual" -> <|
    "apply" :> With[{n = nb[]},
      SetOptions[n, Background -> LightGreen];
      SetOptions[n, Magnification -> 3/4];
    ],
    "remove" :> With[{n = nb[]},
      SetOptions[n, Background -> Inherited];
      SetOptions[n, Magnification -> Inherited];
    ]
  |>,
  
  "window" -> <|
    "apply" :> With[{n = nb[]},
      SetOptions[n, WindowMargins -> {{0, Automatic}, {Automatic, 0}}];
      SetOptions[n, WindowSize -> {Scaled[3/4], Scaled[1.0]}];
    ],
    "remove" :> With[{n = nb[]},
      SetOptions[n, WindowMargins -> Inherited];
      SetOptions[n, WindowSize -> Inherited];
    ]
  |>,
  
  "title" -> <|
    "apply" :> With[{n = nb[], name = safeNotebookBaseName[]},
      If[StringQ[name],
        SetOptions[n, WindowTitle -> StringJoin[" ------- ", name]]
      ]
    ],
    "remove" :> With[{n = nb[]},
      SetOptions[n, WindowTitle -> Inherited]
    ]
  |>,
  
  "selectionMove" -> <|
    "apply" :> With[{n = nb[]},
      SetOptions[n, CellEpilog :> SelectionMove[EvaluationNotebook[], Next, Cell]];
      SetOptions[n, CellProlog :> SelectionMove[EvaluationCell[], All, Cell]];
    ],
    "remove" :> With[{n = nb[]},
      SetOptions[n, CellEpilog -> Inherited];
      SetOptions[n, CellProlog -> Inherited];
    ]
  |>,
  
  "frontEndWorkingPrinting" -> <|
    "apply" :> SetOptions[$FrontEnd, PrintingStyleEnvironment -> "Working"],
    "remove" :> SetOptions[$FrontEnd, PrintingStyleEnvironment -> Inherited]
  |>,
  
  "dynamicUpdatingFE" -> <|
    "apply" :> SetOptions[$FrontEnd, "DynamicUpdating" -> True],
    "remove" :> SetOptions[$FrontEnd, "DynamicUpdating" -> Inherited]
  |>,
  
  "dynamicUpdatingNotebook" -> <|
    "apply" :> With[{n = nb[]},
      SetOptions[n, "DynamicUpdating" -> True]
    ],
    "remove" :> With[{n = nb[]},
      SetOptions[n, "DynamicUpdating" -> Inherited]
    ]
  |>,
  
  "dynamicEvaluationTimeoutFE" -> <|
    "apply" :> SetOptions[$FrontEnd, "DynamicEvaluationTimeout" -> 30],
    "remove" :> SetOptions[$FrontEnd, "DynamicEvaluationTimeout" -> Inherited]
  |>,
  
  "setDirectoryToNotebook" -> <|
    "apply" :> With[{dir = safeNotebookDirectory[]},
      If[DirectoryQ[dir], SetDirectory[dir]]
    ],
    "remove" :> Null
  |>,
  
  "privateNotebookOptions" -> <|
    "apply" :> With[{n = nb[]},
      SetOptions[
        n,
        PrivateNotebookOptions -> {
          "FileOutlineCache" -> False,
          "SafeFileOpen" -> "IgnoreCache"
        }
      ]
    ],
    "remove" :> With[{n = nb[]},
      SetOptions[n, PrivateNotebookOptions -> Inherited]
    ]
  |>,
  
  "showCellLabelOff" -> <|
    "apply" :> With[{n = nb[]},
      SetOptions[n, ShowCellLabel -> False]
    ],
    "remove" :> With[{n = nb[]},
      SetOptions[n, ShowCellLabel -> Inherited]
    ]
  |>,
  
  "autoGeneratedPackageNone" -> <|
    "apply" :> With[{n = nb[]},
      SetOptions[n, AutoGeneratedPackage -> None]
    ],
    "remove" :> With[{n = nb[]},
      SetOptions[n, AutoGeneratedPackage -> Inherited]
    ]
  |>,
  
  "autoMultiplicationSymbol" -> <|
    "apply" :> With[{n = nb[]},
      SetOptions[n, AutoMultiplicationSymbol -> True]
    ],
    "remove" :> With[{n = nb[]},
      SetOptions[n, AutoMultiplicationSymbol -> Inherited]
    ]
  |>,
  
  "initializationCellHandling" -> <|
    "apply" :> With[{n = nb[]},
      SetOptions[n, InitializationCellEvaluation -> False];
      SetOptions[n, InitializationCellWarning -> False];
    ],
    "remove" :> With[{n = nb[]},
      SetOptions[n, InitializationCellEvaluation -> Inherited];
      SetOptions[n, InitializationCellWarning -> Inherited];
    ]
  |>,
  
  "outputSizeLimit" -> <|
    "apply" :> With[{n = nb[]},
      SetOptions[n, OutputSizeLimit -> 100000]
    ],
    "remove" :> With[{n = nb[]},
      SetOptions[n, OutputSizeLimit -> Inherited]
    ]
  |>

|>;

availableSettings[] := Keys[$settingActions];

applyOneSetting[name_String] := Module[{},
  If[KeyExistsQ[$settingActions, name],
    $settingActions[name, "apply"],
    Print["applySettings: unknown setting block: ", name]
  ]
];

removeOneSetting[name_String] := Module[{},
  If[KeyExistsQ[$settingActions, name],
    $settingActions[name, "remove"],
    Print["removeSettings: unknown setting block: ", name]
  ]
];

applySettings[name_String] := applySettings[{name}];
applySettings[names_List] := (Scan[applyOneSetting, DeleteDuplicates @ names]; True);

removeSettings[name_String] := removeSettings[{name}];
removeSettings[names_List] := (Scan[removeOneSetting, DeleteDuplicates @ names]; True);


(* ============================================================
   Unified notebook helpers
   ============================================================ *)

ClearAll[nb, safeNotebookFileName, safeNotebookDirectory,
         safeNotebookBaseName, nbFileName, nbFileDirectory, nbFileBaseName];

nb[] := EvaluationNotebook[];

safeNotebookFileName[]  := Quiet @ NotebookFileName[nb[]];

safeNotebookDirectory[] := Module[{fn = safeNotebookFileName[]},
  If[StringQ[fn], DirectoryName[fn], $HomeDirectory]
];

safeNotebookBaseName[] := Module[{fn = safeNotebookFileName[]},
  If[StringQ[fn], FileBaseName[fn], "UnsavedNotebook"]
];

(* backward-compatible symbol aliases (delayed so they re-evaluate each time) *)
nbFileName      := safeNotebookFileName[];
nbFileDirectory := safeNotebookDirectory[];
nbFileBaseName  := safeNotebookBaseName[];


(* ============================================================
   notebookPathInfo
   ============================================================ *)

notebookPathInfo[] := <|
  "FileName"  -> safeNotebookFileName[],
  "Directory" -> safeNotebookDirectory[],
  "BaseName"  -> safeNotebookBaseName[]
|>;


(* ============================================================
   Focused notebook reports
   ============================================================ *)

ClearAll[
  currentDiagnosticNotebook, reportNotebookPaths,
  reportCellStyleInventory, reportMessageCellList
];

reportNotebookPaths::nofe =
  "No evaluation notebook is available; this report requires a notebook front end.";
reportCellStyleInventory::nofe =
  "No evaluation notebook is available; this report requires a notebook front end.";
reportMessageCellList::nofe =
  "No evaluation notebook is available; this report requires a notebook front end.";

currentDiagnosticNotebook[] := Module[{nbk},
  If[! TrueQ[$Notebooks], Return[$Failed]];
  nbk = Quiet @ Check[EvaluationNotebook[], $Failed];
  If[MatchQ[nbk, _NotebookObject], nbk, $Failed]
];

reportNotebookPaths[] := Module[{nbk, fileName, info},
  nbk = currentDiagnosticNotebook[];
  If[nbk === $Failed,
    Message[reportNotebookPaths::nofe];
    Return[$Failed]
  ];

  fileName = Quiet @ Check[NotebookFileName[nbk], $Failed];
  info = <|
    "Notebook" -> nbk,
    "FileName" -> If[StringQ[fileName], fileName, Missing["UnsavedNotebook"]],
    "Directory" -> If[StringQ[fileName], DirectoryName[fileName], Missing["UnsavedNotebook"]],
    "BaseName" -> If[StringQ[fileName], FileBaseName[fileName], Missing["UnsavedNotebook"]]
  |>;

  Print["Notebook paths:"];
  KeyValueMap[Print[Row[{"  ", #1, ": ", #2}]] &, info];
  info
];

reportCellStyleInventory[] := Module[{nbk, cells, rawStyles, styles, counts, report},
  nbk = currentDiagnosticNotebook[];
  If[nbk === $Failed,
    Message[reportCellStyleInventory::nofe];
    Return[$Failed]
  ];

  cells = Quiet @ Check[Cells[nbk], $Failed];
  If[cells === $Failed,
    Message[reportCellStyleInventory::nofe];
    Return[$Failed]
  ];
  rawStyles = Quiet @ Check[CurrentValue[#, CellStyle] & /@ cells, {}];
  styles = Replace[
    rawStyles,
    {
      style_String :> style,
      style_ :> ToString[Unevaluated[style], InputForm]
    },
    {1}
  ];
  counts = KeySort @ Counts[styles];
  report = <|"Counts" -> counts, "TotalCells" -> Length[cells]|>;

  Print["Cell-style inventory (", Length[cells], " cells):"];
  If[
    counts === <||>,
    Print["  (no cells)"],
    KeyValueMap[Print[Row[{"  ", #1, ": ", #2}]] &, counts]
  ];
  Print[Row[{"  Total: ", Length[cells]}]];
  report
];

reportMessageCellList[] := Module[{nbk, messageCells},
  nbk = currentDiagnosticNotebook[];
  If[nbk === $Failed,
    Message[reportMessageCellList::nofe];
    Return[$Failed]
  ];

  messageCells = Quiet @ Check[
    Cells[nbk, CellStyle -> {"Message", "MSG"}],
    $Failed
  ];
  If[messageCells === $Failed,
    Message[reportMessageCellList::nofe];
    Return[$Failed]
  ];

  Print["Message/MSG cells: ", Length[messageCells]];
  If[
    messageCells === {},
    Print["  (none)"],
    MapIndexed[Print[Row[{"  ", First[#2], ": ", #1}]] &, messageCells]
  ];
  messageCells
];


(* ============================================================
   Cell tools
   ============================================================ *)

cellsByStyle[styles_List] :=
  Select[Cells[nb[]], MemberQ[styles, CurrentValue[#, CellStyle]] &];

listInitializationCells[] := Module[{init, read},
  init = Select[Cells[nb[]],
    TrueQ @ CurrentValue[#, InitializationCell] &&
    MemberQ[{"Input", "Code"}, CurrentValue[#, CellStyle]] &
  ];
  read = NotebookRead /@ init;
  Cases[read, Cell[BoxData[boxes_], ___] :> ToString[boxes, InputForm]]
];

selectInitializationCells[] := Module[{init},
  init = Select[Cells[nb[]], TrueQ @ CurrentValue[#, InitializationCell] &];
  Scan[
    (NotebookLocate[#]; FrontEndExecute @ FrontEndToken[nb[], "SelectCell"]) &,
    init
  ];
  init
];

(* FIX: pattern guard added so only True/False are accepted, preventing
        silent misuse like markInputCellsAsInitialization["yes"] *)
markInputCellsAsInitialization[tf : (True | False) : True] :=
  Module[{inputCells},
    inputCells = Select[Cells[nb[]], CurrentValue[#, CellStyle] === "Input" &];
    SetOptions[inputCells, InitializationCell -> tf];
    Length[inputCells]
  ];


(* ============================================================
   deleteAllEmptyCellsInNotebook
   FIX: old ExportPacket approach was unreliable.
        Replaced with direct BoxData/RowBox pattern matching.
   ============================================================ *)

ClearAll[deleteAllEmptyCellsInNotebook, emptyCellQ];

emptyCellQ[cellObj_CellObject] := Module[{raw, content},
  raw = Quiet @ Check[NotebookRead[cellObj], $Failed];
  If[raw === $Failed || ! MatchQ[raw, Cell[_, ___]],
    Return[False]
  ];
  content = First[raw];
  Or[
    content === "",
    content === "\[Null]",
    (StringQ[content] && StringTrim[content] === ""),
    MatchQ[content, BoxData[""]],
    MatchQ[content, BoxData[RowBox[{""}]]],
    MatchQ[content, BoxData[RowBox[{}]]],
    MatchQ[content, RowBox[{""}]],
    MatchQ[content, RowBox[{}]]
  ]
];

(*emptyCellQ[cellObj_CellObject] := Module[{content},
  content = First @ NotebookRead[cellObj];
  Or[
    (* plain-text cells *)
    content === "",
    content === "\[Null]",
    (StringQ[content] && StringTrim[content] === ""),
    (* box-based cells (most Input / Code cells) *)
    MatchQ[content, BoxData[""]],
    MatchQ[content, BoxData[RowBox[{""}]]],
    MatchQ[content, BoxData[RowBox[{}]]],
    MatchQ[content, RowBox[{""}]],
    MatchQ[content, RowBox[{}]]
  ]
];
*)
deleteAllEmptyCellsInNotebook :=
  NotebookDelete /@ Select[Cells[GeneratedCell -> False], emptyCellQ];


(* ============================================================
   saveNotebookTextCopy
   ============================================================ *)

saveNotebookTextCopy[suffix_: "-output", ext_: "txt"] := Module[{fn, out},
  fn = ensureNotebookSaved[];
  If[fn === $Failed, Return[$Failed]];
  out = FileNameJoin[{DirectoryName[fn], FileBaseName[fn] <> suffix <> "." <> ext}];
  Export[out, NotebookGet[nb[]], "Text"];
  out
];


ClearAll[saveVersionedCopy];
saveVersionedCopy::nofe = "No evaluation notebook is available.";
saveVersionedCopy::mkdir = "Could not create output directory `1`.";
saveVersionedCopy::save = "Could not save the evaluation notebook to its original path `1`.";
saveVersionedCopy::copy = "Could not copy the saved notebook to `1`.";
saveVersionedCopy::text = "The notebook copy was created, but text export to `1` failed.";

saveVersionedCopy[
  tag_String : "",
  whereDir : (_String | Automatic) : Automatic
] := Module[
  {nb$, nbPath$, nbBase$, stamp$, vTag$, baseName$, outDir$, nbOut$, txtOut$,
   ok},

  If[! TrueQ[$Notebooks],
    Message[saveVersionedCopy::nofe];
    Return[$Failed]
  ];

  (* Capture once and use this NotebookObject for every subsequent operation. *)
  nb$ = EvaluationNotebook[];
  If[! MatchQ[nb$, _NotebookObject],
    Message[saveVersionedCopy::nofe];
    Return[$Failed]
  ];

  nbPath$ = Quiet @ Check[NotebookFileName[nb$], $Failed];
  If[! StringQ[nbPath$] || nbPath$ === "" || ! FileExistsQ[nbPath$],
    Message[ensureNotebookSaved::unsaved];
    Return[$Failed]
  ];
  nbPath$ = ExpandFileName[nbPath$];
  nbBase$ = FileBaseName[nbPath$];

  outDir$ = ExpandFileName @ Replace[whereDir,
    Automatic :> configuredProjectDirectory["BackupDirectory", "backups"]];
  If[! DirectoryQ[outDir$],
    ok = Quiet @ Check[
      CreateDirectory[outDir$, CreateIntermediateDirectories -> True];
      True,
      False
    ];
    If[! TrueQ[ok] || ! DirectoryQ[outDir$],
      Message[saveVersionedCopy::mkdir, outDir$];
      Return[$Failed]
    ]
  ];

  stamp$ = "D" <> DateString[Riffle[{"YearShort", "Month", "Day"}, ""]] <>
           "-T" <> DateString[Riffle[{"Hour", "Minute", "Second"}, ""]];
  vTag$ = If[tag === "", "", "_" <> tag];
  baseName$ = nbBase$ <> "_" <> stamp$ <> vTag$;
  nbOut$ = FileNameJoin[{outDir$, baseName$ <> ".nb"}];
  txtOut$ = FileNameJoin[{outDir$, baseName$ <> ".txt"}];

  (* Save current edits to the original file without changing notebook identity. *)
  ok = Quiet @ Check[NotebookSave[nb$, nbPath$]; True, False];
  If[! TrueQ[ok],
    Message[saveVersionedCopy::save, nbPath$];
    Return[$Failed]
  ];

  ok = Quiet @ Check[
    CopyFile[nbPath$, nbOut$, OverwriteTarget -> False];
    True,
    False
  ];
  If[! TrueQ[ok],
    Message[saveVersionedCopy::copy, nbOut$];
    Return[$Failed]
  ];

  ok = Quiet @ Check[
    Export[txtOut$, NotebookGet[nb$], "Text"];
    True,
    False
  ];
  If[! TrueQ[ok],
    Message[saveVersionedCopy::text, txtOut$];
    Return[$Failed]
  ];

  Print["**********************************************************************************"];
  Print["  versioned copy saved to : ", outDir$];
  Print["  base name               : ", baseName$];
  Print["  .nb path                : ", nbOut$];
  Print["  .txt path               : ", txtOut$];
  Print["**********************************************************************************"];

  <|"Notebook" -> nbOut$, "Text" -> txtOut$|>
];




(* ============================================================
   showDiagnostics
 TO CHECK: it works for Cells with multiple styles? does it?
   ============================================================ *)

ClearAll[showDiagnostics];
showDiagnostics::badmode =
  "Unknown mode `1`. Use one of: \"minimal\", \"session\", \"cells\", \"frontend\", \"full\".";

showDiagnostics[mode_: "full"] := Module[
  {nbk = nb[], info = notebookPathInfo[], all, initCells, inputCells, msgCells, outCells, prCells},

  all        = Cells[nbk];
  initCells  = Select[all, TrueQ @ CurrentValue[#, InitializationCell] &];
  inputCells = Select[all, MemberQ[CurrentValue[#,CellStyle],"Input" ]&];
  outCells   = Select[all,MemberQ[CurrentValue[#,CellStyle],"Output" ]&];
  prCells    = Select[all,MemberQ[CurrentValue[#,CellStyle],"Print" ]&];
  msgCells   = Select[all, MemberQ[{"Message", "MSG"}, CurrentValue[#, CellStyle]] &];
  Print["notebook: ",nbk];

  With[
    {
      pHeader = (Print["\n=== ", #, " ==="] &),
      pKV     = (Print[Row[{#1, " ", #2}]] &)
    },
    Switch[mode,

      "minimal",
        pHeader["minimal"];
        pKV["Notebook:", info["FileName"]];
        pKV["Dir:", info["Directory"]];
        pKV["Base:", info["BaseName"]];
        pKV["Init cells:", Length @ initCells];
        pKV["Input cells:", Length @ inputCells];
        pKV["Message cells:", Length @ msgCells];
        pKV["AutoGeneratedPackage:", CurrentValue[nbk, AutoGeneratedPackage]];
        pKV["StyleDefinitions:",
          Replace[Options[nbk, StyleDefinitions], {StyleDefinitions -> v_} :> v]];,

      "session",
        pHeader["session"];
        pKV["$Context:", $Context];
        pKV["$ContextPath:", $ContextPath];
        pKV["$HistoryLength:", $HistoryLength];
        pKV["Directory[]:", Directory[]];
        pKV["NotebookDirectory[]:", Quiet @ NotebookDirectory[]];
        pKV["$MessageList:", $MessageList];,

      "cells",
        pHeader["cells"];
        pKV["Init cells:", Length @ initCells];
        pKV["Input cells:", Length @ inputCells];
        pKV["Output cells:", Length @ outCells];
        pKV["Print cells:", Length @ prCells];
        pKV["Message cells (Message/MSG):", Length @ msgCells];
        pHeader["cell style inventory"];
        Scan[
          Function[{r},
            pKV[First[r] <> ":",
              Length @ Select[all,MemberQ[ CurrentValue[#, CellStyle], Last[r]] &]]
          ],
          {"Title" -> "Title", "Subtitle" -> "Subtitle",
           "Subsubtitle" -> "Subsubtitle", "Section" -> "Section",
           "Subsection" -> "Subsection", "Subsubsection" -> "Subsubsection",
           "Text" -> "Text", "Code" -> "Code", "Input" -> "Input",
           "Output" -> "Output", "Print" -> "Print",
           "ExampleText" -> "ExampleText", "Message" -> "Message", "MSG" -> "MSG"}
        ];
        pKV["Total cells:", Length @ all];,

      "frontend",
              pHeader["frontend"];
        pKV["AutoGeneratedPackage:", CurrentValue[nbk, AutoGeneratedPackage]];
        pKV["StyleDefinitions:",Replace[Options[nbk, StyleDefinitions], {StyleDefinitions -> v_} :> v]];
(*        pKV["DockedCells:",Replace[Options[nbk, DockedCells], {DockedCells -> v_} :> v]];*)(*too verbose...*)
        pKV["PrivateNotebookOptions:",          Replace[Options[nbk, PrivateNotebookOptions], {PrivateNotebookOptions -> v_} :> v]];
        
                pHeader["$FrontEnd options"];   
        pKV["MessageOptions:",          Replace[Options[$FrontEnd, "MessageOptions"],            {("MessageOptions" -> v_) :> v, ___ :> Missing["NotAvailable"]}]];
        pKV["PrintAction:",          Replace[Options[$FrontEnd, "PrintAction"],            {("PrintAction" -> v_) :> v, ___ :> Missing["NotAvailable"]}]];
 
               pHeader["window"];
        pKV["WindowSize:", CurrentValue[nbk, WindowSize]];
        pKV["WindowMargins:", CurrentValue[nbk, WindowMargins]];,

      "full",
        (* FIX: call each mode explicitly rather than relying on the default *)
        pHeader["full"];
        showDiagnostics["minimal"];
        showDiagnostics["session"];
        showDiagnostics["cells"];
        showDiagnostics["frontend"];,

      _,
        Message[showDiagnostics::badmode, mode];
        Return[$Failed]
    ]
  ];
  True
];


(* ============================================================
   Legacy helpers
   ============================================================ *)

SetAttributes[{showIt, printD}, HoldAll];
showIt[x_]   := Module[{y}, Print[Unevaluated[x], " = ", y = x]; y];
printD[x_]   := showIt[x];

SetAttributes[printA, HoldFirst];
printA[var_] := Print[SymbolName[Unevaluated[var]], " = ", Evaluate[var]];


(* ============================================================
   killStop
   FIX: ClearAll added (was missing, unlike all other symbols)
   ============================================================ *)

ClearAll[killStop];
killStop :=(
  bigBanner[" killStop - forced stopping evaluation "];
  Print @ Cells[CellStyle -> {"MSG", "Message"}];
   FrontEndExecute @ FrontEndToken["EvaluatorAbort"]
   );


(* ============================================================
   Export helpers: saveAsPngAllOutputCells / saveAsPdfAllOutputCells
   ============================================================ *)

ClearAll[
  saveAsPngAllOutputCells, saveAsPdfAllOutputCells,
  safeExportDir, safeNotebookBase, outputCells, pad3, exportCellFE
];

safeExportDir[dir_] := Module[{d = dir},
  If[d === Automatic,
    d = FileNameJoin[{
      configuredProjectDirectory["OutputDirectory", "output"],
      "notebook-cells"
    }]
  ];
  If[! StringQ[d] || d === $Failed, d = $HomeDirectory];
  If[! DirectoryQ[d], CreateDirectory[d, CreateIntermediateDirectories -> True]];
  d
];

safeNotebookBase[nbk_NotebookObject] := Module[{fn},
  fn = Quiet @ NotebookFileName[nbk];
  If[StringQ[fn], FileBaseName[fn], "UnsavedNotebook"]
];

outputCells[nbk_NotebookObject] := Cells[nbk, CellStyle -> "Output"];

pad3[i_Integer] := IntegerString[i, 10, 3];

exportCellFE[cell_CellObject, fmt_String] := Module[{expr},
  expr = NotebookRead[cell];
  FrontEndExecute @ FrontEnd`ExportPacket[expr, fmt]
];

saveAsPngAllOutputCells[dir_: Automatic, imageSize_: Scaled[.8]] := Module[
  {nbk = EvaluationNotebook[], d, base, cells, files},
  d     = safeExportDir[dir];
  base  = safeNotebookBase[nbk];
  cells = outputCells[nbk];
  If[cells === {}, Return[{}]];
  files = MapIndexed[
    Function[{cell, idx},
      Module[{fn},
        fn = FileNameJoin[{d, base <> "-cell-" <> pad3[First[idx]] <> ".png"}];
        Export[fn, exportCellFE[cell, "PNG"], "PNG", ImageSize -> imageSize];
        fn
      ]
    ],
    cells
  ];
  files
];

saveAsPdfAllOutputCells[dir_: Automatic, imageSize_: Scaled[.8]] := Module[
  {nbk = EvaluationNotebook[], d, base, cells, files},
  d     = safeExportDir[dir];
  base  = safeNotebookBase[nbk];
  cells = outputCells[nbk];
  If[cells === {}, Return[{}]];
  files = MapIndexed[
    Function[{cell, idx},
      Module[{fn},
        fn = FileNameJoin[{d, base <> "-cell-" <> pad3[First[idx]] <> ".pdf"}];
        Export[fn, exportCellFE[cell, "PDF"], "PDF", ImageSize -> imageSize];
        fn
      ]
    ],
    cells
  ];
  files
];


ClearAll[
  cellStylesEditorPalette, cellStylesScannerPalette,
  explicitCellBackground, restoreCellBackgrounds, cellOptionValueQ
];

explicitCellBackground[cell_CellObject] := Module[{rules},
  rules = Quiet @ Check[Options[cell, Background], {}];
  Replace[rules, {
    {___, Background -> value_, ___} :> value,
    _ :> Inherited
  }]
];

restoreCellBackgrounds[cells_List, backgrounds_List] := Module[{count},
  count = Min[Length[cells], Length[backgrounds]];
  Do[
    Quiet @ Check[SetOptions[cells[[i]], Background -> backgrounds[[i]]], Null],
    {i, count}
  ];
  Null
];

cellOptionValueQ[cell_CellObject, option_, desired : (True | False)] :=
  TrueQ[Quiet @ Check[CurrentValue[cell, option], $Failed] === desired];

cellStylesEditorPalette :=
  CreatePalette[
    DynamicModule[
      {
        nb = InputNotebook[], styles = {}, style = "Input",
        targetCells = {}, previewing = False,
        previewCells = {}, previewBackups = {},
        minimized = False, selectionMode = "By Style",
        bgColor = Lighter[Yellow, 0.6],
        fmtOptions = {
          Background, FontColor, FontSize, FontWeight, FontSlant,
          FontFamily, TextAlignment, CellMargins,
          CellFrame, CellFrameColor, CellFrameMargins, CellFrameLabels,
          CellDingbat, FormatType, LineSpacing, LinebreakAdjustments
        }
      },

      Column[
        {
          Style["Cell Batch Editor", Bold, 14],

          Row[
            {
              "Target: ",
              SetterBar[
                Dynamic[
                  selectionMode,
                  Function[newMode,
                    If[previewing,
                      restoreCellBackgrounds[previewCells, previewBackups]
                    ];
                    selectionMode = newMode;
                    targetCells = {};
                    previewing = False;
                    previewCells = {};
                    previewBackups = {};
                  ]
                ],
                {"By Style", "Mouse Selection"}
              ]
            },
            Alignment -> Center
          ],

          Dynamic[
            If[
              minimized,

              Column[
                {
                  Style["Palette minimized", GrayLevel[0.4], 10],

                  Row[
                    {
                      Button[
                        Style["-", White, FontSize -> 10, Bold],
                        minimized = False,
                        ImageSize -> {42, 18},
                        Background -> RGBColor[0.2, 0.65, 0.25],
                        Method -> "Queued"
                      ],

                      Spacer[8],

                      Button[
                        Style["\[Times]", White, FontSize -> 10, Bold],
                        (
                          If[previewing,
                            restoreCellBackgrounds[previewCells, previewBackups];
                            previewing = False;
                            previewCells = {};
                            previewBackups = {};
                          ];
                          NotebookClose[EvaluationNotebook[]]
                        ),
                        ImageSize -> {42, 18},
                        Background -> RGBColor[0.78, 0.18, 0.18],
                        Method -> "Queued"
                      ]
                    },
                    Alignment -> Center
                  ]
                },
                Spacings -> 1.0,
                Alignment -> Center
              ],

              Column[
                {
                  Dynamic[
                    Row[
                      {
                        "Style: ",
                        PopupMenu[
                          Dynamic[
                            style,
                            Function[newStyle,
                              If[previewing,
                                restoreCellBackgrounds[previewCells, previewBackups]
                              ];
                              style = newStyle;
                              targetCells = {};
                              previewing = False;
                              previewCells = {};
                              previewBackups = {};
                            ]
                          ],
                          Thread[styles -> styles],
                          FieldSize -> 16,
                          Enabled -> Dynamic[selectionMode === "By Style"]
                        ]
                      },
                      Alignment -> Center
                    ]
                  ],

                  Row[
                    {
                      Button[
                        "Refresh Styles",
                        Module[{cells, rawStyles},
                          If[previewing,
                            restoreCellBackgrounds[previewCells, previewBackups]
                          ];
                          nb = InputNotebook[];
                          cells = Cells[nb];
                          rawStyles = Quiet[CurrentValue[cells, CellStyle]];
                          styles = Sort @ DeleteDuplicates @ Cases[Flatten @ {rawStyles}, _String];
                          If[styles === {}, styles = {"Input"}];
                          If[!MemberQ[styles, style], style = First[styles]];
                          targetCells = {};
                          previewing = False;
                          previewCells = {};
                          previewBackups = {};
                        ],
                        ImageSize -> 120
                      ],

                      Button[
                        "Find",
                        Module[{},
                          If[selectionMode === "By Style",
                            nb = InputNotebook[];

                            If[previewing,
                              restoreCellBackgrounds[previewCells, previewBackups];
                            ];

                            previewing = False;
                            previewCells = {};

                            targetCells =
                              Select[
                                Cells[nb],
                                MemberQ[Flatten @ {CurrentValue[#, CellStyle]}, style] &
                              ];

                            previewBackups = {};
                          ];
                        ],
                        ImageSize -> 80,
                        Enabled -> Dynamic[selectionMode === "By Style"]
                      ]
                    },
                    Alignment -> Center
                  ],

                  Dynamic[
                    Module[{cells},
                      cells =
                        If[selectionMode === "Mouse Selection",
                          SelectedCells[InputNotebook[]],
                          targetCells
                        ];

                      Which[
                        selectionMode === "Mouse Selection" && cells === {},
                        "No mouse-selected cells.",
                        selectionMode === "Mouse Selection",
                        ToString[Length[cells]] <> " mouse-selected cell(s).",
                        targetCells === {},
                        "No active selection. Click Find first.",
                        True,
                        ToString[Length[targetCells]] <> " cell(s) with style \"" <> style <> "\""
                      ]
                    ]
                  ],

                  Button[
                    Dynamic[If[previewing, "Unpreview (restore)", "Preview Matches"]],
                    Module[{cells},
                      cells =
                        If[selectionMode === "Mouse Selection",
                          SelectedCells[InputNotebook[]],
                          targetCells
                        ];

                      If[
                        !previewing && cells =!= {},
                        previewCells = cells;
                        previewBackups = explicitCellBackground /@ previewCells;
                        Do[
                          Quiet[SetOptions[previewCells[[i]], Background -> Lighter[Cyan, 0.55]]],
                          {i, Length[previewCells]}
                        ];
                        previewing = True,

                        If[previewing,
                          restoreCellBackgrounds[previewCells, previewBackups];
                          previewCells = {};
                          previewBackups = {};
                          previewing = False
                        ]
                      ]
                    ],
                    ImageSize -> 205
                  ],

                  Framed[
                    Column[
                      {
                        Style["Apply to all matching cells", Bold, 11, GrayLevel[0.25]],

                        Button[
                          "Clear All Formatting",
                          Module[{cells},
                            cells =
                              If[selectionMode === "Mouse Selection",
                                SelectedCells[InputNotebook[]],
                                targetCells
                              ];

                            If[previewing,
                              restoreCellBackgrounds[previewCells, previewBackups];
                              previewing = False;
                              previewCells = {};
                              previewBackups = {};
                            ];

                            Do[
                              Quiet[SetOptions[c, Thread[fmtOptions -> Inherited]]],
                              {c, cells}
                            ];

                            MessageDialog[
                              ToString[Length[cells]] <> " cell(s) formatting cleared."
                            ];
                          ],
                          ImageSize -> 205
                        ],

                        Button[
                          "Clear Background Only",
                          Module[{cells},
                            cells =
                              If[selectionMode === "Mouse Selection",
                                SelectedCells[InputNotebook[]],
                                targetCells
                              ];

                            If[previewing,
                              restoreCellBackgrounds[previewCells, previewBackups];
                              previewing = False;
                              previewCells = {};
                              previewBackups = {};
                            ];

                            Do[
                              Quiet[SetOptions[c, Background -> Inherited]],
                              {c, cells}
                            ];
                          ],
                          ImageSize -> 205
                        ],

                        Row[
                          {
                            Button[
                              "Set Background",
                              Module[{cells},
                                cells =
                                  If[selectionMode === "Mouse Selection",
                                    SelectedCells[InputNotebook[]],
                                    targetCells
                                  ];

                                If[previewing,
                                  restoreCellBackgrounds[previewCells, previewBackups];
                                  previewing = False;
                                  previewCells = {};
                                  previewBackups = {};
                                ];

                                Do[
                                  Quiet[SetOptions[c, Background -> bgColor]],
                                  {c, cells}
                                ];
                              ],
                              ImageSize -> 133
                            ],
                            ColorSetter[Dynamic[bgColor], ImageSize -> {44, 22}]
                          },
                          Alignment -> Center
                        ],

                        Delimiter,

                        Row[
                          {
                            Button[
                              "Set InitCell",
                              Module[{cells},
                                cells =
                                  If[selectionMode === "Mouse Selection",
                                    SelectedCells[InputNotebook[]],
                                    targetCells
                                  ];
                                Do[
                                  Quiet[SetOptions[c, InitializationCell -> True]],
                                  {c, cells}
                                ];
                              ],
                              ImageSize -> 100
                            ],
                            Button[
                              "Unset InitCell",
                              Module[{cells},
                                cells =
                                  If[selectionMode === "Mouse Selection",
                                    SelectedCells[InputNotebook[]],
                                    targetCells
                                  ];
                                Do[
                                  Quiet[SetOptions[c, InitializationCell -> Inherited]],
                                  {c, cells}
                                ];
                              ],
                              ImageSize -> 100
                            ]
                          },
                          Alignment -> Center
                        ],

                        Row[
                          {
                            Button[
                              "Evaluatable",
                              Module[{cells},
                                cells =
                                  If[selectionMode === "Mouse Selection",
                                    SelectedCells[InputNotebook[]],
                                    targetCells
                                  ];
                                Do[
                                  Quiet[SetOptions[c, Evaluatable -> True]],
                                  {c, cells}
                                ];
                              ],
                              ImageSize -> 100
                            ],
                            Button[
                              "Non-Eval.",
                              Module[{cells},
                                cells =
                                  If[selectionMode === "Mouse Selection",
                                    SelectedCells[InputNotebook[]],
                                    targetCells
                                  ];
                                Do[
                                  Quiet[SetOptions[c, Evaluatable -> False]],
                                  {c, cells}
                                ];
                              ],
                              ImageSize -> 100
                            ]
                          },
                          Alignment -> Center
                        ],

                        Row[
                          {
                            Button[
                              "Editable",
                              Module[{cells},
                                cells =
                                  If[selectionMode === "Mouse Selection",
                                    SelectedCells[InputNotebook[]],
                                    targetCells
                                  ];
                                Do[
                                  Quiet[SetOptions[c, Editable -> True]],
                                  {c, cells}
                                ];
                              ],
                              ImageSize -> 100
                            ],
                            Button[
                              "Read-only",
                              Module[{cells},
                                cells =
                                  If[selectionMode === "Mouse Selection",
                                    SelectedCells[InputNotebook[]],
                                    targetCells
                                  ];
                                Do[
                                  Quiet[SetOptions[c, Editable -> False]],
                                  {c, cells}
                                ];
                              ],
                              ImageSize -> 100
                            ]
                          },
                          Alignment -> Center
                        ],

                        Row[
                          {
                            Button[
                              "Open Cells",
                              Module[{cells},
                                cells =
                                  If[selectionMode === "Mouse Selection",
                                    SelectedCells[InputNotebook[]],
                                    targetCells
                                  ];
                                Do[
                                  Quiet[SetOptions[c, CellOpen -> True]],
                                  {c, cells}
                                ];
                              ],
                              ImageSize -> 100
                            ],
                            Button[
                              "Close Cells",
                              Module[{cells},
                                cells =
                                  If[selectionMode === "Mouse Selection",
                                    SelectedCells[InputNotebook[]],
                                    targetCells
                                  ];
                                Do[
                                  Quiet[SetOptions[c, CellOpen -> False]],
                                  {c, cells}
                                ];
                              ],
                              ImageSize -> 100
                            ]
                          },
                          Alignment -> Center
                        ]
                      },
                      Spacings -> 0.9,
                      Alignment -> Center
                    ],
                    FrameMargins -> 8,
                    RoundingRadius -> 5,
                    FrameStyle -> Directive[GrayLevel[0.65], Dashed]
                  ],

                  Row[
                    {
                      Button[
                        Style["-", White, FontSize -> 10, Bold],
                        minimized = True,
                        ImageSize -> {42, 18},
                        Background -> RGBColor[0.2, 0.65, 0.25],
                        Method -> "Queued"
                      ],

                      Spacer[8],

                      Button[
                        Style["\[Times]", White, FontSize -> 10, Bold],
                        (
                          If[previewing,
                            restoreCellBackgrounds[previewCells, previewBackups];
                            previewing = False;
                            previewCells = {};
                            previewBackups = {};
                          ];
                          NotebookClose[EvaluationNotebook[]]
                        ),
                        ImageSize -> {42, 18},
                        Background -> RGBColor[0.78, 0.18, 0.18],
                        Method -> "Queued"
                      ]
                    },
                    Alignment -> Center
                  ]
                },
                Spacings -> 1.2,
                Alignment -> Center
              ]
            ]
          ]
        },
        Spacings -> 1.2,
        Alignment -> Center
      ],

      Initialization :> (
        nb = InputNotebook[];
        Module[{cells, rawStyles},
          cells = Cells[nb];
          rawStyles = Quiet[CurrentValue[cells, CellStyle]];
          styles = Sort @ DeleteDuplicates @ Cases[Flatten @ {rawStyles}, _String];
          If[styles === {}, styles = {"Input"}];
          If[!MemberQ[styles, style], style = First[styles]]
        ]
      ),

      Deinitialization :> (
        If[previewing,
          restoreCellBackgrounds[previewCells, previewBackups]
        ]
      )
    ],

    WindowTitle -> "Cell Batch Editor"
  ];


ClearAll[cellStylesScannerPalette];

cellStylesScannerPalette :=
  CreatePalette[
    DynamicModule[
      {
        nb = InputNotebook[], styles = {}, style = "Message",
        matches = {}, index = 0, prop = "Initialization",
        propMatches = {}, propIndex = 0,
        highlightedCell = None, oldBackground = Inherited,
        propList = {
          "Initialization", "Evaluatable", "Editable", "Open", "Deletable",
          "Non-Initialization", "Non-Evaluatable", "Non-Editable", "Closed", "Non-Deletable"
        },
        propOptionMap = <|
          "Initialization" -> {InitializationCell, True},
          "Evaluatable" -> {Evaluatable, True},
          "Editable" -> {Editable, True},
          "Open" -> {CellOpen, True},
          "Deletable" -> {Deletable, True},
          "Non-Initialization" -> {InitializationCell, False},
          "Non-Evaluatable" -> {Evaluatable, False},
          "Non-Editable" -> {Editable, False},
          "Closed" -> {CellOpen, False},
          "Non-Deletable" -> {Deletable, False}
        |>,
        minimized = False
      },

      Column[
        {
          Style["Cell Style Scanner", Bold, 14],

          Dynamic[
            If[
              minimized,

              Column[
                {
                  Style["Palette minimized", GrayLevel[0.4], 10],

                  Row[
                    {
                      Button[
                        Style["-", White, FontSize -> 10, Bold],
                        minimized = False,
                        ImageSize -> {42, 18},
                        Background -> RGBColor[0.2, 0.65, 0.25],
                        Method -> "Queued"
                      ],

                      Spacer[8],

                      Button[
                        Style["\[Times]", White, FontSize -> 10, Bold],
                        (
                          If[highlightedCell =!= None,
                            Quiet[SetOptions[highlightedCell, Background -> oldBackground]];
                            highlightedCell = None;
                            oldBackground = Inherited;
                          ];
                          NotebookClose[EvaluationNotebook[]]
                        ),
                        ImageSize -> {42, 18},
                        Background -> RGBColor[0.78, 0.18, 0.18],
                        Method -> "Queued"
                      ]
                    },
                    Alignment -> Center
                  ]
                },
                Spacings -> 1.0,
                Alignment -> Center
              ],

              Column[
                {
                  Button[
                    "Refresh Styles",
                    Module[{cells, rawStyles},
                      If[highlightedCell =!= None,
                        Quiet[SetOptions[highlightedCell, Background -> oldBackground]]
                      ];
                      highlightedCell = None;
                      oldBackground = Inherited;
                      matches = {};
                      index = 0;
                      propMatches = {};
                      propIndex = 0;
                      nb = InputNotebook[];
                      cells = Cells[nb];
                      rawStyles = Quiet[CurrentValue[cells, CellStyle]];
                      styles = Sort @ DeleteDuplicates @ Cases[Flatten @ {rawStyles}, _String];
                      If[styles === {}, styles = {"Input"}];
                      If[!MemberQ[styles, style], style = First[styles]];
                    ],
                    ImageSize -> 120
                  ],

                  Dynamic[
                    Row[
                      {
                        "Style: ",
                        PopupMenu[
                          Dynamic[
                            style,
                            Function[newStyle,
                              If[highlightedCell =!= None,
                                Quiet[SetOptions[highlightedCell, Background -> oldBackground]]
                              ];
                              highlightedCell = None;
                              oldBackground = Inherited;
                              matches = {};
                              index = 0;
                              propMatches = {};
                              propIndex = 0;
                              style = newStyle;
                            ]
                          ],
                          Thread[styles -> styles],
                          FieldSize -> 16
                        ]
                      },
                      Alignment -> Center
                    ]
                  ],

                  Row[
                    {
                      Button[
                        "Scan",
                        Module[{},
                          nb = InputNotebook[];
                          matches = Cells[nb, CellStyle -> style];
                          propMatches = {};
                          propIndex = 0;
                          index = If[matches === {}, 0, 1];

                          If[highlightedCell =!= None,
                            Quiet[SetOptions[highlightedCell, Background -> oldBackground]];
                            highlightedCell = None;
                            oldBackground = Inherited;
                          ];

                          If[matches === {},
                            MessageDialog["No cells found with style \"" <> style <> "\"."],
                            SelectionMove[matches[[index]], All, Cell];
                            oldBackground = explicitCellBackground[matches[[index]]];
                            Quiet[SetOptions[matches[[index]], Background -> Lighter[Yellow, 0.7]]];
                            highlightedCell = matches[[index]];
                          ];
                        ],
                        ImageSize -> 100
                      ],

                      Button[
                        "Count",
                        MessageDialog[
                          "Found " <>
                            ToString[Length[Cells[nb, CellStyle -> style]]] <>
                            " cell(s) with style \"" <> style <> "\"."
                        ],
                        ImageSize -> 100
                      ]
                    },
                    Alignment -> Center
                  ],

                  Framed[
                    Column[
                      {
                        Style["Cell Property Filter", Bold, 11, GrayLevel[0.25]],

                        Dynamic[
                          Row[
                            {
                              "Property: ",
                              PopupMenu[
                                Dynamic[
                                  prop,
                                  Function[newProp,
                                    If[highlightedCell =!= None,
                                      Quiet[SetOptions[highlightedCell, Background -> oldBackground]]
                                    ];
                                    highlightedCell = None;
                                    oldBackground = Inherited;
                                    matches = {};
                                    index = 0;
                                    propMatches = {};
                                    propIndex = 0;
                                    prop = newProp;
                                  ]
                                ],
                                propList,
                                FieldSize -> 16
                              ]
                            },
                            Alignment -> Center
                          ]
                        ],

                        Row[
                          {
                            Button[
                              "Scan",
                              Module[{optName, desired},
                                nb = InputNotebook[];
                                {optName, desired} = propOptionMap[prop];
                                propMatches = Select[
                                  Cells[nb],
                                  cellOptionValueQ[#, optName, desired] &
                                ];
                                matches = {};
                                index = 0;
                                propIndex = If[propMatches === {}, 0, 1];

                                If[highlightedCell =!= None,
                                  Quiet[SetOptions[highlightedCell, Background -> oldBackground]];
                                  highlightedCell = None;
                                  oldBackground = Inherited;
                                ];

                                If[propMatches === {},
                                  MessageDialog["No cells found with property \"" <> prop <> "\"."],
                                  SelectionMove[propMatches[[propIndex]], All, Cell];
                                  oldBackground = explicitCellBackground[propMatches[[propIndex]]];
                                  Quiet[SetOptions[propMatches[[propIndex]], Background -> Lighter[Orange, 0.7]]];
                                  highlightedCell = propMatches[[propIndex]];
                                ];
                              ],
                              ImageSize -> 100
                            ],

                            Button[
                              "Count",
                              Module[{optName, desired},
                                {optName, desired} = propOptionMap[prop];
                                MessageDialog[
                                  "Found " <>
                                    ToString[
                                      Length[
                                        Select[
                                          Cells[nb],
                                          cellOptionValueQ[#, optName, desired] &
                                        ]
                                      ]
                                    ] <>
                                    " cell(s) with property \"" <> prop <> "\"."
                                ]
                              ],
                              ImageSize -> 100
                            ]
                          },
                          Alignment -> Center
                        ]
                      },
                      Spacings -> 0.9,
                      Alignment -> Center
                    ],
                    FrameMargins -> 8,
                    RoundingRadius -> 5,
                    FrameStyle -> Directive[GrayLevel[0.65], Dashed]
                  ],

                  Row[
                    {
                      Button[
                        "Previous",
                        If[propMatches =!= {},
                          If[highlightedCell =!= None,
                            Quiet[SetOptions[highlightedCell, Background -> oldBackground]]
                          ];
                          propIndex = If[propIndex <= 1, Length[propMatches], propIndex - 1];
                          SelectionMove[propMatches[[propIndex]], All, Cell];
                          oldBackground = explicitCellBackground[propMatches[[propIndex]]];
                          Quiet[SetOptions[propMatches[[propIndex]], Background -> Lighter[Orange, 0.7]]];
                          highlightedCell = propMatches[[propIndex]],

                          If[matches =!= {},
                            If[highlightedCell =!= None,
                              Quiet[SetOptions[highlightedCell, Background -> oldBackground]]
                            ];
                            index = If[index <= 1, Length[matches], index - 1];
                            SelectionMove[matches[[index]], All, Cell];
                            oldBackground = explicitCellBackground[matches[[index]]];
                            Quiet[SetOptions[matches[[index]], Background -> Lighter[Yellow, 0.7]]];
                            highlightedCell = matches[[index]]
                          ]
                        ],
                        ImageSize -> 100
                      ],

                      Button[
                        "Next",
                        If[propMatches =!= {},
                          If[highlightedCell =!= None,
                            Quiet[SetOptions[highlightedCell, Background -> oldBackground]]
                          ];
                          propIndex = If[propIndex >= Length[propMatches], 1, propIndex + 1];
                          SelectionMove[propMatches[[propIndex]], All, Cell];
                          oldBackground = explicitCellBackground[propMatches[[propIndex]]];
                          Quiet[SetOptions[propMatches[[propIndex]], Background -> Lighter[Orange, 0.7]]];
                          highlightedCell = propMatches[[propIndex]],

                          If[matches =!= {},
                            If[highlightedCell =!= None,
                              Quiet[SetOptions[highlightedCell, Background -> oldBackground]]
                            ];
                            index = If[index >= Length[matches], 1, index + 1];
                            SelectionMove[matches[[index]], All, Cell];
                            oldBackground = explicitCellBackground[matches[[index]]];
                            Quiet[SetOptions[matches[[index]], Background -> Lighter[Yellow, 0.7]]];
                            highlightedCell = matches[[index]]
                          ]
                        ],
                        ImageSize -> 100
                      ]
                    },
                    Alignment -> Center
                  ],

                  Button[
                    "Clear Highlight",
                    (
                      If[highlightedCell =!= None,
                        Quiet[SetOptions[highlightedCell, Background -> oldBackground]]
                      ];
                      highlightedCell = None;
                      oldBackground = Inherited;
                      matches = {};
                      index = 0;
                      propMatches = {};
                      propIndex = 0;
                    ),
                    ImageSize -> 205
                  ],

                  Dynamic[
                    If[
                      styles === {},
                      "Click Refresh Styles to detect styles.",
                      "Available styles: " <> ToString[Length[styles]]
                    ]
                  ],

                  Dynamic[
                    Which[
                      propMatches =!= {},
                      "Prop match " <> ToString[propIndex] <> " of " <> ToString[Length[propMatches]],
                      matches =!= {},
                      "Match " <> ToString[index] <> " of " <> ToString[Length[matches]],
                      True,
                      "No active scan."
                    ]
                  ],

                  Row[
                    {
                      Button[
                        Style["-", White, FontSize -> 10, Bold],
                        minimized = True,
                        ImageSize -> {42, 18},
                        Background -> RGBColor[0.2, 0.65, 0.25],
                        Method -> "Queued"
                      ],

                      Spacer[8],

                      Button[
                        Style["\[Times]", White, FontSize -> 10, Bold],
                        (
                          If[highlightedCell =!= None,
                            Quiet[SetOptions[highlightedCell, Background -> oldBackground]];
                            highlightedCell = None;
                            oldBackground = Inherited;
                          ];
                          NotebookClose[EvaluationNotebook[]]
                        ),
                        ImageSize -> {42, 18},
                        Background -> RGBColor[0.78, 0.18, 0.18],
                        Method -> "Queued"
                      ]
                    },
                    Alignment -> Center
                  ]
                },
                Spacings -> 1.2,
                Alignment -> Center
              ]
            ]
          ]
        },
        Spacings -> 1.2,
        Alignment -> Center
      ],

      Initialization :> (
        nb = InputNotebook[];
        Module[{cells, rawStyles},
          cells = Cells[nb];
          rawStyles = Quiet[CurrentValue[cells, CellStyle]];
          styles = Sort @ DeleteDuplicates @ Cases[Flatten @ {rawStyles}, _String];
          If[styles === {}, styles = {"Message"}];
          If[!MemberQ[styles, style], style = First[styles]];
        ]
      ),

      Deinitialization :> (
        If[highlightedCell =!= None,
          Quiet[SetOptions[highlightedCell, Background -> oldBackground]]
        ]
      )
    ],

    WindowTitle -> "Cell Style Scanner"
  ];


(* ::Code::Initialization::"Tags"-><|"NoVariables" -> <|"Module" -> <||>|>|>:: *)
ClearAll[prettyPrintedCellStyleNumber];
prettyPrintedCellStyleNumber:=Module[{},
(* Cells type inventory for this notebook *)
Print["Length@Cells[CellStyle -> Title                ",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"Title"]];
Print["Length@Cells[CellStyle -> Subtitle             ",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"Subtitle"]];
Print["Length@Cells[CellStyle -> Subsubtitle          ",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"Subsubtitle"]];
Print["Length@Cells[CellStyle -> Section              ",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"Section"]];
Print["Length@Cells[CellStyle -> Subsection           ",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"Subsection"]];
Print["Length@Cells[CellStyle -> Subsubsection        ",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"Subsubsection"]];
Print["Length@Cells[CellStyle -> Input                ",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"Input"]];
Print["Length@Cells[CellStyle -> Text                 ",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"Text"]];
Print["Length@Cells[CellStyle -> ExampleText          ",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"ExampleText"]];
Print["Length@Cells[CellStyle -> Code                 ",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"Code"]];
Print["Length@Cells[CellStyle -> Output                           ",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"Output"]];
Print["Length@Cells[CellStyle -> Print                            ",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"Print"]];
Print["Length@Cells[CellStyle -> Message                          ",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"Message"]];
Print["Length@Cells[CellStyle -> MSG                              ",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"MSG"]];
Print["                       Total Number of Cells ->                                    ",PaddedForm[#,{3,4}]&@Length@Cells[]];
];


End[];

EndPackage[];
