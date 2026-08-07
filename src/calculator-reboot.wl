(* ::Package:: *)

(* Regenerated from calculator-reboot.nb using NotebookImport without a text conversion. *)
(* Each source cell was imported under HoldComplete, serialized in context-preserving FullForm, and syntax-checked without evaluation. *)

(* ::Title:: *)
(* ---... SETUP *)

(* ::Subtitle:: *)
(* PREAMBLE *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 1, expression 1 ---- *)
CompoundExpression[CompoundExpression[Set[Global`$trackedContext, $Context], Null], Null, CompoundExpression[Set[Global`$trackedPath, $ContextPath], Null], Null, CompoundExpression[Set[$Post, Function[Global`expr, CompoundExpression[If[UnsameQ[$Context, Global`$trackedContext], CompoundExpression[Print["Changed Context to: ", $Context], Set[Global`$trackedContext, $Context]]], If[UnsameQ[$ContextPath, Global`$trackedPath], CompoundExpression[Print["Changed ContextPath to: ", $ContextPath], Set[Global`$trackedPath, $ContextPath]]], Global`expr]]], Null]]

(* ::Subtitle:: *)
(* COMMON NOTEBOOK SETUP *)

(* ::Subsubtitle:: *)
(* bootstrap *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 2, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 3, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 4, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 5, expression 1 ---- *)
CompoundExpression[Times[CompoundExpression[Module[List[Global`dir, Global`pkg], CompoundExpression[Set[Global`dir, Quiet[NotebookDirectory[]]], If[Not[StringQ[Global`dir]], Set[Global`dir, $HomeDirectory]], Set[Global`pkg, FileNameJoin[List[Global`dir, "myNotebookInit.wl"]]], If[Not[FileExistsQ[Global`pkg]], CompoundExpression[MessageDialog[StringJoin["Missing myNotebookInit.wl at:\n", Global`pkg]], Return[$Failed], Null]], Get[Global`pkg], Print[Column[List[Button["Save a versioned copy", myNotebookInit`saveVersionedCopy[myNotebookInit`versionTAG, NotebookDirectory[]], Rule[Method, "Queued"]], Button["Save a txt copy", With[List[Set[Global`out, myNotebookInit`saveNotebookTextCopy[]]], If[StringQ[Global`out], Print["Saved: ", Global`out]]], Rule[Method, "Queued"]], Button["List init code (prints)", Map[Print, myNotebookInit`listInitializationCells[]], Rule[Method, "Queued"]], Button["Highlight init cells", myNotebookInit`selectInitializationCells[], Rule[Method, "Queued"]], Button["Mark ALL Input cells as initialization", myNotebookInit`markInputCellsAsInitialization[True], Rule[Method, "Queued"]], Button["Clear initialization on Input cells", myNotebookInit`markInputCellsAsInitialization[False], Rule[Method, "Queued"]], Button["Delete all empty cells", myNotebookInit`deleteAllEmptyCellsInNotebook, Rule[Method, "Queued"]], Button["Export all Output cells to PNG (notebook dir)", myNotebookInit`saveAsPngAllOutputCells[], Rule[Method, "Queued"]], Button["Export all Output cells to PDF (notebook dir)", myNotebookInit`saveAsPdfAllOutputCells[], Rule[Method, "Queued"]], Button["Show diagnostics", myNotebookInit`showDiagnostics[], Rule[Method, "Queued"]], Button["Show error message cells", Print[Cells[Rule[CellStyle, List["MSG", "Message"]]]], Rule[Method, "Preemptive"]]]]]]], Null], CompoundExpression[myNotebookInit`manageMyStyleNotebook[], Null]]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 6, expression 1 ---- *)
CompoundExpression[CompoundExpression[myNotebookInit`clearLoadLog[], Null], Null, CompoundExpression[myNotebookInit`summarizeLoads[], Null], Null, CompoundExpression[myNotebookInit`saveLoadLog[], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 7, expression 1 ---- *)
CompoundExpression[CompoundExpression[myNotebookInit`loadSavedLog[], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 8, expression 1 ---- *)
CompoundExpression[If[TrueQ[Global`$RICHProjectManagedLoad], Null, myNotebookInit`loadMyFile["myDockedCells.wl", DirectoryName[$InputFileName]]]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 9, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 10, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 11, expression 1 ---- *)
CompoundExpression[CompoundExpression[myNotebookInit`checkProtection[List[Global`$dirBackup, Global`$dirSWRoot, Global`$dirSW, Global`$dirOut]], Null], Null, myNotebookInit`setProtection[List[Global`$dirBackup, Global`$dirSWRoot, Global`$dirSW, Global`$dirOut], False], Null, ClearAll[Global`$dirBackup, Global`$dirSWRoot, Global`$dirSW, Global`$dirOut], Null, CompoundExpression[Set[Global`$dirBackup, "C:\\Users\\Ale\\My Drive\\Mathematica"], Null], Null, CompoundExpression[Set[Global`$dirSWRoot, "D:\\Users\\Ale\\Mathematica"], Null], Null, CompoundExpression[Set[Global`$dirSW, ""], Null], Null, CompoundExpression[Set[Global`$dirOut, "C:\\TEMP\\"], Null], Null, CompoundExpression[myNotebookInit`setProtection[List[Global`$dirBackup, Global`$dirSWRoot, Global`$dirSW, Global`$dirOut], True], Null]]

(* ::Subsubtitle:: *)
(* BASE OPTIONS *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 12, expression 1 ---- *)
CompoundExpression[If[TrueQ[Global`$RICHProjectManagedLoad], Null, myNotebookInit`loadMyFile["CellStyleDataRules.wl", DirectoryName[$InputFileName]]]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 13, expression 1 ---- *)
CompoundExpression[Times[CompoundExpression[myNotebookInit`printD[myNotebookInit`nb[]], Null], CompoundExpression[myNotebookInit`printD[myNotebookInit`nbFileName], Null], CompoundExpression[myNotebookInit`printD[myNotebookInit`nbFileDirectory], Null], CompoundExpression[myNotebookInit`printD[myNotebookInit`nbFileBaseName], Null]]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 14, expression 1 ---- *)
CompoundExpression[CompoundExpression[Set[$HistoryLength, 100], Null], Null, CompoundExpression[SetOptions[EvaluationNotebook[], Rule[Background, LightGreen]], Null], Null, CompoundExpression[SetOptions[EvaluationNotebook[], Rule[Magnification, Times[3, Power[4, -1]]]], Null], Null, CompoundExpression[SetOptions[EvaluationNotebook[], Rule[WindowMargins, List[List[0, Automatic], List[Automatic, 0]]]], Null], Null, CompoundExpression[SetOptions[EvaluationNotebook[], Rule[WindowSize, List[Scaled[Times[3, Power[4, -1]]], Scaled[1.`]]]], Null], Null, CompoundExpression[SetOptions[EvaluationNotebook[], Rule[WindowTitle, StringJoin[" ------- ", myNotebookInit`nbFileName]]], Null], Null, CompoundExpression[SetOptions[EvaluationNotebook[], Rule[StyleDefinitions, If[StringQ[Global`$RICHProjectStyleDefinitions], Global`$RICHProjectStyleDefinitions, "myStyle.nb"]]], Null]]

(* ::Subsubtitle:: *)
(* DETECT AND LOG SOME PROPERTIES OF THIS NOTEBOOK *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 15, expression 1 ---- *)
CompoundExpression[Times[CompoundExpression[If[Greater[Length[Cells[Rule[CellStyle, "Output"]]], 0], CompoundExpression[Echo[Cells[Rule[CellStyle, "Output"]]], Print["Length@Cells[CellStyle->Output]  ", Length[Cells[Rule[CellStyle, "Output"]]]]]], Null], CompoundExpression[If[Greater[Length[Cells[Rule[CellStyle, "Print"]]], 0], CompoundExpression[Echo[Cells[Rule[CellStyle, "Print"]]], Print["Length@Cells[CellStyle->Print]  ", Length[Cells[Rule[CellStyle, "Print"]]]]]], Null]]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 16, expression 1 ---- *)
CompoundExpression[Times[CompoundExpression[Print["Length@Cells[CellStyle -> Title                ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[Rule[CellStyle, "Title"]]]]], Null], CompoundExpression[Print["Length@Cells[CellStyle -> Subtitle             ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[Rule[CellStyle, "Subtitle"]]]]], Null], CompoundExpression[Print["Length@Cells[CellStyle -> Subsubtitle          ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[Rule[CellStyle, "Subsubtitle"]]]]], Null], CompoundExpression[Print["Length@Cells[CellStyle -> Section              ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[Rule[CellStyle, "Section"]]]]], Null], CompoundExpression[Print["Length@Cells[CellStyle -> Subsection           ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[Rule[CellStyle, "Subsection"]]]]], Null], CompoundExpression[Print["Length@Cells[CellStyle -> Subsubsection        ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[Rule[CellStyle, "Subsubsection"]]]]], Null], CompoundExpression[Print["Length@Cells[CellStyle -> Input                ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[Rule[CellStyle, "Input"]]]]], Null], CompoundExpression[Print["Length@Cells[CellStyle -> Text                 ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[Rule[CellStyle, "Text"]]]]], Null], CompoundExpression[Print["Length@Cells[CellStyle -> ExampleText          ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[Rule[CellStyle, "ExampleText"]]]]], Null], CompoundExpression[Print["Length@Cells[CellStyle -> Code                 ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[Rule[CellStyle, "Code"]]]]], Null], CompoundExpression[Print["Length@Cells[CellStyle -> Output                           ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[Rule[CellStyle, "Output"]]]]], Null], CompoundExpression[Print["Length@Cells[CellStyle -> Print                            ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[Rule[CellStyle, "Print"]]]]], Null], CompoundExpression[Print["Length@Cells[CellStyle -> Message                          ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[Rule[CellStyle, "Message"]]]]], Null], CompoundExpression[Print["Length@Cells[CellStyle -> MSG                              ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[Rule[CellStyle, "MSG"]]]]], Null], CompoundExpression[Print["                       Total Number of Cells ->                                    ", Function[PaddedForm[Slot[1], List[3, 4]]][Length[Cells[]]]], Null]]]

