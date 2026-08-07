(* ::Package:: *)

(* Regenerated from base.nb using NotebookImport without a text conversion. *)
(* Each source cell was imported under HoldComplete, serialized in context-preserving FullForm, and syntax-checked without evaluation. *)

(* ::Title:: *)
(* SETUP *)

(* ::Subtitle:: *)
(* SETUP *)

(* ::Subsubtitle:: *)
(* Additional general settings for any (complex) notebook *)

(* ::Title:: *)
(* BASE *)

(* ::Subtitle:: *)
(* INIT PACKAGE *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 1, expression 1 ---- *)
CompoundExpression[Times[CompoundExpression[Print["*==================================================================================================*"], Null], CompoundExpression[Print["*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*"], Null], CompoundExpression[Print["***--- base ---***"], Null], CompoundExpression[Print["*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*"], Null], CompoundExpression[Print["*==================================================================================================*"], Null], BeginPackage["base`", List["myNotebookInit`"]], CompoundExpression[Set[MessageName[Global`base, "nodep"], "Required dependency `1` is not available. Load or install it before loading base`."], Null], CompoundExpression[Print["*==================================================================================================*"], Null], CompoundExpression[Print["*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*"], Null], CompoundExpression[Print["***---                  LOADING base                                                                  ---***"], Null], CompoundExpression[Print["*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*"], Null], CompoundExpression[Print["*==================================================================================================*"], Null], CompoundExpression[If[Not[MemberQ[$Packages, "myNotebookInit`"]], Quiet[Check[Needs["myNotebookInit`"], CompoundExpression[Message[MessageName[Global`base, "nodep"], "myNotebookInit`"], Throw[$Failed, "PackageDependencyError"]]]]], Null], CompoundExpression[If[Not[NameQ["myNotebookInit`loadMyFile"]], CompoundExpression[Message[MessageName[Global`base, "nodep"], "myNotebookInit`loadMyFile"], Throw[$Failed, "PackageDependencyError"]]], Null], myNotebookInit`checkNewCreatedSymbols[], myNotebookInit`showContextInfo[], If[TrueQ[Global`$RICHProjectManagedLoad], Null, myNotebookInit`loadMyFile["CellStyleDataRules.wl", DirectoryName[$InputFileName]]], CompoundExpression[Set[MessageName[base`nnff, "usage"], "format"], Null], CompoundExpression[Set[MessageName[base`nnffpm, "usage"], "format"], Null], Set[MessageName[base`ceiling, "usage"], "ceiling"], CompoundExpression[Set[MessageName[base`ceilingTrim, "usage"], "ceilingTrim"], Null], CompoundExpression[Set[MessageName[base`checkEqualRealNumbers, "usage"], "checkEqualRealNumbers"], Null], CompoundExpression[Set[MessageName[base`cleanNum, "usage"], "cleanNum"], Null], CompoundExpression[Set[MessageName[base`cleanText, "usage"], "cleanText"], Null], CompoundExpression[Set[MessageName[base`debugPrint, "usage"], "debugPrint"], Null], CompoundExpression[Set[MessageName[base`debugPrintEnabledFlag, "usage"], "debugPrintEnabledFlag"], Null], Set[MessageName[base`decimals, "usage"], "decimals"], Set[MessageName[base`digits, "usage"], "digits"], CompoundExpression[Set[MessageName[base`dropFirst, "usage"], "dropFirst"], Null], CompoundExpression[Set[MessageName[base`edge, "usage"], "edge"], Null], CompoundExpression[Set[MessageName[base`eps, "usage"], "eps"], Null], Set[MessageName[base`epsFact, "usage"], "epsFact"], CompoundExpression[Set[MessageName[base`epsilonQuantum, "usage"], "epsilonQuantum"], Null], Set[MessageName[base`errorFunction, "usage"], "errorFunction"], CompoundExpression[Set[MessageName[base`errorFunctionDemo, "usage"], "errorFunctionDemo[]"], Null], CompoundExpression[Set[MessageName[base`exception, "usage"], "exception"], Null], CompoundExpression[Set[MessageName[base`exists, "usage"], "exists"], Null], CompoundExpression[Set[MessageName[base`findNotebooks, "usage"], "findNotebooks[]"], Null], Set[MessageName[base`fmt, "usage"], "fmt"], CompoundExpression[Set[MessageName[base`insertCol, "usage"], "insertCol"], Null], CompoundExpression[Set[MessageName[base`insertRow, "usage"], "insertRow"], Null], Set[MessageName[base`lookupVal, "usage"], "lookupVal"], CompoundExpression[Set[MessageName[base`matrixCore, "usage"], "matrixCore"], Null], CompoundExpression[Set[MessageName[base`matrixInfo, "usage"], "matrixInfo"], Null], CompoundExpression[Set[MessageName[base`myNicePrint, "usage"], "myNicePrint"], Null], CompoundExpression[Set[MessageName[base`nf0, "usage"], "nf0"], Null], CompoundExpression[Set[MessageName[base`nf1, "usage"], "nf1"], Null], CompoundExpression[Set[MessageName[base`nf2, "usage"], "nf2"], Null], CompoundExpression[Set[MessageName[base`nf3, "usage"], "nf3"], Null], CompoundExpression[Set[MessageName[base`nf4, "usage"], "nf4"], Null], CompoundExpression[Set[MessageName[base`nf5, "usage"], "nf5"], Null], CompoundExpression[Set[MessageName[base`nf6, "usage"], "nf6"], Null], CompoundExpression[Set[MessageName[base`nf, "usage"], "nf"], Null], CompoundExpression[Set[MessageName[base`nfPad, "usage"], "nfPad"], Null], CompoundExpression[Set[MessageName[base`nfl0, "usage"], "nfl0"], Null], CompoundExpression[Set[MessageName[base`nfl1, "usage"], "nfl1"], Null], CompoundExpression[Set[MessageName[base`nfl2, "usage"], "nfl2"], Null], CompoundExpression[Set[MessageName[base`nfl3, "usage"], "nfl3"], Null], CompoundExpression[Set[MessageName[base`nfl, "usage"], "nfl"], Null], CompoundExpression[Set[MessageName[base`nfpm0, "usage"], "nfpm0"], Null], CompoundExpression[Set[MessageName[base`nfpm1, "usage"], "nfpm1"], Null], CompoundExpression[Set[MessageName[base`nfpm2, "usage"], "nfpm2"], Null], CompoundExpression[Set[MessageName[base`nfpm3, "usage"], "nfpm3"], Null], CompoundExpression[Set[MessageName[base`nfpm4, "usage"], "nfpm4"], Null], CompoundExpression[Set[MessageName[base`nfpm5, "usage"], "nfpm5"], Null], CompoundExpression[Set[MessageName[base`nfpm6, "usage"], "nfpm6"], Null], CompoundExpression[Set[MessageName[base`nfpm, "usage"], "nfpm"], Null], CompoundExpression[Set[MessageName[base`nfpmPad, "usage"], "nfpmPad"], Null], CompoundExpression[Set[MessageName[base`nfpml0, "usage"], "nfpml0"], Null], CompoundExpression[Set[MessageName[base`nfpml1, "usage"], "nfpml1"], Null], CompoundExpression[Set[MessageName[base`nfpml2, "usage"], "nfpml2"], Null], CompoundExpression[Set[MessageName[base`nfpml3, "usage"], "nfpml3"], Null], CompoundExpression[Set[MessageName[base`nfpml, "usage"], "nfpml"], Null], CompoundExpression[Set[MessageName[base`nicePrint, "usage"], "nicePrint"], Null], CompoundExpression[Set[MessageName[base`niceSymbolsOrder, "usage"], "niceSymbolsOrder"], Null], CompoundExpression[Set[MessageName[base`normalizeString, "usage"], "normalizeString"], Null], CompoundExpression[Set[MessageName[base`numCol, "usage"], "numCol"], Null], CompoundExpression[Set[MessageName[base`numFormat, "usage"], "numFormat"], Null], CompoundExpression[Set[MessageName[base`numFormatPad, "usage"], "numFormatPad"], Null], CompoundExpression[Set[MessageName[base`numRow, "usage"], "numRow"], Null], CompoundExpression[Set[MessageName[base`partialSumToEnd, "usage"], "partialSumToEnd"], Null], CompoundExpression[Set[MessageName[base`printa1, "usage"], "printa1"], Null], CompoundExpression[Set[MessageName[base`printa, "usage"], "printa"], Null], CompoundExpression[Set[MessageName[base`prn, "usage"], "prn"], Null], CompoundExpression[Set[MessageName[base`reorderSymbols, "usage"], "reorderSymbols"], Null], CompoundExpression[Set[MessageName[base`rewrite, "usage"], "rewrite"], Null], CompoundExpression[Set[MessageName[base`rll, "usage"], "rll"], Null], CompoundExpression[Set[MessageName[base`roundDigits, "usage"], "roundDigits"], Null], CompoundExpression[Set[MessageName[base`searchForGivenNames, "usage"], "searchForGivenNames"], Null], CompoundExpression[Set[MessageName[base`searchForGivenNamesAndPrint, "usage"], "searchForGivenNamesAndPrint"], Null], CompoundExpression[Set[MessageName[base`searchForGivenNamesRegExp, "usage"], "searchForGivenNamesRegExp"], Null], CompoundExpression[Set[MessageName[base`sll, "usage"], "sll"], Null], CompoundExpression[Set[MessageName[base`sortByColumn, "usage"], "sortByColumn"], Null], CompoundExpression[Set[MessageName[base`sortMatrixCols, "usage"], "sortMatrixCols"], Null], CompoundExpression[Set[MessageName[base`sortMatrixRows, "usage"], "sortMatrixRows"], Null], CompoundExpression[Set[MessageName[base`sumCol, "usage"], "sumCol"], Null], CompoundExpression[Set[MessageName[base`sumRow, "usage"], "sumRow"], Null], CompoundExpression[Set[MessageName[base`swap, "usage"], "swap"], Null], CompoundExpression[Set[MessageName[base`tableOfContents, "usage"], "tableOfContents"], Null], CompoundExpression[Set[MessageName[base`takeFirstCol, "usage"], "takeFirstCol"], Null], CompoundExpression[Set[MessageName[base`takeFirstRow, "usage"], "takeFirstRow"], Null], CompoundExpression[Set[MessageName[base`taylor, "usage"], "taylor"], Null], CompoundExpression[Set[MessageName[base`testNumberFormat, "usage"], "testNumberFormat"], Null], CompoundExpression[Set[MessageName[base`tickFormat, "usage"], "tickFormat"], Null], CompoundExpression[Set[MessageName[base`toClean, "usage"], "toClean"], Null], CompoundExpression[Set[MessageName[base`vLookup, "usage"], "vLookup"], Null], CompoundExpression[Set[MessageName[base`vSum, "usage"], "vSum"], Null], CompoundExpression[Set[MessageName[base`valPlusMinus, "usage"], "valPlusMinus"], Null], CompoundExpression[Set[MessageName[base`variableize, "usage"], "variableize"], Null], CompoundExpression[Set[MessageName[base`window, "usage"], "window"], Null]]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 2, expression 1 ---- *)
CompoundExpression[Times[Begin["`Private`"], Set[myNotebookInit`versionTAG, "v.07-05-2026"]]]

(* ::Subtitle:: *)
(* START *)

(* ::Section:: *)
(* INIT *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 3, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`tableOfContents[Pattern[base`Private`notebook, Blank[]]], Module[List[base`Private`headerTypes, base`Private`nb0, base`Private`headerCells, base`Private`tagHeaders], CompoundExpression[Set[base`Private`headerTypes, Alternatives["Title", "Chapter", "Subtitle", "Subsubtitle", "Section"]], Set[base`Private`nb0, Import[base`Private`notebook]], Set[base`Private`headerCells, Cases[base`Private`nb0, Cell[Blank[], base`Private`headerTypes, BlankNullSequence[]], Infinity]], Set[base`Private`tagHeaders, Map[Function[Append[Slot[1], Rule[CellTags, Part[Slot[1], 1]]]], base`Private`headerCells]], Export[base`Private`notebook, ReplaceAll[base`Private`nb0, Normal[AssociationThread[base`Private`headerCells, base`Private`tagHeaders]]]], TableForm[Map[Function[If[MatchQ[Part[Slot[1], 2], "Chapter"], Hyperlink[Style[Part[Slot[1], 1], RGBColor[List[Times[211, Power[256, -1]], Times[15, Power[64, -1]], 0]], Rule[FontFamily, "Arial"], Rule[FontTracking, "Plain"], Rule[FontSize, 20]], List[base`Private`notebook, Part[Slot[1], 1]]], If[MatchQ[Part[Slot[1], 2], "Subtitle"], Hyperlink[Style[StringJoin["\t", Part[Slot[1], 1]], RGBColor[List[Times[211, Power[256, -1]], Times[15, Power[64, -1]], 0]], Rule[FontFamily, "Arial"], Rule[FontTracking, "Plain"], Rule[FontSize, 18]], List[base`Private`notebook, Part[Slot[1], 1]]], If[MatchQ[Part[Slot[1], 2], "Subsubtitle"], Hyperlink[Style[StringJoin["\t\t", Part[Slot[1], 1]], RGBColor[List[Times[211, Power[256, -1]], Times[15, Power[64, -1]], 0]], Rule[FontFamily, "Arial"], Rule[FontTracking, "Plain"], Rule[FontSize, 16]], List[base`Private`notebook, Part[Slot[1], 1]]], Hyperlink[Style[StringJoin["\t\t\t", Part[Slot[1], 1]], RGBColor[List[Times[53, Power[64, -1]], Times[51, Power[128, -1]], Times[1, Power[256, -1]]]], Rule[FontFamily, "Arial"], Rule[FontTracking, "Plain"], Rule[FontSize, 14]], List[base`Private`notebook, Part[Slot[1], 1]]]]]]], base`Private`headerCells]]]]], Null], Null, Null]

(* ::Subsubtitle:: *)
(* MESSAGES *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 4, expression 1 ---- *)
CompoundExpression[Null]

(* ::Subsubtitle:: *)
(* SYSTEM Setup *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 5, expression 1 ---- *)
CompoundExpression[CompoundExpression[Print[" ************************************************************************************************* "], Null], Null, CompoundExpression[Print[" Start running  ", myNotebookInit`timeStamp], Null], Null, CompoundExpression[Print[" t0=AbsoluteTime[]   ", AbsoluteTime[]], Null], Null, CompoundExpression[Print[" ************************************************************************************************* "], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 6, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 7, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 8, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 9, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 10, expression 1 ---- *)
CompoundExpression[Null]

(* ::Subsubtitle:: *)
(* MATHEMATICA setup *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 11, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 12, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 13, expression 1 ---- *)
CompoundExpression[Null]

(* ::Subsection:: *)
(* general tools for variables management *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 14, expression 1 ---- *)
CompoundExpression[CompoundExpression[Unprotect[base`variableize], Null], Null, CompoundExpression[ClearAll[base`variableize], Null], Null, CompoundExpression[SetDelayed[base`variableize[Pattern[base`Private`text, Blank[]], Optional[Pattern[base`Private`prefix, Blank[]], "id"], Optional[Pattern[base`Private`suffix, Blank[]], ""]], Module[List[], Symbol[StringJoin[base`Private`prefix, StringReplace[If[Equal[Length[base`Private`prefix], 0], Decapitalize[base`Private`text], Capitalize[base`Private`text, "AllWords"]], Rule[Whitespace, ""]], base`Private`suffix]]]], Null], Null, CompoundExpression[SetAttributes[base`variableize, Listable], Null], Null, CompoundExpression[Protect[base`variableize], Null], Null, Null]

(* ::Subsection:: *)
(* error propagation formulas *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 15, expression 1 ---- *)
CompoundExpression[Null]

(* ::Subtitle:: *)
(* GENERAL *)

(* ::Subsubtitle:: *)
(* DEBUG *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 16, expression 1 ---- *)
CompoundExpression[CompoundExpression[Set[base`debugPrintEnabledFlag, False], Null], Null, CompoundExpression[SetAttributes[base`debugPrint, HoldAll], Null], Null, CompoundExpression[SetDelayed[base`debugPrint[Pattern[base`Private`input, BlankSequence[]], Optional[Pattern[base`Private`debug$debugPrint, Blank[]], base`debugPrintEnabledFlag]], Module[List[], If[Equal[base`Private`debug$debugPrint, True], Print[base`Private`input]]]], Null], Null, base`debugPrint[32, True]]

(* ::Subsubtitle:: *)
(* WOLFRAM MATHEMATICA workings *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 17, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 18, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`exception[Pattern[base`Private`cnt, Blank[]], Pattern[base`Private`cntMax, Blank[]], Pattern[base`Private`messageText, Blank[]]], Module[List[], If[Less[base`Private`cnt, base`Private`cntMax], CompoundExpression[Print[base`Private`messageText], Null], If[Equal[base`Private`cnt, base`Private`cntMax], Print[StringJoin["    STOP", base`Private`messageText]]]]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 19, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`checkEqualRealNumbers[Pattern[base`Private`x, Blank[]], Pattern[base`Private`y, Blank[]], Optional[Pattern[base`epsFact, Blank[]], 10]], If[LessEqual[Abs[Plus[base`Private`x, Times[-1, base`Private`y]]], Times[base`epsFact, $MachineEpsilon]], Return["True"], CompoundExpression[Print[" NOT Equal to within ", Times[base`epsFact, $MachineEpsilon]], Return["False"]]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 20, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 21, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`findNotebooks[], If[$Notebooks, Quiet[FileNames["*.nb", NotebookDirectory[], 2]], List[]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 22, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`cleanNum[Pattern[base`Private`v, Blank[]]], Module[List[base`Private`y], CompoundExpression[Set[base`Private`y, ReplaceAll[base`Private`v, Rule[Pattern[base`Private`s, Blank[String]], 0.`]]], Return[base`Private`y], Null]]], Null], Null, CompoundExpression[SetAttributes[base`cleanNum, Listable], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 23, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`ceilingTrim[Pattern[base`Private`dat, Blank[]], Pattern[base`ceiling, Blank[]]], If[Greater[base`Private`dat, base`ceiling], base`ceiling, base`Private`dat]], Null], Null, CompoundExpression[SetAttributes[base`ceilingTrim, Listable], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 24, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`exists[Pattern[base`Private`x, Blank[List]]], If[Greater[Length[base`Private`x], 0], base`Private`x, " n/a "]], Null], Null, CompoundExpression[SetDelayed[base`exists[Pattern[base`Private`x, Blank[]]], base`Private`x], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 25, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`tickFormat[Pattern[base`Private`xmin, Blank[]], Pattern[base`Private`xmax, Blank[]], Pattern[base`digits, Blank[]], Optional[Pattern[base`Private`divisions, Blank[]], 10]], Map[Function[base`Private`tickNumber, List[base`Private`tickNumber, PaddedForm[Round[base`Private`tickNumber, 0.01`], List[Max[Map[Function[Length[IntegerDigits[IntegerPart[Slot[1]]]]], Times[Power[10, base`digits], List[base`Private`xmin, base`Private`xmax]]]], base`digits]]]], FindDivisions[List[base`Private`xmin, base`Private`xmax], base`Private`divisions]]], Null]]

(* ::Subsubtitle:: *)
(* pretty print *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 26, expression 1 ---- *)
CompoundExpression[Times[CompoundExpression[ClearAll[base`printa, base`printa1], Null], CompoundExpression[SetAttributes[List[base`printa, base`printa1], HoldFirst], Null], CompoundExpression[SetDelayed[base`printa1[Pattern[base`Private`var, Blank[]]], Module[List[], CompoundExpression[Print["  >>>  ", SymbolName[Unevaluated[base`Private`var]]], Print["  >>>  ", Evaluate[base`Private`var]]]]], Null], CompoundExpression[SetDelayed[base`printa[Pattern[base`Private`var, Blank[]]], Module[List[], CompoundExpression[Print["  >>>  ", SymbolName[Unevaluated[base`Private`var]]], Print["          >>>  ", Evaluate[base`Private`var]]]]], Null], CompoundExpression[ClearAll[base`myNicePrint], Null], CompoundExpression[SetAttributes[base`myNicePrint, HoldAll], Null], CompoundExpression[SetDelayed[base`myNicePrint[Pattern[base`Private`args, BlankSequence[]]], Scan[Function[base`Private`x, Print[Unevaluated[base`Private`x], " = ", base`Private`x], List[HoldAll]], Hold[base`Private`args]]], Null], CompoundExpression[ClearAll[base`Private`myPrint], Null], CompoundExpression[SetAttributes[base`Private`myPrint, HoldAll], Null], CompoundExpression[SetDelayed[base`Private`myPrint[Pattern[base`Private`args, BlankNullSequence[]]], Do[Print[Extract[Hold[base`Private`args], base`Private`i, HoldForm], "=", Part[List[base`Private`args], base`Private`i]], List[base`Private`i, Length[List[base`Private`args]]]]], Null], CompoundExpression[ClearAll[base`prn], Null], CompoundExpression[SetAttributes[base`prn, List[HoldAll, Listable]], Null], CompoundExpression[SetDelayed[base`prn[Pattern[base`Private`arg, Blank[]]], Print[HoldForm[base`Private`arg], " = ", base`Private`arg]], Null], CompoundExpression[SetDelayed[base`prn[Pattern[base`Private`args, BlankNullSequence[]]], base`prn[List[base`Private`args]]], Null], CompoundExpression[SetDelayed[base`nicePrint[Pattern[base`Private`whattooutput, BlankSequence[]], Optional[Pattern[base`Private`space, Blank[]], 10], Optional[Pattern[base`decimals, Blank[]], 3]], OutputForm[TableForm[Map[Function[PaddedForm[Slot[1], List[base`Private`space, base`decimals], Rule[NumberSigns, List["-", "+"]]]], base`Private`whattooutput, List[2]], Rule[TableSpacing, List[1]]]]], Null], CompoundExpression[If[$Notebooks, CompoundExpression[Set[base`Private`ape, 20], SetDelayed[base`Private`nut, Times[20, base`Private`ape]], Set[base`Private`mouse, Plus[base`Private`cat, base`Private`nut]], base`printa1[base`Private`ape, base`Private`nut, base`Private`mouse], base`printa[base`Private`ape, base`Private`nut, base`Private`mouse], base`myNicePrint[base`Private`ape, base`Private`nut, base`Private`mouse], base`Private`myPrint[base`Private`ape, base`Private`nut, base`Private`mouse], base`prn[base`Private`ape, base`Private`nut, base`Private`mouse], Null]], Null]]]

(* ::Subsubtitle:: *)
(* RE-WRITE EXPRESSIONS *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 27, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`reorderSymbols[Pattern[base`Private`expr, Blank[]], Pattern[base`Private`symbols, Blank[List]]], With[List[Set[base`Private`s, base`Private`symbols]], ReplaceAll[HoldForm[Evaluate[ReplaceAll[base`Private`expr, Thread[Rule[base`Private`s, Sort[base`Private`s]]]]]], Thread[Rule[Sort[base`Private`s], base`Private`s]]]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 28, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`niceSymbolsOrder[Pattern[base`Private`exp, Blank[]], Pattern[base`Private`varli, Blank[List]]], Module[List[base`Private`dummySomething], CompoundExpression[SetDelayed[MakeBoxes[base`Private`dummySomething[Blank[], Pattern[base`Private`y, Blank[]]], Pattern[base`fmt, Blank[]]], ToBoxes[base`Private`y, base`fmt]], ReplaceAll[base`Private`exp, Thread[Rule[base`Private`varli, Map[Reverse, MapIndexed[base`Private`dummySomething, base`Private`varli]]]]]]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 29, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`rewrite[Pattern[base`Private`expr, Blank[]]], Module[List[base`Private`out, base`Private`new, base`Private`old], CompoundExpression[Simplify[Rationalize[base`Private`expr], Element[Variables[base`Private`expr], Reals]], Set[base`Private`out, Experimental`OptimizeExpression[base`Private`expr]], Set[base`Private`new, Map[Symbol, CharacterRange[63396, 63421]]], Set[base`Private`old, DeleteDuplicates[Cases[base`Private`out, Condition[Pattern[base`Private`s, Blank[Symbol]], SameQ[Context[base`Private`s], "Compile`"]], List[-1]]]], ReplaceAll[Extract[base`Private`out, List[1, 2], Defer], Cases[Flatten[List[base`Private`old, base`Private`new], List[2]], RuleDelayed[List[Pattern[base`Private`o, Blank[]], Pattern[base`Private`n, Blank[]]], RuleDelayed[base`Private`o, base`Private`n]]]]]]], Null], Null, Null]

(* ::Subtitle:: *)
(* useful tools *)

(* ::Subsubtitle:: *)
(* styles *)

(* ::Subsubtitle:: *)
(* RunScheduledTask *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 30, expression 1 ---- *)
CompoundExpression[Null]

(* ::Subsubtitle:: *)
(* MergeAppendNotebooks *)

(* ::Subtitle:: *)
(* MATHEMATICAL FUNCTIONS *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 31, expression 1 ---- *)
CompoundExpression[SetDelayed[base`taylor[Pattern[base`Private`f, Blank[]], Pattern[base`Private`var, List[Repeated[Blank[Symbol]]]], PatternTest[Pattern[base`Private`n, Blank[Integer]], Positive]], Module[List[Set[base`Private`expr, Expand[Normal[Series[base`Private`f, Apply[Sequence, Map[Function[List[Slot[1], 0, base`Private`n]], base`Private`var]]]]]]], Select[base`Private`expr, Function[LessEqual[Total[Exponent[Slot[1], base`Private`var]], base`Private`n]]]]], Null, Block[List[base`Private`x, base`Private`y, base`Private`z], If[$Notebooks, CompoundExpression[Set[base`Private`f1[Pattern[base`Private`x, Blank[]], Pattern[base`Private`y, Blank[]]], Sin[Plus[base`Private`x, base`Private`y]]], base`taylor[base`Private`f1[base`Private`x, base`Private`y], List[base`Private`x, base`Private`y], 3], Set[base`Private`f2[Pattern[base`Private`x, Blank[]], Pattern[base`Private`y, Blank[]], Pattern[base`Private`z, Blank[]]], Times[base`Private`z, Sin[Plus[base`Private`x, base`Private`y]]]], base`taylor[base`Private`f2[base`Private`x, base`Private`y, base`Private`z], List[base`Private`x, base`Private`y, base`Private`z], 4]]]]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 32, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`swap[Pattern[base`Private`x, Blank[]]], Map[Function[List[Part[Slot[1], 2], Part[Slot[1], 1]]], base`Private`x]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 33, expression 1 ---- *)
CompoundExpression[SetDelayed[base`edge[Pattern[base`Private`x, Blank[]], Pattern[base`Private`low, Blank[]], Pattern[base`Private`upp, Blank[]]], ResourceFunction["SmoothStep"][base`Private`x, List[base`Private`low, base`Private`upp]]]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 34, expression 1 ---- *)
CompoundExpression[SetDelayed[base`window[Pattern[base`Private`s, Blank[]], Pattern[base`Private`x1, Blank[]], Pattern[base`Private`x2, Blank[]]], UnitBox[Plus[Times[base`Private`s, Power[Plus[base`Private`x2, Times[-1, base`Private`x1]], -1]], Times[-1, Times[Times[Plus[base`Private`x1, base`Private`x2], Power[2, -1]], Power[Plus[base`Private`x2, Times[-1, base`Private`x1]], -1]]]]]]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 35, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`valPlusMinus[Pattern[base`Private`theX, Blank[]], Pattern[base`Private`theDx, Blank[]]], List[base`Private`theX, Plus[base`Private`theX, Times[-1, base`Private`theDx]], Plus[base`Private`theX, base`Private`theDx]]], Null]]

(* ::Subsubtitle:: *)
(* numbers formatting *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 36, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`roundDigits[Pattern[base`Private`z, Blank[]], Optional[Pattern[base`Private`d, Blank[]], 0.001`]], MapAt[Function[Round[Slot[1], base`Private`d]], base`Private`z, Position[Map[Function[NumericQ[Slot[1]]], base`Private`z], True]]], Null], Null, Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 37, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`numFormat[Pattern[base`Private`x, Blank[]], Optional[Pattern[base`Private`n, Blank[]], 10], Optional[Pattern[base`Private`theExp, Blank[]], 10]], NumberForm[base`Private`x, List[base`Private`n, 3], Rule[ExponentFunction, Function[If[Less[Times[-1, base`Private`theExp], Slot[1], Plus[base`Private`theExp]], Null, Slot[1]]]], Rule[NumberSigns, If[Unequal[base`Private`x, 0], List["-", "+"], List["", ""]]]]], Null], Null, CompoundExpression[SetAttributes[base`numFormat, Listable], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 38, expression 1 ---- *)
CompoundExpression[CompoundExpression[Clear[base`testNumberFormat], Null], Null, CompoundExpression[SetDelayed[base`testNumberFormat[Pattern[base`Private`x, Blank[]], Optional[Pattern[base`Private`sp, Blank[]], 8], Optional[Pattern[base`Private`dg, Blank[]], 3], Optional[Pattern[base`Private`theExp, Blank[]], 3]], If[Equal[NumericQ[base`Private`x], True], Return[base`nfpm[base`Private`x, base`Private`sp, base`Private`dg, base`Private`theExp]], Return[base`Private`x]]], Null], Null, Block[List[base`Private`x, base`Private`y, base`Private`z], If[$Notebooks, CompoundExpression[base`testNumberFormat[base`Private`eee], base`testNumberFormat[3.`], base`testNumberFormat[0], base`testNumberFormat[-3.`], base`testNumberFormat[30.`], Null]]]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 39, expression 1 ---- *)
CompoundExpression[CompoundExpression[Unprotect[base`nf, base`nfpm], Null], Null, CompoundExpression[ClearAll[base`nf, base`nfpm], Null], Null, CompoundExpression[SetDelayed[base`nf[Pattern[base`Private`x, Blank[]], Optional[Pattern[base`Private`sp, Blank[]], 8], Optional[Pattern[base`Private`dg, Blank[]], 3], Optional[Pattern[base`Private`theExp, Blank[]], 3]], NumberForm[base`Private`x, List[base`Private`sp, base`Private`dg], Rule[ExponentFunction, Function[If[Less[Times[-1, base`Private`theExp], Slot[1], Plus[base`Private`theExp]], Null, Times[3, Quotient[Slot[1], 3]]]]], Rule[NumberMultiplier, "*"]]], Null], Null, CompoundExpression[SetDelayed[base`nfpm[Pattern[base`Private`x, Blank[]], Optional[Pattern[base`Private`sp, Blank[]], 8], Optional[Pattern[base`Private`dg, Blank[]], 3], Optional[Pattern[base`Private`theExp, Blank[]], 3]], NumberForm[base`Private`x, List[base`Private`sp, base`Private`dg], Rule[ExponentFunction, Function[If[Less[Times[-1, base`Private`theExp], Slot[1], Plus[base`Private`theExp]], Null, Times[3, Quotient[Slot[1], 3]]]]], Rule[NumberMultiplier, "*"], Rule[NumberSigns, If[Unequal[base`Private`x, 0], List["-", "+"], List[" ", " "]]]]], Null], Null, CompoundExpression[SetAttributes[List[base`nf, base`nfpm], Listable], Null], Null, CompoundExpression[Protect[base`nf, base`nfpm], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 40, expression 1 ---- *)
CompoundExpression[CompoundExpression[Unprotect[base`nfl, base`nfpml], Null], Null, CompoundExpression[ClearAll[base`nfl, base`nfpml], Null], Null, CompoundExpression[SetDelayed[base`nfpml[Pattern[base`Private`x, Blank[]], Optional[Pattern[base`Private`sp, Blank[]], 8], Optional[Pattern[base`Private`dg, Blank[]], 3], Optional[Pattern[base`Private`theExp, Blank[]], 3]], If[Equal[NumericQ[base`Private`x], True], Return[base`nfpm[base`Private`x, base`Private`sp, base`Private`dg, base`Private`theExp]], Return[base`Private`x]]], Null], Null, CompoundExpression[SetDelayed[base`nfl[Pattern[base`Private`x, Blank[]], Optional[Pattern[base`Private`sp, Blank[]], 8], Optional[Pattern[base`Private`dg, Blank[]], 3], Optional[Pattern[base`Private`theExp, Blank[]], 3]], If[Equal[NumericQ[base`Private`x], True], Return[base`nf[base`Private`x, base`Private`sp, base`Private`dg, base`Private`theExp]], Return[base`Private`x]]], Null], Null, CompoundExpression[SetAttributes[List[base`nfl, base`nfpml], Listable], Null], Null, CompoundExpression[Protect[base`nfl, base`nfpml], Null], Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 41, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`numFormatPad[Pattern[base`Private`x, Blank[]], Optional[Pattern[base`Private`n, Blank[]], 10], Optional[Pattern[base`Private`theExp, Blank[]], 10]], PaddedForm[base`Private`x, List[base`Private`n, 3], Rule[ExponentFunction, Function[If[Less[Times[-1, base`Private`theExp], Slot[1], Plus[base`Private`theExp]], Null, Slot[1]]]], Rule[NumberSigns, If[Unequal[base`Private`x, 0], List["-", "+"], List[" ", " "]]]]], Null], Null, CompoundExpression[SetDelayed[base`nfPad[Pattern[base`Private`x, Blank[]], Optional[Pattern[base`Private`sp, Blank[]], 8], Optional[Pattern[base`Private`dg, Blank[]], 3], Optional[Pattern[base`Private`theExp, Blank[]], 3]], PaddedForm[base`Private`x, List[base`Private`sp, base`Private`dg], Rule[ExponentFunction, Function[If[Less[Times[-1, base`Private`theExp], Slot[1], Plus[base`Private`theExp]], Null, Times[3, Quotient[Slot[1], 3]]]]], Rule[NumberMultiplier, "*"]]], Null], Null, CompoundExpression[SetDelayed[base`nfpmPad[Pattern[base`Private`x, Blank[]], Optional[Pattern[base`Private`sp, Blank[]], 8], Optional[Pattern[base`Private`dg, Blank[]], 3], Optional[Pattern[base`Private`theExp, Blank[]], 3]], PaddedForm[base`Private`x, List[base`Private`sp, base`Private`dg], Rule[ExponentFunction, Function[If[Less[Times[-1, base`Private`theExp], Slot[1], Plus[base`Private`theExp]], Null, Times[3, Quotient[Slot[1], 3]]]]], Rule[NumberMultiplier, "*"], Rule[NumberSigns, If[Unequal[base`Private`x, 0], List["-", "+"], List[" ", " "]]]]], Null], Null, CompoundExpression[SetAttributes[base`numFormatPad, Listable], Null], Null, CompoundExpression[SetAttributes[base`nfPad, Listable], Null], Null, CompoundExpression[SetAttributes[base`nfpmPad, Listable], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 42, expression 1 ---- *)
CompoundExpression[CompoundExpression[Unprotect[base`nnffpm, base`nnff], Null], Null, CompoundExpression[ClearAll[base`nnff, base`nnffpm], Null], Null, CompoundExpression[SetDelayed[base`nnff[Pattern[base`Private`x, Blank[]], Optional[Pattern[base`Private`sp, Blank[]], Infinity], Optional[Pattern[base`Private`dg, Blank[]], 3], Optional[Pattern[base`Private`theExpStep, Blank[]], 3], Optional[Pattern[base`Private`theExpThrMin, Blank[]], 3]], NumberForm[base`Private`x, List[base`Private`sp, base`Private`dg], Rule[ScientificNotationThreshold, List[Times[-1, base`Private`theExpThrMin], 6]], Rule[ExponentFunction, Function[If[Less[Times[-1, base`Private`theExpThrMin], Slot[1], Plus[base`Private`theExpThrMin]], Null, Times[base`Private`theExpStep, Quotient[Slot[1], base`Private`theExpStep]]]]], Rule[NumberMultiplier, "*"]]], Null], Null, CompoundExpression[SetDelayed[base`nnffpm[Pattern[base`Private`x, Blank[]], Optional[Pattern[base`Private`sp, Blank[]], Infinity], Optional[Pattern[base`Private`dg, Blank[]], 3], Optional[Pattern[base`Private`theExpStep, Blank[]], 3], Optional[Pattern[base`Private`theExpThrMin, Blank[]], 3]], NumberForm[base`Private`x, List[base`Private`sp, base`Private`dg], Rule[ScientificNotationThreshold, List[Times[-1, base`Private`theExpThrMin], 6]], Rule[ExponentFunction, Function[If[Less[Times[-1, base`Private`theExpThrMin], Slot[1], Plus[base`Private`theExpThrMin]], Null, Times[base`Private`theExpStep, Quotient[Slot[1], base`Private`theExpStep]]]]], Rule[NumberMultiplier, "*"], Rule[NumberSigns, If[Unequal[QuantityMagnitude[base`Private`x], 0], List["-", "+"], List["", ""]]]]], Null], Null, CompoundExpression[SetAttributes[List[base`nnff, base`nnffpm], Listable], Null], Null, CompoundExpression[Protect[base`nnff, base`nnffpm], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 43, expression 1 ---- *)
CompoundExpression[CompoundExpression[Unprotect[base`nf0, base`nf1, base`nf2, base`nf3, base`nf4, base`nf5, base`nf6, base`nfpm0, base`nfpm1, base`nfpm2, base`nfpm3, base`nfpm4, base`nfpm5, base`nfpm6, base`nfl0, base`nfl1, base`nfl2, base`nfl3, base`nfpml0, base`nfpml1, base`nfpml2, base`nfpml3], Null], Null, CompoundExpression[ClearAll[base`nf0, base`nf1, base`nf2, base`nf3, base`nf4, base`nf5, base`nf6, base`nfpm0, base`nfpm1, base`nfpm2, base`nfpm3, base`nfpm4, base`nfpm5, base`nfpm6, base`nfl0, base`nfl1, base`nfl2, base`nfl3, base`nfpml0, base`nfpml1, base`nfpml2, base`nfpml3], Null], Null, CompoundExpression[SetDelayed[base`nf0[Pattern[base`Private`x, Blank[]]], base`nf[base`Private`x, 10, 0, 99]], Null], Null, CompoundExpression[SetDelayed[base`nf1[Pattern[base`Private`x, Blank[]]], base`nf[base`Private`x, 10, 1, 99]], Null], Null, CompoundExpression[SetDelayed[base`nf2[Pattern[base`Private`x, Blank[]]], base`nf[base`Private`x, 10, 2, 99]], Null], Null, CompoundExpression[SetDelayed[base`nf3[Pattern[base`Private`x, Blank[]]], base`nf[base`Private`x, 10, 3, 99]], Null], Null, CompoundExpression[SetDelayed[base`nf4[Pattern[base`Private`x, Blank[]]], base`nf[base`Private`x, 10, 4, 99]], Null], Null, CompoundExpression[SetDelayed[base`nf5[Pattern[base`Private`x, Blank[]]], base`nf[base`Private`x, 10, 5, 99]], Null], Null, CompoundExpression[SetDelayed[base`nf6[Pattern[base`Private`x, Blank[]]], base`nf[base`Private`x, 10, 6, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfpm0[Pattern[base`Private`x, Blank[]]], base`nfpm[base`Private`x, 10, 0, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfpm1[Pattern[base`Private`x, Blank[]]], base`nfpm[base`Private`x, 10, 1, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfpm2[Pattern[base`Private`x, Blank[]]], base`nfpm[base`Private`x, 10, 2, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfpm3[Pattern[base`Private`x, Blank[]]], base`nfpm[base`Private`x, 10, 3, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfpm4[Pattern[base`Private`x, Blank[]]], base`nfpm[base`Private`x, 10, 4, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfpm5[Pattern[base`Private`x, Blank[]]], base`nfpm[base`Private`x, 10, 5, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfpm6[Pattern[base`Private`x, Blank[]]], base`nfpm[base`Private`x, 10, 6, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfl0[Pattern[base`Private`x, Blank[]]], base`nfl[base`Private`x, 10, 0, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfl1[Pattern[base`Private`x, Blank[]]], base`nfl[base`Private`x, 10, 1, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfl2[Pattern[base`Private`x, Blank[]]], base`nfl[base`Private`x, 10, 2, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfl3[Pattern[base`Private`x, Blank[]]], base`nfl[base`Private`x, 10, 3, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfpml0[Pattern[base`Private`x, Blank[]]], base`nfpml[base`Private`x, 10, 0, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfpml1[Pattern[base`Private`x, Blank[]]], base`nfpml[base`Private`x, 10, 1, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfpml2[Pattern[base`Private`x, Blank[]]], base`nfpml[base`Private`x, 10, 2, 99]], Null], Null, CompoundExpression[SetDelayed[base`nfpml3[Pattern[base`Private`x, Blank[]]], base`nfpml[base`Private`x, 10, 3, 99]], Null], Null, CompoundExpression[SetAttributes[List[base`nf0, base`nf1, base`nf2, base`nf3, base`nf4, base`nf5, base`nf6, base`nfl0, base`nfl1, base`nfl2, base`nfl3], Listable], Null], Null, CompoundExpression[SetAttributes[List[base`nfpm0, base`nfpm1, base`nfpm2, base`nfpm3, base`nfpm4, base`nfpm5, base`nfpm6, base`nfpml0, base`nfpml1, base`nfpml2, base`nfpml3], Listable], Null], Null, CompoundExpression[Protect[base`nf0, base`nf1, base`nf2, base`nf3, base`nf4, base`nf5, base`nf6, base`nfpm0, base`nfpm1, base`nfpm2, base`nfpm3, base`nfpm4, base`nfpm5, base`nfpm6, base`nfl0, base`nfl1, base`nfl2, base`nfl3, base`nfpml0, base`nfpml1, base`nfpml2, base`nfpml3], Null]]

(* ::Subsubtitle:: *)
(* vector/matrix/tensor operations *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 44, expression 1 ---- *)
CompoundExpression[CompoundExpression[Unprotect[base`dropFirst], Null], Null, CompoundExpression[ClearAll[base`dropFirst], Null], Null, CompoundExpression[SetDelayed[base`dropFirst[Pattern[base`Private`x, Blank[]]], Drop[base`Private`x, 1]], Null], Null, CompoundExpression[Protect[base`dropFirst], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 45, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`insertCol[Pattern[base`Private`a, Blank[]], Pattern[base`Private`b, Blank[]], Pattern[base`Private`n, Blank[]]], Join[Part[base`Private`a, Span[1, All], Span[1, Plus[base`Private`n, -1]]], base`Private`b, Part[base`Private`a, Span[1, All], Span[base`Private`n, All]], 2]], Null], Null, CompoundExpression[SetDelayed[base`insertRow[Pattern[base`Private`a, Blank[]], Pattern[base`Private`b, Blank[]], Pattern[base`Private`n, Blank[]]], Join[Part[base`Private`a, Span[1, Plus[base`Private`n, -1]]], base`Private`b, Part[base`Private`a, Span[base`Private`n, All]]]], Null], Null, CompoundExpression[SetDelayed[base`sumRow[Pattern[base`Private`mat, Blank[]], Pattern[base`Private`iRow, Blank[]]], Module[List[], CompoundExpression[Return[Total[Part[base`Private`mat, base`Private`iRow, All]]], Null]]], Null], Null, CompoundExpression[SetDelayed[base`sumCol[Pattern[base`Private`mat, Blank[]], Pattern[base`Private`iCol, Blank[]]], Module[List[], CompoundExpression[Return[Total[Part[base`Private`mat, All, base`Private`iCol]]], Null]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 46, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`vLookup[Pattern[base`lookupVal, Blank[]], Pattern[base`Private`targetTable, Blank[]], Pattern[base`Private`targetCol, Blank[]], Pattern[base`Private`pickCol, Blank[]]], Module[List[base`Private`rowMatch, base`Private`matchVal, base`Private`allMatchedValues, base`Private`numMatches, base`Private`jdMatchVal, base`Private`jdNumMatch, base`Private`jdAllMatchVal, base`Private`jdRowMatch], CompoundExpression[Set[base`Private`jdMatchVal, 1], Set[base`Private`jdNumMatch, 2], Set[base`Private`jdAllMatchVal, 3], Set[base`Private`jdRowMatch, 4], base`debugPrint[" vLookup returns: { matchVal , numMatches , allMatchedValues , rowMatch } "], Set[base`Private`rowMatch, Flatten[Position[Part[base`Private`targetTable, All, base`Private`targetCol], Condition[Pattern[base`Private`n, Blank[]], Equal[base`Private`n, base`lookupVal]]]]], If[Equal[Length[base`Private`rowMatch], 0], Return[List[List["n/a"], 0]], CompoundExpression[Set[base`Private`matchVal, Part[base`Private`targetTable, base`Private`rowMatch, Plus[base`Private`targetCol, base`Private`pickCol]]], Set[base`Private`numMatches, Length[base`Private`matchVal]], Set[base`Private`allMatchedValues, base`Private`matchVal], Set[base`Private`matchVal, DeleteDuplicates[base`Private`matchVal]], Return[List[base`Private`matchVal, base`Private`numMatches, base`Private`allMatchedValues, base`Private`rowMatch]], Null]]]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 47, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`vSum[Pattern[base`lookupVal, Blank[]], Pattern[base`Private`targetTable, Blank[]], Pattern[base`Private`targetCol, Blank[]], Pattern[base`Private`pickCol, Blank[]]], Module[List[base`Private`rowMatch, base`Private`sum], CompoundExpression[Set[base`Private`rowMatch, Position[Part[base`Private`targetTable, All, base`Private`targetCol], Condition[Pattern[base`Private`n, Blank[]], Equal[base`Private`n, base`lookupVal]]]], If[Equal[Length[base`Private`rowMatch], 0], CompoundExpression[Return[0.`], Null], CompoundExpression[Set[base`Private`sum, Total[Part[base`Private`targetTable, Flatten[base`Private`rowMatch], Plus[base`Private`targetCol, base`Private`pickCol]]]], Null]], Return[base`Private`sum]]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 48, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`numRow[Pattern[base`Private`a, Blank[]]], If[Equal[Length[Dimensions[base`Private`a]], 2], First[Dimensions[base`Private`a]], "Not a 2x2 array"]], Null], Null, CompoundExpression[SetDelayed[base`numCol[Pattern[base`Private`a, Blank[]]], If[Equal[Length[Dimensions[base`Private`a]], 2], Last[Dimensions[base`Private`a]], "Not a 2x2 array"]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 49, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`partialSumToEnd[Pattern[base`Private`v, Blank[List]], Optional[Pattern[base`Private`startCol, Blank[]], 2]], Map[Total, Part[base`Private`v, All, Span[base`Private`startCol, All]]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 50, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`matrixInfo[Pattern[base`Private`x, BlankSequence[]]], Module[List[base`Private`res], CompoundExpression[Set[base`Private`res, List[Dimensions[base`Private`x], ArrayQ[base`Private`x], ArrayDepth[base`Private`x]]], Print[" matrixInfo : ", base`Private`res], Return[base`Private`res]]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 51, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`takeFirstRow[Pattern[base`Private`matrix, Blank[]]], First[base`Private`matrix]], Null], Null, CompoundExpression[SetDelayed[base`takeFirstCol[Pattern[base`Private`matrix, Blank[]]], First[Transpose[base`Private`matrix]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 52, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`matrixCore[Pattern[base`Private`matrix, Blank[]]], Part[base`Private`matrix, Span[2, All], Span[2, All]]], Null], Null, CompoundExpression[SetDelayed[base`rll[Pattern[base`Private`ll, Blank[]], Pattern[base`Private`elem, Blank[]]], Part[base`Private`ll, Ordering[Part[base`Private`ll, base`Private`elem, All]]]], Null], Null, CompoundExpression[SetDelayed[base`sll[Pattern[base`Private`ll, Blank[]], Pattern[base`Private`elem, Blank[]]], Part[base`Private`ll, Ordering[Part[base`Private`ll, All, base`Private`elem]]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 53, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`sortMatrixRows[Pattern[base`Private`matrix, Blank[]], Pattern[base`numCol, Blank[]]], Module[List[], Transpose[Prepend[Transpose[Prepend[base`sll[base`matrixCore[base`Private`matrix], base`numCol], Part[base`takeFirstRow[base`Private`matrix], Span[2, All]]]], Prepend[Part[Rest[base`takeFirstCol[base`Private`matrix]], Ordering[Part[base`matrixCore[base`Private`matrix], All, base`numCol]]], "\\"]]]]], Null], Null, CompoundExpression[SetDelayed[base`sortMatrixCols[Pattern[base`Private`matrix, Blank[]], Pattern[base`numRow, Blank[]]], Transpose[base`sortMatrixRows[Transpose[base`Private`matrix], base`numRow]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 54, expression 1 ---- *)
CompoundExpression[Times[ClearAll[base`sortByColumn], CompoundExpression[Set[MessageName[base`sortByColumn, "usage"], "Arguments: [Table, Direction, Priority]. \nReturns the list sorted by the directions for each column specified in `Direction`. \nFor ascending order, use `1`, and for descending order, use `-1`. \nFor sorting more than one column, input `Direction` as a list. For example, Direction={-1,1} will sort the first column in descending order followed by the second column in ascending order, ignoring any other column. To sort on the second column, use {0,1} for the syntax.\nWhen sorting two or more columns, you can provide the `Priority` for which column should be sorted first. For example, `sortByColumn[data,{-1,1},{1,2}]`\nwould sort first in ascending order on the second column (because it has a higher priority) and then in descending order on the first column."], Null], CompoundExpression[SetDelayed[base`sortByColumn[PatternTest[Pattern[base`Private`list, Blank[]], MatrixQ], Pattern[base`Private`dir, Alternatives[Blank[Integer], List[BlankSequence[Integer]]]], Optional[Pattern[base`Private`priority, Blank[]], List[]]], Module[List[Set[base`Private`l, Length[Part[base`Private`list, 1, All]]], base`Private`w, base`Private`p, base`Private`d], CompoundExpression[Set[base`Private`w, Reverse[Range[base`Private`l]]], Set[base`Private`p, If[Greater[Length[base`Private`priority], 0], PadRight[Flatten[List[base`Private`priority]], base`Private`l], Set[base`Private`p, Range[base`Private`l]]]], Set[base`Private`w, Part[base`Private`w, Ordering[base`Private`p]]], Set[base`Private`d, PadRight[Flatten[List[base`Private`dir]], base`Private`l]], Sort[base`Private`list, Function[NonNegative[Total[Times[base`Private`w, base`Private`d, MapThread[Order, List[SlotSequence[1]]]]]]]]]]], Null]]]

(* ::Subtitle:: *)
(* text *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 55, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`cleanText[Pattern[base`Private`text, Blank[]], Optional[Pattern[base`Private`outChar, Blank[]], ""]], Module[List[base`Private`name, base`Private`test, base`toClean], CompoundExpression[Set[base`toClean, List[Rule[Whitespace, base`Private`outChar], Rule[PunctuationCharacter, base`Private`outChar], Rule[" ", base`Private`outChar], Rule["\[NonBreakingSpace]", base`Private`outChar], Rule["'", base`Private`outChar], Rule["-", base`Private`outChar], Rule["(", base`Private`outChar], Rule[")", base`Private`outChar]]], Set[base`Private`name, StringTrim[RemoveDiacritics[base`Private`text]]], Set[base`Private`name, StringReplace[base`Private`name, base`toClean]], Set[base`Private`test, Extract[base`Private`name, Position[Map[LetterQ, base`Private`name], False]]], If[Equal[base`Private`test, List[]], base`debugPrint[" Cleanup OK "], base`debugPrint[" we have a problem cleaning-up text ", base`Private`test]], Return[base`Private`name]]]], Null], Null, CompoundExpression[SetDelayed[base`normalizeString[Pattern[base`Private`w, Blank[]]], base`cleanText[Capitalize[ToLowerCase[base`cleanText[base`Private`w, " "]], "AllWords"], ""]], Null]]

(* ::Subtitle:: *)
(* MISCELLANEA // TO BE SORTED *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 56, expression 1 ---- *)
CompoundExpression[CompoundExpression[If[$Notebooks, CompoundExpression[base`Private`RefLink[TextCell[RawBoxes["Green"]], Pattern[base`Private`paclet, Times[base`Private`ref, Power[Green, -1]]]], base`Private`RefLink[TextCell[RawBoxes["Blue"]], Pattern[base`Private`paclet, Times[base`Private`ref, Power[Blue, -1]]]], base`Private`RefLink[TextCell[RawBoxes["Black"]], Pattern[base`Private`paclet, Times[base`Private`ref, Power[Black, -1]]]], base`Private`RefLink[TextCell[RawBoxes["White"]], Pattern[base`Private`paclet, Times[base`Private`ref, Power[White, -1]]]], base`Private`RefLink[TextCell[RawBoxes["Gray"]], Pattern[base`Private`paclet, Times[base`Private`ref, Power[Gray, -1]]]], base`Private`RefLink[TextCell[RawBoxes["Cyan"]], Pattern[base`Private`paclet, Times[base`Private`ref, Power[Cyan, -1]]]], base`Private`RefLink[TextCell[RawBoxes["Magenta"]], Pattern[base`Private`paclet, Times[base`Private`ref, Power[Magenta, -1]]]], base`Private`RefLink[TextCell[RawBoxes["Yellow"]], Pattern[base`Private`paclet, Times[base`Private`ref, Power[Yellow, -1]]]], base`Private`RefLink[TextCell[RawBoxes["Brown"]], Pattern[base`Private`paclet, Times[base`Private`ref, Power[Brown, -1]]]], base`Private`RefLink[TextCell[RawBoxes["Orange"]], Pattern[base`Private`paclet, Times[base`Private`ref, Power[Orange, -1]]]], base`Private`RefLink[TextCell[RawBoxes["Pink"]], Pattern[base`Private`paclet, Times[base`Private`ref, Power[Pink, -1]]]], base`Private`RefLink[TextCell[RawBoxes["Purple"]], Pattern[base`Private`paclet, Times[base`Private`ref, Power[Purple, -1]]]]]], Null]]

(* ::Subtitle:: *)
(* BaseNew - latest additions TO DOUBLE CHECK *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 57, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetDelayed[base`searchForGivenNames[Pattern[base`Private`x, Blank[]]], Names[ToString[base`Private`x]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 58, expression 1 ---- *)
CompoundExpression[Set[base`searchForGivenNamesAndPrint, Function[TableForm[Transpose[List[base`searchForGivenNames[Slot[1]], ToExpression[base`searchForGivenNames[Slot[1]]]]]]]]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 59, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 60, expression 1 ---- *)
CompoundExpression[SetDelayed[base`searchForGivenNamesRegExp[Pattern[base`Private`x, Blank[String]]], Names[RegularExpression[StringJoin["(?i).*", base`Private`x, ".*"]]]], Null, Set[base`Private`searchForGivenNamesAndPrintRegExp, Function[TableForm[Transpose[List[base`searchForGivenNamesRegExp[Slot[1]], Evaluate[ToExpression[base`searchForGivenNamesRegExp[Slot[1]]]]]]]]]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 61, expression 1 ---- *)
CompoundExpression[base`searchForGivenNamesRegExp["base`.*Tag"], Null, base`searchForGivenNamesRegExp["rich`.*Tag"]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 62, expression 1 ---- *)
CompoundExpression[base`Private`searchForGivenNamesAndPrintRegExp["rich`.*tag"], Null, base`Private`searchForGivenNamesAndPrintRegExp["base`.*tag"]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 63, expression 1 ---- *)
CompoundExpression[base`Private`searchForGivenNamesAndPrintRegExp["title"], Null, base`Private`searchForGivenNamesAndPrintRegExp["inset"]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 64, expression 1 ---- *)
CompoundExpression[Names[RegularExpression["System`....."]]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 65, expression 1 ---- *)
CompoundExpression[Null]

(* ::Subtitle:: *)
(* END PACKAGE *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 66, expression 1 ---- *)
CompoundExpression[CompoundExpression[Print["*==================================================================================================*"], Null], Null, CompoundExpression[Print["*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*"], Null], Null, CompoundExpression[Print["***---                  END base                                                                       ---***"], Null], Null, CompoundExpression[Print["*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*"], Null], Null, CompoundExpression[Print["*==================================================================================================*"], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 67, expression 1 ---- *)
CompoundExpression[End[], Null, EndPackage[]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 68, expression 1 ---- *)
CompoundExpression[CompoundExpression[If[$Notebooks, Cells[Rule[CellStyle, List["MSG", "Message"]]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 69, expression 1 ---- *)
CompoundExpression[Times[myNotebookInit`checkNewCreatedSymbols[], myNotebookInit`showContextInfo[]]]