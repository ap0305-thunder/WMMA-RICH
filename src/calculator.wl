(* ::Package:: *)

(* ===== RICH managed source =====
   Name: calculator
   Role: interactive-top-level
   Context: calculator`
   Version symbol: calculator`Private`versionTAG
*)
calculator`Private`versionTAG = "v.08-08-2026";

(* Derived textually from validation/native-sources/calculator-native.wl,
   produced by Wolfram Save As. The SETUP and CALCULATOR Title sections are
   selected; CALCULATOR BODY and every later interactive section are excluded.
   Wolfram expressions are neither parsed nor reserialized. *)

(* ::Title::Initialization::Closed:: *)
(*---... SETUP*)


(* ::Subtitle::Closed:: *)
(*PREAMBLE*)


(* ::Input::Initialization:: *)
(* Docked-cell navigation is owned by myNotebookInit` and installed below. *)


(* ::Input::Initialization:: *)
$trackedContext=$Context;
$trackedPath=$ContextPath;

$Post=Function[expr,
If[$Context=!=$trackedContext,
Print["Changed Context to: ",$Context];
$trackedContext=$Context
];
If[$ContextPath=!=$trackedPath,
Print["Changed ContextPath to: ",$ContextPath];
$trackedPath=$ContextPath];
expr];


(* ::Subtitle::Closed:: *)
(*COMMON NOTEBOOK SETUP*)


(* ::Subsubtitle::Closed:: *)
(*bootstrap*)