(* ::Subsubtitle:: *)
(* END *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 17, expression 1 ---- *)
CompoundExpression[CompoundExpression[Print["*==================================================================================================*"], Null], Null, CompoundExpression[Print["*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*"], Null], Null, CompoundExpression[Print["***--- calculator ---***"], Null], Null, CompoundExpression[Print["*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*"], Null], Null, CompoundExpression[Print["*==================================================================================================*"], Null]]

(* ::Subtitle:: *)
(* THIS NOTEBOOK INITIALIZATION *)

(* ::Subsubtitle:: *)
(* INIT *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 18, expression 1 ---- *)
CompoundExpression[CompoundExpression[Print[" ************************************************************************************************* "], Null], Null, CompoundExpression[Print[" Start running  ", Set[Global`theTimeStamp, myNotebookInit`timeStamp]], Null], Null, CompoundExpression[Print[" t0=AbsoluteTime[]   ", Set[Global`t0, AbsoluteTime[]]], Null], Null, CompoundExpression[Print[" ************************************************************************************************* "], Null], Null, SetDelayed[Global`thisTimeStamp, StringJoin[Global`theTimeStamp, "--", ToString[Round[Times[1000000, Plus[1000000, Plus[AbsoluteTime[], Times[-1, Global`t0]]]]]]]]]

