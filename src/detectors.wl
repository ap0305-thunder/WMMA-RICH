(* ::Package:: *)

(* ===== RICH detector list =====
   Name: detectors
   Role: data + helpers for optics.nb (loaded by the "optics" case of LoadProject.wl)
   Context: RICHDetectors`
   Created 2026-11-13.

   ONE place that says, for every detector:
     - its label, the short tag used in file names (tagString), its family and the legacy iRICH number
     - which optics exist, which versions, and the optics definition file in src/ for each version
       (version "*" = the same file for every version)
     - which source types and sensors it accepts, and notes shown by the RUN CONTROL PANEL
   The RUN CONTROL PANEL (src/runControlPanel.wl), the cell *** DEFINE RUN OPTIONS and the optics
   loader cell of optics.nb all read this list: to add a detector, an optics or a version, edit only
   $RICHDetectors below (and write its optics definition file in src/).
*)

BeginPackage["RICHDetectors`"];

$RICHDetectors::usage = "$RICHDetectors is the detector list: key -> <|Label, Tag, Family, IRICH, InUse, Optics, OpticsNotes, Sources, Sensors, Notes|>.";
$RICHDetectorOrder::usage = "$RICHDetectorOrder lists the detector keys in the order shown by the RUN CONTROL PANEL.";
$RICHSourceTypes::usage = "$RICHSourceTypes is the association source type -> label.";
$RICHPlaceholderSources::usage = "$RICHPlaceholderSources lists the placeholder source types (not written yet).";
$RICHSensorTypes::usage = "$RICHSensorTypes lists the sensor names known to calcRICHYield that the panel offers.";
$RICHOpticsVersions::usage = "$RICHOpticsVersions lists the optics version names offered when an optics has one file for every version.";
$RICHRunNotesFunction::usage = "$RICHRunNotesFunction[reg, detector, optics, version, source, srcDir] gives <|File, Warnings, Info|>. It uses only System functions, so the RUN CONTROL PANEL can store it.";
RICHDetectorQ::usage = "RICHDetectorQ[key] is True for a key of $RICHDetectors.";
RICHDetectorProperty::usage = "RICHDetectorProperty[key, prop] gives one property of a detector (Missing if absent).";
RICHDetectorLabel::usage = "RICHDetectorLabel[key] gives the label shown by the panel.";
RICHDetectorTag::usage = "RICHDetectorTag[key] gives the short tag used at the start of tagString (RICH1, RICH2, ALADDIN, ARCB, ...).";
RICHDetectorFamily::usage = "RICHDetectorFamily[key] gives LHCb, ALADDIN, ARC or new.";
RICHDetectorIRICH::usage = "RICHDetectorIRICH[key] gives the legacy iRICH number (1, 2, 9; 0 for the detectors without one).";
RICHDetectorFromIRICH::usage = "RICHDetectorFromIRICH[i] gives the detector key of a legacy iRICH number (1, 2, 9), or Missing.";
RICHOpticsChoices::usage = "RICHOpticsChoices[key] lists the optics names of a detector.";
RICHOpticsVersionChoices::usage = "RICHOpticsVersionChoices[key, optics] lists the versions of an optics.";
RICHOpticsFile::usage = "RICHOpticsFile[key, optics, version] gives the optics definition file name (in src/), or None.";
RICHSourceChoices::usage = "RICHSourceChoices[key] lists the source types accepted by a detector.";
RICHSensorChoices::usage = "RICHSensorChoices[key] lists the sensors accepted by a detector.";
RICHRunNotes::usage = "RICHRunNotes[key, optics, version, source] gives <|File, Warnings, Info|> for a run.";
RICHOpticsDefinedQ::usage = "RICHOpticsDefinedQ[key] is True when the optics definition file just loaded built a complete optical system for that detector.";
RICHApplyRunPanelOptions::usage = "RICHApplyRunPanelOptions[] applies the RUN CONTROL PANEL values (TaggingRules RICHRunOptions of the evaluation notebook) when \"use panel values\" is ticked, derives iRICH and the detector flag detectorFamily from the detector and prints the run options.";
RICHYieldOnce::usage = "RICHYieldOnce[args...] is rich`calcRICHYield[args...] calculated only when needed: when the arguments differ from the last calculation (radiator, wavelength range, RICH, sensor, length, number of samples, quantiles), when the variables set by calcRICHYield were changed since (another calcRICHYield call in the same kernel), or when forceCalcRICHYield is True (RUN CONTROL PANEL: \"recalculate yield\"). Otherwise it returns the result of the last calculation, whose variables (wavLenMean, listOfEqualPureEmissionYieldWavLenSlices, ...) are still in place.";
$RICHYieldLast::usage = "$RICHYieldLast is the last calculation of RICHYieldOnce: <|Key, Result, Fingerprint, Time, Seconds|>.";
RICHStopRun::usage ="RICHStopRun[message] stops the run: it prints the message as a banner, then aborts the evaluation AND the cells queued after it (as the Stop button or Alt+.). Abort[] alone stops only the current cell: the Run button queues whole chapters.";

Begin["`Private`"];

(*=========================================================================*)
(* SOURCES, SENSORS, VERSIONS *)
(*=========================================================================*)
$RICHSourceTypes = <|
  "gun" -> "gun (particle guns)",
  "chr" -> "chr (single particle Cherenkov)",
  "grd" -> "grd (rectangular grid)",
  "line" -> "line (line source)",
  "new-src1" -> "new-src1 (placeholder)",
  "new-src2" -> "new-src2 (placeholder)",
  "new-src3" -> "new-src3 (placeholder)"
|>;
$RICHPlaceholderSources = {"new-src1", "new-src2", "new-src3"};
$RICHSensorTypes = {"MAPMT22", "MPPCHPK"};
$RICHOpticsVersions = {"Ale", "butterfly", "Eli", "Rob", "zero"};

lhcbSources = {"gun", "chr", "grd", "line", "new-src1", "new-src2", "new-src3"};

(*=========================================================================*)
(* THE DETECTOR LIST *)
(*=========================================================================*)
$RICHDetectorOrder = {"LHCb-RICH1", "LHCb-RICH2", "ALADDIN", "ARC-barrel", "ARC-endcaps", "new1", "new2", "new3"};

$RICHDetectors = <|
  "LHCb-RICH1" -> <|
    "Label" -> "LHCb RICH1", "Tag" -> "RICH1", "Family" -> "LHCb", "IRICH" -> 1, "InUse" -> True,
    "Optics" -> <|
      "LHCb22Upg1" -> <|"Ale" -> "optics-def-LHCb22Upg1-rich1.wl"|>,
      "LHCb35Upg2FTDR" -> <|"*" -> "optics-def-LHCb35Upg2FTDR-rich1.wl"|>,
      "LHCb35Upg2Split" -> <|
        "Ale" -> "optics-def-LHCb35Upg2Split-rich1.wl",
        "Eli" -> "optics-def-LHCb35Upg2Split-rich1_E-v3-11-9.wl",
        "butterfly" -> "optics-def-LHCb35Upg2Split-rich1-butterfly.wl"|>
    |>,
    "OpticsNotes" -> <|"LHCb35Upg2FTDR" -> "FTDR RICH1 optics is still a stub (TO DO): the run will stop at OPTICS"|>,
    "Sources" -> lhcbSources, "Sensors" -> $RICHSensorTypes, "Notes" -> {}
  |>,
  "LHCb-RICH2" -> <|
    "Label" -> "LHCb RICH2", "Tag" -> "RICH2", "Family" -> "LHCb", "IRICH" -> 2, "InUse" -> True,
    "Optics" -> <|
      "LHCb22Upg1" -> <|"Ale" -> "optics-def-LHCb22Upg1-rich2.wl"|>,
      "LHCb35Upg2FTDR" -> <|"*" -> "optics-def-LHCb35Upg2FTDR-rich2.wl"|>,
      "LHCb35Upg2Split" -> <|
        "Ale" -> "optics-def-LHCb35Upg2Split-rich2.wl",
        "Eli" -> "optics-def-LHCb35Upg2Split-rich2_E-v8-09-1.wl"|>
    |>,
    "OpticsNotes" -> <||>,
    "Sources" -> lhcbSources, "Sensors" -> $RICHSensorTypes, "Notes" -> {}
  |>,
  "ALADDIN" -> <|
    "Label" -> "ALADDIN", "Tag" -> "ALADDIN", "Family" -> "ALADDIN", "IRICH" -> 9, "InUse" -> True,
    "Optics" -> <||>, "OpticsNotes" -> <||>,
    "Sources" -> lhcbSources, "Sensors" -> $RICHSensorTypes,
    "Notes" -> {"ALADDIN: no optics definition yet (radiator length nominalLengthALADDIN in RICH.wl)"}
  |>,
  "ARC-barrel" -> <|
    "Label" -> "ARC barrel", "Tag" -> "ARCB", "Family" -> "ARC", "IRICH" -> 0, "InUse" -> True,
    "Optics" -> <|"ARCv0" -> <|"ref" -> "optics-def-ARCv0-barrel.wl"|>|>,
    "OpticsNotes" -> <||>,
    "Sources" -> {"chr", "new-src1", "new-src2", "new-src3"}, "Sensors" -> {"MPPCHPK", "MAPMT22"},
    "Notes" -> {
      "ARC: temporary radiator and sensor for the yield (LHCb RICH1 C4F10 and the chosen sensor) until the ARC ones are in calcRICHYield",
      "ARC: analysis so far = the tests of arc.nb (rings on the sensor, Optica versus geometric model); the run stops after them"}
  |>,
  "ARC-endcaps" -> <|
    "Label" -> "ARC endcaps", "Tag" -> "ARCE", "Family" -> "ARC", "IRICH" -> 0, "InUse" -> True,
    "Optics" -> <||>, "OpticsNotes" -> <||>,
    "Sources" -> {"chr", "new-src1", "new-src2", "new-src3"}, "Sensors" -> {"MPPCHPK", "MAPMT22"},
    "Notes" -> {"ARC endcaps: no geometry yet (the ARC files cover the barrel only)"}
  |>,
  "new1" -> <|"Label" -> "new1", "Tag" -> "NEW1", "Family" -> "new", "IRICH" -> 0, "InUse" -> False,
    "Optics" -> <||>, "OpticsNotes" -> <||>, "Sources" -> lhcbSources, "Sensors" -> $RICHSensorTypes, "Notes" -> {}|>,
  "new2" -> <|"Label" -> "new2", "Tag" -> "NEW2", "Family" -> "new", "IRICH" -> 0, "InUse" -> False,
    "Optics" -> <||>, "OpticsNotes" -> <||>, "Sources" -> lhcbSources, "Sensors" -> $RICHSensorTypes, "Notes" -> {}|>,
  "new3" -> <|"Label" -> "new3", "Tag" -> "NEW3", "Family" -> "new", "IRICH" -> 0, "InUse" -> False,
    "Optics" -> <||>, "OpticsNotes" -> <||>, "Sources" -> lhcbSources, "Sensors" -> $RICHSensorTypes, "Notes" -> {}|>
|>;

(*=========================================================================*)
(* ACCESSORS *)
(*=========================================================================*)
RICHDetectorQ[key_] := StringQ[key] && KeyExistsQ[$RICHDetectors, key];
RICHDetectorProperty[key_?RICHDetectorQ, prop_String] := Lookup[$RICHDetectors[key], prop, Missing["NoProperty", prop]];
RICHDetectorProperty[key_, _] := Missing["UnknownDetector", key];
RICHDetectorLabel[key_] := With[{v = RICHDetectorProperty[key, "Label"]}, If[StringQ[v], v, ToString[key]]];
RICHDetectorTag[key_] := With[{v = RICHDetectorProperty[key, "Tag"]}, If[StringQ[v], v, "UNKNOWN"]];
RICHDetectorFamily[key_] := With[{v = RICHDetectorProperty[key, "Family"]}, If[StringQ[v], v, "unknown"]];
RICHDetectorIRICH[key_] := With[{v = RICHDetectorProperty[key, "IRICH"]}, If[IntegerQ[v], v, 0]];
RICHDetectorFromIRICH[i_Integer] := With[{k = Select[$RICHDetectorOrder, $RICHDetectors[#]["IRICH"] === i && i =!= 0 &]},
  If[k === {}, Missing["NoDetectorForIRICH", i], First[k]]];
RICHDetectorFromIRICH[i_] := Missing["NoDetectorForIRICH", i];
RICHOpticsChoices[key_] := With[{o = RICHDetectorProperty[key, "Optics"]}, If[AssociationQ[o], Keys[o], {}]];
RICHOpticsVersionChoices[key_, optics_] := With[{o = RICHDetectorProperty[key, "Optics"]},
  If[AssociationQ[o] && AssociationQ[Lookup[o, optics, None]],
    If[KeyExistsQ[o[optics], "*"], $RICHOpticsVersions, Keys[o[optics]]], {}]];
RICHSourceChoices[key_] := With[{v = RICHDetectorProperty[key, "Sources"]}, If[ListQ[v], v, {}]];
RICHSensorChoices[key_] := With[{v = RICHDetectorProperty[key, "Sensors"]}, If[ListQ[v], v, {}]];

(*=========================================================================*)
(* NOTES FOR A RUN: file to load, warnings (the run will stop) and information *)
(* Only System functions: the RUN CONTROL PANEL stores this function inside its Dynamic cells *)
(*=========================================================================*)
$RICHRunNotesFunction = Function[{reg, det, optics, version, source, srcDir},
  Module[{d, opts, opt, file = None, warn = {}, info = {}},
    d = Lookup[reg, det, None];
    If[! AssociationQ[d],
      <|"File" -> None, "Warnings" -> {"choose a detector"}, "Info" -> {}|>,
      opts = Lookup[d, "Optics", <||>];
      If[! TrueQ[Lookup[d, "InUse", False]], AppendTo[warn, Lookup[d, "Label", det] <> " is not used yet: the run will stop at OPTICS"]];
      opt = Lookup[opts, optics, None];
      Which[
        opts === <||>, AppendTo[warn, "no optics definition for " <> Lookup[d, "Label", det] <> " yet: the run will stop at OPTICS"],
        ! AssociationQ[opt], AppendTo[warn, "optics " <> ToString[optics] <> " is not defined for " <> Lookup[d, "Label", det] <> ": the run will stop at OPTICS"],
        KeyExistsQ[opt, version], file = opt[version],
        KeyExistsQ[opt, "*"], file = opt["*"],
        True, AppendTo[warn, "no file for optics " <> ToString[optics] <> ", version " <> ToString[version] <> ": the run will stop at OPTICS"]
      ];
      If[StringQ[file] && StringQ[srcDir] && StringLength[srcDir] > 0 && ! FileExistsQ[FileNameJoin[{srcDir, file}]],
        AppendTo[warn, "file not found in src: the run will stop at OPTICS"]];
      If[StringQ[file], warn = Join[warn, Flatten[{Lookup[Lookup[d, "OpticsNotes", <||>], optics, {}]}]]];
      If[! MemberQ[Lookup[d, "Sources", {}], source],
        AppendTo[warn, "source " <> ToString[source] <> " is not available for " <> Lookup[d, "Label", det]]];
      If[StringQ[source] && StringStartsQ[source, "new-src"],
        AppendTo[warn, "source " <> source <> " is a placeholder: the run will stop at LIGHT"]];
      info = Flatten[{Lookup[d, "Notes", {}]}];
      <|"File" -> file, "Warnings" -> warn, "Info" -> info|>
    ]
  ]
];

srcDirectory[] := Quiet @ Check[
  If[Length[DownValues[Global`RICHProjectPath]] > 0, Global`RICHProjectPath["src"], ""], ""];

RICHOpticsFile[key_, optics_, version_] := $RICHRunNotesFunction[$RICHDetectors, key, optics, version, "", ""]["File"];
RICHRunNotes[key_, optics_, version_, source_] := $RICHRunNotesFunction[$RICHDetectors, key, optics, version, source, srcDirectory[]];

(*=========================================================================*)
(* WHAT A COMPLETE OPTICS DEFINITION FILE MUST BUILD, per family *)
(*=========================================================================*)
RICHOpticsDefinedQ[key_] := Switch[RICHDetectorFamily[key],
  "ARC",
    ValueQ[Global`myOptics] && ValueQ[Global`arcBarrel],
  _,
    (ValueQ[Global`priMirror] && ValueQ[Global`secMirror] && ValueQ[Global`thePDA]) ||
    (ValueQ[Global`priMirrorL] && ValueQ[Global`priMirrorH] && ValueQ[Global`secMirrorL] &&
      ValueQ[Global`secMirrorH] && ValueQ[Global`thePDAL] && ValueQ[Global`thePDAH])
];

(*=========================================================================*)
(* RUN CONTROL PANEL VALUES -> run options (was the second cell of *** DEFINE RUN OPTIONS, FIX 2026-11-08) *)
(*=========================================================================*)
RICHApplyRunPanelOptions[] := Module[{opt, det, notes},
  opt = Quiet @ CurrentValue[EvaluationNotebook[], {TaggingRules, "RICHRunOptions"}];
  If[(AssociationQ[opt] || MatchQ[opt, {___Rule}]) && TrueQ[Lookup[opt, "usePanel", False]],
    Unprotect[Global`addTag, Global`iRICH, Global`numQuantiles, Global`propagateSystemYes, Global`resonate,
      Global`theSensor, Global`sourceType, Global`turboTraceYes, Global`whichOptics, Global`opticsVersion, Global`whichDetector,
      Global`detectorFamily];
    (* detector: new key "whichDetector"; panels saved before 2026-11-13 only have "iRICH" *)
    det = Lookup[opt, "whichDetector", None];
    If[! RICHDetectorQ[det], det = RICHDetectorFromIRICH[Lookup[opt, "iRICH", None]]];
    If[RICHDetectorQ[det], Global`whichDetector = det];
    With[{v = Lookup[opt, "whichOptics"]}, If[StringQ[v] && StringLength[v] > 0, Global`whichOptics = v]];
    With[{v = Lookup[opt, "opticsVersion"]}, If[StringQ[v] && StringLength[v] > 0, Global`opticsVersion = v]];
    With[{v = Lookup[opt, "sourceType"]}, If[StringQ[v] && StringLength[v] > 0, Global`sourceType = v]];
    With[{v = Lookup[opt, "theSensor"]}, If[StringQ[v] && StringLength[v] > 0, Global`theSensor = v]];
    With[{v = Lookup[opt, "resonate"]}, If[BooleanQ[v], Global`resonate = v]];
    With[{v = Lookup[opt, "propagateSystemYes"]}, If[BooleanQ[v], Global`propagateSystemYes = v]];
    With[{v = Lookup[opt, "turboTraceYes"]}, If[BooleanQ[v], Global`turboTraceYes = v]];
    With[{v = Lookup[opt, "debugPrintEnabledFlag"]}, If[BooleanQ[v], Global`debugPrintEnabledFlag = v]];
    With[{v = Lookup[opt, "numQuantiles"]}, If[NumericQ[v] && v > 0, Global`numQuantiles = Round[v]]];
    With[{v = Lookup[opt, "addTag"]}, If[StringQ[v], Global`addTag = v]];
    With[{v = Lookup[opt, "forceYield"]}, If[BooleanQ[v], Global`forceCalcRICHYield = v]];
    Global`iRICH = RICHDetectorIRICH[Global`whichDetector];
    Global`detectorFamily = RICHDetectorFamily[Global`whichDetector];
    Protect[Global`addTag, Global`iRICH, Global`numQuantiles, Global`propagateSystemYes, Global`resonate,
      Global`theSensor, Global`sourceType, Global`turboTraceYes, Global`whichOptics, Global`opticsVersion, Global`whichDetector,
      Global`detectorFamily];
    Global`runOptionsFrom = "RUN CONTROL PANEL",
    Global`runOptionsFrom = "cell *** DEFINE RUN OPTIONS"
  ];
  Print[" run options from ", Global`runOptionsFrom, ":   ", RICHDetectorLabel[Global`whichDetector],
    " (iRICH = ", Global`iRICH, ", detectorFamily = ", Global`detectorFamily, ")   ", Global`whichOptics, "   ", Global`opticsVersion,
    "   source = ", Global`sourceType, "   sensor = ", Global`theSensor, "   resonate = ", Global`resonate,
    "   propagate = ", Global`propagateSystemYes, "   turbo = ", Global`turboTraceYes,
    "   debug = ", Global`debugPrintEnabledFlag, "   numQuantiles = ", Global`numQuantiles,
    "   recalculate yield = ", TrueQ[Global`forceCalcRICHYield]];
  Print[" tagString = ", Global`tagString];
  notes = RICHRunNotes[Global`whichDetector, Global`whichOptics, Global`opticsVersion, Global`sourceType];
  Print[" optics file = ", notes["File"]];
  Scan[Print[Style[" \[WarningSign] " <> #, Red]] &, notes["Warnings"]];
  Scan[Print[Style[" " <> #, Darker[Orange]]] &, notes["Info"]];
  notes
];

(*=========================================================================*)
(* calcRICHYield ONLY WHEN NEEDED (2026-11-13) *)
(* calcRICHYield sets many variables besides its result (wavLenMean, listOfEqualPureEmissionYieldWavLenSlices, *)
(* theRefrIndex..., used by the sources): a cache of the result alone would leave them from another configuration *)
(* (the reason why Once was removed on 2026-11-07). So only the LAST calculation is kept: it is reused when the *)
(* arguments are the same AND those variables were not changed since (fingerprint below); otherwise calculate. *)
(*=========================================================================*)
$RICHYieldLast = <|"Key" -> None|>;
yieldFingerprintSymbols = {"rich`theCherenkovTag", "rich`theRadiator", "rich`wavLenMean", "rich`wavLenMedian",
  "rich`listOfEqualPureEmissionYieldWavLenSlices", "rich`listQuantiles", "rich`theRefrIndexAtLambdaMean"};
yieldFingerprint[] := Hash[ToExpression /@ yieldFingerprintSymbols];

RICHYieldOnce[args___] := Module[{key = {args}, res, t},
  If[TrueQ[Global`forceCalcRICHYield] || $RICHYieldLast["Key"] =!= key ||
      Lookup[$RICHYieldLast, "Fingerprint", None] =!= yieldFingerprint[],
    $RICHYieldLast = <|"Key" -> None|>;
    {t, res} = AbsoluteTiming[rich`calcRICHYield[args]];
    If[MatchQ[res, $Failed | $Aborted | Null], Return[res, Module]];
    $RICHYieldLast = <|"Key" -> key, "Result" -> res, "Fingerprint" -> yieldFingerprint[],
      "Time" -> DateString[{"Hour", ":", "Minute", ":", "Second"}], "Seconds" -> Round[t, 0.1]|>;
    Print[Style[" calcRICHYield calculated in " <> ToString[Round[t, 0.1]] <> " s (kept: recalculated only when its inputs change)", Darker[Green]]],
    Print[Style[" calcRICHYield NOT recalculated: same inputs as the calculation of " <> $RICHYieldLast["Time"] <>
      " (" <> ToString[$RICHYieldLast["Seconds"]] <> " s). To force it: tick \"recalculate yield\" in the RUN CONTROL PANEL, or set forceCalcRICHYield=True", Darker[Green]]]
  ];
  $RICHYieldLast["Result"]
];

(*=========================================================================*)
(* STOP THE RUN (2026-11-13) *)
(* The Run button of the panel queues whole chapters: Abort[] stops only the cell that calls it and the *)
(* front end goes on with the queued cells. EvaluatorAbort (the Stop button, Alt+.) also drops the queue. *)
(*=========================================================================*)
RICHStopRun[msg_String] := (
  If[Length[DownValues[myNotebookInit`bigBanner]] > 0,
    myNotebookInit`bigBanner[" " <> msg <> " "],
    Print[Style[msg, Red, Bold]]];
  If[TrueQ[$Notebooks], Quiet[FrontEndTokenExecute["EvaluatorAbort"]]];
  Abort[]
);

End[];
EndPackage[];
