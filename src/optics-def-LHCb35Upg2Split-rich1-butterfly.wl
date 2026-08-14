(* ::Package:: *)

(* ::Subsection:: *)
(*BUTTERFLY OPTICS for RICH=1*)


(* ::Input::Initialization:: *)
(**************************************************************************************************)
bigBanner["butterfly"];
(**************************************************************************************************)(**************************************************************************************************)
checkNewCreatedSymbols;
Map[Unprotect,Complement[Join[Names["tiltQuartz*"],Names["tiltPriMir*"],Names["tiltSecMir*"],Names["tiltTerMir*"],Names["tiltScreen*"]],Names["tilt*Var*"]]];
Map[Unprotect,Complement[Join[Names["zQuartz*"],Names["zPriMir*"],Names["zSecMir*"],Names["zTerMir*"],Names["zScreen*"]],Names["z*Var*"]]];
Map[Unprotect,Complement[Join[Names["xQuartz*"],Names["xPriMir*"],Names["xSecMir*"],Names["xTerMir*"],Names["xScreen*"]],Names["x*Var*"]]];
Map[Unprotect,Complement[Join[Names["yQuartz*"],Names["yPriMir*"],Names["ySecMir*"],Names["yTerMir*"],Names["yScreen*"]],Names["y*Var*"]]];
Map[Unprotect,Complement[Join[Names["sizeQuartz*"],Names["sizePriMir*"],Names["sizeSecMir*"],Names["sizeTerMir*"],Names["sizeScreen*"]],Names["size*Var*"]]];



