(* ::Package:: *)

(* ::Subsection::Initialization:: *)
(*(*(*(*(*(*(*(* FTDR OPTICS for RICH=2 *)*)*)*)*)*)*)*)


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
useQuartzPlate=False;(*no quartz plate in this optics yet (TO ADD THE QUARTZ PLATE)*)
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
(* GEOMETRY OF THE FTDR (Upgrade II) RICH2 - design *)
(*=========================================================================*)
(**)
(*=========================================================================*)
(* BOUNDARY AND ACCEPTANCE *)
(*=========================================================================*)
(*the values in this section are those of the RICH2 of LHCb 2002-009 (the same as in optics-def-LHCb22Upg1-rich2.wl): checked, they are valid also for the FTDR RICH2 (2026-11-08)*)
theSensorPitch=1;(* mm *)
pixelSize=3;
minZ=9450;(*ok with LHCb-PUB-2016-XXX EDMS 1685891 13th May 2016*)
maxZ=11900;(*ok with LHCb-PUB-2016-XXX EDMS 1685891 13th May 2016*)
zBoxMin=9578.0;
zBoxMax=11705.0;
(*+/- 120 mrad acceptance real-HOR*)
thrdDimAcc=100/1000.0;
trnsvrsAcc=120/1000.0;
minAcc=15.0/1000.0;maxXAcc:=trnsvrsAcc;(*X<->Y swapped between the two riches*)
maxYAcc:=thrdDimAcc;(*X<->Y swapped between the two riches*)

minThetaTrsvrsTrack=0.030;
(*use 2000mm path length*)
l000z=(11245-9450);
l000:=l000z;
l120z=(11705-9450);
l120:=l120z/Cos[.12];
halfOpenAngle=0.0313*(180/\[Pi]);
(**)
(*=========================================================================*)
(* SIZE TRNSVRS DIM *)
(*=========================================================================*)
sizeTrnsvrsPriMir = 1560.39;
sizeTrnsvrsSecMir=1700(*800*);
sizeTrnsvrsScreen=1200(*682*);
(**)
(*=========================================================================*)
(* SIZE THIRD DIM *)
(*=========================================================================*)
sizeThrdDimPriMir=2500.;
sizeThrdDimSecMir=2200.;
sizeThrdDimScreen=1500.;
(**)
(*=========================================================================*)
(* TILT (Optica rotations, in degrees) *)
(*=========================================================================*)
tiltPriMirDegree=-0.01;
tiltSecMirDegree=31(*20*);
tiltScreenDegree=64.5;
(**)
tiltPriMir=tiltPriMirDegree Degree;
tiltSecMir=tiltSecMirDegree Degree;
tiltScreen=tiltScreenDegree Degree;
(**)
(*=========================================================================*)
(* ABSCISSA AND ORDINATE *)
(*=========================================================================*)
p2z=11705;(*primary mirror: z of the far end of the mirror chord (zPriMirMax), input of calcSphericalPrimaryMirror*)
(*zPriMir=11508.9; xPriMir=0;(*3270.0*): not inputs, computed by calcSphericalPrimaryMirror*)
zSecMir=10000(*9729.8*);(*secondary-mirror centre*)
xSecMir=860;
zScreen=11250(*11550, 11700*);(*photodetector-plane centre*)
xScreen=3825(*4000*) (*4230*);
(**)
(*=========================================================================*)
(* RADII *)
(*=========================================================================*)
radiusPriMir=10000;(*radiusRefToday*N[Sqrt@2];*)(*was radiusPriMir=radiusRefToday=8600, then redefined as radiusPriMir:=10000: 10000 is the value in use*)
radiusSecMir=0.0;
thetaMinPriMir=0.0;
(**)
thickSecMir=0;(*ok for rich, zero dielectric substrate*)(*it screams if thickness is in SphericalMirror*)
thickPriMir=0;(*ok for rich, zero dielectric substrate*)(*it screams if thickness is in SphericalMirror*)
(**)
(*=========================================================================*)
(* QUARTZ PLATE PARAMETERS (used only if useQuartzPlate) *)
(*=========================================================================*)
(*not used: useQuartzPlate==False*)
(**)
(*=========================================================================*)
(* PHOTODETECTOR DEPTH *)
(*=========================================================================*)
(*PDADepth: not set for this optics*)
(**)
(*=========================================================================*)
(* EXPERIMENTS (inactive): ellipsoidal/custom primary mirror // REMOVED *)
(*=========================================================================*)
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
secMirrorNumber=2;
terMirrorNumber=0;
focalSurfaceNumber=3;
boxNumber=4;
quartzPlateNumber=0;(*FIX 2026-11-07: no quartz plate in this optics (a stale value from a previous optics would point to another component)*)
priMirrorSurfNumber=0;
secMirrorSurfNumber=0;
quartzPlateSurfNumberFron=0;
quartzPlateSurfNumberBack=0;
focalSurfaceSurfNumber=0;
terMirrorSurfNumber=0;
(* !@#$% check/correct numbering above *)
(**)
(* redefine for resonate !@#$% to fix *)
onThePriMirror:={ComponentNumber->priMirrorNumber};
onTheSecMirror:={ComponentNumber->secMirrorNumber};
onTheTerMirror:={ComponentNumber->terMirrorNumber};
onTheQuartzPlateFron:={ComponentNumber->quartzPlateNumber};
onTheQuartzPlateBack:={ComponentNumber->quartzPlateNumber};
onTheFS:={ComponentNumber->focalSurfaceNumber};
onTheBox:={ComponentNumber->boxNumber};
theTrackOrigin:={ComponentNumber->priMirrorNumber};
(**)
myOptics:=
(*Resonate[ *)(* !@#$% NOT SURE WHETHER IT IS BETTER TO RESONATE THE WHOLE OR NOT... *)
{
(* component # 1 *)
Resonate[{priMirror},"PRI-MIR"]
,
(* component # 2 *)
Resonate[{secMirror},"SEC-MIR"]
(*,
(* component # 3 *)Resonate[{terMirror},"TER-MIR"]*)
,
(* component # 4 *)
Resonate[{thePDA(*,thePDAT*)},"PD"]
}
(*]*)
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