(* ::Input::Initialization:: *)
(* Explicit load tracking is owned by myNotebookInit` during managed project loading. *)


(* ::Input::Initialization:: *)
ClearLoadLog[]
(* $LoadLog *)
(* Dataset[$LoadLog]*)
SummarizeLoads[]


(* ::Subsubtitle::Closed:: *)
(*INIT*)


(* ::Input::Initialization:: *)
(*TO FIX*)
(*SetDirectory[NotebookDirectory[]];Needs["packageLoadDebugger`"];installPackageLoadDebugger[];clearPackageLoadLog[]*)


(* ::Input::Initialization:: *)
(*TO FIX*)
(*Needs["myNotebookInit`"];*)(*check with loadMyFile: with package can use Needs instead; with notebook need to Get*)
(*Needs["base`"];*)(*check with loadMyFile: with package can use Needs instead; with notebook need to Get*)
(*Needs["statDataAnal`"];*)(*check with loadMyFile: with package can use Needs instead; with notebook need to Get*)
(**)


(* ::Input::Initialization:: *)
(*Off[Unset::norep];*)(*for superClearSet complaints...*)


(* ::Input::Initialization:: *)
(* ::Section::Initialization::*)
(*Notebook bootstrap (WL 14.3)*)
(* The common notebook bootstrap is owned by LoadProject.wl. *)


(* ::Input::Initialization:: *)
(*cellStylesScannerPalette*)


(* ::Input::Initialization:: *)
(* Portable project paths and the legacy $dir... compatibility aliases are
   initialized by LoadProject.wl. *)


(* ::Subsubtitle::Initialization::Closed:: *)
(*BASE OPTIONS*)


(* ::Input::Initialization:: *)
If[!TrueQ[Global`$RICHProjectManagedLoad],myNotebookInit`loadMyFile["cellStyleDataRules.m"]]


(* ::Input::Initialization:: *)
nb[]:=EvaluationNotebook[];
nbFileName:=NotebookFileName[EvaluationNotebook[]];
nbFileDirectory:=NotebookDirectory[EvaluationNotebook[]];
nbFileBaseName:=FileBaseName[EvaluationNotebook[]FileName];
printD[nb[]];
printD[nbFileName];
printD[nbFileDirectory];
printD[nbFileBaseName ];


(* ::Input::Initialization:: *)
$HistoryLength=100;
SetOptions[EvaluationNotebook[],Background->LightGreen];
SetOptions[EvaluationNotebook[],Magnification->3/4];
SetOptions[EvaluationNotebook[],WindowMargins->{{0,Automatic},{Automatic,0}}];
SetOptions[EvaluationNotebook[],WindowSize->{Scaled[3/4],Scaled[1.0]}];
SetOptions[EvaluationNotebook[],WindowTitle->StringJoin[" ------- ",myNotebookInit`safeNotebookBaseName[]]];
SetOptions[EvaluationNotebook[],StyleDefinitions->If[StringQ[Global`$RICHProjectStyleDefinitions],Global`$RICHProjectStyleDefinitions,FileNameJoin[{ParentDirectory[NotebookDirectory[]],"myStyle.nb"}]]];


(* ::Subsubtitle::Initialization::Closed:: *)
(*DETECT AND LOG SOME PROPERTIES OF THIS NOTEBOOK*)


(* ::Input::Initialization:: *)
(* output/print cells *)
If[Length@Cells[CellStyle->"Output"]>0,Echo@Cells[CellStyle->"Output"];Print[      "Length@Cells[CellStyle->Output]  ",       Length@Cells[CellStyle->"Output"]      ]];
If[Length@Cells[CellStyle->"Print"]>0,Echo@Cells[CellStyle->"Print"];Print[     "Length@Cells[CellStyle->Print]  ",           Length@Cells[CellStyle->"Print"]               ]];
(**)


(* ::Input::Initialization:: *)
(* Cells type inventory for this notebook *)
(**)
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


(* ::Subsubtitle::Closed:: *)
(*END*)


(* ::Input::Initialization:: *)
Print["*==================================================================================================*"];
Print["*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*"];
Print["***--- calculator ---***"];
Print["*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*"];
Print["*==================================================================================================*"];


(* ::Subtitle::Initialization::Closed:: *)
(*THIS NOTEBOOK INITIALIZATION*)


(* ::Subsubtitle::Initialization::Closed:: *)
(*INIT*)


(* ::Input::Initialization:: *)
Print[" ************************************************************************************************* "];
Print[" Start running  ",theTimeStamp=timeStamp];
Print[" t0=AbsoluteTime[]   ",t0=AbsoluteTime[]];
Print[" ************************************************************************************************* "];
thisTimeStamp:=theTimeStamp<>"--"<>ToString[Round[1000000*(1000000+(AbsoluteTime[]-t0))]]


(* ::Subsubtitle::Initialization::Closed:: *)
(*MY LIBRARIES*)


(* ::Input::Initialization:: *)
(**************************************************************************************************)
(* my personal stuff *)
(**************************************************************************************************)


(* ::Input::Initialization:: *)
(**************************************************************************************************)
(* rich *)
(**************************************************************************************************)
checkNewCreatedSymbols[]
If[!TrueQ[Global`$RICHProjectManagedLoad],myNotebookInit`loadMyFile["RICH.wl",DirectoryName[$InputFileName]]]
checkNewCreatedSymbols[]


(* ::Subsubtitle::Initialization::Closed:: *)
(*stuff specific to this notebook*)


(* ::Section::Initialization:: *)
(*functions*)


(* ::Section::Initialization::Closed:: *)
(*mathematica options*)


(* ::Input::Initialization:: *)
SetOptions[{LogPlot,Plot,Graphics,ListPlot,Histogram},Ticks->{Automatic,Automatic}];
SetOptions[{LogPlot,Plot,Graphics,ListPlot,Histogram},AxesOrigin->{0,0}];
SetOptions[{LogPlot,Plot,(*Graphics,*)ListPlot,Histogram},Frame->True];
SetOptions[{Graphics},AspectRatio->Automatic];
SetOptions[TableForm,TableAlignments->Center](*works?????*);


(* ::Subsubtitle::Initialization::Closed:: *)
(*loading other packages*)


(* ::Section::Initialization::Closed:: *)
(*authorTools*)


(* ::Input::Initialization:: *)
(*<<AuthorTools`OpenAuthorTool[]*)


(* ::Subtitle::Initialization::Closed:: *)
(*END ALL SETUP*)


(* ::Subsubtitle::Initialization::Closed:: *)
(*END*)


(* ::Input::Initialization:: *)
(**)
(*NotebookDelete[Cells[nb,CellStyle\[Rule]{"Output"}]];*)
(*NotebookDelete[Cells[nb,GeneratedCell\[Rule]True]];*)
(*FrontEndExecute[FrontEndToken["DeleteGeneratedCells"]]*)
(**)
bigBanner[" FINISHING INITIALIZATION "]
(**)
(*FrontEndExecute[FrontEndToken[nb,"SelectAll"]];*)
(*FrontEndTokenExecute["SelectionCloseAllGroups"];*)
(*FrontEndTokenExecute["SelectionOpenAllGroups"]*)
(**)


(* ::Input::Initialization:: *)
Cells[CellStyle->{"MSG","Message"}]
(*Cells[CellStyle\[Rule]{"Print","Output"}]*)


(* ::Input::Initialization:: *)
(*bigBanner[" killStop "];killStop*)


(* ::Title::Initialization::Closed:: *)
(*---... CALCULATOR*)


(* ::Subtitle::Initialization::Closed:: *)
(*>>> INIT FAKE PACKAGE*)


(* ::Input::Initialization:: *)
BeginPackage["calculator`",{"myNotebookInit`","base`","statDataAnal`","rich`"}]
(**)
Print[" loading calculator "]
(**)
Begin["`Private`"] (* Begin Private Context *)
(**)
showContextInfo[]
(**)

(**)
End[]; (* End Private Context *)
(**)
showContextInfo[]
(**)
Print@Cells[CellStyle->{"MSG","Message"}]
(**)
EndPackage[];


(* ::Subtitle::Initialization:: *)
(*<<< END FAKE PACKAGE*)


(* ::Subtitle::Initialization::Closed:: *)
(*DEFINITIONS FOR THIS NOTEBOOK*)


(* ::Section::Initialization::Closed:: *)
(*symbolics for variables to use in this notebook*)


(* ::Input::Initialization:: *)
checkNewCreatedSymbols[]
Off[Symbolize::bsymbexs];
(**)
Notation`AutoLoadNotationPalette=False;(*BEFORE LOADING Notations!*)
(*Notation`AutoLoadNotationPalette=True;*)(*BEFORE LOADING Notations!*)
Needs["Notation`"];
(**)
ClearNotations[](*clears all notations,symbolizations,and infix notations*)
(**)
Symbolize[NotationTemplateTag[Subscript[n, s]]]
Symbolize[NotationTemplateTag[Subscript[n, \[Sigma]]]]
Symbolize[NotationTemplateTag[Subscript[f, \[Sigma]]]]
Symbolize[NotationTemplateTag[Subscript[\[Lambda], 1]]]
Symbolize[NotationTemplateTag[Subscript[\[Lambda], 2]]]
Symbolize[NotationTemplateTag[Subscript[\[Delta]\[Theta], R]]]
Symbolize[NotationTemplateTag[\!\(\*SubsuperscriptBox[\(\[Sigma]\), \(R\), \(\[Infinity]\)]\)]]
Symbolize[NotationTemplateTag[Subscript[\[ScriptCapitalF], \[Lambda]]]]
Symbolize[NotationTemplateTag[Subscript[\[ScriptCapitalD], \[Lambda]]]]
Symbolize[NotationTemplateTag[Subscript[\[ScriptCapitalF], \[Theta]]]]
Symbolize[NotationTemplateTag[Subscript[\[ScriptCapitalD], \[Theta]]]]
(**)
FullForm[NotationTemplateTag[Subscript[n, s]]]
FullForm[NotationTemplateTag[Subscript[n, \[Sigma]]]]
FullForm[NotationTemplateTag[Subscript[f, \[Sigma]]]]
FullForm[NotationTemplateTag[Subscript[\[Lambda], 1]]]
FullForm[NotationTemplateTag[Subscript[\[Lambda], 2]]]
FullForm[NotationTemplateTag[Subscript[\[Delta]\[Theta], R]]]
FullForm[NotationTemplateTag[\!\(\*SubsuperscriptBox[\(\[Sigma]\), \(R\), \(\[Infinity]\)]\)]]
FullForm[NotationTemplateTag[Subscript[\[ScriptCapitalF], \[Lambda]]]]
FullForm[NotationTemplateTag[Subscript[\[ScriptCapitalD], \[Lambda]]]]
FullForm[NotationTemplateTag[Subscript[\[ScriptCapitalF], \[Theta]]]]
FullForm[NotationTemplateTag[Subscript[\[ScriptCapitalD], \[Theta]]]]
(**)
FullForm[Subscript[n, s]]
FullForm[Subscript[n, \[Sigma]]]
FullForm[Subscript[f, \[Sigma]]]
FullForm[Subscript[\[Lambda], 1]]
FullForm[Subscript[\[Lambda], 2]]
FullForm[Subscript[\[Delta]\[Theta], R]]
FullForm[\!\(\*SubsuperscriptBox[\(\[Sigma]\), \(R\), \(\[Infinity]\)]\)]
FullForm[Subscript[\[ScriptCapitalF], \[Lambda]]]
FullForm[Subscript[\[ScriptCapitalD], \[Lambda]]]
FullForm[Subscript[\[ScriptCapitalF], \[Theta]]]
FullForm[Subscript[\[ScriptCapitalD], \[Theta]]]
(*=============================================================================*)
(* some checks on new symbols *)
(*=============================================================================*)
Print[Subscript[\[Delta]\[Theta], R]/.R->1];(*/.X->...: X becomes a new symbol*)
Print[Subscript[\[Delta]\[Theta], R]/.\[Theta]->1];(*/.X->...: X becomes a new symbol*)
Print[Subscript[n, s]/.s->1];(*/.X->...: X becomes a new symbol*)
Print[Subscript[n, \[Sigma]]/.\[Sigma]->11];(*/.X->...: X becomes a new symbol*)
Print[Subscript[\[Lambda], 1]/.\[Lambda]->x1];(*/.X->...: X becomes a new symbol*)
Print[Subscript[\[Lambda], 2]/.\[Lambda]->x2];(*/.X->...: X becomes a new symbol*)
Print[Subscript[\[Lambda], 1]/.Subscript[\[Lambda], 1]->x1];(*/.X->...: X becomes a new symbol*)
Print[Subscript[\[Lambda], 2]/.Subscript[\[Lambda], 2]->x2];(*/.X->...: X becomes a new symbol*)
Print[Subscript[\[ScriptCapitalD], \[Lambda]]/.\[Lambda]->1];(*/.X->...: X becomes a new symbol*)
(**)
On[Symbolize::bsymbexs];
checkNewCreatedSymbols[]


