(* ::Package:: *)

(* ::Subsection::Initialization:: *)
(*(*(*(*(*(*(*(*(*(*(*(*(*LS2/RUN3 OPTICS for RICH = 1*)*)*)*)*)*)*)*)*)*)*)*)*)


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------------------------------*)
bigBanner[" loading optics : "<>ToString[whichOptics]<>" for RICH : "<>ToString[iRICH]];
(*--------------------------------------------------------------------------------------------------------*)
doResetAllVariables[]; 
 setExternalParameters[];




(* ::Input::Initialization:: *)
(**************************************************************************************************)
(**)
Print[" loading optics ",whichOptics,"  for  ",iRICH];
(**)
If[(whichOptics=="LHCb22Upg1")&&(iRICH==1)
(**************************************************************************************************),
(*bigBanner[" \n\n\n POSSIBLY ADD  SECOND SET OF NEARLY FAKE MIRRORS TO HAVE THE SAME COMPONENTS AS FOR THE SPLIT OPTICS \n\n\n "];*)
bigBanner[
"  component # TBD ==>>  ","PRI-MIR","\n",
"  component # TBD ==>>  ","SEC-MIR","\n",
(*"  component # TBD ==>>  ","TER-MIR","\n",*)
"  component # TBD ==>>  ","QUA-PLA","\n",
"  component # TBD ==>>  ","PD","\n",
"  component # TBD ==>>  ","BOX"];
(**)
(*set default,update later possibly*)
(**)
Print[" debug "];
(**************************************************************************************************)(*!@#$% TAPULLO write here instead of setData2022Rich1NewToCheck:TO FIX//see setData2022Rich1NewToCheck*)
setData2022Rich1;
(**)
thickSecMir=0;(*ok for rich, zero dielectric substrate*)(*it screams if thickness is in SphericalMirror*)
thickPriMir=0;(*ok for rich, zero dielectric substrate*)(*it screams if thickness is in SphericalMirror*)
(**)
calcSphericalPrimaryMirror[sizeTrnsvrsPriMir,tiltPriMir,radiusPriMir,thetaMinPriMir,p2z];
(**)
priMirror=Move[SphericalMirror[
{radiusPriMirVar,-radiusPriMir},
{sizeTrnsvrsPriMir,sizeThrdDimPriMir},
(*thickPriMir,*)
"PRI-MIR-NOW",
FlatSubstrate->False,
FrontSurface->True
],(*FlatSubstrate->False gives errors inside my routines???*)
{{zPriMirVar,zVrtxPriMir},{xPriMirVar,xVrtxPriMir}},{tiltPriMirVar,180+tiltPriMir/Degree}
];
(**)
secMirror=Move[SphericalMirror[
{radiusSecMirVar,radiusSecMir},
{sizeTrnsvrsSecMir,sizeThrdDimSecMir},
(*thickSecMir,*)
"SEC-MIR-NOW",
FlatSubstrate->False,
FrontSurface->True
],(*FlatSubstrate->False gives errors inside my routines???*)
{{zSecMirVar,zSecMir},{xSecMirVar,xSecMir}},{tiltSecMirVar,180+tiltSecMir/Degree}];
(**)
(*QUARTZ PLATE//TO FIX/check (wavlen model)*)
Print["Optical Medium data \n",TableForm@Transpose@SearchData[OpticalMedium->"F_SILICA"]];
testQuartzPlate=False;
quartzPlateDist:={zQuartzPlateDist,xQuartzPlateDist};
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
(*Transmittance\[Rule]0.5,Reflectance\[Rule]0.5,CurvatureDirection\[Rule]Back,SwitchDirectionOnReflection\[Rule]True*)
(**)
thePDA=Move[Screen[
{sizeTrnsvrsScreen,sizeThrdDimScreen},
"THE-PDA-NOW",
Transmittance->0],
{{zScreenVar,zScreen},{xScreenVar,xScreen}},{tiltScreenVar,tiltScreen/Degree}]
];
