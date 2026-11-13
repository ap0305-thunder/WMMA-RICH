(* ::Package:: *)

(* ::Subsection::Initialization:: *)
(*(*(*(*(*(*(* ARC v0 OPTICS for the ARC barrel *)*)*)*)*)*)*)


(* ::Input::Initialization:: *)
(**************************************************************************************************)

bigBanner[" loading optics : "<>ToString[whichOptics]<>"-"<>ToString[opticsVersion]<>" for detector : "<>RICHDetectorLabel[whichDetector]];
doResetAllVariables[];
(*no setExternalParameters[]: it sets the LHCb envelope, acceptance and radiator; the ARC values are set below*)
(**************************************************************************************************)
checkNewCreatedSymbols[];


(* ::Input::Initialization:: *)
(**)
(*=========================================================================*)
(* ARC BARREL v0 (2026-11-13) *)
(* - geometry: src/ARCBarrel.wl, numbers from the ARC XML and C++ constructor (src/ARCGeometryData.wl) *)
(* - Optica surfaces: src/ARCBarrelOptica.wl (OpticaEM) *)
(* - global frame {Z beam, X, Y}: Optica first axis along the beam, as in the LHCb optics *)
(* - checked in arc.nb (cell 1: 36/36 photons on the sensor, ring radius 8.82 mm) *)
(*=========================================================================*)
(**)
ClearAll[arcRow,arcPhi,arcFullBoundaryModel,arcIncludeCooling,arcBarrel,arcCell,arcCellNumbers,arcCellSystem];
(*the ARC files are loaded once per kernel; ARCBarrelOptica.wl stops the evaluation if OpticaEM is not available*)
If[!MemberQ[$Packages,"ARCBarrel`"],Get[RICHProjectPath["src","ARCBarrel.wl"]]];
If[!MemberQ[$Packages,"ARCBarrelOptica`"],Get[RICHProjectPath["src","ARCBarrelOptica.wl"]]];


(* ::Input::Initialization:: *)
(**)
(*=========================================================================*)
(* SWITCHES AND PARAMETERS *)
(*=========================================================================*)
arcRow=1;(*1, 2 or "Both": the cells of one eta row at the same azimuth (row 1: 17 cells, row 2: 16)*)
arcPhi=0.;(*physical azimuth of the cell centres (rad): 0 puts the row in the z-x plane, as the LHCb side view*)
arcFullBoundaryModel=False;(*False: inner mirror surface, aerogel and cooling faces, sensor front (as in arc.nb); True: every solid face*)
arcIncludeCooling=True;
(**)
(*=========================================================================*)
(* ENVELOPE (beam first): vessel length 4400 mm, outer radius 2125 mm *)
(*=========================================================================*)
myBoundary={Boundary[{-2300.,-2200.,-2200.},{2300.,2200.,2200.}]};
(**)
(*=========================================================================*)
(* RADIATOR AND SENSOR FOR THE YIELD: TEMPORARY (2026-11-13) *)
(* the LHCb RICH1 gas C4F10-980-293 and the sensor chosen in the run options (theSensor), until the ARC *)
(* radiators (aerogel and C4F10_PFRICH, tables in ARCGeometryData.wl) and the ARC SiPM are added to *)
(* calcRICHYield (RICH.wl). The ARC rays and the Optica media still use the ARC tables (ARCIndex, ARCOpticaMedia) *)
(*=========================================================================*)
ClearAll[resultsCalcRICHYield];
If[simulateCherenkovLightYield==True,
resultsCalcRICHYield=RICHYieldOnce["C4F10-980-293",(*FIX 2026-11-13: calculated again only when its inputs change*)\[Lambda]MinRef,\[Lambda]MaxRef,1,theSensor,nominalLengthRich1,10000,True,numQuantiles];
integratedFullYieldPerMeter=resultsCalcRICHYield[[-32]];(*same magic number as setExternalParameters*)
];


(* ::Input::Initialization:: *)
(**)
(*=========================================================================*)
(* NO MORE CHANGES OF PARAMETERS AFTER HERE *)
(*=========================================================================*)
arcBarrel=ARCBarrel`ARCBarrel["Row"->arcRow,"Phi"->arcPhi];
arcCellNumbers=#["SignedNumber"]&/@arcBarrel["Cells"];
arcCell[n_]:=SelectFirst[arcBarrel["Cells"],#["SignedNumber"]==n&];
(*one Optica system per cell, built when first used: the sources trace each cell alone, as in arc.nb*)
arcCellSystem[n_]:=arcCellSystem[n]=ARCBarrelOptica`ARCOpticaSystem[Append[arcBarrel,"Cells"->{arcCell[n]}],
"FullBoundaryModel"->arcFullBoundaryModel,"IncludeCooling"->arcIncludeCooling];
(*the whole row (do not draw it: every flat face is drawn with its 1.2 m search rectangle, see arc.nb > Notes)*)
myOptics=ARCBarrelOptica`ARCOpticaSystem[arcBarrel,"FullBoundaryModel"->arcFullBoundaryModel,"IncludeCooling"->arcIncludeCooling];
If[myOptics===$Failed,
bigBanner[" ARC: the Optica system could not be built (see the messages above) "];
myOptics=.
];
(**)
miniBanner["\n",
"  ARC barrel, row ",ToString[arcRow],": ",ToString[Length[arcCellNumbers]]," cells ",ToString[arcCellNumbers],"\n",
"  per cell: spherical mirror, aerogel plate",If[arcIncludeCooling,", cooling plate",""],", sensor (one Optica system per cell: arcCellSystem[n])"
];
checkNewCreatedSymbols[];