(* ::Subsubtitle:: *)
(* MY LIBRARIES *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 19, expression 1 ---- *)
CompoundExpression[Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 20, expression 1 ---- *)
CompoundExpression[Times[myNotebookInit`checkNewCreatedSymbols[], If[TrueQ[Global`$RICHProjectManagedLoad], Null, myNotebookInit`loadMyFile["RICH.wl", DirectoryName[$InputFileName]]], myNotebookInit`checkNewCreatedSymbols[]]]

(* ::Subsubtitle:: *)
(* stuff specific to this notebook *)

(* ::Section:: *)
(* functions *)

(* ::Section:: *)
(* mathematica options *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 21, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetOptions[List[LogPlot, Plot, Graphics, ListPlot, Histogram], Rule[Ticks, List[Automatic, Automatic]]], Null], Null, CompoundExpression[SetOptions[List[LogPlot, Plot, Graphics, ListPlot, Histogram], Rule[AxesOrigin, List[0, 0]]], Null], Null, CompoundExpression[SetOptions[List[LogPlot, Plot, ListPlot, Histogram], Rule[Frame, True]], Null], Null, CompoundExpression[SetOptions[List[Graphics], Rule[AspectRatio, Automatic]], Null], Null, CompoundExpression[SetOptions[TableForm, Rule[TableAlignments, Center]], Null]]

