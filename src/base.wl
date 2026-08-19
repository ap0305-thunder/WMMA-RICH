(* ::Package::"Tags"-><|"NoVariables" -> <|"Module" -> <|Enabled -> False|>|>, "PrefixPlus" -> <|Enabled -> False|>|>:: *)

(* ::Text::Initialization:: *)
(*(*(*(*This package/notebook defines several tools of Mathematica/Wolfram which I find useful and/or use later.*)*)*)*)


(* ::Title::Initialization:: *)
(*(*(*(*SETUP*)*)*)*)


(* ::Title::Initialization:: *)
(*(*(*(*BASE*)*)*)*)


(* ::Subtitle:: *)
(*INIT PACKAGE*)


(* ::Input::Initialization:: *)
packageBanner["LOADING base"];


BeginPackage["base`",{"myNotebookInit`"}] (**)
base::nodep = "Required dependency `1` is not available. Load or install it before loading base`.";


(*---Explicit dependency check:myNotebookInit`---*)

If[!MemberQ[$Packages, "myNotebookInit`"],
 Quiet @ Check[
Needs["myNotebookInit`"  ], 
Message[base::nodep, "myNotebookInit`"]; 
Throw[$Failed, "PackageDependencyError"  ]
]
];

If[!NameQ["myNotebookInit`loadMyFile"], Message[base::nodep, "myNotebookInit`loadMyFile"
  ]; Throw[$Failed, "PackageDependencyError"]];


checkNewCreatedSymbols[]
showContextInfo[]