(* ::Section::Initialization::Closed:: *)
(*MISCELLANEA DEFINITIONS*)


(* ::Input::Initialization::"Tags"-><|"NoVariables" -> <|"Module" -> <||>|>|>:: *)
debugPrintD[input__]:=Module[{},If[debugPrintEnabledFlag,printD[input]]];


(* ::Input::Initialization:: *)
fullRationalize=Rationalize[#,0]&;


(* ::Input::Initialization:: *)
(*ClearAll[thisDataPlotInset];*)
printD@tagDataPlot;
printD@thisDataPlotInset;
(**)


(* ::Subtitle::Initialization:: *)
(*OPTIONS FOR THIS NOTEBOOK*)


(* ::Subtitle::Initialization::Closed:: *)
(*RICH SPECIFIC FOR THIS NOTEBOOK*)


(* ::Subsubtitle::Initialization::Closed:: *)
(*SETUP for RICH*)


(* ::Input::Initialization:: *)
(* \[Lambda]MinRef and \[Lambda]MaxRef can only be changed HERE *)
Unprotect[\[Lambda]MinRef,\[Lambda]MaxRef];
\[Lambda]MinRef=200;(*OK FOR MAPMT22*)
(*\[Lambda]MinRef:=270; FOR SIPMFBK/MPPCHPK // but are zero below 270-280 so you can use 200 anyway *)
\[Lambda]MaxRef=700;
Protect[\[Lambda]MinRef,\[Lambda]MaxRef];
bigBanner[" SETTING WAVELENGTH RANGE (\[Lambda]MinRef,\[Lambda]MaxRef) : ","(",\[Lambda]MinRef,"-",\[Lambda]MaxRef,")"," nm"];
(**)
Print[Column[Sort[searchForGivenNames["*pde*"]]]];
(**)


(* ::Subsubtitle::Initialization::Closed:: *)
(*CALC/PREPARE data needed by this notebook*)


(* ::Section::Initialization::Closed:: *)
(*sensors*)


(* ::Input::Initialization:: *)
Names["*EnergyData*"]//TableForm
Names["*label*"]//TableForm
Names["*nRefr*"]//TableForm
Names["*theRef*"]//TableForm
Names["*refrI*"]//TableForm


(* ::Input::Initialization:: *)
allSensorsPDEEnergyData={LAPPDTMEnergyData,MAPMT22EnergyData,MPPCHPKEnergyData,SIPMFBKEnergyData};
allSensorsPDEWavLenData={
Map[{\[Lambda][#[[1]]],#[[2]]}&,LAPPDTMEnergyData],
Map[{\[Lambda][#[[1]]],#[[2]]}&,MAPMT22EnergyData],
Map[{\[Lambda][#[[1]]],#[[2]]}&,MPPCHPKEnergyData],
Map[{\[Lambda][#[[1]]],#[[2]]}&,SIPMFBKEnergyData]
};
Interpolation/@allSensorsPDEEnergyData


(* ::Input::Initialization:: *)
legend=SwatchLegend[{Orange,Blue,Yellow,Green},{"LAPPDTMEnergyData","MAPMT22EnergyData","MPPCHPKEnergyData","SIPMFBKEnergyData"},LegendMarkers->Graphics[{Rectangle[]}],LegendLabel->"sensors",LegendFunction->(Framed[#,RoundingRadius->5]&),LegendMargins->5];


(* ::Input::Initialization:: *)
plot=Print[ListLinePlot[{Style[LAPPDTMEnergyData,Orange],Style[MAPMT22EnergyData,Blue],Style[MPPCHPKEnergyData,Yellow],Style[SIPMFBKEnergyData,Green]},
PlotRange->{{eneMin,eneMax},{0,0.7}},
PlotLegends->legend,
GridLines->Automatic,Epilog->{},AxesLabel->labelEffVsEv]];
exportGraphicsToPDF[plot,"allSensorsPDEEnergyData","","",False];
(**)


(* ::Input::Initialization:: *)
plot=Print[ListLinePlot[{Style[allSensorsPDEWavLenData[[1]],Orange],Style[allSensorsPDEWavLenData[[2]],Blue],Style[allSensorsPDEWavLenData[[3]],Yellow],Style[allSensorsPDEWavLenData[[4]],Green]},
PlotRange->{{\[Lambda][eneMin],\[Lambda][eneMax]},{0,0.7}},
PlotLegends->legend,
GridLines->Automatic,Epilog->{},AxesLabel->labelEffVsNm]];
exportGraphicsToPDF[plot,"allSensorsPDEWavLenData","","",False];


(* ::Section::Initialization::Closed:: *)
(*all radiators info: to check/update (now only the standard LHCb/RICH rads)*)


(* ::Input::Initialization:: *)
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


(* ::Section::Closed:: *)
(*momentum related things*)


(* ::Input::Initialization:: *)
(* momentum thr and asymptotic number of photons *)
printD@momentumCherenkovThreshold[m,n];
Plot[{Sin[thetaChrTheMax[n]]^2},{n,1.0001,1.0027},PlotRange->All,PlotLegends->"Expressions",GridLines->Automatic]
Plot[{momentumCherenkovThreshold[m,n]/m},{n,1.0001,1.0027},PlotRange->All,PlotLegends->"Expressions",GridLines->Automatic]


(* ::Subtitle:: *)
(*END INITIALIZATION CELLS*)

myNotebookInit`endEvalPrintOut[];

myNotebookInit`packageBanner["END calculator"];
