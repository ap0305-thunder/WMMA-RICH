(* Extracted from base.nb. Definitions preserve original initialization-cell order. *)
(* Generated mechanically; validate in a clean Wolfram kernel before deleting legacy-original/. *)

(* ---- initialization cell 1 | 95ad6317-19c9-c243-aaf0-fb078a636afe ---- *)
Print["\<*==================================================================================================*\>"];
Print["\<*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*\>"];
Print["\<***--- base ---***\>"];
Print["\<*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*\>"];
Print["\<*==================================================================================================*\>"];

BeginPackage["\<base`\>",{"\<myNotebookInit`\>"}] (**)
base::nodep = "\<Required dependency `1` is not available. Load or install it before loading base`.\>";
Print["\<*==================================================================================================*\>"  ];
Print["\<*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*\>"  ];
Print["\<***---                  LOADING base                   ---***\>"  ];
Print["\<*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*\>"  ];
Print["\<*==================================================================================================*\>"  ];

(*---Explicit dependency check:myNotebookInit`---*)

If[!MemberQ[$Packages, "\<myNotebookInit`\>"],
 Quiet @ Check[
Needs["\<myNotebookInit`\>"  ], 
Message[base::nodep, "\<myNotebookInit`\>"]; 
Throw[$Failed, "\<PackageDependencyError\>"  ]
]
];

If[!NameQ["\<myNotebookInit`loadMyFile\>"], Message[base::nodep, "\<myNotebookInit`loadMyFile\>"
  ]; Throw[$Failed, "\<PackageDependencyError\>"]];


checkNewCreatedSymbols[]
showContextInfo[]

