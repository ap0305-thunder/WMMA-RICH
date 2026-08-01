(* Extracted from calculator-reboot.nb. Definitions preserve original initialization-cell order. *)
(* Generated mechanically; validate in a clean Wolfram kernel before deleting legacy-original/. *)

(* ---- initialization cell 1 | 7352a6e7-3289-7f40-9628-4c004cde9271 ---- *)
$trackedContext=$Context;

$trackedPath=$ContextPath;

$Post=Function[expr,
If[$Context=!=$trackedContext,
Print["\<Changed Context to: \>",$Context];
$trackedContext=$Context
];
If[$ContextPath=!=$trackedPath,
Print["\<Changed ContextPath to: \>",$ContextPath];
$trackedPath=$ContextPath];
expr];

(* ---- initialization cell 2 | c8cdfcaa-d51c-b34f-bd73-1d7810eb3370 ---- *)
(*TO FIX*)
(*SetDirectory[NotebookDirectory[]];Needs["\<packageLoadDebugger`\>"];installPackageLoadDebugger[];clearPackageLoadLog[]*)

(* ---- initialization cell 3 | 60a63adc-7445-c348-a339-0150d2c449bf ---- *)
(*TO FIX*)
(*Needs["\<myNotebookInit`\>"];*)(*check with loadMyFile: with package can use Needs instead; with notebook need to Get*)
(*Needs["\<base`\>"];*)(*check with loadMyFile: with package can use Needs instead; with notebook need to Get*)
(*Needs["\<statDataAnal`\>"];*)(*check with loadMyFile: with package can use Needs instead; with notebook need to Get*)
(**)

(* ---- initialization cell 4 | 3e022f8b-8b80-0145-87b6-cbef45d9ff96 ---- *)
(*Off[Unset::norep];*)(*for superClearSet complaints...*)

