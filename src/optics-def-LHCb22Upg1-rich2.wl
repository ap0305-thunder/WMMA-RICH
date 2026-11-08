(* ::Package:: *)

(* ::Subsection::Initialization:: *)
(* LS2/RUN3 OPTICS for RICH = 2 *)


(* ::Input::Initialization:: *)
(**************************************************************************************************)

bigBanner[" loading optics : "<>ToString[whichOptics]<>"-"<>ToString[opticsVersion]<>" for RICH : "<>ToString[iRICH]];
doResetAllVariables[];
setExternalParameters[];
(**************************************************************************************************)(**************************************************************************************************)
checkNewCreatedSymbols[];
(*=========================================================================*)
(* SWITCHES *)
(*=========================================================================*)
useQuartzPlate=True;(*the quartz window in front of the photodetector plane is part of this optics*)
miniBanner["\n",
"  component #  ==>>  ","PRI-MIR","\n",
"  component #  ==>>  ","SEC-MIR","\n",
If[useQuartzPlate,Sequence["  component #  ==>>  ","QUA-PLA","\n"],Sequence[]],
"  component #  ==>>  ","PD","\n",
"  component #  ==>>  ","BOX"
];


(* ::Input::Initialization:: *)
(**)
(*=========================================================================*)
(* NON-SPLIT OPTICS TEMPLATE (2026-11-08): the same sections and conventions in every non-split optics-def file *)
(* - the tilts are the Optica rotations given to Move: input in degrees (tilt...Degree), tilt... in radians *)
(* - the primary mirror is placed by calcSphericalPrimaryMirror from its size, tilt, radius, thetaMinPriMir and p2z *)
(* - the secondary mirror and the photodetector plane are placed by their centres {z,x} *)
(* - the derived geometry (secondary-mirror edges and normal, paraxial focal surface, reflected points) is computed by the same block in every file *)
(* - the quartz plate is included when useQuartzPlate==True *)
(* - TO DO (later): one resonate==True strategy for all the non-split optics; until then the resonate==True branch of the numbering is specific to each file *)
(*=========================================================================*)
(**)
(*=========================================================================*)
(* GEOMETRY OF THE BUILT RICH2 - FROZEN: LHCb 2002-009 (EDR), unchanged for LS2/RUN3 (2022) *)
(* hard-coded numbers, from setData2022Rich2 = setData2009Rich2 + calc2009Rich2Geometry + setBoundaryParametersOLD (src/optics.wl) *)
(* the values that were computed there (Solve, dist, ArcTan) are written to machine precision, with the formula in a comment *)
(*=========================================================================*)
(**)
(*=========================================================================*)
(* BOUNDARY AND ACCEPTANCE *)
(*=========================================================================*)
theSensorPitch=1;(* mm *)
pixelSize=3;
minZ=9450;(*ok with LHCb-PUB-2016-XXX EDMS 1685891 13th May 2016*)
maxZ=11900;(*ok with LHCb-PUB-2016-XXX EDMS 1685891 13th May 2016*)
zBoxMin=9578.0;
zBoxMax=11705.0;
(*+/- 120 mrad acceptance real-HOR*)
thrdDimAcc=100/1000.0;
trnsvrsAcc=120/1000.0;
minAcc=15.0/1000.0;

thrdDimMinAcc=minAcc;

trnsvrsMinAcc=minAcc;

maxXAcc:=trnsvrsAcc;(*X<->Y swapped between the two riches*)
maxYAcc:=thrdDimAcc;(*X<->Y swapped between the two riches*)
minThetaTrsvrsTrack=0.030;(*use 2000mm path length*)
(*=========================================================================*)
(*=========================================================================*)

