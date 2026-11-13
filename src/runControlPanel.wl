(* ::Package:: *)

(* ===== RICH optics run control panel =====
   Name: runControlPanel
   Role: user interface for optics.nb (loaded by the "optics" case of LoadProject.wl)
   Context: RICHRunPanel`
   Created 2026-11-13 from the RUN CONTROL PANEL cell of optics.nb (2026-11-08; 2026-11-12: title,
   high-contrast choices), now driven by the detector list src/detectors.wl.

   RICHRunControlPanel[] returns the panel and the Float button. In optics.nb the cell under the Title
   "RUN CONTROL PANEL" evaluates it; the panel is saved with the notebook.
    - the choices are saved in the notebook (notebook option TaggingRules -> "RICHRunOptions")
    - "use panel values" ticked: the cells of *** DEFINE RUN OPTIONS use the values chosen here
      (RICHApplyRunPanelOptions[], src/detectors.wl); unticked: the values written in the cell are used
    - detector -> optics -> version: only the choices of the detector list are offered
    - recalculate yield: forceCalcRICHYield; unticked, calcRICHYield is calculated again only when its
      inputs change (RICHYieldOnce, src/detectors.wl)
    - Apply options: evaluates only the DEFINE RUN OPTIONS cells (cell tag "RICHDefineRunOptions")
    - Run: evaluates the chapters OPTICAL SYSTEM DESIGN and OPTICS ANALYSIS (Title cells tagged "RICHRunChapter")
    - Stop: aborts the running evaluation and the queued cells (same as Alt+.)
    - Export drawing / Export summary: exportRunDrawings[] / exportRunSummary[] (defined by a Run)
    - Float: the same panel as a floating palette bound to the notebook (not saved)
   The detector list, the source labels and the notes function are copied INTO the panel when it is
   built (only System functions are left inside its Dynamic parts), so the saved panel works before the
   SETUP cell is evaluated. Rebuild the panel (evaluate its cell) after changing the detector list.
*)

BeginPackage["RICHRunPanel`", {"RICHDetectors`"}];

RICHRunControlPanel::usage = "RICHRunControlPanel[] builds the RICH optics run control panel (with the Float button) from the detector list $RICHDetectors.";
RICHRunPanelMigrateOptions::usage = "RICHRunPanelMigrateOptions[nb] adds the detector (whichDetector) to the panel values saved before 2026-11-13, which only had iRICH.";

Begin["`Private`"];

RICHRunPanelMigrateOptions[nb_] := Module[{o, d},
  o = Quiet @ CurrentValue[nb, {TaggingRules, "RICHRunOptions"}];
  If[(AssociationQ[o] || MatchQ[o, {___Rule}]) && ! RICHDetectorQ[Lookup[o, "whichDetector", None]],
    d = RICHDetectorFromIRICH[Lookup[o, "iRICH", None]];
    If[StringQ[d], CurrentValue[nb, {TaggingRules, "RICHRunOptions", "whichDetector"}] = d]];
];

RICHRunControlPanel[] := (RICHRunPanelMigrateOptions[EvaluationNotebook[]]; makePanel[]);

makePanel[] := With[{
    reg = $RICHDetectors,
    order = $RICHDetectorOrder,
    srcLabels = $RICHSourceTypes,
    sensors = $RICHSensorTypes,
    notesFn = $RICHRunNotesFunction,
    allVersions = $RICHOpticsVersions,
    selBg = RGBColor[0.10, 0.33, 0.72], offBg = GrayLevel[0.95], offFg = GrayLevel[0.35], naFg = GrayLevel[0.72]},
  Module[{rpTmpl},
    (*panel template: richRunPanelNB / richRunPanelButtonNB stand for the notebook the panel acts on*)
    rpTmpl = Hold[Module[{rpCtl, rpSetter, rpCheck},
      rpCtl[k_] := Dynamic[CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions", k}]];
      (*choice buttons: the selected one is dark blue with bold white text, the others light grey*)
      rpSetter[k_, choices_List] := Row[Map[Function[ch, With[{v = If[Head[ch] === Rule, First[ch], ch], lbl = If[Head[ch] === Rule, Last[ch], ToString[ch]]},
        Button[Dynamic[Style[lbl, If[CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions", k}] === v, Directive[Bold, White], offFg]]],
          CurrentValue[richRunPanelButtonNB, {TaggingRules, "RICHRunOptions", k}] = v,
          Background -> Dynamic[If[CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions", k}] === v, selBg, offBg]],
          ImageSize -> All]]], choices], " "];
      (*check boxes: the label is bold dark blue when ticked, light grey when not*)
      rpCheck[k_, lbl_String] := Row[{Checkbox[rpCtl[k]], Dynamic[Style[" " <> lbl,
        If[TrueQ[CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions", k}]], Directive[Bold, selBg], GrayLevel[0.6]]]]}];
      Panel[Column[{
        Style["RICH optics run control", Bold, 14],
        Grid[{
          {"notebook", Dynamic[With[{rpF = Quiet@Check[FileNameTake[NotebookFileName[richRunPanelNB]], $Failed]},
            If[StringQ[rpF], Style[rpF, "Program"], Style["notebook not open", Red]]]]},
          {"use panel values", Row[{rpCheck["usePanel", "in use"], Style["   (untick: *** DEFINE RUN OPTIONS uses the values written in its cell)", Gray]}]},
          (*detector: choosing a detector also picks its first optics/version when the current ones do not exist for it*)
          {"detector", Row[Map[Function[k, With[{lbl = reg[k]["Label"], inUse = TrueQ[reg[k]["InUse"]], opt = reg[k]["Optics"]},
            Button[Dynamic[Style[lbl, Which[
                CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions", "whichDetector"}] === k, Directive[Bold, White],
                inUse, offFg, True, naFg]]],
              CurrentValue[richRunPanelButtonNB, {TaggingRules, "RICHRunOptions", "whichDetector"}] = k;
              Module[{o = CurrentValue[richRunPanelButtonNB, {TaggingRules, "RICHRunOptions", "whichOptics"}],
                  v = CurrentValue[richRunPanelButtonNB, {TaggingRules, "RICHRunOptions", "opticsVersion"}]},
                If[Length[opt] > 0 && ! KeyExistsQ[opt, o], o = First[Keys[opt]];
                  CurrentValue[richRunPanelButtonNB, {TaggingRules, "RICHRunOptions", "whichOptics"}] = o];
                If[Length[opt] > 0 && AssociationQ[opt[o]] && ! KeyExistsQ[opt[o], "*"] && ! KeyExistsQ[opt[o], v],
                  CurrentValue[richRunPanelButtonNB, {TaggingRules, "RICHRunOptions", "opticsVersion"}] = First[Keys[opt[o]]]]],
              Background -> Dynamic[If[CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions", "whichDetector"}] === k, selBg, offBg]],
              ImageSize -> All]]], order], " "]},
          (*optics: the optics of the chosen detector*)
          {"optics", Dynamic[Module[{det, opt},
            det = Lookup[Replace[CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions"}], Except[_Association | {___Rule}] -> <||>], "whichDetector", None];
            opt = If[KeyExistsQ[reg, det], reg[det]["Optics"], <||>];
            If[Length[opt] == 0, Style[If[KeyExistsQ[reg, det], "none defined for this detector yet", "choose a detector"], Gray],
              (*With puts the versions of each optics into its button: the Module variables of this Dynamic do not survive*)
              Row[Map[Function[o, With[{ov = opt[o]}, Button[
                Style[o, If[CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions", "whichOptics"}] === o, Directive[Bold, White], offFg]],
                CurrentValue[richRunPanelButtonNB, {TaggingRules, "RICHRunOptions", "whichOptics"}] = o;
                If[AssociationQ[ov] && ! KeyExistsQ[ov, "*"] &&
                    ! KeyExistsQ[ov, CurrentValue[richRunPanelButtonNB, {TaggingRules, "RICHRunOptions", "opticsVersion"}]],
                  CurrentValue[richRunPanelButtonNB, {TaggingRules, "RICHRunOptions", "opticsVersion"}] = First[Keys[ov]]],
                Background -> If[CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions", "whichOptics"}] === o, selBg, offBg],
                ImageSize -> All]]], Keys[opt]], " "]]]]},
          (*optics version: the versions of the chosen optics; "*" = one file for every version*)
          {"optics version", Dynamic[Module[{rpO, det, o, opt, vs},
            rpO = Replace[CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions"}], Except[_Association | {___Rule}] -> <||>];
            det = Lookup[rpO, "whichDetector", None]; o = Lookup[rpO, "whichOptics", None];
            opt = If[KeyExistsQ[reg, det], Lookup[reg[det]["Optics"], o, <||>], <||>];
            If[! AssociationQ[opt] || Length[opt] == 0, Style["-", Gray],
              vs = If[KeyExistsQ[opt, "*"], allVersions, Keys[opt]];
              Row[{PopupMenu[Dynamic[CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions", "opticsVersion"}]], vs],
                If[KeyExistsQ[opt, "*"], Style["   (the same file for every version)", Gray], ""]}]]]]},
          (*source: every source type; those not available for the chosen detector are light grey*)
          {"source", Row[Map[Function[s, With[{lbl = srcLabels[s]},
            Button[Dynamic[Style[lbl, Module[{det = CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions", "whichDetector"}]},
                Which[CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions", "sourceType"}] === s, Directive[Bold, White],
                  KeyExistsQ[reg, det] && ! MemberQ[reg[det]["Sources"], s], naFg, True, offFg]]]],
              CurrentValue[richRunPanelButtonNB, {TaggingRules, "RICHRunOptions", "sourceType"}] = s,
              Background -> Dynamic[If[CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions", "sourceType"}] === s, selBg, offBg]],
              ImageSize -> All]]], Keys[srcLabels]], " "]},
          {"sensor", rpSetter["theSensor", sensors]},
          {"Optica", Row[{rpCheck["resonate", "resonate"], "      ", rpCheck["propagateSystemYes", "propagate system"], "      ", rpCheck["turboTraceYes", "turbo trace"]}]},
          {"yield", Row[{rpCheck["forceYield", "recalculate yield"], Style["   (unticked: calcRICHYield is calculated again only when its inputs change)", Gray]}]},
          {"debug print", rpCheck["debugPrintEnabledFlag", "on"]},
          {"numQuantiles", InputField[rpCtl["numQuantiles"], Number, FieldSize -> 4]},
          {"addTag", InputField[rpCtl["addTag"], String, FieldSize -> 24]},
          {"tagString", Dynamic[Module[{rpO},
            rpO = Replace[CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions"}], Except[_Association | {___Rule}] -> <||>];
            Style[StringJoin[
              With[{det = Lookup[rpO, "whichDetector", None]}, If[KeyExistsQ[reg, det], reg[det]["Tag"], "?"]],
              "_", ToString[Lookup[rpO, "sourceType", "?"]], "_", ToString[Lookup[rpO, "whichOptics", "?"]], "_",
              ToString[Lookup[rpO, "opticsVersion", "?"]], "_", ToString[Lookup[rpO, "addTag", ""]]], "Program"]]]},
          (*optics file and notes: same rules as the optics loader cell (detector list, src/detectors.wl)*)
          {"optics file", Dynamic[Module[{rpO, rpDir, rpN},
            rpO = Replace[CurrentValue[richRunPanelNB, {TaggingRules, "RICHRunOptions"}], Except[_Association | {___Rule}] -> <||>];
            rpDir = Quiet@Check[FileNameJoin[{ParentDirectory[NotebookDirectory[richRunPanelNB]], "src"}], ""];
            rpN = notesFn[reg, Lookup[rpO, "whichDetector", None], Lookup[rpO, "whichOptics", None],
              Lookup[rpO, "opticsVersion", None], Lookup[rpO, "sourceType", None], rpDir];
            Column[Join[{Style[If[StringQ[rpN["File"]], rpN["File"], "-"], "Program"]},
              If[rpN["Warnings"] === {}, {Style["ok", Darker[Green]]}, Style["\[WarningSign] " <> #, Red] & /@ rpN["Warnings"]],
              Style[#, Darker[Orange]] & /@ rpN["Info"]]]]]}
        }, Alignment -> {Left, Center}, Spacings -> {2, 0.7}],
        Row[{
          Button["Apply options",
            Module[{rpNb = richRunPanelButtonNB, rpCells},
              If[FreeQ[Notebooks[], rpNb], MessageDialog["the notebook of this panel is not open"],
                rpCells = Cells[rpNb, CellTags -> "RICHDefineRunOptions"];
                If[rpCells === {}, MessageDialog["no cell with the cell tag RICHDefineRunOptions"],
                  Do[SelectionMove[rpC, All, Cell]; SelectionEvaluate[rpNb], {rpC, rpCells}]]]],
            Method -> "Queued"],
          "   ",
          Button[Style["  Run  ", Bold],
            Module[{rpNb = richRunPanelButtonNB, rpCells},
              If[FreeQ[Notebooks[], rpNb], MessageDialog["the notebook of this panel is not open"],
                rpCells = Cells[rpNb, CellTags -> "RICHRunChapter"];
                If[rpCells === {}, MessageDialog["no Title cell with the cell tag RICHRunChapter"],
                  Do[SelectionMove[rpC, All, CellGroup]; SelectionEvaluate[rpNb], {rpC, rpCells}]]]],
            Method -> "Queued"],
          "   ",
          Button["Stop", FrontEndExecute[FrontEndToken["EvaluatorAbort"]], Evaluator -> None],
          "      ",
          Button["Export drawing",
            If[Length[DownValues[Global`exportRunDrawings]] == 0,
              MessageDialog["exportRunDrawings[] is not defined yet: Run first (it is defined in OPTICS ANALYSIS > RAY-TRACING > optics geometry printout/export)"],
              Global`exportRunDrawings[]],
            Method -> "Queued"],
          "   ",
          Button["Export summary",
            If[Length[DownValues[Global`exportRunSummary]] == 0,
              MessageDialog["exportRunSummary[] is not defined yet: Run first (it is defined in OPTICAL SYSTEM DESIGN > SYSTEM DEFINITION > summary data export)"],
              Global`exportRunSummary[]],
            Method -> "Queued"]
        }],
        Style["Run = evaluate the chapters OPTICAL SYSTEM DESIGN and OPTICS ANALYSIS (Title cells tagged RICHRunChapter); the SETUP cell must have been evaluated", Gray, 10],
        Style["detectors, optics, versions and files: src/detectors.wl (rebuild this panel after changing it)", Gray, 10]
      }, Spacings -> 1.2]]]];
    With[{rpT = rpTmpl},
      Column[{
        ReleaseHold[rpT /. {HoldPattern[richRunPanelNB] :> EvaluationNotebook[], HoldPattern[richRunPanelButtonNB] :> ButtonNotebook[]}],
        Button["Float: open this panel as a floating palette",
          Module[{rpTarget = ButtonNotebook[], rpTitle},
            rpTitle = "RICH optics run control - " <> Quiet@Check[FileNameTake[NotebookFileName[rpTarget]], "notebook"];
            Scan[NotebookClose, Select[Notebooks[], Quiet[CurrentValue[#, WindowTitle]] === rpTitle &]];
            CreatePalette[ReleaseHold[rpT /. {HoldPattern[richRunPanelNB] -> rpTarget, HoldPattern[richRunPanelButtonNB] -> rpTarget}],
              WindowTitle -> rpTitle, Saveable -> False]],
          Method -> "Queued"]
      }, Spacings -> 0.8]]
  ]
];

End[];
EndPackage[];
