(* ::Package:: *)

(* ::Subsection:: *)
(*BUTTERFLY OPTICS for RICH=1*)


(* ::Input::Initialization:: *)
(**************************************************************************************************)

bigBanner[" loading optics : "<>ToString[whichOptics]<>"-"<>ToString[opticsVersion]<>" for RICH : "<>ToString[iRICH]];
doResetAllVariables[];
setExternalParameters[];
debugThisOptics=False;

fullBackMirror=True;
(**************************************************************************************************)(**************************************************************************************************)
checkNewCreatedSymbols[];
miniBanner["TO ADD CONSISTENTlY THE QUARTZ PLATE"];
miniBanner["\n",
"  component #  ==>>  ","PRI-MIR","\n",
"  component #  ==>>  ","SEC-MIR","\n",
"  component #  ==>>  ","TER-MIR","\n",
"  component #  ==>>  ","QUA-PLA","\n",
"  component #  ==>>  ","PD","\n",
"  component #  ==>>  ","BOX"
];


(* ::Input::Initialization:: *)
(**)
(*=========================================================================*)
(**)
(*p4z=1075+50;*) (*needed here ???*)
(*=======================================================================*)
(*helpers consistent with tuple order {z,x,y}*)
(*=======================================================================*)
azL=0 Degree;
(*LOW in z-x plane*)
azH=90 Degree;(*HIGH in z-y plane*)
tiltVectorFromAzimuth[az_,tilt_]:=Normalize[{Cos[tilt],Sin[tilt] Cos[az],Sin[tilt] Sin[az]}];
shiftAlongTilt[{z_,x_,y_},d_,az_,tilt_]:=N[{z,x,y}+d*tiltVectorFromAzimuth[az,tilt]];





(*=======================================================================*)
(*sizes:keep your existing values*)
(*=======================================================================*)


(**)
(*=========================================================================*)
(* SIZE TRNSVRS DIM *)
(*=========================================================================*)
sizeTrnsvrsPriMirL=265*3/4.+10.;
sizeTrnsvrsPriMirH=700;
sizeTrnsvrsSecMirL=250;
sizeTrnsvrsSecMirH=590;
sizeTrnsvrsTerMir=500;
sizeTrnsvrsScreenL=350;
sizeTrnsvrsScreenH=500;
sizeTrnsvrsScreenT=450;