(* ::Subsubtitle:: *)
(* loading other packages *)

(* ::Section:: *)
(* authorTools *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 22, expression 1 ---- *)
CompoundExpression[Null]

(* ::Subtitle:: *)
(* END ALL SETUP *)

(* ::Subsubtitle:: *)
(* END *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 23, expression 1 ---- *)
CompoundExpression[myNotebookInit`bigBanner[" FINISHING INITIALIZATION "]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 24, expression 1 ---- *)
CompoundExpression[myNotebookInit`endEvalPrintOut[]]

(* ::Title:: *)
(* ---... CALCULATOR INIT *)

(* ::Subtitle:: *)
(* >>> INIT FAKE PACKAGE *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 25, expression 1 ---- *)
CompoundExpression[BeginPackage["calculator`", List["myNotebookInit`", "base`", "statDataAnal`", "rich`"]], Null, Print[" loading calculator "], Null, Begin["`Private`"], Null, myNotebookInit`showContextInfo[], Null, CompoundExpression[Set[myNotebookInit`versionTAG, "v.15-03-2026"], Null], Null, End[], Null, myNotebookInit`showContextInfo[], Null, Print[Cells[Rule[CellStyle, List["MSG", "Message"]]]], Null, EndPackage[]]

(* ::Subtitle:: *)
(* <<< END FAKE PACKAGE *)

(* ::Subtitle:: *)
(* DEFINITIONS FOR THIS NOTEBOOK *)

(* ::Section:: *)
(* symbolics for variables to use in this notebook *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 26, expression 1 ---- *)
CompoundExpression[myNotebookInit`checkNewCreatedSymbols[], Null, CompoundExpression[Set[Notation`AutoLoadNotationPalette, False], Null], Null, CompoundExpression[myNotebookInit`loadNeeds["Notation`"], Null], Null, CompoundExpression[Off[MessageName[Notation`Symbolize, "bsymbexs"]], Null], Null, Global`ClearNotations[], Null, Global`Symbolize[Global`NotationTemplateTag[Subscript[Global`n, Global`s]]], Null, Global`Symbolize[Global`NotationTemplateTag[Subscript[Global`n, Global`\[Sigma]]]], Null, Global`Symbolize[Global`NotationTemplateTag[Subscript[Global`f, Global`\[Sigma]]]], Null, Global`Symbolize[Global`NotationTemplateTag[Subscript[Global`\[Lambda], 1]]], Null, Global`Symbolize[Global`NotationTemplateTag[Subscript[Global`\[Lambda], 2]]], Null, Global`Symbolize[Global`NotationTemplateTag[Subscript[Global`\[Delta]\[Theta], Global`R]]], Null, Global`Symbolize[Global`NotationTemplateTag[Power[Subscript[Global`\[Sigma], Global`R], Infinity]]], Null, Global`Symbolize[Global`NotationTemplateTag[Subscript[Global`\[ScriptCapitalF], Global`\[Lambda]]]], Null, Global`Symbolize[Global`NotationTemplateTag[Subscript[Global`\[ScriptCapitalD], Global`\[Lambda]]]], Null, Global`Symbolize[Global`NotationTemplateTag[Subscript[Global`\[ScriptCapitalF], Global`\[Theta]]]], Null, Global`Symbolize[Global`NotationTemplateTag[Subscript[Global`\[ScriptCapitalD], Global`\[Theta]]]], Null, FullForm[Global`NotationTemplateTag[Subscript[Global`n, Global`s]]], Null, FullForm[Global`NotationTemplateTag[Subscript[Global`n, Global`\[Sigma]]]], Null, FullForm[Global`NotationTemplateTag[Subscript[Global`f, Global`\[Sigma]]]], Null, FullForm[Global`NotationTemplateTag[Subscript[Global`\[Lambda], 1]]], Null, FullForm[Global`NotationTemplateTag[Subscript[Global`\[Lambda], 2]]], Null, FullForm[Global`NotationTemplateTag[Subscript[Global`\[Delta]\[Theta], Global`R]]], Null, FullForm[Global`NotationTemplateTag[Power[Subscript[Global`\[Sigma], Global`R], Infinity]]], Null, FullForm[Global`NotationTemplateTag[Subscript[Global`\[ScriptCapitalF], Global`\[Lambda]]]], Null, FullForm[Global`NotationTemplateTag[Subscript[Global`\[ScriptCapitalD], Global`\[Lambda]]]], Null, FullForm[Global`NotationTemplateTag[Subscript[Global`\[ScriptCapitalF], Global`\[Theta]]]], Null, FullForm[Global`NotationTemplateTag[Subscript[Global`\[ScriptCapitalD], Global`\[Theta]]]], Null, FullForm[Subscript[Global`n, Global`s]], Null, FullForm[Subscript[Global`n, Global`\[Sigma]]], Null, FullForm[Subscript[Global`f, Global`\[Sigma]]], Null, FullForm[Subscript[Global`\[Lambda], 1]], Null, FullForm[Subscript[Global`\[Lambda], 2]], Null, FullForm[Subscript[Global`\[Delta]\[Theta], Global`R]], Null, FullForm[Power[Subscript[Global`\[Sigma], Global`R], Infinity]], Null, FullForm[Subscript[Global`\[ScriptCapitalF], Global`\[Lambda]]], Null, FullForm[Subscript[Global`\[ScriptCapitalD], Global`\[Lambda]]], Null, FullForm[Subscript[Global`\[ScriptCapitalF], Global`\[Theta]]], Null, FullForm[Subscript[Global`\[ScriptCapitalD], Global`\[Theta]]], Null, CompoundExpression[Print[ReplaceAll[Subscript[Global`\[Delta]\[Theta], Global`R], Rule[Global`R, 1]]], Null], Null, CompoundExpression[Print[ReplaceAll[Subscript[Global`\[Delta]\[Theta], Global`R], Rule[Global`\[Theta], 1]]], Null], Null, CompoundExpression[Print[ReplaceAll[Subscript[Global`n, Global`s], Rule[Global`s, 1]]], Null], Null, CompoundExpression[Print[ReplaceAll[Subscript[Global`n, Global`\[Sigma]], Rule[Global`\[Sigma], 11]]], Null], Null, CompoundExpression[Print[ReplaceAll[Subscript[Global`\[Lambda], 1], Rule[Global`\[Lambda], Global`x1]]], Null], Null, CompoundExpression[Print[ReplaceAll[Subscript[Global`\[Lambda], 2], Rule[Global`\[Lambda], Global`x2]]], Null], Null, CompoundExpression[Print[ReplaceAll[Subscript[Global`\[Lambda], 1], Rule[Subscript[Global`\[Lambda], 1], Global`x1]]], Null], Null, CompoundExpression[Print[ReplaceAll[Subscript[Global`\[Lambda], 2], Rule[Subscript[Global`\[Lambda], 2], Global`x2]]], Null], Null, CompoundExpression[Print[ReplaceAll[Subscript[Global`\[ScriptCapitalD], Global`\[Lambda]], Rule[Global`\[Lambda], 1]]], Null], Null, CompoundExpression[On[MessageName[Global`Symbolize, "bsymbexs"]], Null], Null, myNotebookInit`checkNewCreatedSymbols[]]

(* ::Section:: *)
(* MISCELLANEA DEFINITIONS *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 27, expression 1 ---- *)
CompoundExpression[CompoundExpression[SetAttributes[Global`debugPrintD, HoldAll], Null], Null, CompoundExpression[SetDelayed[Global`debugPrintD[Pattern[Global`input, BlankSequence[]]], Module[List[], If[base`debugPrintEnabledFlag, myNotebookInit`printD[Global`input]]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 28, expression 1 ---- *)
CompoundExpression[CompoundExpression[Set[Global`fullRationalize, Function[Rationalize[Slot[1], 0]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 29, expression 1 ---- *)
CompoundExpression[Times[CompoundExpression[myNotebookInit`printD[Global`tagDataPlot], Null], CompoundExpression[myNotebookInit`printD[Global`thisDataPlotInset], Null]]]

(* ::Subtitle:: *)
(* OPTIONS FOR THIS NOTEBOOK *)

(* ::Subtitle:: *)
(* RICH SPECIFIC FOR THIS NOTEBOOK *)

(* ::Subsubtitle:: *)
(* SETUP for RICH *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 30, expression 1 ---- *)
CompoundExpression[Times[CompoundExpression[Unprotect[Global`\[Lambda]MinRef, Global`\[Lambda]MaxRef], Null], CompoundExpression[Set[Global`\[Lambda]MinRef, 200], Null], CompoundExpression[Set[Global`\[Lambda]MaxRef, 700], Null], CompoundExpression[Protect[Global`\[Lambda]MinRef, Global`\[Lambda]MaxRef], Null], CompoundExpression[myNotebookInit`bigBanner[" SETTING WAVELENGTH RANGE (\[Lambda]MinRef,\[Lambda]MaxRef) : ", "(", Global`\[Lambda]MinRef, "-", Global`\[Lambda]MaxRef, ")", " nm"], Null], CompoundExpression[Print[Column[Sort[base`searchForGivenNames["*pde*"]]]], Null]]]

(* ::Subsubtitle:: *)
(* CALC/PREPARE data needed by this notebook *)

(* ::Section:: *)
(* sensors *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 31, expression 1 ---- *)
CompoundExpression[TableForm[Names["*EnergyData*"]], Null, TableForm[Names["*label*"]], Null, TableForm[Names["*nRefr*"]], Null, TableForm[Names["*theRef*"]], Null, TableForm[Names["*refrI*"]]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 32, expression 1 ---- *)
CompoundExpression[CompoundExpression[Set[Global`allSensorsPDEEnergyData, List[Global`LAPPDTMEnergyData, Global`MAPMT22EnergyData, Global`MPPCHPKEnergyData, Global`SIPMFBKEnergyData]], Null], Null, CompoundExpression[Set[Global`allSensorsPDEWavLenData, List[Map[Function[List[Global`\[Lambda][Part[Slot[1], 1]], Part[Slot[1], 2]]], Global`LAPPDTMEnergyData], Map[Function[List[Global`\[Lambda][Part[Slot[1], 1]], Part[Slot[1], 2]]], Global`MAPMT22EnergyData], Map[Function[List[Global`\[Lambda][Part[Slot[1], 1]], Part[Slot[1], 2]]], Global`MPPCHPKEnergyData], Map[Function[List[Global`\[Lambda][Part[Slot[1], 1]], Part[Slot[1], 2]]], Global`SIPMFBKEnergyData]]], Null], Null, Map[Interpolation, Global`allSensorsPDEEnergyData]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 33, expression 1 ---- *)
CompoundExpression[CompoundExpression[Set[Global`legend, SwatchLegend[List[Orange, Blue, Yellow, Green], List["LAPPDTMEnergyData", "MAPMT22EnergyData", "MPPCHPKEnergyData", "SIPMFBKEnergyData"], Rule[LegendMarkers, Graphics[List[Rectangle[]]]], Rule[LegendLabel, "sensors"], Rule[LegendFunction, Function[Framed[Slot[1], Rule[RoundingRadius, 5]]]], Rule[LegendMargins, 5]]], Null]]

(* ::Input::Initialization:: *)
(* ---- initialization cell 34, expression 1 ---- *)
CompoundExpression[CompoundExpression[Set[Global`plot, ListLinePlot[List[Style[Global`LAPPDTMEnergyData, Orange], Style[Global`MAPMT22EnergyData, Blue], Style[Global`MPPCHPKEnergyData, Yellow], Style[Global`SIPMFBKEnergyData, Green]], Rule[PlotRange, List[List[Global`eneMin, Global`eneMax], List[0, 0.7`]]], Rule[PlotLegends, Global`legend], Rule[GridLines, Automatic], Rule[Epilog, List[]], Rule[AxesLabel, Global`labelEffVsEv]]], Null], Null, CompoundExpression[Print[Global`plot], Null], Null, CompoundExpression[myNotebookInit`exportGraphicsToPDF[Global`plot, "allSensorsPDEEnergyData", "", "", False], Null], Null, Null]

(* ::Input::Initialization:: *)
(* ---- initialization cell 35, expression 1 ---- *)
CompoundExpression[CompoundExpression[Set[Global`plot, ListLinePlot[List[Style[Part[Global`allSensorsPDEWavLenData, 1], Orange], Style[Part[Global`allSensorsPDEWavLenData, 2], Blue], Style[Part[Global`allSensorsPDEWavLenData, 3], Yellow], Style[Part[Global`allSensorsPDEWavLenData, 4], Green]], Rule[PlotRange, List[List[Global`\[Lambda][Global`eneMin], Global`\[Lambda][Global`eneMax]], List[0, 0.7`]]], Rule[PlotLegends, Global`legend], Rule[GridLines, Automatic], Rule[Epilog, List[]], Rule[AxesLabel, Global`labelEffVsNm]]], Null], Null, CompoundExpression[Print[Global`plot], Null], Null, CompoundExpression[myNotebookInit`exportGraphicsToPDF[Global`plot, "allSensorsPDEWavLenData", "", "", False], Null]]

(* ::Section:: *)
(* all radiators info: to check/update (now only the standard LHCb/RICH rads) *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 36, expression 1 ---- *)
CompoundExpression[Times[CompoundExpression[Set[Global`theWavLen1, List[200.`, 200.`, 200.`, 200.`, 200.`]], Null], CompoundExpression[Set[Global`theWavLen2, List[700.`, 700.`, 700.`, 700.`, 700.`]], Null], CompoundExpression[Set[Global`theWavLenMean, List[346.3`, 347.7`, 345.4`, 347.4`, 350.2`]], Null], CompoundExpression[Set[Global`theWavLenMedian, List[305.4`, 307.2`, 304.4`, 306.9`, 310.3`]], Null], CompoundExpression[Set[Global`nRefrAtTheWavLen1, List[1.0015657`, 1.0005187`, 1.0005132`, 1.5505055`, 1.0308707`]], Null], CompoundExpression[Set[Global`nRefrAtTheWavLenMedian, List[1.0014367`, 1.000489`, 1.0004633`, 1.4859271`, 1.0304975`]], Null], CompoundExpression[Set[Global`nRefrAtTheWavLenMean, List[1.0014173`, 1.0004845`, 1.0004558`, 1.4773295`, 1.0304414`]], Null], CompoundExpression[Set[Global`nRefrAtTheWavLen2, List[1.0013682`, 1.0004729`, 1.0004373`, 1.4552925`, 1.0302885`]], Null], CompoundExpression[myNotebookInit`printD[Global`theWavLen1], Null], CompoundExpression[myNotebookInit`printD[Global`theWavLen2], Null], CompoundExpression[myNotebookInit`printD[Global`theWavLenMean], Null], CompoundExpression[myNotebookInit`printD[Global`theWavLenMedian], Null], CompoundExpression[myNotebookInit`printD[Global`nRefrAtTheWavLen1], Null], CompoundExpression[myNotebookInit`printD[Global`nRefrAtTheWavLen2], Null], CompoundExpression[myNotebookInit`printD[Global`nRefrAtTheWavLenMean], Null], CompoundExpression[myNotebookInit`printD[Global`nRefrAtTheWavLenMedian], Null]]]

(* ::Section:: *)
(* momentum related things *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 37, expression 1 ---- *)
CompoundExpression[Times[CompoundExpression[myNotebookInit`printD[Global`momentumCherenkovThreshold[Global`m, Global`n]], Null], Plot[List[Power[Sin[Global`thetaChrTheMax[Global`n]], 2]], List[Global`n, 1.0001`, 1.0027`], Rule[PlotRange, All], Rule[PlotLegends, "Expressions"], Rule[GridLines, Automatic]], Plot[List[Times[Global`momentumCherenkovThreshold[Global`m, Global`n], Power[Global`m, -1]]], List[Global`n, 1.0001`, 1.0027`], Rule[PlotRange, All], Rule[PlotLegends, "Expressions"], Rule[GridLines, Automatic]]]]

(* ::Subtitle:: *)
(* END INITIALIZATION CELLS *)

(* ::Input::Initialization:: *)
(* ---- initialization cell 38, expression 1 ---- *)
CompoundExpression[myNotebookInit`endEvalPrintOut[]]

(* ::Title:: *)
(* ---... CALCULATOR BODY *)

(* ::Subtitle:: *)
(* SOME PRELIMINARY CALCULATIONS *)

(* ::Section:: *)
(* calculate RICH results *)

(* ::Subsection:: *)
(* INIT *)

(* ::Subsection:: *)
(* RICH-2022 *)

(* ::Subsection:: *)
(* RICH-Upg2 *)

(* ::Subsubsection:: *)
(* summary results *)

(* ::Subsection:: *)
(* RICH1 *)

(* ::Subsubsection:: *)
(* C4F10 *)

(* ::Subsection:: *)
(* RICH2 *)

(* ::Subsubsection:: *)
(* C1F04 *)

(* ::Subsubsection:: *)
(* C1O02 *)

(* ::Subsubsection:: *)
(* summary results *)

(* ::Subsection:: *)
(* ALADDIN *)

(* ::Subsubsection:: *)
(* INIT *)

(* ::Subsubsection:: *)
(* He *)

(* ::Subsubsection:: *)
(* Ne *)

(* ::Subsubsection:: *)
(* summary results *)

(* ::Subtitle:: *)
(* INPUT DATA *)

(* ::Subsubtitle:: *)
(* INIT *)

(* ::Subsubtitle:: *)
(* FUNCTIONS *)

(* ::Section:: *)
(* basic *)

(* ::Subsection:: *)
(* pixel geometrical filling factors *)

(* ::Subsubsection:: *)
(* in pixel *)

(* ::Subsubsection:: *)
(* in device *)

(* ::Subsubsection:: *)
(* calcPixRelGeomAccept *)

(* ::Subsection:: *)
(* fiducialAreaOfTheRing *)

(* ::Subsection:: *)
(* theIntensityPhysBack *)

(* ::Subsection:: *)
(* fakeRound? *)

(* ::Subsubtitle:: *)
(* variables *)

(* ::Subsubtitle:: *)
(* basic experiment quantities *)

(* ::Subsubtitle:: *)
(* ALL BASIC INPUTs *)

(* ::Section:: *)
(* INIT *)

(* ::Section:: *)
(* single photon angular precision, ring angular precision and number of photons *)

(* ::Section:: *)
(* PDA *)

(* ::Section:: *)
(* general *)

(* ::Section:: *)
(* RICH1 *)

(* ::Section:: *)
(* RICH2 *)

(* ::Section:: *)
(* some calculations *)

(* ::Section:: *)
(* one specific radiator to exemplify gamma lists  *)

(* ::Section:: *)
(* gamma lists *)

(* ::Subsubtitle:: *)
(* general functions *)

(* ::Section:: *)
(* significances *)

(* ::Section:: *)
(* binary readout *)

(* ::Section:: *)
(* units of measure *)

(* ::Subtitle:: *)
(* detector design *)

(* ::Subsubtitle:: *)
(* DETECTOR FUNCTIONS *)

(* ::Section:: *)
(* doSetExperiment *)

(* ::Section:: *)
(* doCalcExperiment *)

(* ::Section:: *)
(* doCalcSignificance *)

(* ::Section:: *)
(* Significance plots functions *)

(* ::Section:: *)
(* modelChromaEvolutionWithGamma *)

(* ::Section:: *)
(* significance functions *)

(* ::Subsubtitle:: *)
(* CALC ALL EXPERIMENTS *)

(* ::Section:: *)
(* init *)

(* ::Section:: *)
(* definition doCalcAllExperiments *)

(* ::Subsection:: *)
(* general functions *)

(* ::Subsection:: *)
(* NEW TO IMPLEMENT AND CHECK - non evaluatable cells *)

(* ::Subsection:: *)
(* SAFE version - production version *)

(* ::Section:: *)
(* do calculations allCalcAllExperiments *)

(* ::Section:: *)
(* Summary results *)

(* ::Section:: *)
(* short summary results *)

(* ::Subsection:: *)
(* END *)

(* ::Section:: *)
(* Cross-Checks *)

(* ::Section:: *)
(* doAllCalcOneExperimentShort TO DELETE *)

(* ::Subtitle:: *)
(* significance and detector design (cont) *)

(* ::Subsubtitle:: *)
(* doAllSignificancePlots *)

(* ::Section:: *)
(* dataset *)

(* ::Subsubtitle:: *)
(* miscellanea *)

(* ::Subsubtitle:: *)
(* END *)