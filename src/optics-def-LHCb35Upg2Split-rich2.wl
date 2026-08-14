(* ::Package:: *)

(* ::Subsection::Initialization:: *)
(*(*(* SPLIT OPTICS for RICH=2 *)*)*)


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------------------------------*)
bigBanner[" loading optics : "<>ToString[whichOptics]<>" for RICH : "<>ToString[iRICH]];
(*--------------------------------------------------------------------------------------------------------*)
doResetAllVariables[];
setExternalParameters[];
(**************************************************************************************************)
If[(whichOptics=="LHCb35Upg2Split")&&(iRICH==2),
(**************************************************************************************************)
debugThisOptics=False;
fullBackMirror=True;
(*Clear[apertPriMirL,apertPriMirH];*)
miniBanner["TO ADD THE QUARTZ PLATE"];
miniBanner["\n",
"  component # 1 ==>>  ","PRI-MIR","\n",
"  component # 2 ==>>  ","SEC-MIR","\n",
(*"  component # 3 ==>>  ","TER-MIR","\n",*)
(*"  component # TBD ==>>  ","QUA-PLA","\n",*)
"  component # 3 ==>>  ","PD","\n",
"  component # 4 ==>>  ","BOX"
];
(**)
(*=========================================================================*)
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
(*sizeTrnsvrsPriMir=0;*)
sizeTrnsvrsPriMirL=265;
sizeTrnsvrsPriMirH=700;
(**)
sizeTrnsvrsSecMirL=500;
sizeTrnsvrsSecMirH=400;
(**)
(*sizeTrnsvrsTerMir=500;*)
(**)
sizeTrnsvrsScreenL=520;
sizeTrnsvrsScreenH=670;
sizeTrnsvrsScreenT=430;
(**)
(*=========================================================================*)
(* SIZE THIRD DIM // MANY RELATIVIZED *)
(*=========================================================================*)
(**)
sizeThrdDimPriMir0=2000;(* according to aperture this is half-size by def. *)
sizeThrdDimPriMirL:=sizeThrdDimPriMir0;(* apertPriMirL: this is half-size by def. *)
sizeThrdDimPriMirH:=sizeThrdDimPriMir0;(* apertPriMirH: this is half-size by def. *)
(**)
sizeThrdDimSecMir0:=2*sizeThrdDimPriMir0;(*need the 2* due to different definitions of PriMir/SecMir*)
sizeThrdDimSecMirL:=sizeThrdDimSecMir0;
sizeThrdDimSecMirH:=sizeThrdDimSecMir0;
(**)
sizeThrdDimTerMir:=sizeThrdDimSecMir0;
(**)
sizeThrdDimScreen0=1600;
sizeThrdDimScreenL:=sizeThrdDimScreen0;
sizeThrdDimScreenH:=sizeThrdDimScreen0;
sizeThrdDimScreenT:=sizeThrdDimScreen0;
(**)
(*=========================================================================*)
(* TILT *)
(*=========================================================================*)
tiltPriMirLDegree=-1;
tiltPriMirL:=tiltPriMirLDegree Degree; (* to radian *)
tiltPriMirHDegree=-15.5;
tiltPriMirH=tiltPriMirHDegree Degree;
(**)
tiltSecMirLDegree=30;
tiltSecMirL:=tiltSecMirLDegree Degree;(* to radian *)
tiltSecMirHDegree=18;
tiltSecMirH:=tiltSecMirHDegree Degree;(* to radian *)
(**)
tiltTerMirDegree=385;
tiltTerMir:=tiltTerMirDegree Degree; (* to radian *)
(**)
tiltScreenL=60. Degree;
tiltScreenH=56. Degree;
(**)
tiltScreenTDegree=125.;
tiltScreenT:=tiltScreenTDegree Degree;
(**)
(*=========================================================================*)
(* ABSCISSA AND ORDINATE *)
(*=========================================================================*)
(**)
zPriMirL=11609;
xPriMirL=0;
zPriMirH=11559;
xPriMirH=0;
zSecMirL=9730;
xSecMirL=300;
zSecMirH=9750;
xSecMirH=1770;
(**)
zScreenL=11340;
xScreenL=3100;
zScreenH=10820;
xScreenH=3610;
(**)
centerPriMirL={0,0};(*needed to define as a 2D pair*)
centerPriMirH={0,0};(*needed to define as a 2D pair*)
centerPriMirLRefl={0,0};(*needed to define as a 2D pair*)
centerPriMirHRefl={0,0};(*needed to define as a 2D pair*)
(**)
edgeParaFSNear={0,0};
edgeParaFSAway={0,0};
edgeParaFSNearRefl={0,0};
edgeParaFSAwayRefl={0,0};
thetaMinPriMirL=0.0;
(**)
(*=========================================================================*)
(*RADII*)
(*=========================================================================*)
radiusSecMir=0.0;
radiusSecMirL:=radiusSecMir;
radiusSecMirH:=radiusSecMir;
radiusRefToday=8600;
(*deltaRadiusL=0;BETTER TO AVOID...*)
(*deltaRadiusH=0;BETTER TO AVOID...*)
radiusPriMirL:=radiusRefToday*N[Sqrt[1.5]];
radiusPriMirH:=radiusRefToday;
(**)
(*=========================================================================*)
(* APERTURES *)
(*=========================================================================*)
delta2PriMirHTrnsvrs=0.(*100.*);
delta2PriMirHThrdDim=10.(*50.*);
sizeTrnsvrsPriMirH2:=(*300*)sizeTrnsvrsPriMirH;
delta1PriMirHTrnsvrs:=2*sizeTrnsvrsPriMirH2/3;
delta1PriMirHThrdDim:=2*sizeThrdDimPriMirH/3;
(**)
(*=========================================================================*)
(*SHIFT THE PDA*)(* ??? WRONG IMPLEMENTATION: TO FIX*)
(*=========================================================================*)
(* theShiftOfThePDAL=-20;*)(* rubbish!!! to fix to manage PDA perpendicular shifts *)
(* theShiftOfThePDAH=-1;*)(* rubbish!!! to fix to manage PDA perpendicular shifts *)
(* shiftThePDAL[d_]:={zScreenL=N[zScreenL+d*Cos[tiltScreenL]],xScreenL=N[xScreenL+d*Sin[tiltScreenL]]};*)(* rubbish!!! to fix to manage PDA perpendicular shifts *)
(* shiftThePDAH[d_]:={zScreenH=N[zScreenH+d*Cos[tiltScreenH]],xScreenH=N[xScreenH+d*Sin[tiltScreenH]]};*)(* rubbish!!! to fix to manage PDA perpendicular shifts *)
(**)
theShiftOfThePDAL=0.0(*-20*);(*WRONG IMPLEMENTATION: TO FIX*)
theShiftOfThePDAH=0.0(*-1*);(*WRONG IMPLEMENTATION: TO FIX*)
shiftThePDAL[d_]={N[zScreenL+d*Cos[tiltScreenL]],N[xScreenL+d*Sin[tiltScreenL]]};
shiftThePDAH[d_]={N[zScreenH+d*Cos[tiltScreenH]],N[xScreenH+d*Sin[tiltScreenH]]};
(**)
(*=========================================================================*)
(* TESTING CHANGES : temporary modifying values already defined above *)
(*=========================================================================*)
(*sizeThrdDimPriMirL=1500/3;*)
(*sizeTrnsvrsPriMir=325;*)
(*sizeTrnsvrsPriMirL:=sizeTrnsvrsPriMir;*)
(**)
(*=========================================================================*)
(* NO MORE CHANGES OF PARAMETERS AFTER HERE *)
(*=========================================================================*)
(*=========================================================================*)
(**)
{zc0L,xc0L,yc0L}:={-radiusPriMirL(*-deltaRadiusL*),0,0};(* The base surface vertex passes by the origin; then it is moved by Move *)
{a1,b1,c1}={1,1,1};
Print[Plot3D[ellipse3D[a1,b1,c1,radiusPriMirL,rt,r3,zc0L,xc0L,yc0L],
{rt,-bigBox/10,+bigBox/10},{r3,-bigBox/10,+bigBox/10},
AspectRatio->Automatic,Axes->True,AxesLabel->Automatic]
];
(**)
(*=========================================================================*)
(*=========================================================================*)
(*BE CAREFUL NOT TO HAVE DUPLICATE POINTS IN THE APERTURE!!!*)
(*OPTICA joins the first and last point of the aperture*)
apertPriMirL:={
{0,-sizeThrdDimPriMirL},
{+sizeTrnsvrsPriMirL,-sizeThrdDimPriMirL},
{+sizeTrnsvrsPriMirL,+sizeThrdDimPriMirL},
{0,+sizeThrdDimPriMirL}
};
If[Length@apertPriMirL!=Length@DeleteDuplicates@apertPriMirL,miniBanner["STOP"];killStop];
If[debugThisOptics==True
,
apertPriMirL:=1*sizeTrnsvrsPriMirL
];
priMirrorL:=Move[
CustomMirror[Function[Evaluate[ellipse3D[a1,b1,c1,radiusPriMirL,#1,#2,zc0L,xc0L,yc0L]]],
apertPriMirL,
"PRI-MIR-L",
SurfaceRayIntersections->Symbol,
LabelPositions->{{0,0,0}}],
{{zPriMirLVar,zPriMirL},
{xPriMirLVar,xPriMirL}},
{tiltPriMirLVar,tiltPriMirL/Degree}];
(**)
(*=========================================================================*)
(**)
{zc0H,xc0H,yc0H}:={-radiusPriMirH(*-deltaRadiusH*),0,0};(* The base surface vertex passes by the origin; then it is moved by Move *)
{a2,b2,c2}={1,1,1};
Print[Plot3D[ellipse3D[a2,b2,c2,radiusPriMirH,rt,r3,zc0H,xc0H,yc0H],
{rt,-bigBox/10,+bigBox/10},{r3,-bigBox/10,+bigBox/10},AspectRatio->Automatic,Axes->True,AxesLabel->Automatic]];
(**)
(*BE CAREFUL NOT TO HAVE DUPLICATE POINTS IN THE APERTURE!!!*)
(*OPTICA joins the first and last point of the aperture*)
If[fullBackMirror==True,
apertPriMirH:={
{0,-sizeThrdDimPriMirH},
{+sizeTrnsvrsPriMirH,-sizeThrdDimPriMirH},
{+sizeTrnsvrsPriMirH,+sizeThrdDimPriMirH},
{0,+sizeThrdDimPriMirH}
},
(*xPriMirH=0*)
apertPriMirH:={
{-sizeTrnsvrsPriMirH2+delta1PriMirHTrnsvrs-delta2PriMirHTrnsvrs,+delta2PriMirHThrdDim},
{-sizeTrnsvrsPriMirH2+delta1PriMirHTrnsvrs,+sizeThrdDimPriMirH-delta1PriMirHThrdDim},
{-sizeTrnsvrsPriMirH2,+sizeThrdDimPriMirH-delta1PriMirHThrdDim},
{-sizeTrnsvrsPriMirH2,+sizeThrdDimPriMirH},
{+sizeTrnsvrsPriMirH2,+sizeThrdDimPriMirH},
{+sizeTrnsvrsPriMirH2,-sizeThrdDimPriMirH},
{-sizeTrnsvrsPriMirH2,-sizeThrdDimPriMirH},
{-sizeTrnsvrsPriMirH2,-sizeThrdDimPriMirH+delta1PriMirHThrdDim},
{-sizeTrnsvrsPriMirH2+delta1PriMirHTrnsvrs,-sizeThrdDimPriMirH+delta1PriMirHThrdDim},
{-sizeTrnsvrsPriMirH2+delta1PriMirHTrnsvrs-delta2PriMirHTrnsvrs,-delta2PriMirHThrdDim}
}
];
If[Length@apertPriMirH!=Length@DeleteDuplicates@apertPriMirH,miniBanner["STOP"];killStop];
If[debugThisOptics==True
,
apertPriMirH:=1*sizeTrnsvrsPriMirH
];
priMirrorH:=Move[
CustomMirror[Function[Evaluate[ellipse3D[a2,b2,c2,radiusPriMirH,#1,#2,zc0H,xc0H,yc0H]]],
apertPriMirH,
"PRI-MIR-H",
SurfaceRayIntersections->Symbol,
LabelPositions->{{0,0,0}}],
{{zPriMirHVar,zPriMirH},
{xPriMirHVar,xPriMirH}},
{tiltPriMirHVar,tiltPriMirH/Degree}
];
(**)
miniBanner[" superimposed drawings of the apertures"];
Print@Graphics[
{{Pink,Thick,Dashed,Line[swapTheXYCoords/@apertPriMirL]},{Blue,Thick,Dashed,Line[swapTheXYCoords/@apertPriMirH]}},
Axes->None];
(**)
(*=========================================================================*)
apertSecMirL:={sizeTrnsvrsSecMirL,sizeThrdDimSecMirL};
secMirrorL:=Move[
SphericalMirror[{radiusSecMirLVar,radiusSecMirL},
apertSecMirL,
"SEC-MIR-L",
(*Transmittance->0.5,Reflectance->0.5,*)(*how it works?*)
FlatSubstrate->False,
FrontSurface->True],
{{zSecMirLVar,zSecMirL},
{xSecMirLVar,xSecMirL}},
{tiltSecMirLVar,tiltSecMirL/Degree}
];
(**)
(*=========================================================================*)
apertSecMirH:={sizeTrnsvrsSecMirH,sizeThrdDimSecMirH};
secMirrorH:=Move[
SphericalMirror[{radiusSecMirHVar,radiusSecMirH},
apertSecMirH,
"SEC-MIR-H",
FlatSubstrate->False,
FrontSurface->True],
{{zSecMirHVar,zSecMirH},
{xSecMirHVar,xSecMirH}},
{tiltSecMirHVar,tiltSecMirH/Degree}
];
(**)
(*=========================================================================*)
terMirror:=Move[
SphericalMirror[{radiusTerMirVar,0},
{sizeTrnsvrsTerMir,sizeThrdDimTerMir},
"TER-MIR",
FlatSubstrate->False,
FrontSurface->True],
{{zTerMirVar,zTerMir},
{xTerMirVar,xTerMir}},
{tiltTerMirVar,tiltTerMir/Degree}];
(**)
(*=========================================================================*)
apertScreenL:={sizeTrnsvrsScreenL, sizeThrdDimScreenL};
thePDAL:=Move[
Screen[apertScreenL,
"PDA-L",
Transmittance->0,
GraphicDesign->Wire
],{
{zScreenLVar,zScreenL(*=shiftThePDAL[theShiftOfThePDAL][[1]]*)},(* rubbish!!! to fix to manage PDA perpendicular shifts *)
{xScreenLVar,xScreenL(*=shiftThePDAL[theShiftOfThePDAL][[2]]*)}(* rubbish!!! to fix to manage PDA perpendicular shifts *)
},
{tiltScreenLVar,tiltScreenL/Degree}];
(**)
(*=========================================================================*)
apertScreenH:={sizeTrnsvrsScreenH, sizeThrdDimScreenH};
thePDAH:=Move[
Screen[apertScreenH,
"PDA-H",
Transmittance->0,
GraphicDesign->Wire
],{
{zScreenHVar,zScreenH(*=shiftThePDAH[theShiftOfThePDAH][[1]]*)},(* rubbish!!! to fix to manage PDA perpendicular shifts *)
{xScreenHVar,xScreenH(*=shiftThePDAH[theShiftOfThePDAH][[2]]*)}(* rubbish!!! to fix to manage PDA perpendicular shifts *)
},
{tiltScreenHVar,tiltScreenH/Degree}];
(**)
(*=========================================================================*)
thePDAT:=Move[
Screen[{sizeTrnsvrsScreenT,sizeThrdDimScreenT},
"PDA-T",
Transmittance->0,
GraphicDesign->Wire
],
{{zScreenTVar,zScreenT},
{xScreenTVar,xScreenT}},
{tiltScreenTVar,tiltScreenT/Degree}];
(**)
(*Print[" delta paraxial focal distance two mirrors  = ",(radiusPriMirL-radiusPriMirH)/2];*)
(**)
(*=========================================================================*)
(**)
printD@resonate;
(*???ELSEWHERE*)
(*=========================================================================*)
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
Resonate[{priMirrorL,priMirrorH},"PRI-MIR"]
,
(* component # 2 *)
Resonate[{secMirrorL,secMirrorH},"SEC-MIR"]
(*,
(* component # 3 *)Resonate[{terMirror},"TER-MIR"]*)
,
(* component # 4 *)
Resonate[{thePDAL,thePDAH(*,thePDAT*)},"PD"]
}
(*]*)
,
(*==================================================================================================*)
(* resonate == False *)
(*???ELSEWHERE*)
priMirrorNumber=1;
secMirrorNumber=3;
terMirrorNumber=0;
focalSurfaceNumber=5;
boxNumber=7;
priMirrorSurfNumber=1;
secMirrorSurfNumber=1;
quartzPlateSurfNumberFron=0;
quartzPlateSurfNumberBack=0;
focalSurfaceSurfNumber=1;
terMirrorSurfNumber=0;
(* !@#$% check/correct numbering above *)
(**)
myOptics:={priMirrorL,priMirrorH,secMirrorL,secMirrorH,thePDAL,thePDAH};
myOpticsL:={priMirrorL,secMirrorL,thePDAL};
myOpticsH:={priMirrorH,secMirrorH,thePDAH};
];
(**)
(*=========================================================================*)
(*=========================================================================*)
(*radiusPriMir=radiusPriMirL;*)
(*calcSphericalPrimaryMirror[sizeTrnsvrsPriMirL,tiltPriMirL ,radiusPriMirL,thetaMinPriMirL,p2z];*)
(*centerPriMir={0,0};*)
(**)
centerPriMirL=doCalcSphereCenter[zc0L,xc0L,zPriMirL,xPriMirL,tiltPriMirL];
(**)
(*zSecMir,xSecMir,zSecMirMin,xSecMirMin,zSecMirMax,xSecMirMax*)
ecnfL=doCalcPlaneSidewiseCoords[zSecMirL,xSecMirL,tiltSecMirL,sizeTrnsvrsSecMirL,sizeThrdDimSecMirL];
zSecMirLMin=ecnfL[[1]][[1]][[1]];
xSecMirLMin=ecnfL[[1]][[1]][[2]];
zSecMirLCen=ecnfL[[1]][[2]][[1]];
xSecMirLCen=ecnfL[[1]][[2]][[2]];
zSecMirLMax=ecnfL[[1]][[3]][[1]];
xSecMirLMax=ecnfL[[1]][[3]][[2]];
(**)
calcFS[centerPriMirL[[1]],centerPriMirL[[2]],radiusPriMirL,Abs[\[Pi]-tiltPriMirL Degree]];
(**)
dirVectToReflectOnSecMirL=dirVect[zSecMirLMin-zSecMirLMax,xSecMirLMin-xSecMirLMax];
(**)
(*edgeParaFSNear==???*)
(*edgeParaFSAway==???*)
(**)
reflect0[centerPriMirL[[1]],centerPriMirL[[2]],dirVectToReflectOnSecMirL,zSecMirL,xSecMirL];
centerPriMirLRefl[[1]]=reflectedPoint[[1]];(*bad to fix add as a return[] from reflect0*)
centerPriMirLRefl[[2]]=reflectedPoint[[2]];(*bad to fix add as a return[] from reflect0*)
(**)
reflect0[edgeParaFSNear[[1]],edgeParaFSNear[[2]],dirVectToReflectOnSecMirL,zSecMirL,xSecMirL];
edgeParaFSNearRefl[[1]]=reflectedPoint[[1]];(*bad to fix add as a return[] from reflect0*)
edgeParaFSNearRefl[[2]]=reflectedPoint[[2]];(*bad to fix add as a return[] from reflect0*)
(**)
reflect0[edgeParaFSAway[[1]],edgeParaFSAway[[2]],dirVectToReflectOnSecMirL,zSecMirL,xSecMirL];
edgeParaFSAwayRefl[[1]]=reflectedPoint[[1]];(*bad to fix add as a return[] from reflect0*)
edgeParaFSAwayRefl[[2]]=reflectedPoint[[2]];(*bad to fix add as a return[] from reflect0*)
(**)
doCalcPlaneSidewiseCoords[zScreenL,xScreenL,tiltScreenL,sizeTrnsvrsScreenL,sizeThrdDimScreenL];
(**)
centerPriMirH=doCalcSphereCenter[zc0H,xc0H,zPriMirH,xPriMirH,tiltPriMirH];
(**)
(*zSecMir,xSecMir,zSecMirMin,xSecMirMin,zSecMirMax,xSecMirMax*)
ecnfH=doCalcPlaneSidewiseCoords[zSecMirH,xSecMirH,tiltSecMirH,sizeTrnsvrsSecMirH,sizeThrdDimSecMirH];
zSecMirHMin=ecnfH[[1]][[1]][[1]];
xSecMirHMin=ecnfH[[1]][[1]][[2]];
zSecMirHCen=ecnfH[[1]][[2]][[1]];
xSecMirHCen=ecnfH[[1]][[2]][[2]];
zSecMirHMax=ecnfH[[1]][[3]][[1]];
xSecMirHMax=ecnfH[[1]][[3]][[2]];
(**)
calcFS[centerPriMirH[[1]],centerPriMirH[[2]],radiusPriMirH,Abs[\[Pi]-tiltPriMirH Degree]];
(**)
dirVectToReflectOnSecMirH=dirVect[zSecMirHMin-zSecMirHMax,xSecMirHMin-xSecMirHMax];
(**)
(*edgeParaFSNear==???*)
(*edgeParaFSAway==???*)
(**)
reflect0[centerPriMirH[[1]],centerPriMirH[[2]],dirVectToReflectOnSecMirH,zSecMirH,xSecMirH];
centerPriMirHRefl[[1]]=reflectedPoint[[1]];(*bad to fix add as a return[] from reflect0*)
centerPriMirHRefl[[2]]=reflectedPoint[[2]];(*bad to fix add as a return[] from reflect0*)
(**)
reflect0[edgeParaFSNear[[1]],edgeParaFSNear[[2]],dirVectToReflectOnSecMirH,zSecMirH,xSecMirH];
edgeParaFSNearRefl[[1]]=reflectedPoint[[1]];(*bad to fix add as a return[] from reflect0*)
edgeParaFSNearRefl[[2]]=reflectedPoint[[2]];(*bad to fix add as a return[] from reflect0*)
(**)
reflect0[edgeParaFSAway[[1]],edgeParaFSAway[[2]],dirVectToReflectOnSecMirH,zSecMirH,xSecMirH];
edgeParaFSAwayRefl[[1]]=reflectedPoint[[1]];(*bad to fix add as a return[] from reflect0*)
edgeParaFSAwayRefl[[2]]=reflectedPoint[[2]];(*bad to fix add as a return[] from reflect0*)
(**)
doCalcPlaneSidewiseCoords[zScreenH,xScreenH,tiltScreenH,sizeTrnsvrsScreenH,sizeThrdDimScreenH];
(**)
(**)
(**)
];