(**)
(*=========================================================================*)
(* SIZE THIRD DIM // MANY RELATIVIZED *)
(*=========================================================================*)
sizeThrdDimPriMir0=650;
sizeThrdDimPriMirL:=sizeThrdDimPriMir0;
sizeThrdDimPriMirH:=sizeThrdDimPriMir0;
sizeThrdDimSecMir0:=2*sizeThrdDimPriMir0;
sizeThrdDimSecMirL:=sizeThrdDimSecMir0;
sizeThrdDimSecMirH:=sizeThrdDimSecMir0;
sizeThrdDimTerMir:=sizeThrdDimSecMir0;
sizeThrdDimScreen0=1500;
sizeThrdDimScreenL:=sizeThrdDimScreen0;
sizeThrdDimScreenH:=sizeThrdDimScreen0;
sizeThrdDimScreenT:=sizeThrdDimScreen0;
(*=======================================================================*)
(*roll*)
(*=======================================================================*)
rollPriMirL=0 Degree;
rollPriMirH=0 Degree;
rollSecMirL=0 Degree;
rollSecMirH=0 Degree;
rollScreenL=0 Degree;
rollScreenH=0 Degree;
(*=======================================================================*)
(*tilt*)
(*=======================================================================*)
tiltPriMirLDegree=0;
tiltPriMirL:=tiltPriMirLDegree Degree;
tiltPriMirHDegree=-7;
tiltPriMirH:=tiltPriMirHDegree Degree;
tiltSecMirLDegree=28;
tiltSecMirL:=tiltSecMirLDegree Degree;
tiltSecMir:=tiltSecMirL;
tiltSecMirHDegree=24;
tiltSecMirH:=tiltSecMirHDegree Degree;
tiltTerMirDegree=385;
tiltTerMir:=tiltTerMirDegree Degree;
tiltScreenL=57 Degree;
tiltScreenH=55 Degree;
tiltScreenTDegree=125.;
tiltScreenT:=tiltScreenTDegree Degree;
(**)
(*=========================================================================*)
(* ABSCISSA AND ORDINATE *)
(*positions in physical axes,stored as z,x,y*)
(*=========================================================================*)
(**)
zPriMirL=2150;
xPriMirL=0;
yPriMirL=0;



zPriMirH=2100;
xPriMirH=0;
yPriMirH=0;


zSecMirL=1157;
xSecMirL=130;
ySecMirL=0;

zSecMirH=1112.5;
xSecMirH=0;
ySecMirH=663;




(**)

zScreenL0=2065;
xScreenL0=1500;
yScreenL0=0;


zScreenH0=1520;
xScreenH0=0;
yScreenH0=1370;


(*=========================================================================*)
(*optional top plane*)
(*=========================================================================*)
If[!ValueQ[zScreenT0],zScreenT0=2065];
If[!ValueQ[xScreenT0],xScreenT0=0];
If[!ValueQ[yScreenT0],yScreenT0=1500];
theShiftOfThePDAL=-20;
theShiftOfThePDAH=-1;
If[!ValueQ[theShiftOfThePDAT],theShiftOfThePDAT=0];
{zScreenL,xScreenL,yScreenL}=shiftAlongTilt[{zScreenL0,xScreenL0,yScreenL0},theShiftOfThePDAL,azL,tiltScreenL];
{zScreenH,xScreenH,yScreenH}=shiftAlongTilt[{zScreenH0,xScreenH0,yScreenH0},theShiftOfThePDAH,azH,tiltScreenH];
{zScreenT,xScreenT,yScreenT}=shiftAlongTilt[{zScreenT0,xScreenT0,yScreenT0},theShiftOfThePDAT,azH,tiltScreenT];
(*=========================================================================*)
(*edges (needed here????*)
(*=========================================================================*)

edgeParaFSNear={0.,0.};
edgeParaFSAway={0.,0.};
edgeParaFSNearRefl={0.,0.};
edgeParaFSAwayRefl={0.,0.};
thetaMinPriMirL=0.0;
(**)

(*=======================================================================*)
(*radii*)
(*=======================================================================*)







radiusSecMir=0.0;
radiusSecMirL:=radiusSecMir;
radiusSecMirH:=radiusSecMir;
radiusRefToday=3650.;


deltaRadiusPriMirL=100;(*BETTER TO AVOID...*)
deltaRadiusPriMirH=0;(*BETTER TO AVOID...*)


radiusPriMirL=5000;
radiusPriMirH:=radiusRefToday;




(*=======================================================================*)
(*apertures*)
(*=======================================================================*)

delta2PriMirHTrnsvrs=0.;
delta2PriMirHThrdDim=10.;
sizeTrnsvrsPriMirH2:=sizeTrnsvrsPriMirH;
delta1PriMirHTrnsvrs:=2.*sizeTrnsvrsPriMirH2/3;
delta1PriMirHThrdDim:=2.*sizeThrdDimPriMirH/3;



(*=======================================================================*)(*no more parameter changes*)(*=======================================================================*)






(*=======================================================================*)
(*primary mirrors*)
(*=======================================================================*)
{zc0L,xc0L,yc0L}:={-radiusPriMirL-deltaRadiusPriMirL,0,0};
{a1,b1,c1}={1,1,1};
apertPriMirL:={{0,-sizeThrdDimPriMirL},{+sizeTrnsvrsPriMirL,-sizeThrdDimPriMirL},{+sizeTrnsvrsPriMirL,+sizeThrdDimPriMirL},{0,+sizeThrdDimPriMirL}};
If[Length@apertPriMirL!=Length@DeleteDuplicates@apertPriMirL,bigBanner["STOP"];killStop];
priMirrorL:=Move[CustomMirror[Function[Evaluate[ellipse3D[a1,b1,c1,radiusPriMirL,#1,#2,zc0L,xc0L,yc0L]]],apertPriMirL,"PRI-MIR-L",SurfaceRayIntersections->Symbol,LabelPositions->{{0,0,0}}],{{zPriMirLVar,zPriMirL},{xPriMirLVar,xPriMirL},{yPriMirLVar,yPriMirL}},tiltVectorFromAzimuth[azL,tiltPriMirL],TwistAngle->rollPriMirL];





{zc0H,xc0H,yc0H}:={-radiusPriMirH-deltaRadiusPriMirH,0,0};
{a2,b2,c2}={1,1,1};

If[fullBackMirror==True,apertPriMirH:={{0,-sizeThrdDimPriMirH},{+sizeTrnsvrsPriMirH,-sizeThrdDimPriMirH},{+sizeTrnsvrsPriMirH,+sizeThrdDimPriMirH},{0,+sizeThrdDimPriMirH}},apertPriMirH:={{-sizeTrnsvrsPriMirH2+delta1PriMirHTrnsvrs-delta2PriMirHTrnsvrs,+delta2PriMirHThrdDim},{-sizeTrnsvrsPriMirH2+delta1PriMirHTrnsvrs,+sizeThrdDimPriMirH-delta1PriMirHThrdDim},{-sizeTrnsvrsPriMirH2,+sizeThrdDimPriMirH-delta1PriMirHThrdDim},{-sizeTrnsvrsPriMirH2,+sizeThrdDimPriMirH},{+sizeTrnsvrsPriMirH2,+sizeThrdDimPriMirH},{+sizeTrnsvrsPriMirH2,-sizeThrdDimPriMirH},{-sizeTrnsvrsPriMirH2,-sizeThrdDimPriMirH},{-sizeTrnsvrsPriMirH2,-sizeThrdDimPriMirH+delta1PriMirHThrdDim},{-sizeTrnsvrsPriMirH2+delta1PriMirHTrnsvrs,-sizeThrdDimPriMirH+delta1PriMirHThrdDim},{-sizeTrnsvrsPriMirH2+delta1PriMirHTrnsvrs-delta2PriMirHTrnsvrs,-delta2PriMirHThrdDim}}];
If[Length@apertPriMirH!=Length@DeleteDuplicates@apertPriMirH,bigBanner["STOP"];killStop];
priMirrorH:=Move[CustomMirror[Function[Evaluate[ellipse3D[a2,b2,c2,radiusPriMirH,#1,#2,zc0H,xc0H,yc0H]]],apertPriMirH,"PRI-MIR-H",SurfaceRayIntersections->Symbol,LabelPositions->{{0,0,0}}],{{zPriMirHVar,zPriMirH},{xPriMirHVar,xPriMirH},{yPriMirHVar,yPriMirH}},tiltVectorFromAzimuth[azH,tiltPriMirH],TwistAngle->rollPriMirH];
(*=======================================================================*)
(*secondary mirrors*)
(*=======================================================================*)secMirrorL:=Move[SphericalMirror[{radiusSecMirLVar,radiusSecMirL},{sizeTrnsvrsSecMirL,sizeThrdDimSecMirL},"SEC-MIR-L",FlatSubstrate->False,FrontSurface->True],{{zSecMirLVar,zSecMirL},{xSecMirLVar,xSecMirL},{ySecMirLVar,ySecMirL}},tiltVectorFromAzimuth[azL,tiltSecMirL],TwistAngle->rollSecMirL];
secMirrorH:=Move[SphericalMirror[{radiusSecMirHVar,radiusSecMirH},{sizeTrnsvrsSecMirH,sizeThrdDimSecMirH},"SEC-MIR-H",FlatSubstrate->False,FrontSurface->True],{{zSecMirHVar,zSecMirH},{xSecMirHVar,xSecMirH},{ySecMirHVar,ySecMirH}},tiltVectorFromAzimuth[azH,tiltSecMirH],TwistAngle->rollSecMirH];
(*=======================================================================*)
(*screens*)
(*=======================================================================*)

thePDAL:=Move[Screen[{sizeTrnsvrsScreenL,sizeThrdDimScreenL},"PDA-L",Transmittance->0,GraphicDesign->Wire],{{zScreenLVar,zScreenL},{xScreenLVar,xScreenL},{yScreenLVar,yScreenL}},tiltVectorFromAzimuth[azL,tiltScreenL],TwistAngle->rollScreenL];

thePDAH:=Move[Screen[{sizeTrnsvrsScreenH,sizeThrdDimScreenH},"PDA-H",Transmittance->0,GraphicDesign->Wire],{{zScreenHVar,zScreenH},{xScreenHVar,xScreenH},{yScreenHVar,yScreenH}},tiltVectorFromAzimuth[azH,tiltScreenH],TwistAngle->rollScreenH];

(*=======================================================================*)
(*optics list*)
(*=======================================================================*)
printD@resonate;
(*resonate===True is not supported for butterfly optics*)
If[resonate===False,
priMirrorNumber=1;
secMirrorNumber=3;
terMirrorNumber=0;
focalSurfaceNumber=5;
boxNumber=7;
myOptics:={priMirrorL,priMirrorH,secMirrorL,secMirrorH,thePDAL,thePDAH};
myOpticsL:={priMirrorL,secMirrorL,thePDAL};
myOpticsH:={priMirrorH,secMirrorH,thePDAH};
];
(*=======================================================================*)
(*IMPORTANT:the old 2D diagnostic block below is only valid for LOW*)
(*in the z-x plane.Do not use it for HIGH until you rewrite it in 3D.*)
(*=======================================================================*)

checkNewCreatedSymbols[];