(*Once[*)
If[
  ! TrueQ[Global`$RICHProjectManagedLoad],
  myNotebookInit`loadMyFile[
    "cellStyleDataRules.wl",
    DirectoryName[$InputFileName]
  ]
]
(*,"Notebook"]*)

(*EXPORT*)
ceiling::usage="ceiling"
ceilingTrim::usage="ceilingTrim";
checkEqualRealNumbers::usage="checkEqualRealNumbers";
cleanNum::usage="cleanNum";
cleanText::usage="cleanText";
debugPrint::usage="debugPrint";
debugPrintEnabledFlag::usage="debugPrintEnabledFlag";
decimals::usage="decimals"
digits::usage="digits"
dropFirst::usage="dropFirst";
edge::usage="edge";
eps::usage="eps";
epsFact::usage="epsFact"
epsilonQuantum::usage="epsilonQuantum";
errorFunction::usage="errorFunction"
errorFunctionDemo::usage="errorFunctionDemo[]";
exception::usage="exception";
exists::usage="exists";
findNotebooks::usage="findNotebooks[]";
fmt::usage="fmt"
insertCol::usage="insertCol";
insertRow::usage="insertRow";
lookupVal::usage="lookupVal"
matrixCore::usage="matrixCore";
matrixInfo::usage="matrixInfo";
myNicePrint::usage="myNicePrint";
nf0::usage="nf0";
nf1::usage="nf1";
nf2::usage="nf2";
nf3::usage="nf3";
nf4::usage="nf4";
nf5::usage="nf5";
nf6::usage="nf6";
nf::usage="nf";
nfPad::usage="nfPad";
nfl0::usage="nfl0";
nfl1::usage="nfl1";
nfl2::usage="nfl2";
nfl3::usage="nfl3";
nfl::usage="nfl";
nfpm0::usage="nfpm0";
nfpm1::usage="nfpm1";
nfpm2::usage="nfpm2";
nfpm3::usage="nfpm3";
nfpm4::usage="nfpm4";
nfpm5::usage="nfpm5";
nfpm6::usage="nfpm6";
nfpm::usage="nfpm";
nfpmPad::usage="nfpmPad";
nfpml0::usage="nfpml0";
nfpml1::usage="nfpml1";
nfpml2::usage="nfpml2";
nfpml3::usage="nfpml3";
nfpml::usage="nfpml";
nicePrint::usage="nicePrint";
niceSymbolsOrder::usage="niceSymbolsOrder";
normalizeString::usage="normalizeString";
numCol::usage="numCol";
numFormat::usage="numFormat";
numFormatPad::usage="numFormatPad";
numRow::usage="numRow";
partialSumToEnd::usage="partialSumToEnd";
printa1::usage="printa1";
printa::usage="printa";
prn::usage="prn";
reorderSymbols::usage="reorderSymbols";
rewrite::usage="rewrite";
rll::usage="rll";
roundDigits::usage="roundDigits";
searchForGivenNames::usage="searchForGivenNames";
searchForGivenNamesAndPrint::usage="searchForGivenNamesAndPrint";
searchForGivenNamesRegExp::usage="searchForGivenNamesRegExp";
sll::usage="sll";
sortByColumn::usage="sortByColumn";
sortMatrixCols::usage="sortMatrixCols";
sortMatrixRows::usage="sortMatrixRows";
sumCol::usage="sumCol";
sumRow::usage="sumRow";
swap::usage="swap";
tableOfContents::usage="tableOfContents";
takeFirstCol::usage="takeFirstCol";
takeFirstRow::usage="takeFirstRow";
taylor::usage="taylor";
testNumberFormat::usage="testNumberFormat";
tickFormat::usage="tickFormat";
toClean::usage="toClean";
vLookup::usage="vLookup";
vSum::usage="vSum";
valPlusMinus::usage="valPlusMinus";
variableize::usage="variableize";
window::usage="window";


(* ::Input::Initialization:: *)
Begin["`Private`"] 
(* Begin Private Context *) 
versionTAG="v.08-08-2026"
(*ResourceFunction["NotebookOutlineMenu"][EvaluationNotebook[],"Table Of Contents",{"Title","Subtitle","Subsubtitle"}]*)
(* End Private Context *)


(* ::Subtitle::Initialization:: *)
(*(*(*(*START*)*)*)*)


(* ::Section::Initialization:: *)
(*(*(*(*INIT*)*)*)*)


(* ::Input::Initialization:: *)
tableOfContents[notebook_]:=Module[{headerTypes,nb0,headerCells,tagHeaders},
(*Cell types to include in ToC*)
headerTypes="Title"|"Chapter"|"Subtitle"|"Subsubtitle"|"Section";
(*Find cells of the desired type and tag with their names*)
nb0=Import[notebook];
headerCells=Cases[nb0,Cell[_,headerTypes,___],Infinity];
tagHeaders=Map[Append[#,CellTags->#[[1]]]&,headerCells];
(*Export tagged cells*)
Export[notebook,ReplaceAll[nb0,Normal[AssociationThread[headerCells,tagHeaders]]]];
(*Generate styled hyperlinks for ToC*)
TableForm@Map[
If[MatchQ[#[[2]],"Chapter"],
Hyperlink[Style[#[[1]],RGBColor@{211/256,15/64,0},FontFamily->"Arial",FontTracking->"Plain",FontSize->20],{notebook,#[[1]]}],
If[MatchQ[#[[2]],"Subtitle"],
Hyperlink[Style["\t"<>#[[1]],RGBColor@{211/256,15/64,0},FontFamily->"Arial",FontTracking->"Plain",FontSize->18],{notebook,#[[1]]}],
If[MatchQ[#[[2]],"Subsubtitle"],
Hyperlink[Style["\t\t"<>#[[1]],RGBColor@{211/256,15/64,0},FontFamily->"Arial",FontTracking->"Plain",FontSize->16],{notebook,#[[1]]}],
Hyperlink[Style["\t\t\t"<>#[[1]],RGBColor@{53/64,51/128,1/256},FontFamily->"Arial",FontTracking->"Plain",FontSize->14],{notebook,#[[1]]}]
]
]
]&
,headerCells]
];
(*toc=tableOfContents[NotebookFileName[EvaluationNotebook[]]];
SaveToCell[toc,Short[toc]];
Print@toc;
*)


(* ::Subsubtitle::Initialization:: *)
(*(*(*(*MESSAGES*)*)*)*)


(* ::Input::Initialization:: *)
(*bigBanner["Don't leave the Suggestions Bar enabled
The predictive interface (Suggestions Bar) is the source of many bugs reported on this site and surely many more that have yet to be reported. 
I strongly suggest that all new users turn off the Suggestions Bar to avoid unexpected problems such as 
massive memory usage([1], [2]), peculiar evaluation leaks ([1], [2]), broken assignments, disappearing definitions, and crashes([1], [2])."];*)


(* ::Subsubtitle::Initialization:: *)
(*(*(*(*SYSTEM Setup*)*)*)*)


(* ::Input::Initialization:: *)
Print[" ************************************************************************************************* "];
Print[" Start running  ",myNotebookInit`timeStamp];
Print[" t0=AbsoluteTime[]   ",AbsoluteTime[]];
Print[" ************************************************************************************************* "];


(* ::Input::Initialization:: *)
(*Select[Names["Global`*"],Head@Symbol[#]=!=Symbol&&Head@Symbol[#]=!=Function&]*)
(*
Clear[$globalProperties];
$globalProperties={OwnValues,DownValues,SubValues,UpValues,NValues,FormatValues,Options,DefaultValues,Attributes,Messages};
ClearAll[getDefinitions];
SetAttributes[getDefinitions,HoldAllComplete];
getDefinitions[s_Symbol]:=Flatten@Through[Map[Function[prop,Function[sym,prop[sym],HoldAll]],$globalProperties][Unevaluated[s]]];
ClearAll[symbolMemoryUsage];
symbolMemoryUsage[sname_String]:=ToExpression[sname,InputForm,Function[s,ByteCount[getDefinitions[s]],HoldAllComplete]];
ClearAll[heavySymbols];
heavySymbols[context_,sizeLim_: 10^6]:=Pick[#,UnitStep[#-sizeLim]&@Map[symbolMemoryUsage,#],1]&@Names[context<>"*"];
heavySymbols["Global`"]
*)
(*CellPrint[TextCell["1\t55\n33\t44", "Text"]]*)


(* ::Input::Initialization:: *)
(*
ClearAll[removeDeclareContext];
removeDeclareContext[context_String]:=$NewSymbol::declarativeContexts=StringDelete[$NewSymbol::declarativeContexts,"|"<>context]
ClearAll[declareContext];
declareContext[context_String]:=Module[{},$NewSymbol::undeclared="`1``2` was not previously declared.";
If[ValueQ[$NewSymbol::declarativeContexts]\[Equal]False,$NewSymbol::declarativeContexts=""];
$NewSymbol::declarativeContexts=StringJoin[$NewSymbol::declarativeContexts,"|",context];
$NewSymbol:=If[ContainsAny[StringSplit[$NewSymbol::declarativeContexts,"|"],{#2}]&&ContainsNone[Names[#2<>"*"],{#1}],Message[$NewSymbol::undeclared,#2,#1]]&]
*)


(* ::Input::Initialization:: *)
(*
(*==================================================================================================*)
(* ERROR HANDLING *)
(*==================================================================================================*)
(* Put the following two lines at the top of every notebook. *)
messageHandler=If[Last[#],Interrupt[]]&;
Internal`AddHandler["Message",messageHandler];
forceFakeBreakForDebug:={warn={1,2};Do[Print[warn[[i]]],{i,1,3}]};
(*forceFakeBreakForDebug;*)
(*==================================================================================================*)*)


(* ::Input::Initialization:: *)
(*Off[ParallelMap::subpar]*)
(*On[General::newsym];*)
(*$NewSymbol=Print["Name: ",#1," Context: ",#2]&;*)
(*Print[SystemInformation[]];*)
(*Print[NotebookInformation[]];*)
(*Needs["Experimental`"];*)
(*Experimental`ValueFunction[x]:=Print[" INFO: insCdlDat changed to : ",x];*)
(*$NewSymbol::undeclared="`1` was not previously declared.";*)
(*$NewSymbol:=Message[$NewSymbol::undeclared,#1]&*)
(*Names["*"];*)


(* ::Input::Initialization:: *)
(*Button[" EMERGENCY QUIT KERNEL ",Quit[]]*)
(*Names["Global`*"]*)
(* To get rid of error message: "There was insufficient Java heap space for the operation. Try increasing the Java Virtual Machine heap size." *)
(*
<<JLink`;
InstallJava[];
ReinstallJava[JVMArguments\[Rule]"-Xmx32768m"];
*)


(* ::Subsubtitle::Initialization:: *)
(*(*(*(*MATHEMATICA setup*)*)*)*)


(* ::Input::Initialization:: *)
(*==================================================================================================*)
(* ERROR HANDLING *)
(*==================================================================================================*)
(* Put the following two lines at the top of every notebook. *)
(*
messageHandler=If[Last[#],Interrupt[]]&;
Internal`AddHandler["Message",messageHandler];
forceFakeBreakForDebug:={warn={1,2};Do[Print[warn[[i]]],{i,1,3}]};
*)
(*forceFakeBreakForDebug;*)
(*==================================================================================================*)


(* ::Input::Initialization:: *)
(*Hyperlink["Go To Index",{SelectedNotebook[],"index"}]*)


(* ::Input::Initialization:: *)
(* 
MAGNIFICATION SLIDER
SetOptions[EvaluationNotebook[],DockedCells->Cell[BoxData[ToBoxes[
DynamicModule[{m=1},Panel[Slider[Dynamic[m,SetOptions[EvaluationNotebook[],Magnification->(m=#)]&],{0.5,2.0}],"Magnification"]]]
],"DockedCell"]
];
*)


(* ::Subsection::Initialization:: *)
(*(*(*(*general tools for variables management*)*)*)*)


(* ::Input::Initialization::"Tags"-><|"NoVariables" -> <|"Module" -> <||>|>|>:: *)
Unprotect[variableize];
ClearAll[variableize];
variableize[text_,prefix_:"id",suffix_:""]:=Module[{},
(*Symbol[StringJoin[prefix,StringReplace[Capitalize[ToLowerCase[text],"AllWords"],Whitespace\[Rule]""]]]*)
Symbol[
StringJoin[
prefix,
StringReplace[If[Length[prefix]==0,Decapitalize[text],Capitalize[text,"AllWords"]],Whitespace->""],
suffix
]
]
];
SetAttributes[variableize,Listable];
Protect[variableize];
(*head={"aaa"," bbb ","ccccc"," Ale","PPP"};*)
(*vars=variableize[head,"","R1"]*)


(* ::Subsection::Initialization:: *)
(*(*(*(*error propagation formulas*)*)*)*)


(* ::Input::Initialization:: *)
(* introduced bug to fix


errorFunction[v_,f_]:=Module[{varlist,funct,varlength,theoretical,uncert},

Manipulate[varlist=ToExpression[variables];
funct=ToExpression[function];
errorFunction[variables,function],{variables,"{M,m}"},{function,"g*(M-m)/(M+m)"},LabelStyle->{FontSize->17},AutoAction->False,Initialization:>(errorFunction[v_,f_]:=(varlist=ToExpression[v];
funct=ToExpression[f];
varlength=Length[Variables[varlist]];
theoretical=Sqrt[(Total[Table[(D[funct,Part[varlist,n]]*Subscript[U,Part[varlist,n]])^2,{n,1,varlength}]])];
Part[theoretical,1];
varlist;
uncert=Table[Subscript[U,Part[varlist,n]],{n,1,varlength}];
uncert=DeleteCases[uncert,Alternatives@@{0}];
theoretical=Simplify[theoretical];
Column[{Row[{Grid[{{"Variables",varlist},{"Uncertainties",uncert},{"Function",function},{"Uncertainty Function",theoretical}},Alignment->Left,Spacings->{2,1},Frame->All,ItemStyle->{"Text",FontSize->20},Background->{{LightGray,None}}]}],Row[{Grid[{{"Brian Gennow  March/24/2015"}},Alignment->Left,Spacings->{2,1},ItemStyle->"Text",Background->{{None}}]}]}]))]]
];*)


(* ::Subtitle::Initialization:: *)
(*(*(*(*GENERAL*)*)*)*)


(* ::Subsubtitle::Initialization:: *)
(*(*(*(*DEBUG*)*)*)*)


(* ::Input::Initialization:: *)
debugPrintEnabledFlag=False;
debugPrint[input__,debug$debugPrint_:debugPrintEnabledFlag]:=Module[{},If[debug$debugPrint==True,Print[input]]];
debugPrint[32,True]


(* ::Subsubtitle::Initialization:: *)
(*(*(*(*WOLFRAM MATHEMATICA workings*)*)*)*)


(* ::Input::Initialization:: *)
(*epsilonQuantum=10^-9;*)
(*superClearSet[epsilonQuantum];*)
(*myNumberOfDigits=10;*)
(*eps=1.0*10^-12;*)


(* ::Input::Initialization:: *)
exception[cnt_, cntMax_, messageText_] :=
  Module[
    {}
    ,
    (*Print["cnt =",cnt];*)
    If[cnt < cntMax,
      Print[messageText];
      ,
      If[cnt == cntMax,
        Print["    STOP" <> messageText]
      ]
    ]
  ];


(* ::Input::Initialization:: *)
checkEqualRealNumbers[x_, y_, epsFact_:10] :=
  If[Abs[x - y] <= epsFact * $MachineEpsilon,
    (*Print["Equal to within ",epsFact*$MachineEpsilon];*)
    Return["True"]
    ,
    Print[" NOT Equal to within ", epsFact * $MachineEpsilon];
    Return["False"]
  ];


(* ::Input::Initialization:: *)
(* Beware: a lot of output! *)

(*$NewSymbol=Print["Name: ",#1," Context: ",#2]&;*) 


(* ::Input::Initialization:: *)
findNotebooks[]:=If[$Notebooks,Quiet@FileNames["*.nb",NotebookDirectory[],2],{}];


(* ::Input::Initialization:: *)
cleanNum[v_] :=
  Module[
    {y}
    ,
    y = v /. s_String -> 0.0;
    Return[y];
  ];

SetAttributes[cleanNum, Listable];


(* ::Input::Initialization:: *)
ceilingTrim[dat_, ceiling_] :=
  If[dat > ceiling,
    ceiling
    ,
    dat
  ];

SetAttributes[ceilingTrim, Listable];


(* ::Input::Initialization:: *)
exists[x_List]:=If[Length[x]>0,x," n/a "];
exists[x_]:=x;


(* ::Input::Initialization:: *)
tickFormat[xmin_, xmax_, digits_, divisions_:10] :=
  Function[
      tickNumber
      ,
      {tickNumber, PaddedForm[Round[tickNumber, 0.01], {Max @ (Length
         @ IntegerDigits @ IntegerPart[#]& /@ (10^digits {xmin, xmax})), digits
        }]}
    ] /@ FindDivisions[{xmin, xmax}, divisions];


(* ::Subsubtitle::Initialization:: *)
(*(*(*(*pretty print*)*)*)*)


(* ::Input::Initialization:: *)
ClearAll[printa,printa1];
SetAttributes[{printa,printa1},HoldFirst];
printa1[var_]:=Module[{},Print["  >>>  ",SymbolName[Unevaluated[var]]];Print["  >>>  ",Evaluate[var]]];
printa[var_]:=Module[{},Print["  >>>  ",SymbolName[Unevaluated[var]]];Print["          >>>  ",Evaluate[var]]];

ClearAll[myNicePrint];
SetAttributes[myNicePrint,HoldAll];
myNicePrint[args__]:=Scan[Function[x,Print[Unevaluated[x]," = ",x],{HoldAll}],Hold[args]];
ClearAll[myPrint];
SetAttributes[myPrint,HoldAll];
myPrint[args___]:=Do[Print[Extract[Hold[args],i,HoldForm],"=",List[args][[i]]],{i,Length[List[args]]}];
ClearAll[prn];
SetAttributes[prn,{HoldAll,Listable}];
prn[arg_]:=Print[HoldForm[arg]," = ",arg];
prn[args___]:=prn[{args}];
nicePrint[whattooutput__,space_:10,decimals_:3]:= OutputForm[TableForm[Map[PaddedForm[#,{space,decimals},NumberSigns->{"-","+"}]&,whattooutput,{2}],TableSpacing->{1}]];

(*If[$Notebooks,
ape=20;
nut:=20 ape;
mouse=cat+nut;
printa1[ape,nut,mouse];
printa[ape,nut,mouse];
myNicePrint[ape,nut,mouse];
myPrint[ape,nut,mouse];
prn[ape,nut,mouse];
];*)


(* ::Subsubtitle::Initialization:: *)
(*(*(*(*RE-WRITE EXPRESSIONS*)*)*)*)


(* ::Input::Initialization:: *)
reorderSymbols[expr_,symbols_List]:=With[{s=symbols},
HoldForm[Evaluate[expr/. Thread[s->Sort@s]]]/. Thread[Sort@s->s]
];


(* ::Input::Initialization:: *)
niceSymbolsOrder[exp_,varli_List]:=Module[{dummySomething},
   MakeBoxes[dummySomething[_,y_],fmt_]:=ToBoxes[y,fmt];
   exp/.Thread[varli->Reverse/@MapIndexed[dummySomething,varli]]
];


(* ::Input::Initialization:: *)
rewrite[expr_]:=Module[{out,new,old},
Simplify[Rationalize[expr],Variables[expr]\[Element]Reals];
out=Experimental`OptimizeExpression[expr];
new=Symbol/@CharacterRange[63396,63421];
old=DeleteDuplicates@Cases[out,s_Symbol/;Context[s]==="Compile`",{-1}];
Extract[out,{1,2},Defer]/.Cases[Flatten[{old,new},{2}],{o_,n_}:>(o:>n)]
];
(*K=a*b*t/((t+f)c*d);
FullSimplify[K,TransformationFunctions->{(#/. t/(t+f)->p&),Automatic}]*)


(* ::Subtitle::Initialization:: *)
(*(*(*(*useful tools*)*)*)*)


(* ::Subsubtitle::Initialization:: *)
(*(*(*(*styles*)*)*)*)


(* ::Subsubtitle::Initialization:: *)
(*(*(*(*RunScheduledTask*)*)*)*)


(* ::Input::Initialization:: *)
(*RunScheduledTask[EmitSound[Sound[SoundNote[]]];NotebookSave[EvaluationNotebook[]],600];*)


(* ::Subsubtitle::Initialization:: *)
(*(*(*(*MergeAppendNotebooks*)*)*)*)


(* ::Text::Initialization:: *)
(*(*(*(*TO CHECK*)*)*)*)


(* ::Input::Initialization:: *)
(*gatherNotebooks[]:=Module[{nbs=Notebooks[]},nbs=Replace[SortBy[nbs,("WindowTitle"/. NotebookInformation[#])&],{bef___,this:EvaluationNotebook[],after___}:>{bef,after,this}];*)
(*nbs=Cases[nbs,nb_?unsavedNotebookQ:>nbToCollapsedCell[nb]];*)
(*NotebookPut@Notebook@nbs*)
(*];*)
(**)
(*$notebooksToIgnore="Messages"|"DocuTools"; (*or whatever palettes you don't want to gather*)*)
(**)
(*unsavedNotebookQ[nb_NotebookObject]:=MatchQ[{"ModifiedInMemory","DocumentType","WindowTitle"}/. NotebookInformation[nb],{True,"Notebook",Except[$notebooksToIgnore]}];*)
(**)
(*cellTypeRules={("Title"|"Section")->"Subsection","Subsection"->"Subsubsection","Subsubsection"->"Subsubsubsection"};*)
(**)
(*downgradeCellTypes=ReplaceAll[Cell[pre___,style:(Alternatives@@Keys[cellTypeRules]),post___]:>Cell[pre,Replace[style,cellTypeRules],post]];*)
(**)
(*nbToCollapsedCell[nb_]:=Cell@CellGroupData[{Sequence[Cell["WindowTitle"/. NotebookInformation[nb],"Section"],Sequence@@downgradeCellTypes[First[NotebookGet[nb]]]]},"Closed"];*)
(**)
(*closeOtherNotebooks[]:=With[{nbs=Cases[Notebooks[],Except[EvaluationNotebook[]]]},Scan[NotebookClose,nbs]];*)
(**)
(*gatherNotebooks[]*)
(**)
(*closeOtherNotebooks[]*)


(* ::Subtitle::Initialization:: *)
(*(*(*(*MATHEMATICAL FUNCTIONS*)*)*)*)


(* ::Input::Initialization:: *)
taylor[f_,var:{_Symbol..},n_Integer?Positive]:=Module[{expr=Series[f,Sequence@@({#,0,n}&/@var)]//Normal//Expand},Select[expr,Total[Exponent[#,var]]<=n&]]


Block[{x,y,z},
If[$Notebooks,

f1[x_,y_]=Sin[x+y];
taylor[f1[x,y],{x,y},3];
(*x-x^3/6+y-(x^2 y)/2-(x y^2)/2-y^3/6*)
f2[x_,y_,z_]=z*Sin[x+y];
taylor[f2[x,y,z],{x,y,z},4]
(*x z-(x^3 z)/6+y z-1/2 x^2 y z-1/2 x y^2 z-(y^3 z)/6*)

]
]


(* ::Input::Initialization:: *)
swap[x_]:=Map[{#[[2]],#[[1]]}&,x];


(* ::Input::Initialization:: *)
edge[x_,low_,upp_]:=ResourceFunction["SmoothStep"][x,{low,upp}]


(* ::Input::Initialization:: *)
window[s_,x1_,x2_]:=UnitBox[s/(x2-x1)-(x1+x2)/2/(x2-x1)]


(* ::Input::Initialization:: *)
valPlusMinus[theX_,theDx_]:={theX,theX-theDx,theX+theDx};


(* ::Subsubtitle::Initialization:: *)
(*(*(*(*numbers formatting*)*)*)*)


(* ::Input::Initialization::"Tags"-><|"PrefixPlus" -> <||>|>:: *)
roundDigits[z_,d_:0.001]:=MapAt[Round[#,d]&,z,Position[NumericQ[#]&/@z,True]];
(* Attributes=Listable BREAKS the function; but it is listable even without *)
(*SetAttributes[roundDigits,Listable];*)


(* ::Input::Initialization::"Tags"-><|"PrefixPlus" -> <||>|>:: *)
numFormat[x_,n_:10,theExp_:10]:=NumberForm[x,{n,3},
ExponentFunction->(If[-theExp<#<+theExp,Null,#]&),NumberSigns->(If[x!=0,{"-","+"},{"",""}])];
SetAttributes[numFormat,Listable];


(* ::Input::Initialization:: *)
Clear[testNumberFormat];
testNumberFormat[x_,sp_:8,dg_:3,theExp_:3]:=If[NumericQ[x]==True,
Return[nfpm[x,sp,dg,theExp]],
Return[x]
];
Block[{x,y,z},
If[$Notebooks,
testNumberFormat[eee];
testNumberFormat[3.];
testNumberFormat[0];
testNumberFormat[-3.];
testNumberFormat[030.];
]]


(* ::Input::Initialization::"Tags"-><|"PrefixPlus" -> <||>|>:: *)
Unprotect[nf,nfpm];
ClearAll[nf,nfpm];
nf[x_,sp_:8,dg_:3,theExp_:3]:=NumberForm[x,{sp,dg},
ExponentFunction->(If[-theExp<#1<+theExp,Null,3 Quotient[#1,3]]&),NumberMultiplier->"*"];
(*nfp: old name, to disappear*)
nfpm[x_,sp_:8,dg_:3,theExp_:3]:=NumberForm[x,{sp,dg},
ExponentFunction->(If[-theExp<#1<+theExp,Null,3 Quotient[#1,3]]&),NumberMultiplier->"*",NumberSigns->(If[x!=0,{"-","+"},{" "," "}])];
(*nfp[x_,sp_:8,dg_:3,theExp_:3]:=nfpm[x,sp,dg,theExp];*)(*deprecated*)
SetAttributes[{nf,nfpm},Listable];
Protect[nf,nfpm];


(* ::Input::Initialization:: *)
Unprotect[nfl,nfpml];
ClearAll[nfl,nfpml];
nfpml[x_,sp_:8,dg_:3,theExp_:3]:=If[NumericQ[x]==True,
Return[nfpm[x,sp,dg,theExp]],
Return[x]
];
nfl[x_,sp_:8,dg_:3,theExp_:3]:=If[NumericQ[x]==True,
Return[nf[x,sp,dg,theExp]],
Return[x]
];
SetAttributes[{nfl,nfpml},Listable];
Protect[nfl,nfpml];



(* ::Input::Initialization::"Tags"-><|"PrefixPlus" -> <||>|>:: *)
numFormatPad[x_,n_:10,theExp_:10]:=PaddedForm[x,{n,3},
ExponentFunction->(If[-theExp<#<+theExp,Null,#]&),NumberSigns->(If[x!=0,{"-","+"},{" "," "}])];
nfPad[x_,sp_:8,dg_:3,theExp_:3]:=PaddedForm[x,{sp,dg},
ExponentFunction->(If[-theExp<#1<+theExp,Null,3 Quotient[#1,3]]&),NumberMultiplier->"*"];
nfpmPad[x_,sp_:8,dg_:3,theExp_:3]:=PaddedForm[x,{sp,dg},
ExponentFunction->(If[-theExp<#1<+theExp,Null,3 Quotient[#1,3]]&),NumberMultiplier->"*",NumberSigns->(If[x!=0,{"-","+"},{" "," "}])];
SetAttributes[numFormatPad,Listable];
SetAttributes[nfPad,Listable];
SetAttributes[nfpmPad,Listable];


(* ::Input::Initialization::"Tags"-><|"PrefixPlus" -> <||>|>:: *)
Unprotect[nf0,nf1,nf2,nf3,nf4,nf5,nf6,nfpm0,nfpm1,nfpm2,nfpm3,nfpm4,nfpm5,nfpm6,nfl0,nfl1,nfl2,nfl3,nfpml0,nfpml1,nfpml2,nfpml3];
ClearAll[nf0,nf1,nf2,nf3,nf4,nf5,nf6,nfpm0,nfpm1,nfpm2,nfpm3,nfpm4,nfpm5,nfpm6,nfl0,nfl1,nfl2,nfl3,nfpml0,nfpml1,nfpml2,nfpml3];
(**)
nf0[x_]:=nf[x,10,0,99];
nf1[x_]:=nf[x,10,1,99];
nf2[x_]:=nf[x,10,2,99];
nf3[x_]:=nf[x,10,3,99];
nf4[x_]:=nf[x,10,4,99];
nf5[x_]:=nf[x,10,5,99];
nf6[x_]:=nf[x,10,6,99];
(**)
nfpm0[x_]:=nfpm[x,10,0,99];
nfpm1[x_]:=nfpm[x,10,1,99];
nfpm2[x_]:=nfpm[x,10,2,99];
nfpm3[x_]:=nfpm[x,10,3,99];
nfpm4[x_]:=nfpm[x,10,4,99];
nfpm5[x_]:=nfpm[x,10,5,99];
nfpm6[x_]:=nfpm[x,10,6,99];
(**)
nfl0[x_]:=nfl[x,10,0,99];
nfl1[x_]:=nfl[x,10,1,99];
nfl2[x_]:=nfl[x,10,2,99];
nfl3[x_]:=nfl[x,10,3,99];
(**)
nfpml0[x_]:=nfpml[x,10,0,99];
nfpml1[x_]:=nfpml[x,10,1,99];
nfpml2[x_]:=nfpml[x,10,2,99];
nfpml3[x_]:=nfpml[x,10,3,99];
(**)
SetAttributes[{nf0,nf1,nf2,nf3,nf4,nf5,nf6,nfl0,nfl1,nfl2,nfl3},Listable];
SetAttributes[{nfpm0,nfpm1,nfpm2,nfpm3,nfpm4,nfpm5,nfpm6,nfpml0,nfpml1,nfpml2,nfpml3},Listable];
Protect[nf0,nf1,nf2,nf3,nf4,nf5,nf6,nfpm0,nfpm1,nfpm2,nfpm3,nfpm4,nfpm5,nfpm6,nfl0,nfl1,nfl2,nfl3,nfpml0,nfpml1,nfpml2,nfpml3];


(* ::Subsubtitle::Initialization:: *)
(*(*(*(*vector/matrix/tensor operations*)*)*)*)


(* ::Input::Initialization:: *)
Unprotect[dropFirst];
ClearAll[dropFirst];
dropFirst[x_]:=Drop[x,1];
Protect[dropFirst];


(* ::Input::Initialization:: *)
insertCol[a_,b_,n_]:=Join[a[[;;,;;(n-1)]],b,a[[;;,n;;]],2];
insertRow[a_,b_,n_]:=Join[a[[;;(n-1)]],b,a[[n;;]]];
sumRow[mat_,iRow_]:=Module[{},Return[Total[mat[[iRow,All]]]];];
sumCol[mat_,iCol_]:=Module[{},Return[Total[mat[[All,iCol]]]];];


(* ::Input::Initialization:: *)
vLookup[lookupVal_,targetTable_,targetCol_,pickCol_]:=Module[{rowMatch,matchVal,allMatchedValues,numMatches,jdMatchVal,
jdNumMatch,
jdAllMatchVal,
jdRowMatch},
jdMatchVal=1;
jdNumMatch=2;
jdAllMatchVal=3;
jdRowMatch=4; 
debugPrint[" vLookup returns: { matchVal , numMatches , allMatchedValues , rowMatch } "];
rowMatch=Flatten[Position[targetTable[[All,targetCol]],n_/;n==lookupVal]];
If[
Length[rowMatch]==0
,
Return[{{"n/a"},0}]
,
matchVal=targetTable[[rowMatch,targetCol+pickCol]];
numMatches=Length[matchVal];
allMatchedValues=matchVal;
matchVal=DeleteDuplicates[matchVal];
Return[{matchVal,numMatches,allMatchedValues,rowMatch}];
]
];


(* ::Input::Initialization:: *)
vSum[lookupVal_,targetTable_,targetCol_,pickCol_]:=Module[{rowMatch,sum},
rowMatch=Position[targetTable[[All,targetCol]],n_/;n==lookupVal];
If[Length[rowMatch]==0
,
Return[0.0];
,
sum=Total[targetTable[[Flatten@rowMatch,targetCol+pickCol]]];
];
Return[sum]
];


(* ::Input::Initialization:: *)
numRow[a_]:=If[Length[Dimensions[a]]==2,First[Dimensions[a]],"Not a 2x2 array"];
numCol[a_]:=If[Length[Dimensions[a]]==2,Last[Dimensions[a]],"Not a 2x2 array"];


(* ::Input::Initialization:: *)
(* partialSumToEnd for a list of identical lists *)
partialSumToEnd[v_List,startCol_:2]:=Total/@v[[All,startCol;;All]];


(* ::Input::Initialization:: *)
matrixInfo[x__]:=Module[{res},
res={Dimensions[x],ArrayQ[x],ArrayDepth[x]};
Print[" matrixInfo : ",res];
Return[res]
];


(* ::Input::Initialization:: *)
takeFirstRow[matrix_]:=First[matrix];
takeFirstCol[matrix_]:=First[Transpose[matrix]];


(* ::Input::Initialization:: *)
matrixCore[matrix_]:=matrix[[2;;All,2;;All]];
rll[ll_,elem_] := ll[[Ordering[ll[[elem,All]]]]];
sll[ll_,elem_] := ll[[Ordering[ll[[All,elem]]]]];


(* ::Input::Initialization:: *)
sortMatrixRows[matrix_,numCol_]:=Module[{},
Transpose[Prepend[Transpose[Prepend[sll[matrixCore[matrix],numCol],takeFirstRow[matrix][[2;;All]]]],Prepend[Rest[takeFirstCol[matrix]][[Ordering[matrixCore[matrix][[All,numCol]]]]],"\\"]]]
];
sortMatrixCols[matrix_,numRow_]:=Transpose[sortMatrixRows[Transpose[matrix],numRow]];


(* ::Input::Initialization:: *)
(* sortByColumn *)
ClearAll[sortByColumn]
(* https://mathematica.stackexchange.com/questions/2934/sort-data-after-specific-ordering-ascending-descending-in-multiple-columns *)
sortByColumn::usage="Arguments: [Table, Direction, Priority]. 
Returns the list sorted by the directions for each column specified in `Direction`. 
For ascending order, use `1`, and for descending order, use `-1`. 
For sorting more than one column, input `Direction` as a list. For example, Direction={-1,1} will sort the first column in descending order followed by the second column in ascending order, ignoring any other column. To sort on the second column, use {0,1} for the syntax.
When sorting two or more columns, you can provide the `Priority` for which column should be sorted first. For example, `sortByColumn[data,{-1,1},{1,2}]`
would sort first in ascending order on the second column (because it has a higher priority) and then in descending order on the first column.";
sortByColumn[list_?MatrixQ,dir:_Integer|{__Integer},priority_: {}]:=Module[{l=Length@list[[1,All]],w,p,d},w=Reverse@Range@l;
p=If[Length@priority>0,PadRight[Flatten@{priority},l],p=Range@l];
w=w[[Ordering@p]];
d=PadRight[Flatten@{dir},l];
Sort[list,NonNegative@Total[(w d MapThread[Order,{##}])]&]
];


(* ::Subtitle::Initialization:: *)
(*(*(*(*text*)*)*)*)


(* ::Input::Initialization:: *)
cleanText[text_,outChar_:""]:=Module[{name,test,toClean},
toClean=
{Whitespace->outChar,PunctuationCharacter->outChar," "->outChar,"\[NonBreakingSpace]"->outChar,"'"->outChar,"-"->outChar,"("->outChar,")"->outChar};
name=StringTrim[RemoveDiacritics[text]];
name=StringReplace[name,toClean];
(* BELOW NOT NEEDED *)
(* Select[Map[LetterQ,name],#==False&];*)
test=Extract[name,Position[Map[LetterQ,name],False]];
If[test=={},debugPrint[" Cleanup OK "],debugPrint[" we have a problem cleaning-up text ",test]];
Return[name]
];
normalizeString[w_]:=cleanText[Capitalize[ToLowerCase[cleanText[w," "]],"AllWords"],""];


(* ::Subtitle::Initialization:: *)
(*(*(*(*MISCELLANEA // TO BE SORTED*)*)*)*)


(* ::Input::Initialization:: *)
If[$Notebooks,
RefLink[Green,paclet:ref/Green];
RefLink[Blue,paclet:ref/Blue];
RefLink[Black,paclet:ref/Black];
RefLink[White,paclet:ref/White];
RefLink[Gray,paclet:ref/Gray];
RefLink[Cyan,paclet:ref/Cyan];
RefLink[Magenta,paclet:ref/Magenta];
RefLink[Yellow,paclet:ref/Yellow];
RefLink[Brown,paclet:ref/Brown];
RefLink[Orange,paclet:ref/Orange];
RefLink[Pink,paclet:ref/Pink];
RefLink[Purple,paclet:ref/Purple]
];


(* ::Subtitle::Initialization:: *)
(*(*(*(*BaseNew - latest additions TO DOUBLE CHECK*)*)*)*)


(* ::Input::Initialization:: *)
(*searchForGivenNames[x_]:=Names["*"<>ToString[x]<>"*"];(*to change name....*)*)
searchForGivenNames[x_]:=Names[ToString[x]];


(* ::Input::Initialization:: *)
searchForGivenNamesAndPrint=(TableForm@Transpose@{searchForGivenNames[#],ToExpression@searchForGivenNames[#]})&


(* ::Input::Initialization:: *)
(*searchForGivenNamesAndPrint[base`tag]*)
(*Names[RegularExpression["(?i)base`.*tag.*"]]*)
(*Names[RegularExpression["(?i)rich`.*tag.*"]]*)


(* ::Input::Initialization:: *)
searchForGivenNamesRegExp[x_String]:=Names[RegularExpression["(?i).*"<>x<>".*"]]
searchForGivenNamesAndPrintRegExp=(TableForm@Transpose@{searchForGivenNamesRegExp[#],Evaluate@ToExpression@searchForGivenNamesRegExp[#]})&


(* ::Input::Initialization:: *)
searchForGivenNamesRegExp["base`.*Tag"]
searchForGivenNamesRegExp["rich`.*Tag"]


(* ::Input::Initialization:: *)
searchForGivenNamesAndPrintRegExp["rich`.*tag"]
searchForGivenNamesAndPrintRegExp["base`.*tag"]


(* ::Input::Initialization:: *)
searchForGivenNamesAndPrintRegExp["title"]
searchForGivenNamesAndPrintRegExp["inset"]


(* ::Input::Initialization:: *)
Names[RegularExpression["System`....."]]


(* ::Input::Initialization:: *)
(*EMPTY SO FAR*)


(* ::Subtitle::Initialization:: *)
(*(*(*(*END PACKAGE*)*)*)*)


(* ::Input::Initialization:: *)
End[] 
EndPackage[]


(* ::Input::Initialization:: *)
If[$Notebooks,Cells[CellStyle->{"MSG","Message"}]];


endEvalPrintOut[];


packageBanner["END base"];