(* ---- initialization cell 5 | fda25420-f9b6-b44d-ab84-fed6dd52857c ---- *)
(* ::Section::Initialization::*)
Module[{dir,pkg},
dir=Quiet@NotebookDirectory[];
If[!StringQ[dir],dir=$HomeDirectory];(*unsaved notebook fallback*)
pkg=FileNameJoin[{dir,"\<myNotebookInit.wl\>"}];
If[!FileExistsQ[pkg],MessageDialog["\<Missing myNotebookInit.wl at:\n\>"<>pkg];Return[$Failed];];
Get[pkg];
Print@Column[{
Button["\<Save a versioned copy\>",myNotebookInit`saveVersionedCopy[myNotebookInit`versionTAG,NotebookDirectory[]],Method->"\<Queued\>"],Button["\<Save a txt copy\>",With[{out=myNotebookInit`saveNotebookTextCopy[]},If[StringQ[out],Print["\<Saved: \>",out]]],Method->"\<Queued\>"],Button["\<List init code (prints)\>",Print/@myNotebookInit`listInitializationCells[],Method->"\<Queued\>"],Button["\<Highlight init cells\>",myNotebookInit`selectInitializationCells[],Method->"\<Queued\>"],Button["\<Mark ALL Input cells as initialization\>",myNotebookInit`markInputCellsAsInitialization[True],Method->"\<Queued\>"],Button["\<Clear initialization on Input cells\>",myNotebookInit`markInputCellsAsInitialization[False],Method->"\<Queued\>"],Button["\<Delete all empty cells\>",myNotebookInit`deleteAllEmptyCellsInNotebook,Method->"\<Queued\>"],Button["\<Export all Output cells to PNG (notebook dir)\>",myNotebookInit`saveAsPngAllOutputCells[],Method->"\<Queued\>"],Button["\<Export all Output cells to PDF (notebook dir)\>",myNotebookInit`saveAsPdfAllOutputCells[],Method->"\<Queued\>"],Button["\<Show diagnostics\>",myNotebookInit`showDiagnostics[],Method->"\<Queued\>"],
Button["\<Show error message cells\>",Print[Cells[CellStyle->{"\<MSG\>","\<Message\>"}]],Method->"\<Preemptive\>"]
}]
];
(**)
(*Apply default options+optional stylesheet+optional session init*)
myNotebookInit`manageMyStyleNotebook[];
(**)

(* ---- initialization cell 6 | f4d784b5-6c21-c048-90e7-5ee9ac5fabcc ---- *)
myNotebookInit`clearLoadLog[];

myNotebookInit`summarizeLoads[];

myNotebookInit`saveLoadLog[];

(* ---- initialization cell 7 | bc176284-fb72-b749-9f52-9179049d2ae2 ---- *)
myNotebookInit`loadSavedLog[];

(* ---- initialization cell 8 | 1e9a93ef-9e87-fd4f-9d07-6d4c9d4262f8 ---- *)
loadMyFile["\<myDockedCells.wl\>"]

(* ---- initialization cell 9 | dd067d3e-30ec-3a47-a655-fa168c1d7dd5 ---- *)
(*
Context/@{Global`s,rich`s}
OwnValues/@{Global`s,rich`s}
DownValues/@{Global`s,rich`s}
UpValues/@{Global`s,rich`s}
*)

(* ---- initialization cell 10 | a9b78f3e-c289-4d46-bc55-33ca3e863ece ---- *)
(*cellStylesScannerPalette*)

(* ---- initialization cell 11 | 691ec283-9550-a348-a6df-fa9da925af55 ---- *)
checkProtection[{$dirBackup,$dirSWRoot,$dirSW,$dirOut}];

setProtection[{$dirBackup,$dirSWRoot,$dirSW,$dirOut},False]

ClearAll[$dirBackup,$dirSWRoot,$dirSW,$dirOut]

$dirBackup="\<C:\\Users\\Ale\\My Drive\\Mathematica\>";

$dirSWRoot="\<D:\\Users\\Ale\\Mathematica\>";

$dirSW="\<\>";

$dirOut="\<C:\\TEMP\\\>";

setProtection[{$dirBackup,$dirSWRoot,$dirSW,$dirOut},True];

(* ---- initialization cell 12 | 36066e36-9e65-dc46-bb0e-c9222b14252f ---- *)
myNotebookInit`loadMyFile["\<CellStyleDataRules.wl\>"]

(* ---- initialization cell 13 | 848a8e45-7277-bb40-9292-126b1a108982 ---- *)
(*nb[]:=EvaluationNotebook[];
nbFileName:=NotebookFileName[EvaluationNotebook[]];
nbFileDirectory:=NotebookDirectory[EvaluationNotebook[]];
nbFileBaseName:=FileBaseName[NotebookFileName[EvaluationNotebook[]]];*)
printD[nb[]];
printD[nbFileName];
printD[nbFileDirectory];
printD[nbFileBaseName ];

(* ---- initialization cell 14 | cd8f3e07-fbcd-3d4d-8205-ad9d98578bac ---- *)
$HistoryLength=100;

SetOptions[EvaluationNotebook[],Background->LightGreen];

SetOptions[EvaluationNotebook[],Magnification->3/4];

SetOptions[EvaluationNotebook[],WindowMargins->{{0,Automatic},{Automatic,0}}];

SetOptions[EvaluationNotebook[],WindowSize->{Scaled[3/4],Scaled[1.0]}];

SetOptions[EvaluationNotebook[],WindowTitle->StringJoin["\< ------- \>",nbFileName]];

SetOptions[EvaluationNotebook[],StyleDefinitions->FileNameJoin[{NotebookDirectory[],"\<myStyle.nb\>"}]];

(* ---- initialization cell 15 | 37125f97-8abb-094f-8a1e-38bcbe4f3935 ---- *)
(* output/print cells *)
If[Length@Cells[CellStyle->"\<Output\>"]>0,Echo@Cells[CellStyle->"\<Output\>"];Print[      "\<Length@Cells[CellStyle->Output]  \>",       Length@Cells[CellStyle->"\<Output\>"]      ]];
If[Length@Cells[CellStyle->"\<Print\>"]>0,Echo@Cells[CellStyle->"\<Print\>"];Print[     "\<Length@Cells[CellStyle->Print]  \>",           Length@Cells[CellStyle->"\<Print\>"]               ]];
(**)

(* ---- initialization cell 16 | a3e54289-b413-3d45-b1a2-72c5ab52e4d0 ---- *)
(* Cells type inventory for this notebook *)
(**)
Print["\<Length@Cells[CellStyle -> Title                \>",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"\<Title\>"]];
Print["\<Length@Cells[CellStyle -> Subtitle             \>",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"\<Subtitle\>"]];
Print["\<Length@Cells[CellStyle -> Subsubtitle          \>",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"\<Subsubtitle\>"]];
Print["\<Length@Cells[CellStyle -> Section              \>",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"\<Section\>"]];
Print["\<Length@Cells[CellStyle -> Subsection           \>",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"\<Subsection\>"]];
Print["\<Length@Cells[CellStyle -> Subsubsection        \>",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"\<Subsubsection\>"]];
Print["\<Length@Cells[CellStyle -> Input                \>",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"\<Input\>"]];
Print["\<Length@Cells[CellStyle -> Text                 \>",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"\<Text\>"]];
Print["\<Length@Cells[CellStyle -> ExampleText          \>",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"\<ExampleText\>"]];
Print["\<Length@Cells[CellStyle -> Code                 \>",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"\<Code\>"]];
Print["\<Length@Cells[CellStyle -> Output                           \>",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"\<Output\>"]];
Print["\<Length@Cells[CellStyle -> Print                            \>",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"\<Print\>"]];
Print["\<Length@Cells[CellStyle -> Message                          \>",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"\<Message\>"]];
Print["\<Length@Cells[CellStyle -> MSG                              \>",PaddedForm[#,{3,4}]&@Length@Cells[CellStyle->"\<MSG\>"]];
Print["\<                       Total Number of Cells ->             \>",PaddedForm[#,{3,4}]&@Length@Cells[]];

(* ---- initialization cell 17 | 81811305-9ab7-7d4b-96a3-fea749c4b587 ---- *)
Print["\<*==================================================================================================*\>"];

Print["\<*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*\>"];

Print["\<***--- calculator ---***\>"];

Print["\<*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*\>"];

Print["\<*==================================================================================================*\>"];

(* ---- initialization cell 18 | 4a3e4955-026d-4740-ad7d-1ea10dac0667 ---- *)
Print["\< ************************************************************************************************* \>"];

Print["\< Start running  \>",theTimeStamp=timeStamp];

Print["\< t0=AbsoluteTime[]   \>",t0=AbsoluteTime[]];

Print["\< ************************************************************************************************* \>"];

thisTimeStamp:=theTimeStamp<>"\<--\>"<>ToString[Round[1000000*(1000000+(AbsoluteTime[]-t0))]]

(* ---- initialization cell 19 | 8b82798e-562a-e34d-b993-7a123f6498b3 ---- *)
(**************************************************************************************************)
(* my personal stuff *)
(**************************************************************************************************)

(* ---- initialization cell 20 | 26a8ece2-274a-5849-bd08-e9fa4d1a996e ---- *)
(**************************************************************************************************)
(* rich *)
(**************************************************************************************************)
checkNewCreatedSymbols[]
(*Once[*)myNotebookInit`loadMyFile["\<RICH.wl\>",NotebookDirectory[]](*,"\<KernelSession\>"];*)
checkNewCreatedSymbols[]

(* ---- initialization cell 21 | 6484e006-f257-8543-8199-b33b221ce6d3 ---- *)
SetOptions[{LogPlot,Plot,Graphics,ListPlot,Histogram},Ticks->{Automatic,Automatic}];

SetOptions[{LogPlot,Plot,Graphics,ListPlot,Histogram},AxesOrigin->{0,0}];

SetOptions[{LogPlot,Plot,(*Graphics,*)ListPlot,Histogram},Frame->True];

SetOptions[{Graphics},AspectRatio->Automatic];

SetOptions[TableForm,TableAlignments->Center](*works?????*);

(* ---- initialization cell 22 | 599f650f-3675-5c4a-abeb-870e15917e3a ---- *)
(*<<AuthorTools`OpenAuthorTool[]*)

(* ---- initialization cell 23 | 55edd580-6069-dc47-824f-d50394e720cd ---- *)
(**)
(*NotebookDelete[Cells[nb,CellStyle->{"\<Output\>"}]];*)
(*NotebookDelete[Cells[nb,GeneratedCell->True]];*)
(*FrontEndExecute[FrontEndToken["\<DeleteGeneratedCells\>"]]*)
(**)
bigBanner["\< FINISHING INITIALIZATION \>"]
(**)
(*FrontEndExecute[FrontEndToken[nb,"\<SelectAll\>"]];*)
(*FrontEndTokenExecute["\<SelectionCloseAllGroups\>"];*)
(*FrontEndTokenExecute["\<SelectionOpenAllGroups\>"]*)
(**)

(* ---- initialization cell 24 | d651f60b-ecc4-104e-a704-4919076918b1 ---- *)
endEvalPrintOut[]

(* ---- initialization cell 25 | 68af2530-cbfe-bc4e-8cb4-c52536c5a067 ---- *)
BeginPackage["\<calculator`\>",{"\<myNotebookInit`\>","\<base`\>","\<statDataAnal`\>","\<rich`\>"}]
(**)

Print["\< loading calculator \>"]
(**)

Begin["\<`Private`\>"] (* Begin Private Context *) 
(**)

showContextInfo[]
(**)

versionTAG="\<v.15-03-2026\>";
(**)

End[] (* End Private Context *)
(**)

showContextInfo[]
(**)

Print@Cells[CellStyle->{"\<MSG\>","\<Message\>"}]
(**)

EndPackage[]

(* ---- initialization cell 26 | 2bd4c87c-d49c-49a6-b17d-cda9b42996b0 ---- *)
(* Exact box evaluation retained because this cell uses special front-end constructs. *)
ReleaseHold[ToExpression[BoxData[{
 RowBox[{
  RowBox[{"checkNewCreatedSymbols", "[", "]"}], "\[IndentingNewLine]", 
  RowBox[{"(*", "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"Notation`AutoLoadNotationPalette", "=", "False"}], ";"}], 
  RowBox[{"(*", 
   RowBox[{"BEFORE", " ", "LOADING", " ", 
    RowBox[{"Notations", "!"}]}], "*)"}], "\[IndentingNewLine]", 
  RowBox[{"(*", 
   RowBox[{
    RowBox[{"Notation`AutoLoadNotationPalette", "=", "True"}], ";"}], "*)"}], 
  RowBox[{"(*", 
   RowBox[{"BEFORE", " ", "LOADING", " ", 
    RowBox[{"Notations", "!"}]}], "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"loadNeeds", "[", "\"\<Notation`\>\"", "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"Off", "[", 
    RowBox[{"Notation`Symbolize", "::", "bsymbexs"}], "]"}], ";"}], 
  "\[IndentingNewLine]", 
  RowBox[{"(*", "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"ClearNotations", "[", "]"}], 
  RowBox[{"(*", 
   RowBox[{
    RowBox[{"clears", " ", "all", " ", "notations"}], ",", "symbolizations", ",", 
    RowBox[{"and", " ", "infix", " ", "notations"}]}], "*)"}], 
  "\[IndentingNewLine]", 
  RowBox[{"(*", "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{"Symbolize", "[", 
  TemplateBox[{
    SubscriptBox["n", "s"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"Symbolize", "[", 
  TemplateBox[{
    SubscriptBox["n", "\[Sigma]"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"Symbolize", "[", 
  TemplateBox[{
    SubscriptBox["f", "\[Sigma]"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"Symbolize", "[", 
  TemplateBox[{
    SubscriptBox["\[Lambda]", "1"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"Symbolize", "[", 
  TemplateBox[{
    SubscriptBox["\[Lambda]", "2"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"Symbolize", "[", 
  TemplateBox[{
    SubscriptBox["\[Delta]\[Theta]", "R"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"Symbolize", "[", 
  TemplateBox[{
    SubsuperscriptBox["\[Sigma]", "R", "\[Infinity]"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"Symbolize", "[", 
  TemplateBox[{
    SubscriptBox["\[ScriptCapitalF]", "\[Lambda]"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"Symbolize", "[", 
  TemplateBox[{
    SubscriptBox["\[ScriptCapitalD]", "\[Lambda]"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"Symbolize", "[", 
  TemplateBox[{
    SubscriptBox["\[ScriptCapitalF]", "\[Theta]"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"Symbolize", "[", 
   TemplateBox[{
     SubscriptBox["\[ScriptCapitalD]", "\[Theta]"]},
    "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
  RowBox[{"(*", "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  TemplateBox[{
    SubscriptBox["n", "s"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  TemplateBox[{
    SubscriptBox["n", "\[Sigma]"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  TemplateBox[{
    SubscriptBox["f", "\[Sigma]"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  TemplateBox[{
    SubscriptBox["\[Lambda]", "1"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  TemplateBox[{
    SubscriptBox["\[Lambda]", "2"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  TemplateBox[{
    SubscriptBox["\[Delta]\[Theta]", "R"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  TemplateBox[{
    SubsuperscriptBox["\[Sigma]", "R", "\[Infinity]"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  TemplateBox[{
    SubscriptBox["\[ScriptCapitalF]", "\[Lambda]"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  TemplateBox[{
    SubscriptBox["\[ScriptCapitalD]", "\[Lambda]"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  TemplateBox[{
    SubscriptBox["\[ScriptCapitalF]", "\[Theta]"]},
   "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"FullForm", "[", 
   TemplateBox[{
     SubscriptBox["\[ScriptCapitalD]", "\[Theta]"]},
    "NotationTemplateTag"], "]"}], "\[IndentingNewLine]", 
  RowBox[{"(*", "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  SubscriptBox["n", "s"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  SubscriptBox["n", "\[Sigma]"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  SubscriptBox["f", "\[Sigma]"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  SubscriptBox["\[Lambda]", "1"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  SubscriptBox["\[Lambda]", "2"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  SubscriptBox["\[Delta]\[Theta]", "R"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  SubsuperscriptBox["\[Sigma]", "R", "\[Infinity]"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  SubscriptBox["\[ScriptCapitalF]", "\[Lambda]"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  SubscriptBox["\[ScriptCapitalD]", "\[Lambda]"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"FullForm", "[", 
  SubscriptBox["\[ScriptCapitalF]", "\[Theta]"], "]"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"FullForm", "[", 
   SubscriptBox["\[ScriptCapitalD]", "\[Theta]"], "]"}], 
  "\[IndentingNewLine]", 
  RowBox[{"(*", 
   RowBox[{
   "===", "===", "===", "===", "===", "===", "===", "===", "===", "===", "===",
     "===", "===", "===", "===", "===", "===", "===", "===", "===", "===", "===",
     "===", "===", "===", "=="}], "*)"}], "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{"some", " ", "checks", " ", "on", " ", "new", " ", "symbols"}], 
   " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{"(*", 
   RowBox[{
   "===", "===", "===", "===", "===", "===", "===", "===", "===", "===", "===",
     "===", "===", "===", "===", "===", "===", "===", "===", "===", "===", "===",
     "===", "===", "===", "=="}], "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"Print", "[", 
    RowBox[{
     SubscriptBox["\[Delta]\[Theta]", "R"], "/.", 
     RowBox[{"R", "->", "1"}]}], "]"}], ";"}], 
  RowBox[{"(*", 
   RowBox[{"/.", 
    RowBox[{"X", "->", 
     RowBox[{"...", ":", " ", 
      RowBox[{
      "X", " ", "becomes", " ", "a", " ", "new", " ", "symbol"}]}]}]}], 
   "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"Print", "[", 
    RowBox[{
     SubscriptBox["\[Delta]\[Theta]", "R"], "/.", 
     RowBox[{"\[Theta]", "->", "1"}]}], "]"}], ";"}], 
  RowBox[{"(*", 
   RowBox[{"/.", 
    RowBox[{"X", "->", 
     RowBox[{"...", ":", " ", 
      RowBox[{
      "X", " ", "becomes", " ", "a", " ", "new", " ", "symbol"}]}]}]}], 
   "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"Print", "[", 
    RowBox[{
     SubscriptBox["n", "s"], "/.", 
     RowBox[{"s", "->", "1"}]}], "]"}], ";"}], 
  RowBox[{"(*", 
   RowBox[{"/.", 
    RowBox[{"X", "->", 
     RowBox[{"...", ":", " ", 
      RowBox[{
      "X", " ", "becomes", " ", "a", " ", "new", " ", "symbol"}]}]}]}], 
   "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"Print", "[", 
    RowBox[{
     SubscriptBox["n", "\[Sigma]"], "/.", 
     RowBox[{"\[Sigma]", "->", "11"}]}], "]"}], ";"}], 
  RowBox[{"(*", 
   RowBox[{"/.", 
    RowBox[{"X", "->", 
     RowBox[{"...", ":", " ", 
      RowBox[{
      "X", " ", "becomes", " ", "a", " ", "new", " ", "symbol"}]}]}]}], 
   "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"Print", "[", 
    RowBox[{
     SubscriptBox["\[Lambda]", "1"], "/.", 
     RowBox[{"\[Lambda]", "->", "x1"}]}], "]"}], ";"}], 
  RowBox[{"(*", 
   RowBox[{"/.", 
    RowBox[{"X", "->", 
     RowBox[{"...", ":", " ", 
      RowBox[{
      "X", " ", "becomes", " ", "a", " ", "new", " ", "symbol"}]}]}]}], 
   "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"Print", "[", 
    RowBox[{
     SubscriptBox["\[Lambda]", "2"], "/.", 
     RowBox[{"\[Lambda]", "->", "x2"}]}], "]"}], ";"}], 
  RowBox[{"(*", 
   RowBox[{"/.", 
    RowBox[{"X", "->", 
     RowBox[{"...", ":", " ", 
      RowBox[{
      "X", " ", "becomes", " ", "a", " ", "new", " ", "symbol"}]}]}]}], 
   "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"Print", "[", 
    RowBox[{
     SubscriptBox["\[Lambda]", "1"], "/.", 
     RowBox[{
      SubscriptBox["\[Lambda]", "1"], "->", "x1"}]}], "]"}], ";"}], 
  RowBox[{"(*", 
   RowBox[{"/.", 
    RowBox[{"X", "->", 
     RowBox[{"...", ":", " ", 
      RowBox[{
      "X", " ", "becomes", " ", "a", " ", "new", " ", "symbol"}]}]}]}], 
   "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"Print", "[", 
    RowBox[{
     SubscriptBox["\[Lambda]", "2"], "/.", 
     RowBox[{
      SubscriptBox["\[Lambda]", "2"], "->", "x2"}]}], "]"}], ";"}], 
  RowBox[{"(*", 
   RowBox[{"/.", 
    RowBox[{"X", "->", 
     RowBox[{"...", ":", " ", 
      RowBox[{
      "X", " ", "becomes", " ", "a", " ", "new", " ", "symbol"}]}]}]}], 
   "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"Print", "[", 
    RowBox[{
     SubscriptBox["\[ScriptCapitalD]", "\[Lambda]"], "/.", 
     RowBox[{"\[Lambda]", "->", "1"}]}], "]"}], ";"}], 
  RowBox[{"(*", 
   RowBox[{"/.", 
    RowBox[{"X", "->", 
     RowBox[{"...", ":", " ", 
      RowBox[{
      "X", " ", "becomes", " ", "a", " ", "new", " ", "symbol"}]}]}]}], 
   "*)"}], "\[IndentingNewLine]", 
  RowBox[{"(*", "*)"}]}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"On", "[", 
   RowBox[{"Symbolize", "::", "bsymbexs"}], "]"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{"checkNewCreatedSymbols", "[", "]"}]}], StandardForm, HoldComplete]];

(* ---- initialization cell 27 | e17c3409-7689-3449-bcf9-b0b36e9085e4 ---- *)
SetAttributes[debugPrintD,HoldAll];

debugPrintD[input__]:=Module[{},If[debugPrintEnabledFlag,printD[input]]];

(* ---- initialization cell 28 | 1772c2f4-7289-6e4b-a36f-4d32892210af ---- *)
fullRationalize=Rationalize[#,0]&;

(* ---- initialization cell 29 | fff8e5d3-257a-244a-9b46-2a7fc101e779 ---- *)
(*ClearAll[thisDataPlotInset];*)
printD@tagDataPlot;
printD@thisDataPlotInset;
(**)

(* ---- initialization cell 30 | 3fa80105-cd59-a14b-8c88-afe908c92a29 ---- *)
(* \[Lambda]MinRef and \[Lambda]MaxRef can only be changed HERE *)
Unprotect[\[Lambda]MinRef,\[Lambda]MaxRef];
\[Lambda]MinRef=200;(*OK FOR MAPMT22*)
(*\[Lambda]MinRef:=270; FOR SIPMFBK/MPPCHPK // but are zero below 270-280 so you can use 200 anyway *)
\[Lambda]MaxRef=700;
Protect[\[Lambda]MinRef,\[Lambda]MaxRef];
bigBanner["\< SETTING WAVELENGTH RANGE (\[Lambda]MinRef,\[Lambda]MaxRef) : \>","\<(\>",\[Lambda]MinRef,"\<-\>",\[Lambda]MaxRef,"\<)\>","\< nm\>"];
(**)
Print[Column[Sort[searchForGivenNames["\<*pde*\>"]]]];
(**)

(* ---- initialization cell 31 | 81c92161-b12e-0b4e-a7e8-707c29bb176f ---- *)
Names["\<*EnergyData*\>"]//TableForm

Names["\<*label*\>"]//TableForm

Names["\<*nRefr*\>"]//TableForm

Names["\<*theRef*\>"]//TableForm

Names["\<*refrI*\>"]//TableForm

(* ---- initialization cell 32 | 4eaf34dd-6d69-dc4b-ab1d-220ab26664fa ---- *)
allSensorsPDEEnergyData={LAPPDTMEnergyData,MAPMT22EnergyData,MPPCHPKEnergyData,SIPMFBKEnergyData};

allSensorsPDEWavLenData={
Map[{\[Lambda][#[[1]]],#[[2]]}&,LAPPDTMEnergyData],
Map[{\[Lambda][#[[1]]],#[[2]]}&,MAPMT22EnergyData],
Map[{\[Lambda][#[[1]]],#[[2]]}&,MPPCHPKEnergyData],
Map[{\[Lambda][#[[1]]],#[[2]]}&,SIPMFBKEnergyData]
};

Interpolation/@allSensorsPDEEnergyData

(* ---- initialization cell 33 | ff658c73-7662-1f4a-904a-91904282d95a ---- *)
legend=SwatchLegend[{Orange,Blue,Yellow,Green},{"\<LAPPDTMEnergyData\>","\<MAPMT22EnergyData\>","\<MPPCHPKEnergyData\>","\<SIPMFBKEnergyData\>"},LegendMarkers->Graphics[{Rectangle[]}],LegendLabel->"\<sensors\>",LegendFunction->(Framed[#,RoundingRadius->5]&),LegendMargins->5];

(* ---- initialization cell 34 | 2c045e51-e569-7949-9cd6-a14a68b30185 ---- *)
plot=ListLinePlot[{Style[LAPPDTMEnergyData,Orange],Style[MAPMT22EnergyData,Blue],Style[MPPCHPKEnergyData,Yellow],Style[SIPMFBKEnergyData,Green]},
PlotRange->{{eneMin,eneMax},{0,0.7}},
PlotLegends->legend,
GridLines->Automatic,Epilog->{},AxesLabel->labelEffVsEv];

Print[plot];

exportGraphicsToPDF[plot,"\<allSensorsPDEEnergyData\>","\<\>","\<\>",False];

(**)

(* ---- initialization cell 35 | 2e19d584-f1e5-8041-87cb-e644182c17d6 ---- *)
plot=ListLinePlot[{Style[allSensorsPDEWavLenData[[1]],Orange],Style[allSensorsPDEWavLenData[[2]],Blue],Style[allSensorsPDEWavLenData[[3]],Yellow],Style[allSensorsPDEWavLenData[[4]],Green]},
PlotRange->{{\[Lambda][eneMin],\[Lambda][eneMax]},{0,0.7}},
PlotLegends->legend,
GridLines->Automatic,Epilog->{},AxesLabel->labelEffVsNm];

Print[plot];

exportGraphicsToPDF[plot,"\<allSensorsPDEWavLenData\>","\<\>","\<\>",False];

(* ---- initialization cell 36 | 6bb3b2c5-5504-4f18-8efc-71b59c7d7e5b ---- *)
(*fixed data calculated by calcAllRadiators*)
(**)
theWavLen1={200.0,200.0,200.0,200.0,200.0};
theWavLen2={700.0,700.0,700.0,700.0,700.0};
theWavLenMean={346.3,347.7,345.4,347.4,350.2};
theWavLenMedian={305.4,307.2,304.4,306.9,310.3};
nRefrAtTheWavLen1={1.0015657,1.0005187,1.0005132,1.5505055,1.0308707};
nRefrAtTheWavLenMedian={1.0014367,1.0004890,1.0004633,1.4859271,1.0304975};
nRefrAtTheWavLenMean={1.0014173,1.0004845,1.0004558,1.4773295,1.0304414};
nRefrAtTheWavLen2={1.0013682,1.0004729,1.0004373,1.4552925,1.0302885};
(**)
(*===================================================================================*)
(*DETECTOR SETUP // TO BE CHECKED LATER FOR SPECIFIC APPLICATIONS*)
(*===================================================================================*)
printD@theWavLen1;
printD@theWavLen2;
printD@theWavLenMean;
printD@theWavLenMedian;
printD@nRefrAtTheWavLen1;
printD@nRefrAtTheWavLen2;
printD@nRefrAtTheWavLenMean;
printD@nRefrAtTheWavLenMedian;
(**)

(* ---- initialization cell 37 | c8ad9c84-0a77-4618-b43c-032212a7047c ---- *)
(* momentum thr and asymptotic number of photons *)
printD@momentumCherenkovThreshold[m,n];
Plot[{(Sin[thetaChrTheMax[n]])^(2)},{n,1.0001,1.0027},PlotRange->All,PlotLegends->"\<Expressions\>",GridLines->Automatic]
Plot[{momentumCherenkovThreshold[m,n]/m},{n,1.0001,1.0027},PlotRange->All,PlotLegends->"\<Expressions\>",GridLines->Automatic]

(* ---- initialization cell 38 | 6663ff6d-8d85-b249-82b3-3601a8d702b8 ---- *)
endEvalPrintOut[]