Clear[apertureL,apertureH];
p4z=1075+50;
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
sizeTrnsvrsPriMirL=265*3/4.+10.;
sizeTrnsvrsPriMirH=700;
sizeTrnsvrsSecMirL=250;
sizeTrnsvrsSecMirH=590;
sizeTrnsvrsTerMir=500;
sizeTrnsvrsScreenL=350;
sizeTrnsvrsScreenH=500;
sizeTrnsvrsScreenT=450;
sizeThirdDimPriMir0=650;
sizeThirdDimPriMirL:=sizeThirdDimPriMir0;
sizeThirdDimPriMirH:=sizeThirdDimPriMir0;
sizeThirdDimSecMir0:=2*sizeThirdDimPriMir0;
sizeThirdDimSecMirL:=sizeThirdDimSecMir0;
sizeThirdDimSecMirH:=sizeThirdDimSecMir0;
sizeThirdDimTerMir:=sizeThirdDimSecMir0;
sizeThirdDimScreen0=1500;
sizeThirdDimScreenL:=sizeThirdDimScreen0;
sizeThirdDimScreenH:=sizeThirdDimScreen0;
sizeThirdDimScreenT:=sizeThirdDimScreen0;
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
(*=======================================================================*)
(*positions in physical axes,stored as z,x,y*)
(*=======================================================================*)
zPriMirL=2150;xPriMirL=0;yPriMirL=0;
zPriMirH=2100;xPriMirH=0;yPriMirH=0;
zSecMirL=1157;xSecMirL=130;ySecMirL=0;
zSecMirH=1112.5;xSecMirH=0;ySecMirH=663;
zScreenL0=2065;xScreenL0=1500;yScreenL0=0;
zScreenH0=1520;xScreenH0=0;yScreenH0=1370;
(*optional top plane*)If[!ValueQ[zScreenT0],zScreenT0=2065];
If[!ValueQ[xScreenT0],xScreenT0=0];
If[!ValueQ[yScreenT0],yScreenT0=1500];
theShiftOfThePDAL=-20;
theShiftOfThePDAH=-1;
If[!ValueQ[theShiftOfThePDAT],theShiftOfThePDAT=0];
{zScreenL,xScreenL,yScreenL}=shiftAlongTilt[{zScreenL0,xScreenL0,yScreenL0},theShiftOfThePDAL,azL,tiltScreenL];
{zScreenH,xScreenH,yScreenH}=shiftAlongTilt[{zScreenH0,xScreenH0,yScreenH0},theShiftOfThePDAH,azH,tiltScreenH];
{zScreenT,xScreenT,yScreenT}=shiftAlongTilt[{zScreenT0,xScreenT0,yScreenT0},theShiftOfThePDAT,azH,tiltScreenT];
(*=======================================================================*)(*radii*)(*=======================================================================*)radiusSecMir=0.0;
radiusSecMirL:=radiusSecMir;
radiusSecMirH:=radiusSecMir;
radiusRefToday=3650;
deltaRadiusL=100;
radiusL:=5000;
radiusH:=radiusRefToday;
(*=======================================================================*)(*apertures*)(*=======================================================================*)delta2PriMirHTrnsvrs=0.;
delta2PriMirHThirdDim=10.;
sizeTrnsvrsPriMirH2:=sizeTrnsvrsPriMirH;
delta1PriMirHTrnsvrs:=2*sizeTrnsvrsPriMirH2/3;
delta1PriMirHThirdDim:=2*sizeThirdDimPriMirH/3;
(*=======================================================================*)(*no more parameter changes*)(*=======================================================================*)Map[Protect,Complement[Join[Names["tiltQuartz*"],Names["tiltPriMir*"],Names["tiltSecMir*"],Names["tiltTerMir*"],Names["tiltScreen*"]],Names["tilt*Var*"]]];
Map[Protect,Complement[Join[Names["zQuartz*"],Names["zPriMir*"],Names["zSecMir*"],Names["zTerMir*"],Names["zScreen*"]],Names["z*Var*"]]];
Map[Protect,Complement[Join[Names["xQuartz*"],Names["xPriMir*"],Names["xSecMir*"],Names["xTerMir*"],Names["xScreen*"]],Names["x*Var*"]]];
Map[Protect,Complement[Join[Names["yQuartz*"],Names["yPriMir*"],Names["ySecMir*"],Names["yTerMir*"],Names["yScreen*"]],Names["y*Var*"]]];
Map[Protect,Complement[Join[Names["sizeQuartz*"],Names["sizePriMir*"],Names["sizeSecMir*"],Names["sizeTerMir*"],Names["sizeScreen*"]],Names["size*Var*"]]];
(*=======================================================================*)(*primary mirrors*)(*=======================================================================*){x01,y01,z01}:={-radiusL-deltaRadiusL,0,0};
{a1,b1,c1}={1,1,1};
apertureL:={{0,-sizeThirdDimPriMirL},{+sizeTrnsvrsPriMirL,-sizeThirdDimPriMirL},{+sizeTrnsvrsPriMirL,+sizeThirdDimPriMirL},{0,+sizeThirdDimPriMirL}};
If[Length@apertureL!=Length@DeleteDuplicates@apertureL,bigBanner["STOP"];killStop];
priMirrorL=Move[CustomMirror[Function[Evaluate[ellipse3D[a1,b1,c1,radiusL,#1,#2,x01,y01,z01]]],apertureL,"PRI-MIR-L",SurfaceRayIntersections->Symbol,LabelPositions->{{0,0,0}}],{{zPriMirLVar,zPriMirL},{xPriMirLVar,xPriMirL},{yPriMirLVar,yPriMirL}},tiltVectorFromAzimuth[azL,tiltPriMirL],TwistAngle->rollPriMirL];
{x02,y02,z02}:={-radiusH,0,0};
{a2,b2,c2}={1,1,1};
fullBackMirror=True;
If[fullBackMirror==True,apertureH:={{0,-sizeThirdDimPriMirH},{+sizeTrnsvrsPriMirH,-sizeThirdDimPriMirH},{+sizeTrnsvrsPriMirH,+sizeThirdDimPriMirH},{0,+sizeThirdDimPriMirH}},apertureH:={{-sizeTrnsvrsPriMirH2+delta1PriMirHTrnsvrs-delta2PriMirHTrnsvrs,+delta2PriMirHThirdDim},{-sizeTrnsvrsPriMirH2+delta1PriMirHTrnsvrs,+sizeThirdDimPriMirH-delta1PriMirHThirdDim},{-sizeTrnsvrsPriMirH2,+sizeThirdDimPriMirH-delta1PriMirHThirdDim},{-sizeTrnsvrsPriMirH2,+sizeThirdDimPriMirH},{+sizeTrnsvrsPriMirH2,+sizeThirdDimPriMirH},{+sizeTrnsvrsPriMirH2,-sizeThirdDimPriMirH},{-sizeTrnsvrsPriMirH2,-sizeThirdDimPriMirH},{-sizeTrnsvrsPriMirH2,-sizeThirdDimPriMirH+delta1PriMirHThirdDim},{-sizeTrnsvrsPriMirH2+delta1PriMirHTrnsvrs,-sizeThirdDimPriMirH+delta1PriMirHThirdDim},{-sizeTrnsvrsPriMirH2+delta1PriMirHTrnsvrs-delta2PriMirHTrnsvrs,-delta2PriMirHThirdDim}}];
If[Length@apertureH!=Length@DeleteDuplicates@apertureH,bigBanner["STOP"];killStop];
priMirrorH=Move[CustomMirror[Function[Evaluate[ellipse3D[a2,b2,c2,radiusH,#1,#2,x02,y02,z02]]],apertureH,"PRI-MIR-H",SurfaceRayIntersections->Symbol,LabelPositions->{{0,0,0}}],{{zPriMirHVar,zPriMirH},{xPriMirHVar,xPriMirH},{yPriMirHVar,yPriMirH}},tiltVectorFromAzimuth[azH,tiltPriMirH],TwistAngle->rollPriMirH];
(*=======================================================================*)(*secondary mirrors*)(*=======================================================================*)secMirrorL=Move[SphericalMirror[{radiusSecMirLVar,radiusSecMirL},{sizeTrnsvrsSecMirL,sizeThirdDimSecMirL},"SEC-MIR-L",FlatSubstrate->False,FrontSurface->True],{{zSecMirLVar,zSecMirL},{xSecMirLVar,xSecMirL},{ySecMirLVar,ySecMirL}},tiltVectorFromAzimuth[azL,tiltSecMirL],TwistAngle->rollSecMirL];
secMirrorH=Move[SphericalMirror[{radiusSecMirHVar,radiusSecMirH},{sizeTrnsvrsSecMirH,sizeThirdDimSecMirH},"SEC-MIR-H",FlatSubstrate->False,FrontSurface->True],{{zSecMirHVar,zSecMirH},{xSecMirHVar,xSecMirH},{ySecMirHVar,ySecMirH}},tiltVectorFromAzimuth[azH,tiltSecMirH],TwistAngle->rollSecMirH];
(*=======================================================================*)(*screens*)(*=======================================================================*)Unprotect[zScreenL,xScreenL,yScreenL];
thePDAL=Move[Screen[{sizeTrnsvrsScreenL,sizeThirdDimScreenL},"PDA-L",Transmittance->0,GraphicDesign->Wire],{{zScreenLVar,zScreenL},{xScreenLVar,xScreenL},{yScreenLVar,yScreenL}},tiltVectorFromAzimuth[azL,tiltScreenL],TwistAngle->rollScreenL];
Protect[zScreenL,xScreenL,yScreenL];
Unprotect[zScreenH,xScreenH,yScreenH];
thePDAH=Move[Screen[{sizeTrnsvrsScreenH,sizeThirdDimScreenH},"PDA-H",Transmittance->0,GraphicDesign->Wire],{{zScreenHVar,zScreenH},{xScreenHVar,xScreenH},{yScreenHVar,yScreenH}},tiltVectorFromAzimuth[azH,tiltScreenH],TwistAngle->rollScreenH];
Protect[zScreenH,xScreenH,yScreenH];
(*=======================================================================*)(*optics list*)(*=======================================================================*)printD@resonate;
If[resonate==True,priMirrorNumber=1;
secMirrorNumber=2;
terMirrorNumber=0;
focalSurfaceNumber=3;
boxNumber=4;
onThePriMirror:={ComponentNumber->priMirrorNumber};
onTheSecMirror:={ComponentNumber->secMirrorNumber};
onTheFS:={ComponentNumber->focalSurfaceNumber};
onTheBox:={ComponentNumber->boxNumber};
theTrackOrigin:={ComponentNumber->priMirrorNumber};
myOptics:={Resonate[{priMirrorL,priMirrorH},"PRI-MIR"],Resonate[{secMirrorL,secMirrorH},"SEC-MIR"],Resonate[{thePDAL,thePDAH},"PD"]},priMirrorNumber=1;
secMirrorNumber=3;
terMirrorNumber=0;
focalSurfaceNumber=5;
boxNumber=7;
myOptics:={priMirrorL,priMirrorH,secMirrorL,secMirrorH,thePDAL,thePDAH}];
(*=======================================================================*)
(*IMPORTANT:the old 2D diagnostic block below is only valid for LOW*)
(*in the z-x plane.Do not use it for HIGH until you rewrite it in 3D.*)
(*=======================================================================*)

checkNewCreatedSymbols