(*
l000z=(11245-9450);
l000:=l000z;
l120z=(11705-9450);
l120:=l120z/Cos[.12];
halfOpenAngle=0.0313*(180/\[Pi]);
*)
(**)
(*=========================================================================*)
(* REFERENCE POINTS OF LHCb 2002-009 {z, transverse} (p*y is the transverse coordinate, x in this code) *)
(*=========================================================================*)
(*documentation only: not used at run time (the values used are written in the sections below)*)
(*
zc=3291.0;
yc=3270.0;
cc={zc,yc};(*centre of the primary mirror sphere*)
(**)
p1z=11245.061855429589;(*sphere at p1y: z/.Solve[circumference[zc,yc,radiusPriMir,z,p1y]==0,z][[2]]*)
p1y=0;
p1={p1z,p1y};
p2z=11705;
p2y=1491.066611702394;(*sphere at p2z: y/.Solve[circumference[zc,yc,radiusPriMir,p2z,y]==0,y][[1]]*)
p2={p2z,p2y};
(**)
(*p3z=(2848-1234)*Tan[.185]+9578;*)
p3z=9880;
p3y=1234.0;
p3={p3z,p3y};
p4y=2848.0;
p4z=9578.0;
p4={p4z,p4y};
(**)
p8z=10761.0;
p8y=3892.0;
p8={p8z,p8y};
p7={11059.303024498691,3726.784063798515};(*=p8+{Cos[\[Pi]/2-1.065],-Sin[\[Pi]/2-1.065]}*682/2*)
p9={10462.696975501309,4057.215936201485};(*=p8-{Cos[\[Pi]/2-1.065],-Sin[\[Pi]/2-1.065]}*682/2*)
p7z=p7[[1]];
p7y=p7[[2]];
p9z=p9[[1]];
p9y=p9[[2]];
*)
(**)
(*=========================================================================*)
(* SIZE TRNSVRS DIM *)
(*=========================================================================*)
sizeTrnsvrsPriMir=1560.391853786904;(*=dist[p1z,p1y,p2z,p2y]*)
sizeTrnsvrsSecMir=1642.0109622045768;(*=dist[p3z,p3y,p4z,p4y]*)
sizeTrnsvrsScreen=681.9999999999998;(*=dist[p7z,p7y,p9z,p9y], nominally 682*)
(**)
(*=========================================================================*)
(* SIZE THIRD DIM *)
(*=========================================================================*)
sizeThrdDimPriMir=2500.;
sizeThrdDimSecMir=2000.;
sizeThrdDimScreen=1500.;
(**)
(*=========================================================================*)
(* TILT (Optica rotations, in degrees) *)
(*=========================================================================*)
(*up to 2026-11-07 this file used the chord tilts of LHCb 2002-009 (162.857..., 10.598...) and Move added 180 degrees for the two mirrors: here the 180 is in the tilt*)
tiltPriMirDegree=180+162.8569671903692;(*162.857... = chord tilt = 180+ArcTan[-1/AngCoeff[p1z,p1y,p2z,p2y]]/Degree*)
tiltSecMirDegree=180+10.59822026798452;(*10.598... = chord tilt = ArcTan[-1/AngCoeff[p4z,p4y,p3z,p3y]]/Degree*)
tiltScreenDegree=1.065/Degree;(*1.065 rad*)
(**)
tiltPriMir=tiltPriMirDegree Degree;
tiltSecMir=tiltSecMirDegree Degree;
tiltScreen=tiltScreenDegree Degree;
(**)
theThetaMinSecMir=0.12425533587803288;(*=ArcTan[p3y/p3z]: not used by this template (the secondary mirror is placed by its centre), kept for reference*)
thetaMinSecMir=theThetaMinSecMir;
(**)
(*=========================================================================*)
(* ABSCISSA AND ORDINATE *)
(*=========================================================================*)
p2z=11705;(*primary mirror: z of the far end of the mirror chord (zPriMirMax), input of calcSphericalPrimaryMirror*)
p4z=9578.0;(*z of the near end of the secondary mirror (p4): not used by this template, kept for reference*)
zSecMir=9729.0;(*secondary-mirror centre = (p3+p4)/2*)
xSecMir=2041.0;
zScreen=10761.0;(*photodetector-plane centre = p8*)
xScreen=3892.0;
(**)
(*=========================================================================*)
(* RADII *)
(*=========================================================================*)
radiusPriMir=8600;
radiusSecMir=0.0;
thetaMinPriMir=0.0;
(*deltaSphMirr=0;*)
(**)
thickSecMir=0;(*ok for rich, zero dielectric substrate*)(*it screams if thickness is in SphericalMirror*)
thickPriMir=0;(*ok for rich, zero dielectric substrate*)(*it screams if thickness is in SphericalMirror*)
(**)
(*=========================================================================*)
(* QUARTZ PLATE PARAMETERS (used only if useQuartzPlate) *)
(*=========================================================================*)
testQuartzPlate=False;
tiltQuartzPlate=0;
If[testQuartzPlate==True
,
distanceQuartzPlateFromPD=-300;
quartzPlateThick=8;(*!@#$% CHECK*);
tiltScreenAddToQuartzPlateDegrees=25
,
distanceQuartzPlateFromPD=-200;
quartzPlateThick=8;
tiltScreenAddToQuartzPlateDegrees=0
];
(**)
(*=========================================================================*)
(* PHOTODETECTOR DEPTH *)
(*=========================================================================*)
PDADepth=200;
(**)
(*=========================================================================*)
(* NO MORE CHANGES OF PARAMETERS AFTER HERE *)
(*=========================================================================*)
(**)
calcSphericalPrimaryMirror[sizeTrnsvrsPriMir,tiltPriMir,radiusPriMir,thetaMinPriMir,p2z];
(**)
(*=========================================================================*)
(* DERIVED GEOMETRY (common block): secondary-mirror edges and normal, paraxial focal surface, reflected points *)
(*=========================================================================*)
(*replaces execDoCalc (used up to 2026-11-07 by LHCb22Upg1 only), which placed the secondary mirror from p4z and theThetaMinSecMir*)
centerPriMirRefl={0,0};
edgeParaFSNear={0,0};
edgeParaFSAway={0,0};
edgeParaFSNearRefl={0,0};
edgeParaFSAwayRefl={0,0};
(**)
secMirEdges=doCalcPlaneSidewiseCoords[zSecMir,xSecMir,tiltSecMir,sizeTrnsvrsSecMir,sizeThrdDimSecMir];(*edges ordered by increasing z*)
{{zSecMirMin,xSecMirMin},{zSecMirCen,xSecMirCen},{zSecMirMax,xSecMirMax}}=secMirEdges[[1]];
secMirNorm3D=Normalize[{-(xSecMirMax-xSecMirMin),+(zSecMirMax-zSecMirMin),0}];(*secondary-mirror normal, used by the back-tracing*)
(**)
(*angle between the primary-mirror axis and the beam line, from the Optica rotation (only printed through betaVrtx)*)
calcFS[centerPriMir[[1]],centerPriMir[[2]],radiusPriMir,Abs[Mod[tiltPriMir,2\[Pi],-\[Pi]]]];
(**)
reflect0[centerPriMir[[1]],centerPriMir[[2]],dirVect[zSecMirMin-zSecMirMax,xSecMirMin-xSecMirMax],zSecMir,xSecMir];
centerPriMirRefl[[1]]=reflectedPoint[[1]];
centerPriMirRefl[[2]]=reflectedPoint[[2]];
reflect0[edgeParaFSNear[[1]],edgeParaFSNear[[2]],dirVect[zSecMirMin-zSecMirMax,xSecMirMin-xSecMirMax],zSecMir,xSecMir];
edgeParaFSNearRefl[[1]]=reflectedPoint[[1]];
edgeParaFSNearRefl[[2]]=reflectedPoint[[2]];
reflect0[edgeParaFSAway[[1]],edgeParaFSAway[[2]],dirVect[zSecMirMin-zSecMirMax,xSecMirMin-xSecMirMax],zSecMir,xSecMir];
edgeParaFSAwayRefl[[1]]=reflectedPoint[[1]];
edgeParaFSAwayRefl[[2]]=reflectedPoint[[2]];
(**)
(*=========================================================================*)
(* PRIMARY MIRROR *)
(*=========================================================================*)
priMirror=Move[SphericalMirror[
{radiusPriMirVar,-radiusPriMir},
{sizeTrnsvrsPriMir,sizeThrdDimPriMir},
(*thickPriMir,*)
"PRI-MIR-NOW",
FlatSubstrate->False,
FrontSurface->True
],(*FlatSubstrate->False gives errors inside my routines???*)
{{zPriMirVar,zVrtxPriMir},{xPriMirVar,xVrtxPriMir}},{tiltPriMirVar,tiltPriMir/Degree}
];
(**)
(*=========================================================================*)
(* SECONDARY MIRROR *)
(*=========================================================================*)
secMirror=Move[SphericalMirror[
{radiusSecMirVar,radiusSecMir},
{sizeTrnsvrsSecMir,sizeThrdDimSecMir},
(*thickSecMir,*)
"SEC-MIR-NOW",
FlatSubstrate->False,
FrontSurface->True
],(*FlatSubstrate->False gives errors inside my routines???*)
{{zSecMirVar,zSecMir},{xSecMirVar,xSecMir}},{tiltSecMirVar,tiltSecMir/Degree}
];
(**)
(*=========================================================================*)
(* QUARTZ PLATE (only if useQuartzPlate) *)
(*=========================================================================*)
If[useQuartzPlate,
(*QUARTZ PLATE//TO FIX/check (wavlen model)*)
Print["Optical Medium data \n",TableForm@Transpose@SearchData[OpticalMedium->"F_SILICA"]];
quartzPlateDist:={zQuartzPlateDist,xQuartzPlateDist};
{zQuartzPlateDist,xQuartzPlateDist}=
distanceQuartzPlateFromPD*{Cos[tiltScreen],Sin[tiltScreen]}+{zScreen,xScreen};(*set delayed does not work*)
quartzPlate=Move[PlanoConvexLens[
0,{sizeTrnsvrsScreen,sizeThrdDimScreen},
quartzPlateThick,
"QUA-WIN-NOW",
Transmittance->100,
OpticalMedium->"F_SILICA",
DesignWaveLength->0.350],
{{zQuartzPlateDistVar,zQuartzPlateDist},{xQuartzPlateDistVar,xQuartzPlateDist}},{tiltQuartzPlateVar,tiltScreenAddToQuartzPlateDegrees+tiltScreen/Degree}(*here tiltScreen!*)
];
];
(*Transmittance\[Rule]0.5,Reflectance\[Rule]0.5,CurvatureDirection\[Rule]Back,SwitchDirectionOnReflection\[Rule]True*)
(**)
(*=========================================================================*)
(* PHOTODETECTOR PLANE *)
(*=========================================================================*)
thePDA=Move[Screen[
{sizeTrnsvrsScreen,sizeThrdDimScreen},
"THE-PDA-NOW",
Transmittance->0],
{{zScreenVar,zScreen},{xScreenVar,xScreen}},{tiltScreenVar,tiltScreen/Degree}];
(**)
(*=========================================================================*)
(* COMPONENT NUMBERING *)
(*=========================================================================*)
(* Sequential tracking follows the numbering here.... *)
(* If you use Resonate the component numbering changes!!! some functions may stop working *)
(* Boundary is the last one *)
(**)
printD@resonate;
Unprotect[onThePriMirror,onTheSecMirror,onTheTerMirror,onTheQuartzPlateFron,onTheQuartzPlateBack,onTheFS,onTheBox];
If[resonate==True
(*=========================================================================*)
,
(*==================================================================================================*)
(* resonate == True *)
(* TO DO (later): ONE resonate==True strategy for all the non-split optics (LHCb22Upg1 resonates {pri,sec,quartz} together, FTDR resonates each component); until then this branch is specific to this file *)
priMirrorNumber=1;
secMirrorNumber=1;
quartzPlateNumber=1;
focalSurfaceNumber=2;
boxNumber=3;
terMirrorNumber=0;
priMirrorSurfNumber=1;
secMirrorSurfNumber=2;
quartzPlateSurfNumberFron=3;
quartzPlateSurfNumberBack=4;
focalSurfaceSurfNumber=1;
terMirrorSurfNumber=0;
(**)
myOptics:={Resonate[{priMirror,secMirror,quartzPlate}],thePDA};(* with PDA in resonate.. strange traces appear *)
(**)
onThePriMirror:={ComponentNumber->priMirrorNumber,SurfaceNumber->priMirrorSurfNumber};
onTheSecMirror:={ComponentNumber->secMirrorNumber,SurfaceNumber->secMirrorSurfNumber};
onTheTerMirror:={ComponentNumber->terMirrorNumber,SurfaceNumber->terMirrorSurfNumber};
onTheQuartzPlateFron:={ComponentNumber->quartzPlateNumber,SurfaceNumber->quartzPlateSurfNumberFron};
onTheQuartzPlateBack:={ComponentNumber->quartzPlateNumber,SurfaceNumber->quartzPlateSurfNumberBack};
onTheFS:={ComponentNumber->focalSurfaceNumber,SurfaceNumber->focalSurfaceSurfNumber};
onTheBox:={ComponentNumber->boxNumber};
(**)
theTrackOrigin:={ComponentNumber->priMirrorNumber,SurfaceNumber->1};
,
(*==================================================================================================*)
(* resonate == False: the same for every non-split optics *)
priMirrorNumber=1;
secMirrorNumber=2;
quartzPlateNumber=If[useQuartzPlate,3,0];
focalSurfaceNumber=If[useQuartzPlate,4,3];
boxNumber=focalSurfaceNumber+1;
terMirrorNumber=0;
priMirrorSurfNumber=1;
secMirrorSurfNumber=1;
quartzPlateSurfNumberFron=If[useQuartzPlate,1,0];
quartzPlateSurfNumberBack=If[useQuartzPlate,2,0];
focalSurfaceSurfNumber=1;
terMirrorSurfNumber=0;
(**)
myOptics:=Join[{priMirror,secMirror},If[useQuartzPlate,{quartzPlate},{}],{thePDA}];
(**)
onThePriMirror:={ComponentNumber->priMirrorNumber,SurfaceNumber->priMirrorSurfNumber};
onTheSecMirror:={ComponentNumber->secMirrorNumber,SurfaceNumber->secMirrorSurfNumber};
onTheTerMirror:={ComponentNumber->terMirrorNumber,SurfaceNumber->terMirrorSurfNumber};
onTheQuartzPlateFron:={ComponentNumber->quartzPlateNumber,SurfaceNumber->quartzPlateSurfNumberFron};
onTheQuartzPlateBack:={ComponentNumber->quartzPlateNumber,SurfaceNumber->quartzPlateSurfNumberBack};
onTheFS:={ComponentNumber->focalSurfaceNumber,SurfaceNumber->focalSurfaceSurfNumber};
onTheBox:={ComponentNumber->boxNumber};
(**)
theTrackOrigin:={ComponentNumber->priMirrorNumber,SurfaceNumber->1};
];
(**)
Protect[onThePriMirror,onTheSecMirror,onTheTerMirror,onTheQuartzPlateFron,onTheQuartzPlateBack,onTheFS,onTheBox];
(**)

checkNewCreatedSymbols[];