(*Once[*)If[TrueQ[Global`$RICHProjectManagedLoad],Null,myNotebookInit`loadMyFile["\<CellStyleDataRules.wl\>",DirectoryName[$InputFileName]]](*,"\<Notebook\>"]*)

(*EXPORT*)

nnff::usage ="\<format\>";
nnffpm::usage ="\<format\>";
ceiling::usage="\<ceiling\>"
ceilingTrim::usage="\<ceilingTrim\>";
checkEqualRealNumbers::usage="\<checkEqualRealNumbers\>";
cleanNum::usage="\<cleanNum\>";
cleanText::usage="\<cleanText\>";
debugPrint::usage="\<debugPrint\>";
debugPrintEnabledFlag::usage="\<debugPrintEnabledFlag\>";
decimals::usage="\<decimals\>"
digits::usage="\<digits\>"
dropFirst::usage="\<dropFirst\>";
edge::usage="\<edge\>";
eps::usage="\<eps\>";
epsFact::usage="\<epsFact\>"
epsilonQuantum::usage="\<epsilonQuantum\>";
errorFunction::usage="\<errorFunction\>"
errorFunctionDemo::usage="\<errorFunctionDemo[]\>";
exception::usage="\<exception\>";
exists::usage="\<exists\>";
findNotebooks::usage="\<findNotebooks[]\>";
fmt::usage="\<fmt\>"
insertCol::usage="\<insertCol\>";
insertRow::usage="\<insertRow\>";
lookupVal::usage="\<lookupVal\>"
matrixCore::usage="\<matrixCore\>";
matrixInfo::usage="\<matrixInfo\>";
myNicePrint::usage="\<myNicePrint\>";
nf0::usage="\<nf0\>";
nf1::usage="\<nf1\>";
nf2::usage="\<nf2\>";
nf3::usage="\<nf3\>";
nf4::usage="\<nf4\>";
nf5::usage="\<nf5\>";
nf6::usage="\<nf6\>";
nf::usage="\<nf\>";
nfPad::usage="\<nfPad\>";
nfl0::usage="\<nfl0\>";
nfl1::usage="\<nfl1\>";
nfl2::usage="\<nfl2\>";
nfl3::usage="\<nfl3\>";
nfl::usage="\<nfl\>";
nfpm0::usage="\<nfpm0\>";
nfpm1::usage="\<nfpm1\>";
nfpm2::usage="\<nfpm2\>";
nfpm3::usage="\<nfpm3\>";
nfpm4::usage="\<nfpm4\>";
nfpm5::usage="\<nfpm5\>";
nfpm6::usage="\<nfpm6\>";
nfpm::usage="\<nfpm\>";
nfpmPad::usage="\<nfpmPad\>";
nfpml0::usage="\<nfpml0\>";
nfpml1::usage="\<nfpml1\>";
nfpml2::usage="\<nfpml2\>";
nfpml3::usage="\<nfpml3\>";
nfpml::usage="\<nfpml\>";
nicePrint::usage="\<nicePrint\>";
niceSymbolsOrder::usage="\<niceSymbolsOrder\>";
normalizeString::usage="\<normalizeString\>";
numCol::usage="\<numCol\>";
numFormat::usage="\<numFormat\>";
numFormatPad::usage="\<numFormatPad\>";
numRow::usage="\<numRow\>";
partialSumToEnd::usage="\<partialSumToEnd\>";
printa1::usage="\<printa1\>";
printa::usage="\<printa\>";
prn::usage="\<prn\>";
reorderSymbols::usage="\<reorderSymbols\>";
rewrite::usage="\<rewrite\>";
rll::usage="\<rll\>";
roundDigits::usage="\<roundDigits\>";
searchForGivenNames::usage="\<searchForGivenNames\>";
searchForGivenNamesAndPrint::usage="\<searchForGivenNamesAndPrint\>";
searchForGivenNamesRegExp::usage="\<searchForGivenNamesRegExp\>";
sll::usage="\<sll\>";
sortByColumn::usage="\<sortByColumn\>";
sortMatrixCols::usage="\<sortMatrixCols\>";
sortMatrixRows::usage="\<sortMatrixRows\>";
sumCol::usage="\<sumCol\>";
sumRow::usage="\<sumRow\>";
swap::usage="\<swap\>";
tableOfContents::usage="\<tableOfContents\>";
takeFirstCol::usage="\<takeFirstCol\>";
takeFirstRow::usage="\<takeFirstRow\>";
taylor::usage="\<taylor\>";
testNumberFormat::usage="\<testNumberFormat\>";
tickFormat::usage="\<tickFormat\>";
toClean::usage="\<toClean\>";
vLookup::usage="\<vLookup\>";
vSum::usage="\<vSum\>";
valPlusMinus::usage="\<valPlusMinus\>";
variableize::usage="\<variableize\>";
window::usage="\<window\>";

(* ---- initialization cell 2 | 09e323ec-7b46-0548-92c4-8cbdd9a99653 ---- *)
Begin["\<`Private`\>"] 
(* Begin Private Context *) 
versionTAG="\<v.07-05-2026\>"
(*ResourceFunction["\<NotebookOutlineMenu\>"][EvaluationNotebook[],"\<Table Of Contents\>",{"\<Title\>","\<Subtitle\>","\<Subsubtitle\>"}]*)
(* End Private Context *)

(* ---- initialization cell 3 | b7f79eb3-a64f-ac4e-85cf-bee124ca43c8 ---- *)
tableOfContents[notebook_]:=Module[{headerTypes,nb0,headerCells,tagHeaders},
(*Cell types to include in ToC*)
headerTypes="\<Title\>"|"\<Chapter\>"|"\<Subtitle\>"|"\<Subsubtitle\>"|"\<Section\>";
(*Find cells of the desired type and tag with their names*)
nb0=Import[notebook];
headerCells=Cases[nb0,Cell[_,headerTypes,___],Infinity];
tagHeaders=Map[Append[#,CellTags->#[[1]]]&,headerCells];
(*Export tagged cells*)
Export[notebook,ReplaceAll[nb0,Normal[AssociationThread[headerCells,tagHeaders]]]];
(*Generate styled hyperlinks for ToC*)
TableForm@Map[
If[MatchQ[#[[2]],"\<Chapter\>"],
Hyperlink[Style[#[[1]],RGBColor@{211/256,15/64,0},FontFamily->"\<Arial\>",FontTracking->"\<Plain\>",FontSize->20],{notebook,#[[1]]}],
If[MatchQ[#[[2]],"\<Subtitle\>"],
Hyperlink[Style["\<\t\>"<>#[[1]],RGBColor@{211/256,15/64,0},FontFamily->"\<Arial\>",FontTracking->"\<Plain\>",FontSize->18],{notebook,#[[1]]}],
If[MatchQ[#[[2]],"\<Subsubtitle\>"],
Hyperlink[Style["\<\t\t\>"<>#[[1]],RGBColor@{211/256,15/64,0},FontFamily->"\<Arial\>",FontTracking->"\<Plain\>",FontSize->16],{notebook,#[[1]]}],
Hyperlink[Style["\<\t\t\t\>"<>#[[1]],RGBColor@{53/64,51/128,1/256},FontFamily->"\<Arial\>",FontTracking->"\<Plain\>",FontSize->14],{notebook,#[[1]]}]
]
]
]&
,headerCells]
];

(*toc=tableOfContents[NotebookFileName[EvaluationNotebook[]]];
SaveToCell[toc,Short[toc]];
Print@toc;
*)

(* ---- initialization cell 4 | 233bbe11-ae0c-ca42-8e7f-738325c5dad2 ---- *)
(*bigBanner["\<Don't leave the Suggestions Bar enabled
The predictive interface (Suggestions Bar) is the source of many bugs reported on this site and surely many more that have yet to be reported. 
I strongly suggest that all new users turn off the Suggestions Bar to avoid unexpected problems such as 
massive memory usage([1], [2]), peculiar evaluation leaks ([1], [2]), broken assignments, disappearing definitions, and crashes([1], [2]).\>"];*)

(* ---- initialization cell 5 | 19aa30ef-1712-9a45-a043-0047d0d6c159 ---- *)
Print["\< ************************************************************************************************* \>"];

Print["\< Start running  \>",myNotebookInit`timeStamp];

Print["\< t0=AbsoluteTime[]   \>",AbsoluteTime[]];

Print["\< ************************************************************************************************* \>"];

(* ---- initialization cell 6 | c94113e8-6122-da4f-965e-63d7c50ca2c7 ---- *)
(*Select[Names["\<Global`*\>"],Head@Symbol[#]=!=Symbol&&Head@Symbol[#]=!=Function&]*)
(*
Clear[$globalProperties];
$globalProperties={OwnValues,DownValues,SubValues,UpValues,NValues,FormatValues,Options,DefaultValues,Attributes,Messages};
ClearAll[getDefinitions];
SetAttributes[getDefinitions,HoldAllComplete];
getDefinitions[s_Symbol]:=Flatten@Through[Map[Function[prop,Function[sym,prop[sym],HoldAll]],$globalProperties][Unevaluated[s]]];
ClearAll[symbolMemoryUsage];
symbolMemoryUsage[sname_String]:=ToExpression[sname,InputForm,Function[s,ByteCount[getDefinitions[s]],HoldAllComplete]];
ClearAll[heavySymbols];
heavySymbols[context_,sizeLim_: 10^6]:=Pick[#,UnitStep[#-sizeLim]&@Map[symbolMemoryUsage,#],1]&@Names[context<>"\<*\>"];
heavySymbols["\<Global`\>"]
*)
(*CellPrint[TextCell["\<1\t55\n33\t44\>", "\<Text\>"]]*)

(* ---- initialization cell 7 | 35bc8cfb-4818-8244-bd5e-af6e8dc88def ---- *)
(*
ClearAll[removeDeclareContext];
removeDeclareContext[context_String]:=$NewSymbol::declarativeContexts=StringDelete[$NewSymbol::declarativeContexts,"\<|\>"<>context]
ClearAll[declareContext];
declareContext[context_String]:=Module[{},$NewSymbol::undeclared="\<`1``2` was not previously declared.\>";
If[ValueQ[$NewSymbol::declarativeContexts]==False,$NewSymbol::declarativeContexts="\<\>"];
$NewSymbol::declarativeContexts=StringJoin[$NewSymbol::declarativeContexts,"\<|\>",context];
$NewSymbol:=If[ContainsAny[StringSplit[$NewSymbol::declarativeContexts,"\<|\>"],{#2}]&&ContainsNone[Names[#2<>"\<*\>"],{#1}],Message[$NewSymbol::undeclared,#2,#1]]&]
*)

(* ---- initialization cell 8 | d777aa93-27a5-b949-b42e-a135dd6c3cf2 ---- *)
(*
(*==================================================================================================*)
(* ERROR HANDLING *)
(*==================================================================================================*)
(* Put the following two lines at the top of every notebook. *)
messageHandler=If[Last[#],Interrupt[]]&;
Internal`AddHandler["\<Message\>",messageHandler];
forceFakeBreakForDebug:={warn={1,2};Do[Print[warn[[i]]],{i,1,3}]};
(*forceFakeBreakForDebug;*)
(*==================================================================================================*)*)

(* ---- initialization cell 9 | 71d5fa77-f406-1c46-bb43-3978b76619c1 ---- *)
(*Off[ParallelMap::subpar]*)
(*On[General::newsym];*)
(*$NewSymbol=Print["\<Name: \>",#1,"\< Context: \>",#2]&;*)
(*Print[SystemInformation[]];*)
(*Print[NotebookInformation[]];*)
(*Needs["\<Experimental`\>"];*)
(*Experimental`ValueFunction[x]:=Print["\< INFO: insCdlDat changed to : \>",x];*)
(*$NewSymbol::undeclared="\<`1` was not previously declared.\>";*)
(*$NewSymbol:=Message[$NewSymbol::undeclared,#1]&*)
(*Names["\<*\>"];*)

(* ---- initialization cell 10 | 24e0721d-365f-c74a-b148-fad1fa241c99 ---- *)
(*Button["\< EMERGENCY QUIT KERNEL \>",Quit[]]*)
(*Names["\<Global`*\>"]*)
(* To get rid of error message: "\<There was insufficient Java heap space for the operation. Try increasing the Java Virtual Machine heap size.\>" *)
(*
<<JLink`;
InstallJava[];
ReinstallJava[JVMArguments->"\<-Xmx32768m\>"];
*)

(* ---- initialization cell 11 | 316ce293-f8e5-ef48-93a7-d5d368e10e0c ---- *)
(*==================================================================================================*)
(* ERROR HANDLING *)
(*==================================================================================================*)
(* Put the following two lines at the top of every notebook. *)
(*
messageHandler=If[Last[#],Interrupt[]]&;
Internal`AddHandler["\<Message\>",messageHandler];
forceFakeBreakForDebug:={warn={1,2};Do[Print[warn[[i]]],{i,1,3}]};
*)
(*forceFakeBreakForDebug;*)
(*==================================================================================================*)

(* ---- initialization cell 12 | d3233527-2a2e-bf41-8884-0ef81f1b73f3 ---- *)
(*Hyperlink["\<Go To Index\>",{SelectedNotebook[],"\<index\>"}]*)

(* ---- initialization cell 13 | e4a16644-c9fb-8743-bdcf-077ee87a2245 ---- *)
(* 
MAGNIFICATION SLIDER
SetOptions[EvaluationNotebook[],DockedCells->Cell[BoxData[ToBoxes[
DynamicModule[{m=1},Panel[Slider[Dynamic[m,SetOptions[EvaluationNotebook[],Magnification->(m=#)]&],{0.5,2.0}],"\<Magnification\>"]]]
],"\<DockedCell\>"]
];
*)

(* ---- initialization cell 14 | 9c1139c8-1eb1-6940-83d6-fa1fbe01b34e ---- *)
Unprotect[variableize];

ClearAll[variableize];

variableize[text_,prefix_:"\<id\>",suffix_:"\<\>"]:=Module[{},
(*Symbol[StringJoin[prefix,StringReplace[Capitalize[ToLowerCase[text],"\<AllWords\>"],Whitespace->"\<\>"]]]*)
Symbol[
StringJoin[
prefix,
StringReplace[If[Length[prefix]==0,Decapitalize[text],Capitalize[text,"\<AllWords\>"]],Whitespace->"\<\>"],
suffix
]
]
];

SetAttributes[variableize,Listable];

Protect[variableize];
(*head={"\<aaa\>","\< bbb \>","\<ccccc\>","\< Ale\>","\<PPP\>"};*)

(*vars=variableize[head,"\<\>","\<R1\>"]*)

(* ---- initialization cell 15 | c2b431a8-6de1-3546-9741-179e4e3546e6 ---- *)
(* introduced bug to fix


errorFunction[v_,f_]:=Module[{varlist,funct,varlength,theoretical,uncert},

Manipulate[varlist=ToExpression[variables];
funct=ToExpression[function];
errorFunction[variables,function],{variables,"\<{M,m}\>"},{function,"\<g*(M-m)/(M+m)\>"},LabelStyle->{FontSize->17},AutoAction->False,Initialization:>(errorFunction[v_,f_]:=(varlist=ToExpression[v];
funct=ToExpression[f];
varlength=Length[Variables[varlist]];
theoretical=Sqrt[(Total[Table[(D[funct,Part[varlist,n]]*Subscript[U,Part[varlist,n]])^2,{n,1,varlength}]])];
Part[theoretical,1];
varlist;
uncert=Table[Subscript[U,Part[varlist,n]],{n,1,varlength}];
uncert=DeleteCases[uncert,Alternatives@@{0}];
theoretical=Simplify[theoretical];
Column[{Row[{Grid[{{"\<Variables\>",varlist},{"\<Uncertainties\>",uncert},{"\<Function\>",function},{"\<Uncertainty Function\>",theoretical}},Alignment->Left,Spacings->{2,1},Frame->All,ItemStyle->{"\<Text\>",FontSize->20},Background->{{LightGray,None}}]}],Row[{Grid[{{"\<Brian Gennow  March/24/2015\>"}},Alignment->Left,Spacings->{2,1},ItemStyle->"\<Text\>",Background->{{None}}]}]}]))]]
];*)

(* ---- initialization cell 16 | efc2ed3e-55d2-5449-b817-8415b0413916 ---- *)
debugPrintEnabledFlag=False;

SetAttributes[debugPrint,HoldAll];

debugPrint[input__,debug$debugPrint_:debugPrintEnabledFlag]:=Module[{},If[debug$debugPrint==True,Print[input]]];

debugPrint[32,True]

(* ---- initialization cell 17 | 23a9688a-0a3b-c449-b45e-23fe71ab7f61 ---- *)
(*epsilonQuantum=(10)^(-9);*)
(*superClearSet[epsilonQuantum];*)
(*myNumberOfDigits=10;*)
(*eps=1.0*(10)^(-12);*)

(* ---- initialization cell 18 | 09743b4e-1e9a-9442-a272-212e27e8013c ---- *)
exception[cnt_, cntMax_, messageText_] :=
  Module[
    {}
    ,
    (*Print["\<cnt =\>",cnt];*)
    If[cnt < cntMax,
      Print[messageText];
      ,
      If[cnt == cntMax,
        Print["\<    STOP\>" <> messageText]
      ]
    ]
  ];

(* ---- initialization cell 19 | bbe3cc2a-a295-994e-98d2-1c3dd3a5eb3e ---- *)
checkEqualRealNumbers[x_, y_, epsFact_:10] :=
  If[Abs[x - y] <= epsFact * $MachineEpsilon,
    (*Print["\<Equal to within \>",epsFact*$MachineEpsilon];*)
    Return["\<True\>"]
    ,
    Print["\< NOT Equal to within \>", epsFact * $MachineEpsilon];
    Return["\<False\>"]
  ];

(* ---- initialization cell 20 | 590db50a-1fcb-5b48-8c7f-aa4795367f80 ---- *)
(* Beware: a lot of output! *)

(*$NewSymbol=Print["\<Name: \>",#1,"\< Context: \>",#2]&;*)

(* ---- initialization cell 21 | dfa806b6-6c6f-1b41-a056-0e8554e80bf6 ---- *)
findNotebooks[]:=If[$Notebooks,Quiet@FileNames["\<*.nb\>",NotebookDirectory[],2],{}];

(* ---- initialization cell 22 | 37a3f68e-a2ba-4b4f-8a51-dd427e8c6dc2 ---- *)
cleanNum[v_] :=
  Module[
    {y}
    ,
    y = v /. s_String -> 0.0;
    Return[y];
  ];

SetAttributes[cleanNum, Listable];

(* ---- initialization cell 23 | 691ad58b-0460-6548-8dc8-8ed03ab82c7c ---- *)
ceilingTrim[dat_, ceiling_] :=
  If[dat > ceiling,
    ceiling
    ,
    dat
  ];

SetAttributes[ceilingTrim, Listable];

(* ---- initialization cell 24 | e59cb52d-0d26-f940-9cf1-0e3f9e98d8f8 ---- *)
exists[x_List]:=If[Length[x]>0,x,"\< n/a \>"];

exists[x_]:=x;

(* ---- initialization cell 25 | 08faa98e-c5d0-3c4b-94af-9d7537952ec3 ---- *)
tickFormat[xmin_, xmax_, digits_, divisions_:10] :=
  Function[
      tickNumber
      ,
      {tickNumber, PaddedForm[Round[tickNumber, 0.01], {Max @ (Length
         @ IntegerDigits @ IntegerPart[#]& /@ (10^digits {xmin, xmax})), digits
        }]}
    ] /@ FindDivisions[{xmin, xmax}, divisions];

(* ---- initialization cell 26 | 9345444f-c229-3c42-9dcb-1adf45690c73 ---- *)
ClearAll[printa,printa1];
SetAttributes[{printa,printa1},HoldFirst];
printa1[var_]:=Module[{},Print["\<  >>>  \>",SymbolName[Unevaluated[var]]];Print["\<  >>>  \>",Evaluate[var]]];
printa[var_]:=Module[{},Print["\<  >>>  \>",SymbolName[Unevaluated[var]]];Print["\<          >>>  \>",Evaluate[var]]];

ClearAll[myNicePrint];
SetAttributes[myNicePrint,HoldAll];
myNicePrint[args__]:=Scan[Function[x,Print[Unevaluated[x],"\< = \>",x],{HoldAll}],Hold[args]];
ClearAll[myPrint];
SetAttributes[myPrint,HoldAll];
myPrint[args___]:=Do[Print[Extract[Hold[args],i,HoldForm],"\<=\>",List[args][[i]]],{i,Length[List[args]]}];
ClearAll[prn];
SetAttributes[prn,{HoldAll,Listable}];
prn[arg_]:=Print[HoldForm[arg],"\< = \>",arg];
prn[args___]:=prn[{args}];
nicePrint[whattooutput__,space_:10,decimals_:3]:= OutputForm[TableForm[Map[PaddedForm[#,{space,decimals},NumberSigns->{"\<-\>","\<+\>"}]&,whattooutput,{2}],TableSpacing->{1}]];

If[$Notebooks,
ape=20;
nut:=20 ape;
mouse=cat+nut;
printa1[ape,nut,mouse];
printa[ape,nut,mouse];
myNicePrint[ape,nut,mouse];
myPrint[ape,nut,mouse];
prn[ape,nut,mouse];
];

(* ---- initialization cell 27 | 84429cf4-aaff-8841-89b6-1773b7d2637a ---- *)
reorderSymbols[expr_,symbols_List]:=With[{s=symbols},
HoldForm[Evaluate[expr/. Thread[s->Sort@s]]]/. Thread[Sort@s->s]
];

(* ---- initialization cell 28 | e85c0048-e2a4-874d-8bb7-8ee9f68b1c3b ---- *)
niceSymbolsOrder[exp_,varli_List]:=Module[{dummySomething},
   MakeBoxes[dummySomething[_,y_],fmt_]:=ToBoxes[y,fmt];
   exp/.Thread[varli->Reverse/@MapIndexed[dummySomething,varli]]
];

(* ---- initialization cell 29 | b95f23c6-fb1a-3d46-81f9-74deed317453 ---- *)
rewrite[expr_]:=Module[{out,new,old},
Simplify[Rationalize[expr],Variables[expr]\[Element]Reals];
out=Experimental`OptimizeExpression[expr];
new=Symbol/@CharacterRange[63396,63421];
old=DeleteDuplicates@Cases[out,s_Symbol/;Context[s]==="\<Compile`\>",{-1}];
Extract[out,{1,2},Defer]/.Cases[Flatten[{old,new},{2}],{o_,n_}:>(o:>n)]
];

(*K=a*b*t/((t+f)c*d);
FullSimplify[K,TransformationFunctions->{(#/. t/(t+f)->p&),Automatic}]*)

(* ---- initialization cell 30 | 04390693-7432-b044-b594-a893cb1168a0 ---- *)
(*RunScheduledTask[EmitSound[Sound[SoundNote[]]];NotebookSave[EvaluationNotebook[]],600];*)

(* The corresponding notebook cell was marked Evaluatable -> False and is intentionally not loaded. *)

(* ---- initialization cell 32 | 77c084ab-434a-0044-b9f7-48f3e30a022b ---- *)
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

(* ---- initialization cell 33 | ae9fc829-69ba-8e44-91a7-07bef64a9c2f ---- *)
swap[x_]:=Map[{#[[2]],#[[1]]}&,x];

(* ---- initialization cell 34 | b11b6478-624b-c846-8436-d8b0dd6dbfe8 ---- *)
edge[x_,low_,upp_]:=ResourceFunction["\<SmoothStep\>"][x,{low,upp}]

(* ---- initialization cell 35 | 27c1fed3-f86c-9f47-9ba8-dfccf99628a8 ---- *)
window[s_,x1_,x2_]:=UnitBox[s/(x2-x1)-(x1+x2)/2/(x2-x1)]

(* ---- initialization cell 36 | b9e76def-2c9e-cf43-a886-1b5359ed83af ---- *)
valPlusMinus[theX_,theDx_]:={theX,theX-theDx,theX+theDx};

(* ---- initialization cell 37 | 441ba4da-cafb-f949-a712-9c282e702848 ---- *)
roundDigits[z_,d_:0.001]:=MapAt[Round[#,d]&,z,Position[NumericQ[#]&/@z,True]];
(* Attributes=Listable BREAKS the function; but it is listable even without *)

(*SetAttributes[roundDigits,Listable];*)

(* ---- initialization cell 38 | e416cafc-70e9-9b46-a628-a76b7097eda4 ---- *)
numFormat[x_,n_:10,theExp_:10]:=NumberForm[x,{n,3},
ExponentFunction->(If[-theExp<#<+theExp,Null,#]&),NumberSigns->(If[x\[NotEqual]0,{"\<-\>","\<+\>"},{"\<\>","\<\>"}])];

SetAttributes[numFormat,Listable];

(* ---- initialization cell 39 | 73fee665-3a85-7a4e-a259-3fbed6a8d08f ---- *)
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

(* ---- initialization cell 40 | ddcf0a5e-cfd4-8c4f-80f9-5692bdab5ccf ---- *)
Unprotect[nf,nfpm];

ClearAll[nf,nfpm];

nf[x_,sp_:8,dg_:3,theExp_:3]:=NumberForm[x,{sp,dg},
ExponentFunction->(If[-theExp<#1<+theExp,Null,3 Quotient[#1,3]]&),NumberMultiplier->"\<*\>"];
(*nfp: old name, to disappear*)

nfpm[x_,sp_:8,dg_:3,theExp_:3]:=NumberForm[x,{sp,dg},
ExponentFunction->(If[-theExp<#1<+theExp,Null,3 Quotient[#1,3]]&),NumberMultiplier->"\<*\>",NumberSigns->(If[x\[NotEqual]0,{"\<-\>","\<+\>"},{"\< \>","\< \>"}])];
(*nfp[x_,sp_:8,dg_:3,theExp_:3]:=nfpm[x,sp,dg,theExp];*)(*deprecated*)

SetAttributes[{nf,nfpm},Listable];

Protect[nf,nfpm];

(* ---- initialization cell 41 | fc6f1a89-80fc-5944-9930-7c9a8bb784b4 ---- *)
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

(* ---- initialization cell 42 | 7cf549a2-1a9b-4340-8050-333b6b5472a6 ---- *)
numFormatPad[x_,n_:10,theExp_:10]:=PaddedForm[x,{n,3},
ExponentFunction->(If[-theExp<#<+theExp,Null,#]&),NumberSigns->(If[x\[NotEqual]0,{"\<-\>","\<+\>"},{"\< \>","\< \>"}])];

nfPad[x_,sp_:8,dg_:3,theExp_:3]:=PaddedForm[x,{sp,dg},
ExponentFunction->(If[-theExp<#1<+theExp,Null,3 Quotient[#1,3]]&),NumberMultiplier->"\<*\>"];

nfpmPad[x_,sp_:8,dg_:3,theExp_:3]:=PaddedForm[x,{sp,dg},
ExponentFunction->(If[-theExp<#1<+theExp,Null,3 Quotient[#1,3]]&),NumberMultiplier->"\<*\>",NumberSigns->(If[x\[NotEqual]0,{"\<-\>","\<+\>"},{"\< \>","\< \>"}])];

SetAttributes[numFormatPad,Listable];

SetAttributes[nfPad,Listable];

SetAttributes[nfpmPad,Listable];

(* ---- initialization cell 43 | 76cad93b-6903-ae4b-bf7d-cae918b4abf5 ---- *)
Unprotect[nnffpm,nnff];

ClearAll[nnff,nnffpm];

(*
option name default value
DigitBlock	Infinity	maximum length of blocks of digits between breaks
NumberSeparator	{"\<,\>","\< \>"}	strings to insert at breaks between blocks of digits to the left and right of a decimal point
NumberPoint	"\<.\>"	string to use for a decimal point
NumberMultiplier	"\<\[Backslash][Times]\>"	string to use for the multiplication sign in scientific notation
NumberSigns	{"\<-\>","\<\>"}	strings to use for signs of negative and positive numbers
NumberPadding	{"\<\>","\<\>"}	strings to use for padding on the left and right
SignPadding	False	whether to insert padding after the sign
NumberFormat	Automatic	function to generate final format of number
ExponentFunction	Automatic	function to determine the exponent to use
*)(*
All the options in the table except the last one apply to both integers and approximate real numbers.All the options can be used in any of the functions NumberForm,ScientificForm,EngineeringForm,and AccountingForm.In fact,you can in principle reproduce the behavior of any one of these functions simply by giving appropriate option settings in one of the others.
*)

nnff[x_,sp_:\[Infinity],dg_:3,theExpStep_:3,theExpThrMin_:3]:=NumberForm[x,{sp,dg},
ScientificNotationThreshold->{-theExpThrMin,6},
(*ExponentFunction->(theExpStep*Quotient[#,theExpStep]&),*)
ExponentFunction->(If[-theExpThrMin<#1<+theExpThrMin,Null,theExpStep*Quotient[#1,theExpStep]]&),
NumberMultiplier->"\<*\>"(*NumberMultiplier->"\<\[Times]\>"*)
];

nnffpm[x_,sp_:\[Infinity],dg_:3,theExpStep_:3,theExpThrMin_:3]:=NumberForm[x,{sp,dg},
ScientificNotationThreshold->{-theExpThrMin,6},
(*ExponentFunction->(theExpStep*Quotient[#,theExpStep]&),*)
ExponentFunction->(If[-theExpThrMin<#1<+theExpThrMin,Null,theExpStep*Quotient[#1,theExpStep]]&),
NumberMultiplier->"\<*\>",(*NumberMultiplier->"\<\[Times]\>"*)
NumberSigns->If[QuantityMagnitude[x]!=0,{"\<-\>","\<+\>"},{"\<\>","\<\>"}]
];

SetAttributes[{nnff,nnffpm},Listable];

Protect[nnff,nnffpm];

(* ---- initialization cell 44 | e40c50b5-40e4-3247-8aa0-39f5e40d5f11 ---- *)
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

(* ---- initialization cell 45 | 9bf4e8ef-dfd2-7c49-a140-1ce2ffa335ee ---- *)
Unprotect[dropFirst];

ClearAll[dropFirst];

dropFirst[x_]:=Drop[x,1];

Protect[dropFirst];

(* ---- initialization cell 46 | 54cfaa6a-c0fc-0d4e-94bf-e79952724579 ---- *)
insertCol[a_,b_,n_]:=Join[a[[;;,;;(n-1)]],b,a[[;;,n;;]],2];

insertRow[a_,b_,n_]:=Join[a[[;;(n-1)]],b,a[[n;;]]];

sumRow[mat_,iRow_]:=Module[{},Return[Total[mat[[iRow,All]]]];];

sumCol[mat_,iCol_]:=Module[{},Return[Total[mat[[All,iCol]]]];];

(* ---- initialization cell 47 | 63689dbb-f73a-7343-a7cd-93332f42a2ac ---- *)
vLookup[lookupVal_,targetTable_,targetCol_,pickCol_]:=Module[{rowMatch,matchVal,allMatchedValues,numMatches,jdMatchVal,
jdNumMatch,
jdAllMatchVal,
jdRowMatch},
jdMatchVal=1;
jdNumMatch=2;
jdAllMatchVal=3;
jdRowMatch=4; 
debugPrint["\< vLookup returns: { matchVal , numMatches , allMatchedValues , rowMatch } \>"];
rowMatch=Flatten[Position[targetTable\[LeftDoubleBracket]All,targetCol\[RightDoubleBracket],n_/;n==lookupVal]];
If[
Length[rowMatch]==0
,
Return[{{"\<n/a\>"},0}]
,
matchVal=targetTable\[LeftDoubleBracket]rowMatch,targetCol+pickCol\[RightDoubleBracket];
numMatches=Length[matchVal];
allMatchedValues=matchVal;
matchVal=DeleteDuplicates[matchVal];
Return[{matchVal,numMatches,allMatchedValues,rowMatch}];
]
];

(* ---- initialization cell 48 | a7ea9c4c-8106-b542-81de-4c3bc9602139 ---- *)
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

(* ---- initialization cell 49 | a1f21b40-ab5b-0240-bd5f-6915b412faec ---- *)
numRow[a_]:=If[Length[Dimensions[a]]==2,First[Dimensions[a]],"\<Not a 2x2 array\>"];

numCol[a_]:=If[Length[Dimensions[a]]==2,Last[Dimensions[a]],"\<Not a 2x2 array\>"];

(* ---- initialization cell 50 | b5dfedf5-1cb7-4842-82a5-f455a227dd02 ---- *)
(* partialSumToEnd for a list of identical lists *)
partialSumToEnd[v_List,startCol_:2]:=Total/@v[[All,startCol;;All]];

(* ---- initialization cell 51 | db97dba4-08e0-3244-98ac-7bc5c24a1726 ---- *)
matrixInfo[x__]:=Module[{res},
res={Dimensions[x],ArrayQ[x],ArrayDepth[x]};
Print["\< matrixInfo : \>",res];
Return[res]
];

(* ---- initialization cell 52 | 837535d8-2d62-0349-803a-262fb09c111d ---- *)
takeFirstRow[matrix_]:=First[matrix];

takeFirstCol[matrix_]:=First[Transpose[matrix]];

(* ---- initialization cell 53 | 98e14f9b-60b1-e44b-bebf-e59775e86800 ---- *)
matrixCore[matrix_]:=matrix[[2;;All,2;;All]];

rll[ll_,elem_] := ll[[Ordering[ll[[elem,All]]]]];

sll[ll_,elem_] := ll[[Ordering[ll[[All,elem]]]]];

(* ---- initialization cell 54 | e629ee5d-6857-3f49-b915-e749aa488c63 ---- *)
sortMatrixRows[matrix_,numCol_]:=Module[{},
Transpose[Prepend[Transpose[Prepend[sll[matrixCore[matrix],numCol],takeFirstRow[matrix][[2;;All]]]],Prepend[Rest[takeFirstCol[matrix]][[Ordering[matrixCore[matrix][[All,numCol]]]]],"\<\\\>"]]]
];

sortMatrixCols[matrix_,numRow_]:=Transpose[sortMatrixRows[Transpose[matrix],numRow]];

(* ---- initialization cell 55 | 16115ab9-e90f-f441-9ba0-d30779ab6162 ---- *)
(* sortByColumn *)
ClearAll[sortByColumn]
(* https://mathematica.stackexchange.com/questions/2934/sort-data-after-specific-ordering-ascending-descending-in-multiple-columns *)
sortByColumn::usage="\<Arguments: [Table, Direction, Priority]. 
Returns the list sorted by the directions for each column specified in `Direction`. 
For ascending order, use `1`, and for descending order, use `-1`. 
For sorting more than one column, input `Direction` as a list. For example, Direction={-1,1} will sort the first column in descending order followed by the second column in ascending order, ignoring any other column. To sort on the second column, use {0,1} for the syntax.
When sorting two or more columns, you can provide the `Priority` for which column should be sorted first. For example, `sortByColumn[data,{-1,1},{1,2}]`
would sort first in ascending order on the second column (because it has a higher priority) and then in descending order on the first column.\>";
sortByColumn[list_?MatrixQ,dir:_Integer|{__Integer},priority_: {}]:=Module[{l=Length@list[[1,All]],w,p,d},w=Reverse@Range@l;
p=If[Length@priority>0,PadRight[Flatten@{priority},l],p=Range@l];
w=w[[Ordering@p]];
d=PadRight[Flatten@{dir},l];
Sort[list,NonNegative@Total[(w d MapThread[Order,{##}])]&]
];

(* ---- initialization cell 56 | 3f4be6d7-5227-4346-ac0b-aec0bdba3424 ---- *)
cleanText[text_,outChar_:"\<\>"]:=Module[{name,test,toClean},
toClean=
{Whitespace->outChar,PunctuationCharacter->outChar,"\< \>"->outChar,"\<\[NonBreakingSpace]\>"->outChar,"\<'\>"->outChar,"\<-\>"->outChar,"\<(\>"->outChar,"\<)\>"->outChar};
name=StringTrim[RemoveDiacritics[text]];
name=StringReplace[name,toClean];
(* BELOW NOT NEEDED *)
(* Select[Map[LetterQ,name],#==False&];*)
test=Extract[name,Position[Map[LetterQ,name],False]];
If[test=={},debugPrint["\< Cleanup OK \>"],debugPrint["\< we have a problem cleaning-up text \>",test]];
Return[name]
];

normalizeString[w_]:=cleanText[Capitalize[ToLowerCase[cleanText[w,"\< \>"]],"\<AllWords\>"],"\<\>"];

(* ---- initialization cell 57 | 2422d3b8-0c8c-b64d-910d-ffd77142750f ---- *)
(* Exact box evaluation retained because this cell uses special front-end constructs. *)
ReleaseHold[ToExpression[BoxData[
 RowBox[{
  RowBox[{"If", "[", 
   RowBox[{"$Notebooks", ",", "\[IndentingNewLine]", 
    RowBox[{
     TemplateBox[{
       Cell[
        TextData["Green"]], "paclet:ref/Green"},
      "RefLink",
      BaseStyle->{"InlineFormula"}], ";", "\[IndentingNewLine]", 
     TemplateBox[{
       Cell[
        TextData["Blue"]], "paclet:ref/Blue"},
      "RefLink",
      BaseStyle->{"InlineFormula"}], ";", "\[IndentingNewLine]", 
     TemplateBox[{
       Cell[
        TextData["Black"]], "paclet:ref/Black"},
      "RefLink",
      BaseStyle->{"InlineFormula"}], ";", "\[IndentingNewLine]", 
     TemplateBox[{
       Cell[
        TextData["White"]], "paclet:ref/White"},
      "RefLink",
      BaseStyle->{"InlineFormula"}], ";", "\[IndentingNewLine]", 
     TemplateBox[{
       Cell[
        TextData["Gray"]], "paclet:ref/Gray"},
      "RefLink",
      BaseStyle->{"InlineFormula"}], ";", "\[IndentingNewLine]", 
     TemplateBox[{
       Cell[
        TextData["Cyan"]], "paclet:ref/Cyan"},
      "RefLink",
      BaseStyle->{"InlineFormula"}], ";", "\[IndentingNewLine]", 
     TemplateBox[{
       Cell[
        TextData["Magenta"]], "paclet:ref/Magenta"},
      "RefLink",
      BaseStyle->{"InlineFormula"}], ";", "\[IndentingNewLine]", 
     TemplateBox[{
       Cell[
        TextData["Yellow"]], "paclet:ref/Yellow"},
      "RefLink",
      BaseStyle->{"InlineFormula"}], ";", "\[IndentingNewLine]", 
     TemplateBox[{
       Cell[
        TextData["Brown"]], "paclet:ref/Brown"},
      "RefLink",
      BaseStyle->{"InlineFormula"}], ";", "\[IndentingNewLine]", 
     TemplateBox[{
       Cell[
        TextData["Orange"]], "paclet:ref/Orange"},
      "RefLink",
      BaseStyle->{"InlineFormula"}], ";", "\[IndentingNewLine]", 
     TemplateBox[{
       Cell[
        TextData["Pink"]], "paclet:ref/Pink"},
      "RefLink",
      BaseStyle->{"InlineFormula"}], ";", "\[IndentingNewLine]", 
     TemplateBox[{
       Cell[
        TextData["Purple"]], "paclet:ref/Purple"},
      "RefLink",
      BaseStyle->{"InlineFormula"}]}]}], "\[IndentingNewLine]", "]"}], 
  ";"}]], StandardForm, HoldComplete]];

(* ---- initialization cell 58 | 1109fe95-00a9-c247-94fa-c409ab6da938 ---- *)
(*searchForGivenNames[x_]:=Names["\<*\>"<>ToString[x]<>"\<*\>"];(*to change name....*)*)
searchForGivenNames[x_]:=Names[ToString[x]];

(* ---- initialization cell 59 | d9c756c0-4053-e541-bb44-750ad59c1362 ---- *)
searchForGivenNamesAndPrint=(TableForm@Transpose@{searchForGivenNames[#],ToExpression@searchForGivenNames[#]})&

(* ---- initialization cell 60 | 0d995172-88d0-4b40-a634-cc1a74e2e548 ---- *)
(*searchForGivenNamesAndPrint[base`tag]*)
(*Names[RegularExpression["\<(?i)base`.*tag.*\>"]]*)
(*Names[RegularExpression["\<(?i)rich`.*tag.*\>"]]*)

(* ---- initialization cell 61 | b2e273cd-0e9c-d94b-bcc9-6f7640f92b28 ---- *)
searchForGivenNamesRegExp[x_String]:=Names[RegularExpression["\<(?i).*\>"<>x<>"\<.*\>"]]

searchForGivenNamesAndPrintRegExp=(TableForm@Transpose@{searchForGivenNamesRegExp[#],Evaluate@ToExpression@searchForGivenNamesRegExp[#]})&

(* ---- initialization cell 62 | fd40ad83-e46a-d341-90a5-8bbf55a223fc ---- *)
searchForGivenNamesRegExp["\<base`.*Tag\>"]

searchForGivenNamesRegExp["\<rich`.*Tag\>"]

(* ---- initialization cell 63 | 40eceb6b-12c7-354d-bf24-62044105e185 ---- *)
searchForGivenNamesAndPrintRegExp["\<rich`.*tag\>"]

searchForGivenNamesAndPrintRegExp["\<base`.*tag\>"]

(* ---- initialization cell 64 | d7f6f0a4-cb15-ab49-97fe-baf099f70819 ---- *)
searchForGivenNamesAndPrintRegExp["\<title\>"]

searchForGivenNamesAndPrintRegExp["\<inset\>"]

(* ---- initialization cell 65 | 288c2ee0-59b2-3545-b8e9-99a6401c383d ---- *)
Names[RegularExpression["\<System`.....\>"]]

(* ---- initialization cell 66 | 9b3f33ec-2c2e-e74e-86b2-7f158701ce85 ---- *)
(*EMPTY SO FAR*)

(* ---- initialization cell 67 | 41b27ee8-ca95-cd45-8ee4-bcfb666b84ae ---- *)
Print["\<*==================================================================================================*\>"];

Print["\<*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*\>"];

Print["\<***---                  END base                         ---***\>"];

Print["\<*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*\>"];

Print["\<*==================================================================================================*\>"];

(* ---- initialization cell 68 | 7ad0fdee-fb19-8d43-bcb7-7c687e417a02 ---- *)
End[]

EndPackage[]

(* ---- initialization cell 69 | 317b1acb-c72c-a643-8e98-899984ec4bde ---- *)
If[$Notebooks,Cells[CellStyle->{"\<MSG\>","\<Message\>"}]];

(* ---- initialization cell 70 | ee23bf0e-e96a-9645-a081-9dd8106c0b54 ---- *)
checkNewCreatedSymbols[]
showContextInfo[]
