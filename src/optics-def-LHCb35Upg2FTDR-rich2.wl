(* ::Package:: *)

(* ::Subsection::Initialization:: *)
(*(*(*(*(*(*(* FTDR OPTICS for RICH=2 *)*)*)*)*)*)*)


(* ::Input::Initialization:: *)
(**************************************************************************************************)

bigBanner[" loading optics : "<>ToString[whichOptics]<>"-"<>ToString[opticsVersion]<>" for RICH : "<>ToString[iRICH]];
doResetAllVariables[];
setExternalParameters[];
(**************************************************************************************************)(**************************************************************************************************)
checkNewCreatedSymbols[];
miniBanner["TO ADD THE QUARTZ PLATE"];
miniBanner["\n",
"  component #  ==>>  ","PRI-MIR","\n",
"  component #  ==>>  ","SEC-MIR","\n",
"  component #  ==>>  ","PD","\n",
"  component #  ==>>  ","BOX"
];


(* ::Input::Initialization:: *)
(**)
(*=========================================================================*)
(**)
(*zBoxMin=9678.0;(*10 cm shift with respect to old version 9578*)
zBoxMax=11705.0;
thirdDimAcc=100/1000.0;
trnsvrsAcc=120/1000.0;*)
(**)
(* Se aumento b, si sparpaglia in orizzontale; riferito a rich1 ???!@#$% NO? *)
(* Se abbasso c, si avvicina il piano focale ???!@#$% NO? *)
(**)
(*=========================================================================*)
(* !@#$% to move ALL DATA SETTING BELOW to setData *)
(*=========================================================================*)
(**)
(*p4z=1075+50;*) (*needed here ???*)
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
(* TILT *)
(*=========================================================================*)
tiltPriMirLDegree=-0.01;
tiltPriMir:=tiltPriMirLDegree Degree; (* to radian *)
(**)
tiltSecMirLDegree =31(*20*);
tiltSecMirL:=tiltSecMirLDegree Degree;(* to radian *)
tiltSecMir:=tiltSecMirL;
(**)
tiltScreen =64.5 Degree;
(**)
tiltScreenTDegree=125.0;
tiltScreenT:=tiltScreenTDegree Degree;
(**)
(*=========================================================================*)
(* ABSCISSA AND ORDINATE *)
(*=========================================================================*)
(**)
zPriMir=11508.9;
xPriMir=0;(*3270.0*)
(**)
zSecMir =10000(*9729.8*);
xSecMir=860;
(**)
zScreen=11250(*11550, 11700*);
zScreenL:=zScreen;
xScreen=3825(*4000*) (*4230*);
xScreenL:=xScreen;
(**)
(*=========================================================================*)
(* EDGES AND REFERENCE POINTS *)
(*=========================================================================*)
centerPriMirRefl={0,0};
edgeParaFSNear={0,0};
edgeParaFSAway={0,0};
edgeParaFSNearRefl={0,0};
edgeParaFSAwayRefl={0,0};
thetaMinPriMir=0.0;
(**)
(*=========================================================================*)
(* RADII *)
(*=========================================================================*)
radiusSecMir=0.0;
radiusSecMirL:=radiusSecMir;
radiusSecMirH:=radiusSecMir;
radiusRefToday=8600;
radiusPriMir=radiusRefToday;
deltaRadiusL=100;
deltaRadiusH=0;
radiusPriMir:=10000;(*radiusRefToday*N[Sqrt@2];*)(*NB: this delayed definition is the one in use*)
(**)
(*thickSecMir=0;(*ok for rich, zero dielectric substrate*)(*it screams if thickness is in SphericalMirror*)
thickPriMir=0;(*ok for rich, zero dielectric substrate*)(*it screams if thickness is in SphericalMirror*)*)
(**)
p2z=11705;
(**)
(*=========================================================================*)
(* NO MORE CHANGES OF PARAMETERS AFTER HERE *)
(*=========================================================================*)
(**)
calcSphericalPrimaryMirror[sizeTrnsvrsPriMir,tiltPriMir,radiusPriMir,thetaMinPriMir,p2z];
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
{x01,y01,z01}:={-radiusPriMir-deltaRadiusL,0,0};(* The base surface vertex passes by the origin; then it is moved by Move *)
{a1,b1,c1}={1,1,1};
Print[Plot3D[ellipse3D[a1,b1,c1,radiusPriMir,rt,r3,x01,y01,z01],
{rt,-bigBox/10,+bigBox/10},{r3,-bigBox/10,+bigBox/10},
AspectRatio->Automatic,Axes->True,AxesLabel->Automatic]
];
(**)
(*=========================================================================*)
(*
(*========= paraboloid (1) ========*)
ClearAll[a,b,c,rad,x,y,z,x0,y0,z0];
rrr=radius;
{x01,y01,z01}={-rrr,0,0};(* The base surface vertex passes by the origin; then it is moved by Move *)
solutionE=Solve[((x-x0)/a)^2+((y-y0)/b)^2+((z-z0)/c)^2\[Equal]rad^2,x];
ellipse3D[a_,b_,c_,rad_,y_,z_,x0_,y0_,z0_]=x/.solutionE[[2]];
*)
(*
(*========= paraboloid (2) ========*)
CustomMirror[Function[Evaluate[ellipse3D[rrr,1,1,rrr,#1,#2,rrr^2,y01,z01]]]
*)
(*=========================================================================*)
(**)
(*BE CAREFUL NOT TO HAVE DUPLICATE POINTS IN THE APERTURE!!!*)
(*OPTICA joins the first and last point of the aperture*)
apertPriMirL:={
{0,-sizeThrdDimPriMir},
{+sizeTrnsvrsPriMirL,-sizeThrdDimPriMir},
{+sizeTrnsvrsPriMirL,+sizeThrdDimPriMir},
{0,+sizeThrdDimPriMir}
};
If[Length@apertPriMirL!=Length@DeleteDuplicates@apertPriMirL,miniBanner["STOP"];killStop];
(*priMirror=Move[
CustomMirror[Function[Evaluate[ellipse3D[a1,b1,c1,radiusPriMir,#1,#2,x01,y01,z01]]],
apertPriMirL,
"PRI-MIR-NOW",
SurfaceRayIntersections\[Rule]Symbol,
LabelPositions\[Rule]{{0,0,0}}],
(*{zPriMir,xPriMir}, tiltPriMir/Degree];*)
{{zPriMirLVar,zPriMir},
{xPriMirLVar,xPriMir}},
{tiltPriMirLVar,tiltPriMir/Degree}];*)
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
(* QUARTZ PLATE (not used in this optics) *)
(*=========================================================================*)
(*QUARTZ PLATE//TO FIX/check (wavlen model)*)
(*Print["Optical Medium data \n",TableForm@Transpose@SearchData[OpticalMedium->"F_SILICA"]];
testQuartzPlate=False;
quartzPlateDist:={zQuartzPlateDist,xQuartzPlateDist};
tiltQuartzPlate=0;
If[testQuartzPlate==True
,
distanceQuartzPlateFromPD=-300;
quartzPlateThick=8;
tiltScreenAddToQuartzPlateDegrees=25
,
distanceQuartzPlateFromPD=-200;
quartzPlateThick=8;
tiltScreenAddToQuartzPlateDegrees=0
];
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
];*)
(*Transmittance\[Rule]0.5,Reflectance\[Rule]0.5,CurvatureDirection\[Rule]Back,SwitchDirectionOnReflection\[Rule]True*)
(**)
(*=========================================================================*)
(* PHOTODETECTOR PLANE *)
(*=========================================================================*)
thePDA=Move[Screen[
{sizeTrnsvrsScreen,sizeThrdDimScreen},
"THE-PDA-NOW",
Transmittance->0],
{{zScreenVar,zScreen},{xScreenVar,xScreen}},{tiltScreenVar,tiltScreen/Degree}
];
(**)
(*=========================================================================*)
(* COMPONENT NUMBERING *)
(*=========================================================================*)
(**)
printD@resonate;
Unprotect[onThePriMirror,onTheSecMirror,onTheTerMirror,onTheQuartzPlateFron,onTheQuartzPlateBack,onTheFS,onTheBox];
If[resonate==True
(*=========================================================================*)
,
(*==================================================================================================*)
(* resonate == True *)
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
(* resonate == False *)
(*FIX 2026-11-07: myOptics below has 3 components + the boundary box; the numbers were 1/3/5/7 (copied from the 6-component SPLIT optics) and the onThe* selectors were not defined*)
priMirrorNumber=1;
secMirrorNumber=2;(*was 3*)
terMirrorNumber=0;
focalSurfaceNumber=3;(*was 5*)
boxNumber=4;(*was 7*)
quartzPlateNumber=0;(*no quartz plate in this optics*)
priMirrorSurfNumber=1;
secMirrorSurfNumber=1;
quartzPlateSurfNumberFron=0;
quartzPlateSurfNumberBack=0;
focalSurfaceSurfNumber=1;
terMirrorSurfNumber=0;
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
(**)
myOptics:={priMirror,secMirror, thePDA}
];
(**)
Protect[onThePriMirror,onTheSecMirror,onTheTerMirror,onTheQuartzPlateFron,onTheQuartzPlateBack,onTheFS,onTheBox];
(**)
Print[myOptics];
(**)
(**)

checkNewCreatedSymbols[];
