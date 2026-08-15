(* ::Package:: *)

(* Derived textually from validation/native-sources/optics-native.wl,
   produced by Wolfram Save As. Only the OPTICS Title section is selected;
   Wolfram expressions are neither parsed nor reserialized. Five explicit
   logical-disjunction heads from the notebook are rewritten as ||. *)



(* ::Title::Initialization:: *)
(*(*---... OPTICS*)*)


(* ::Subtitle::Initialization:: *)
(*(*INIT BASE*)*)


(* ::Input::Initialization:: *)
(*!@#$%I CANT GET THE PACKAGE TO WORK DUE TO SHADOWING WITH OPTICA EM:TO FIX!!!*)
(*BeginPackage["rich`optica`",{"Global`","rich`","base`","base`StatDataAnal`"}];*)
bigBanner[" loading optica "];

(*f::usage="text", \[Ellipsis]*)



(* ::Subsubtitle::Initialization:: *)
(*(*EllipseFit*)*)


(* ::Input::Initialization:: *)
Options[EllipseFit]={TimeConstraint->1,WorkingPrecision:>MachinePrecision};

SyntaxInformation[EllipseFit]={"ArgumentsPattern"->{_,_,OptionsPattern[]}};

EllipseFit[data_?(MatrixQ[#,NumericQ]&),{x0_Symbol,y0_Symbol},opts:OptionsPattern[]]/;And[CheckArguments[EllipseFit[data,{x0,y0},opts],2],Context[x0]=!="System`",Context[y0]=!="System`",(2===Part[Dimensions@data,2]),(0===Max@Abs@Im@Flatten@data),(3<Length@Union@data)]:=Module[{machinePrec,exactData,x,y,d1,d2,s1,s2,m,mInverse,t,ev,discriminates,a,b,c,d,e,f},
If[Precision@data===MachinePrecision,
{exactData,machinePrec}={False,True};
{x,y}=Transpose[Developer`ToPackedArray@N@data];
d1=Developer`ToPackedArray@{x^2,x y,y^2};
d2=Developer`ToPackedArray@{x,y,ConstantArray[1.0,Length@x]},
(* else *)
{exactData,machinePrec}={Precision[data]===\[Infinity],False};
{x,y}=Transpose@data;
d1={x^2,x y,y^2};
d2={x,y,ConstantArray[1,Length@x]}
];
s1=d1 . Transpose[d1];
{s2,m}={d1 . #,d2 . #}&[Transpose[d2]];
mInverse=Quiet[Check[Inverse[m],$Failed,{Inverse::sing,Inverse::luc}],{Inverse::sing,Inverse::luc}];
If[mInverse===$Failed,ResourceFunction["ResourceFunctionMessage"][EllipseFit::sing];$Failed,
(* else *)
t=-mInverse . Transpose[s2];
Which[
(* Test 1 *)machinePrec,
ev=Eigenvectors[{{0,0,0.5},{0,-1.0,0},{0.5,0,0}} . (s1+s2 . t)],
(* Test 2 *)exactData && \[Infinity]===OptionValue@WorkingPrecision,
ev=Eigenvectors[{{0,0,1/2},{0,-1,0},{1/2,0,0}} . (s1+s2 . t)],
(* Test 3 *)True,
TimeConstrained[ev=Eigenvectors[{{0,0,1/2},{0,-1,0},{1/2,0,0}} . (s1+s2 . t)],OptionValue@TimeConstraint,
ev=Quiet[Eigenvectors[N[{{0,0,1/2},{0,-1,0},{1/2,0,0}} . (s1+s2 . t),OptionValue@WorkingPrecision]],N::meprec];
ev=N[ev,OptionValue@WorkingPrecision]
]
];
discriminates=Function[{a,b,c},b^2-4 a c]@@@ev;
If[FreeQ[discriminates,_?Negative],ResourceFunction["ResourceFunctionMessage"][EllipseFit::none];$Failed,
(* else *)
{a,b,c}=First[Pick[ev,Quiet[Negative@discriminates,N::meprec]]];
{a,b,c}={a,b,c}/.(_?(#==0.0&)->0);(* Change values like 0.0``200 to Integer 0. *)
{d,e,f}=Quiet[t . {a,b,c},N::meprec]/.(_?(#==0.0&)->0);(* Change values like 0.0``200 to Integer 0. *);
f+d*x0+a*x0^2+e*y0+b*x0*y0+c*y0^2==0
]
]
];

invalidMatrix[data_]:=With[{flattened=Flatten@data},{0}=!=Union@Im[flattened]||False===And@@NumericQ/@flattened];

invalidData[data_]:=False===MatrixQ[data]||2=!=Last@Dimensions@data||invalidMatrix@data;

notSymbolPair[e_]:=If[List=!=Head@e||2=!=Length@e,
True,
(* else *)
With[{x=First@e,y=Last@e},
If[Symbol=!=Head@x||Symbol=!=Head@y,
True,
(* else *)
"System`"===Context[x]||"System`"===Context[y]
]]];

EllipseFit[data:{{_,_}..},{_,_},___?(OptionQ[{#}&])]/;MatrixQ[data]&&(Length@Union@data<4)&&ResourceFunction["ResourceFunctionMessage"][EllipseFit::err1]:="This side never evaluates.";

EllipseFit[data_,{_,_},___?(OptionQ[{#}&])]/;invalidData[data]&&ResourceFunction["ResourceFunctionMessage"][EllipseFit::err2]:="This side never evaluates.";

EllipseFit[_,_?notSymbolPair,___?(OptionQ[{#}&])]/;ResourceFunction["ResourceFunctionMessage"][EllipseFit::err3]:="This side never evaluates.";

EllipseFit[_?(MatrixQ[#,NumericQ]&),{_,_},arg__]/;(False===OptionQ[{arg}])&&ResourceFunction["ResourceFunctionMessage"][EllipseFit::err4]:="This side never evaluates.";

EllipseFit::err1="EllipseFit was given an invalid list of data because the data contained fewer then four disticnt {x,y} coordinates.";

EllipseFit::err2="EllipseFit was given an invalid list of data. The data must have the form {{x1,y1},{x2,y2},...{xn,yn}} where each xi and yi are real numeric values.";

EllipseFit::err3="EllipseFit was give an invalid expression as a second argument. The second argument must have the form {x,y} where x and y are Symbols not in the System context.";

EllipseFit::err4="EllipseFit was used where one or more argument after the second argument was not an option. EllipseFit is not defined in this case.";

EllipseFit::sing="EllipseFit was unable to find a solution due to the need to invert a singular or nearly singular matrix.";

EllipseFit::none="EllipseFit was unable to find an ellipse to approximate the data.";


(* ::Subsubtitle::Initialization:: *)
(*(*GENERAL DEFINITIONS FOR THIS NOTEBOOK*)*)


(* ::Input::Initialization:: *)
(*TO FINISH*)

(*checkNewCreatedSymbolsWithOpt[how_:"short"] := (
  names1 = Names["Global`*"];
  If[how \[NotEqual] "short",
    Print["\n ALL SYMBOLS ", Complement[names1, names0]]
  ];
  If[how \[NotEqual] "noTemporary",
namesListPos=ResourceFunction["SelectPositions"][names1,ContainsAny[Attributes[#],{Temporary}]&];
names2=Delete[names1,namesListPos];

    Print["\n ALL SYMBOLS ", Complement[names2, names0]]
  ];



  Print["\n NEW SYMBOLS SINCE LAST CALL of checkNewCreatedSymbols \n ",     Complement[names1, namesSave], "\n"];

  namesSave = names1;


)*)


(* ::Section::Initialization:: *)
(*(*MISCELLANEA DEFINITIONS*)*)


(* ::Subsubtitle::Initialization:: *)
(*(*GENERAL OPTIONS FOR THIS NOTEBOOK*)*)


(* ::Section::Initialization:: *)
(*(*MISCELLANEA OPTIONS*)*)


(* ::Subtitle::Initialization:: *)
(*(*OPTICA setup*)*)


(* ::Input::Initialization:: *)
(**)
(* TAPULLO : still needed? *)
(* $OpticaSystemProtection *)
Unprotect[$OpticaSystemProtection];
(**)
openOpticaEMDocumentation:=
KernelExecute[
NotebookOpen[
FileNameJoin[{
$AddOnsDirectory(*$UserBaseDirectory*),"Autoload","OpticaDocumentation","Documentation","English","Tutorials","OpticaDocumentationOverview.nb"
}]
]
];
(*openOpticaEMDocumentation*)
(**)
printD@$VersionNumber;
Switch[$VersionNumber,
12.3,
bigBanner[" MATHEMATICA VERSION 12.3: OK for OpticaSE ! "];
bigBanner[" ACTIVATING OpticaSE "];
Off[General::stop];
Off[$RecursionLimit::reclim2];
Off[Complement::heads];
Off[Join::incpt];
Once[Needs["OpticaSE`OpticaSE`"],"KernelSession"];
On[Join::incpt];
On[Complement::heads];
On[$RecursionLimit::reclim2];
On[General::stop];
Print[$OpticaHome];
Print[$OpticaVersion];
Print[$OpticaBuildDate];
Print[TableForm[Names["$Optica*"]]];
Print@Column@$ContextPath;
printD@Column@Contexts["*Optica*"];
$ContextPath =DeleteDuplicates@Prepend[$ContextPath,"OpticaSE`OpticaSE`"];
$ContextPath =DeleteDuplicates@Prepend[$ContextPath,"OpticaTools`"];
Print@Column@$ContextPath,


14.1,
bigBanner[" MATHEMATICA VERSION 14.1: OK for OpticaEM ! "];
bigBanner[" ACTIVATING OpticaEM "];
Once[Needs["OpticaEM`OpticaEM`"],"KernelSession"];
Print[$OpticaHome];
Print[$OpticaVersion];
Print[$OpticaBuildDate];
Print[TableForm[Names["$Optica*"]]];
Print@Column@$ContextPath;
printD@Column@Contexts["*Optica*"];
$ContextPath =DeleteDuplicates@Prepend[$ContextPath,"OpticaEM`OpticaEM`"];
$ContextPath =DeleteDuplicates@Prepend[$ContextPath,"OpticaTools`"];
Print@Column@$ContextPath,


14.2,
bigBanner[" MATHEMATICA VERSION 14.2: OK for OpticaEM ! "];
bigBanner[" ACTIVATING OpticaEM "];
Once[Needs["OpticaEM`OpticaEM`"],"KernelSession"];
Print[$OpticaHome];
Print[$OpticaVersion];
Print[$OpticaBuildDate];
Print[TableForm[Names["$Optica*"]]];
Print@Column@$ContextPath;
printD@Column@Contexts["*Optica*"];
$ContextPath =DeleteDuplicates@Prepend[$ContextPath,"OpticaEM`OpticaEM`"];
$ContextPath =DeleteDuplicates@Prepend[$ContextPath,"OpticaTools`"];
Print@Column@$ContextPath,


14.3,
bigBanner[" MATHEMATICA VERSION 14.3: OK for OpticaEM ! "];
bigBanner[" ACTIVATING OpticaEM "];
Once[Needs["OpticaEM`OpticaEM`"],"KernelSession"];
Print[$OpticaHome];
Print[$OpticaVersion];
Print[$OpticaBuildDate];
Print[TableForm[Names["$Optica*"]]];
Print@Column@$ContextPath;
printD@Column@Contexts["*Optica*"];
$ContextPath =DeleteDuplicates@Prepend[$ContextPath,"OpticaEM`OpticaEM`"];
$ContextPath =DeleteDuplicates@Prepend[$ContextPath,"OpticaTools`"];
Print@Column@$ContextPath,


15.0,
bigBanner[" MATHEMATICA VERSION 15.0: to check for OpticaEM ! "];
bigBanner[" ACTIVATING OpticaEM "];
Once[Needs["OpticaEM`OpticaEM`"],"KernelSession"];
Print[$OpticaHome];
Print[$OpticaVersion];
Print[$OpticaBuildDate];
Print[TableForm[Names["$Optica*"]]];
Print@Column@$ContextPath;
printD@Column@Contexts["*Optica*"];
$ContextPath =DeleteDuplicates@Prepend[$ContextPath,"OpticaEM`OpticaEM`"];
$ContextPath =DeleteDuplicates@Prepend[$ContextPath,"OpticaTools`"];
Print@Column@$ContextPath,


_,
bigBanner[" WRONG MATHEMATICA VERSION ??? "];
bigBanner[" NOT ACTIVATING OPTICA - NORMAL MATHEMATICA STUFF OK "]
(*killStop*)
];


(* ::Section::Initialization:: *)
(*(*Optica HELP*)*)


(* ::Subsection::Initialization:: *)
(*(*open OpticaEM main help page*)*)


(* ::Input::Initialization:: *)
openOpticaEMDocumentation:=KernelExecute[NotebookOpen[
FileNameJoin[{StringDrop[$OpticaHome,-8],"OpticaDocumentation","Documentation","English","Tutorials","OpticaDocumentationOverview.nb"}]
]
];
?openOpticaEMDocumentation


(* ::Subsection::Initialization:: *)
(*(*detailed Optica HELP*)*)


(* ::Input::Initialization:: *)
TableForm[{{ComponentFunctions,ShortHandFunctions}},TableAlignments->Center]


TableForm[{{SourceFunctions,OpticaFunctions},{EMFunctions,BuildingBlockFunctions}},TableAlignments->Center]



(*NearFieldFunctions
FarFieldFunctions
*)




(* ::Subtitle::Initialization:: *)
(*(*MISCELLANEOUS RICH FUNCTIONS - OPTICS/ANA/SIM*)*)


(* ::Subsubtitle::Initialization:: *)
(*(*general*)*)


(* ::Input::Initialization:: *)
(*(*--------------------------------------------------------------------------------*)
(* !@#$% IF Module:= IT DOES NOT WORK !!! *)
myFocalSurfaceAnalyze[points3DOnTheFS_,points2DOnTheFS_,pointsTiltOnTheFS_,tilt_]:=Module[{
sizeFSTrnsvrs,sizeFSThrdDim,
areaFS,numSensors,
resThetaProj,resTheta,
theDirScreenInCentralPlane,pointsTiltProjOnTheFS,
uuu,vvv,
trnsvrsMagnification,thrdDimMagnification,
zPDACenter,xPDACenter,
finalRaysDir
},
(* !@#$% changed for a split PD: pass all data and only do calculations here *)
If [Length@points3DOnTheFS \[LessEqual]0 || Length@points2DOnTheFS\[LessEqual] 0,bigBanner[" ERROR ON myFocalSurfaceAnalyze - Returning "];Return[]];
(* improve: tilt screen can be determined by points3DOnTheFS *)
zPDACenter=Median[Transpose[points3DOnTheFS][[1]]];
xPDACenter=Median[Transpose[points3DOnTheFS][[2]]];
Histogram[Transpose[points2DOnTheFS][[1]],100,AspectRatio\[Rule]1/2];
Histogram[Transpose[points2DOnTheFS][[2]],100,AspectRatio\[Rule]1/2];
sizeFSTrnsvrs=Max[Transpose[points2DOnTheFS][[1]]]-Min[Transpose[points2DOnTheFS][[1]]];
sizeFSThrdDim=Max[Transpose[points2DOnTheFS][[2]]]-Min[Transpose[points2DOnTheFS][[2]]];
areaFS=sizeFSTrnsvrs*sizeFSThrdDim/1000000;
numSensors=sizeFSTrnsvrs*sizeFSThrdDim/sensorPitch^2;
(**)
resThetaProj={};resTheta={};
theDirScreenInCentralPlane={Cos[tilt*Degree],Sin[tilt*Degree],0};
finalRaysDir=Mean[ArcTan[Transpose[pointsTiltOnTheFS][[2]]/Transpose[pointsTiltOnTheFS][[1]]]]/Degree;
If[Length[pointsTiltOnTheFS]>0,
AppendTo[resTheta,1000*ArcCos[pointsTiltOnTheFS.theDirScreenInCentralPlane]],
Print["zero length pointsTiltOnTheFS  "]
];
If[Length[pointsTiltOnTheFS]>0,pointsTiltProjOnTheFS=Transpose[{Transpose[pointsTiltOnTheFS][[1]],Transpose[pointsTiltOnTheFS][[2]],ConstantArray[0,Length[pointsTiltOnTheFS]]}];
uuu=Map[Normalize,pointsTiltProjOnTheFS];
vvv=Table[Cross[theDirScreenInCentralPlane,uuu[[k]]],{k,1,Length[uuu]}];
AppendTo[resThetaProj,1000*ArcSin[Transpose[vvv][[3]]]],
Print["zero length pointsTiltOnTheFS"]
];
trnsvrsMagnification=sizeFSTrnsvrs/(2*halfOpenAngleMRad);
thrdDimMagnification=sizeFSThrdDim/(2*halfOpenAngleMRad);
resThetaProj=Flatten[resThetaProj];
resTheta=Flatten[resTheta];
Print[Histogram[resThetaProj,ChartElementFunction\[Rule]"FadingRectangle",ChartStyle\[Rule]Orange,PlotLabel\[Rule]"resThetaProj (mrad)",AspectRatio\[Rule]1/2,Frame->True]];
Print[Histogram[resTheta,ChartElementFunction\[Rule]"FadingRectangle",ChartStyle\[Rule]Orange,PlotLabel\[Rule]"resTheta (mrad)",AspectRatio\[Rule]1/2,Frame->True]];
Print["   zPDACenter                                                       ",nf1[zPDACenter]];
Print["   xPDACenter                                                       ",nf1[xPDACenter]];
Print["   finalRaysDir in plane z-x (degrees)                              ",nf1[finalRaysDir]];
Print["   Mean resThetaProj         (mrad)                                 ",nf1[Mean[resThetaProj]]];
Print["   Median resThetaProj       (mrad)                                 ",nf1[Median[resThetaProj]]];
Print["   Mean resTheta             (mrad)                                 ",nf1[Mean[resTheta]]];
Print["   Median resTheta           (mrad)                                 ",nf1[Median[resTheta]]];
Print["   Estimated size PD-plane local z-Trnsvrs coordinate (mm)          ",nf1[sizeFSTrnsvrs]];
Print["   Estimated size PD-plane ThrdDim (mm)                            ",nf1[sizeFSThrdDim]];
Print["   Estimated area of the PD-plane (m**2)                            ",nf1[areaFS]];
Print["   Estimated number of sensors (one half detector)                  ",nf1[numSensors]];
Print["   Assumed Nominal Sensor Pitch                                     ",nf1[sensorPitch]];
Print["   Transverse Magnification (mm/mrad) - meaningful for single trace ",nf3[trnsvrsMagnification]];
Print["   ThrdDim Magnification   (mm/mrad) - meaningful for single trace ",nf3[thrdDimMagnification]];
Print["   Average Magnification    (mm/mrad) - meaningful for single trace ",nf3[average[trnsvrsMagnification,thrdDimMagnification]]]
];*)


(* ::Subsubtitle::Initialization:: *)
(*(*ANALITICAL GEOMETRY*)*)


(* ::Input::Initialization:: *)
(*=========================================================================*)
(* swap coordinates for the FS view *)
(*=========================================================================*)
(**)
?swap(* already defined *)
ClearAll[swapTheXYCoords];
swapTheXYCoords[v_]:=Module[{},If[Length[v]!=2,Return[Print["ERROR swapTheXYCoords "]],Return[  (1.0)*     {v[[2]],v[[1]]}]]];
Attributes[swapTheXYCoords]


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
dist[z1_,x1_,z2_,x2_]:=Sqrt[(z1-z2)^2+(x1-x2)^2];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
AngCoeff[z1_,x1_,z2_,x2_]:=(x2-x1)/(z2-z1);


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
dirVect[z1_,x1_,z2_,x2_]:={(z2-z1),(x2-x1)}/dist[z1,x1,z2,x2];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
dirVectOrth[z1_,x1_,z2_,x2_]:={-(x2-x1),(z2-z1)}/dist[z1,x1,z2,x2];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
average[t1_,t2_]:=(t1+t2)/2;


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
midPoint[z1_,x1_,z2_,x2_]:={average[z1,z2],average[x1,x2]};


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
reflect0[z0_,y0_,axis_,za_,ya_]:=Module[{uvp,t,s,zp,yp,w,zap,yap,sol},
uvp={-axis[[2]],axis[[1]]};
zp=z0+t*uvp[[1]];
yp=y0+t*uvp[[2]];
zap=za+s*axis[[1]];
yap=ya+s*axis[[2]];
sol=Solve[{zp==zap,yp==yap},{s,t}];
w={zp,yp}/.sol[[1]];
reflectedPoint=2*w-{z0,y0};
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
reflect[x0_,y0_,dirAxis_,xAxis_,yAxis_]:=Module[{uvp,t,s,xp,yp,w,xap,yap,sol,reflectedPoint},
uvp={-dirAxis[[2]],dirAxis[[1]]};
xp=x0+t*uvp[[1]];
yp=y0+t*uvp[[2]];
xap=xAxis+s*dirAxis[[1]];
yap=yAxis+s*dirAxis[[2]];
sol=Solve[{xp==xap,yp==yap},{s,t}];
w={xp,yp}/.sol[[1]];
reflectedPoint=2*w-{x0,y0};
Return[reflectedPoint]
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
(*garbage*)
(*reflect3D[point_,planeAxis_]:=Module[{k,pp,tSol,pointIntersect},
pp=point+t*planeAxis;
k=-Dot[secMirNorm3D,{zSecMirLMin,xSecMirLMin,0}];
tSol=-k-Dot[point,planeAxis];
pointIntersect=pp/.t\[Rule]tSol;
point+2*(pointIntersect-point)
];*)


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
angles[p_,q_,d_,radius_]:=Module[{alpha},
alpha=N[ArcCos[resX[p,q,d,radius][[2]]],wp]//Chop;
beta=N[sumAB[p,q,d]-alpha,wp]//Chop;
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
circumference[z0_,y0_,radius_,z_,y_]:=(z-z0)^2+(y-y0)^2-radius^2;


(* ::Input::Initialization:: *)
tiltAroundVertexMatrix[\[Alpha]_]={{Cos[\[Alpha]],-Sin[\[Alpha]]},{Sin[\[Alpha]],Cos[\[Alpha]]}};


doCalcSphereCenter[zc0_,xc0_,zMir_,xMir_,tiltMir_]:=Module[{centerMirrorTemp,vrtxTemp,centerMir},
centerMirrorTemp={zc0+zMir,xc0+xMir};
vrtxTemp={zMir,xMir};
centerMir=vrtxTemp+tiltAroundVertexMatrix[tiltMir] . (centerMirrorTemp-vrtxTemp);
Return[centerMir]
];



(* ::Subsubtitle::Initialization:: *)
(*(*SPECIFIC GEOMETRY OF RICH (NEED REFRESHING)*)*)


(* ::Input::Initialization:: *)
(*=========================================================================*)
(**)
(*=========================================================================*)
Clear[doCalcPlaneSidewiseCoords];
doCalcPlaneSidewiseCoords[z_,x_,\[Alpha]_,l_,d_:0]:=
Module[{zxCoords},
Print["\n >>>>>>>>>>>>>>>>>>>>> plane coordinates sidewise calc and report // BEGIN "];
zxCoords=(*tiltTheViewRotTra3DZ0@*)Map[{z,x}+#*{Sin[\[Alpha]],-Cos[\[Alpha]]}&,{-l/2,+l/2}];
(*Print@zxCoords;*)
If[zxCoords[[1]][[1]]> zxCoords[[2]][[1]],zxCoords={zxCoords[[2]],zxCoords[[1]]};Print["points swapped to get p4z < p3z "],Print[" p4z < p3z"] ];
Print[" plane edges (P4)  : "," *** along z (beam) = ",nf3@N@zxCoords[[1]][[1]]," *** transverseCoordinate / radial from beam = ",nf3@N@zxCoords[[1]][[2]]];Print[" plane center  C   : "," *** along z (beam) = ",nf3@N@z,          " *** transverseCoordinate / radial from beam = ",nf3@N@x];Print[" plane edges (P3)  : "," *** along z (beam) = ",nf3@N@zxCoords[[2]][[1]]," *** transverseCoordinate / radial from beam = ",nf3@N@zxCoords[[2]][[2]]];
Print[" plane tilt (with respect to the beam-line :=: positive z-axis) DEGREES: ",nf1[\[Alpha]/Degree//N]," RADIANS: ",nf1[\[Alpha]//N]];
Print[" plane Transverse size       : ",nf1[l]," ----- plane ThrdDim size :     ",nf1[d]];
Print[" <<<<<<<<<<<<<<<<<<<<< plane coordinates sidewise calc and report // END \n"];
Return[N@{{zxCoords[[1]],1.0*{z,x},zxCoords[[2]]},{-d/2,+d/2}}]
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
calcSphericalPrimaryMirror[size_,tilt_,radius_,thetaMinPriMir_,p2z$local_]:=Module[{p,q,sol,halfAnglePriMir,sagittaPriMir,antiSagittaPriMir,
crossPriMir,
(*centerPriMir,centerPriMir3D,vrtxPriMir,zVrtxPriMir,xVrtxPriMir,*)
zPriMirMinVar,
xPriMirMinVar,
zPriMirMaxVar,
xPriMirMaxVar,
lhcbTiltAngle
},
printD@size;
printD@tilt;
printD@radius;
printD@thetaMinPriMir;
printD@p2z$local;
zPriMirMinVar=Cos[thetaMinPriMir]*p;
xPriMirMinVar=Sin[thetaMinPriMir]*p;
zPriMirMaxVar=p2z$local;
xPriMirMaxVar=q;
sol=N@Solve[{
dist[zPriMirMinVar,xPriMirMinVar,zPriMirMaxVar,xPriMirMaxVar]==size,-1/AngCoeff[zPriMirMinVar,xPriMirMinVar,zPriMirMaxVar,xPriMirMaxVar]==Tan[tilt]},
{p,q}];
zPriMirMin=zPriMirMinVar/.sol[[1]];
xPriMirMin=xPriMirMinVar/.sol[[1]];
zPriMirMax=zPriMirMaxVar/.sol[[1]];
xPriMirMax=xPriMirMaxVar/.sol[[1]];
zPriMir=(zPriMirMin+zPriMirMax)/2;
xPriMir=(xPriMirMin+xPriMirMax)/2;
(*Determine the axis of the SM*)
dirVectPriMir={zPriMirMax-zPriMirMin,xPriMirMax-xPriMirMin}/dist[zPriMirMin,xPriMirMin,zPriMirMax,xPriMirMax];
dirVectPriMirAxis={xPriMirMax-xPriMirMin,-(zPriMirMax-zPriMirMin)}/dist[zPriMirMin,xPriMirMin,zPriMirMax,xPriMirMax];
halfAnglePriMir=ArcSin[dist[zPriMirMin,xPriMirMin,zPriMirMax,xPriMirMax]/2/radius];
sagittaPriMir=radius*(1-Cos[halfAnglePriMir]);
antiSagittaPriMir=radius*(Cos[halfAnglePriMir]);
crossPriMir={zPriMir,xPriMir};
centerPriMir=crossPriMir-antiSagittaPriMir*dirVectPriMirAxis;
centerPriMir3D=Flatten[{centerPriMir,0}];
vrtxPriMir=crossPriMir+sagittaPriMir*dirVectPriMirAxis;
zVrtxPriMir=vrtxPriMir[[1]];
xVrtxPriMir=vrtxPriMir[[2]];
lhcbTiltAngle=ArcSin[centerPriMir[[2]]/radius];
Print[" SPHERICAL MIRROR ================================================================================================ "];
Print[" Spherical mirror ROC : ",radius];
Print[" P1 *** {z} Spherical mirror min : ",nf1[zPriMirMin]," ----- {transverseCoordinate} Spherical mirror min : ",nf1[xPriMirMin]];
Print[" {z} Spherical mirror Vrtx: ",nf1[zVrtxPriMir]," ----- {transverseCoordinate} Spherical mirror Vrtx: ",nf1[xVrtxPriMir]];
Print[" P2 *** {z} Spherical mirror max : ",nf1[zPriMirMax]," ----- {transverseCoordinate} Spherical mirror max : ",nf1[xPriMirMax]];
Print[" Tilt Spherical mirror (with respect to the beam-line :=: negative z-axis) DEGREES: ",nf1[180-tiltPriMir/Degree//N]," RADIANS: ",nf1[180Degree-tiltPriMir//N]];
Print[" Tilt Spherical mirror (LHCb convention) DEGREES: ",nf1[lhcbTiltAngle/Degree]," RADIANS: ",nf1[lhcbTiltAngle]];
Print[" COC Spherical mirror                   {z,transverseCoordinate} : ",nf1[centerPriMir]];
Print[" Vrtx Spherical mirror                  {z,transverseCoordinate} : ",nf1[vrtxPriMir]];Print[" Center of the Sagitta Spherical mirror {z,transverseCoordinate} : ",nf1[crossPriMir]];
Print[" Spherical mirror width : ",nf1[sizeTrnsvrsPriMir]," ------ Spherical mirror ThrdDim : ",nf1[sizeThrdDimPriMir]];
(*printD@zPriMirMinVar;
printD@xPriMirMinVar;
printD@zPriMirMaxVar;
printD@xPriMirMaxVar;
printD[sol];
printD@zPriMirMin;
printD@xPriMirMin;
printD@zPriMirMax;
printD@xPriMirMax;
printD@zPriMir;
printD@xPriMir;
printD@dirVectPriMir;
printD@dirVectPriMirAxis;
printD@halfAnglePriMir;
printD@sagittaPriMir;
printD@antiSagittaPriMir;
printD@crossPriMir;
printD@centerPriMir;
printD@centerPriMir3D;
printD@vrtxPriMir;
printD@zVrtxPriMir;
printD@xVrtxPriMir;
printD@lhcbTiltAngle;*)
Return[]
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
(* e` un tapullamento... da fare per ogni specchio piano...... *)
(*--------------------------------------------------------------------------------*)
calcFlatSecMirFromLowerAngle[size_,tilt_,thetaMinSecMir_,p4z$local_]:=Module[{p,q,sol,
zSecMirMinVar,xSecMirMinVar,zSecMirMaxVar,xSecMirMaxVar,
zSecMirMin,xSecMirMin,zSecMirMax,xSecMirMax,zSecMir,xSecMir,
thetaMinSecMir2
},
bigBanner[" BEWARE: IT IS OLD !!! ??? it works.... compare with: doCalcPlaneSidewiseCoords"];
bigBanner[" DO NOT USE FOR SPLIT OPTICS WHERE YOU DO NOT NEED TO PUT THE H- FLAT MIRROR AS LOW AS POSSIBLE "];
zSecMirMinVar=p4z$local;
xSecMirMinVar=q;
zSecMirMaxVar=Cos[thetaMinSecMir]*p;
xSecMirMaxVar=Sin[thetaMinSecMir]*p;
sol=N@Solve[{
dist[zSecMirMinVar,xSecMirMinVar,zSecMirMaxVar,xSecMirMaxVar]==size
,
1/AngCoeff[zSecMirMinVar,xSecMirMinVar,zSecMirMaxVar,xSecMirMaxVar]==-Tan[tilt]
},{p,q}
];
zSecMirMin=zSecMirMinVar/.sol[[2]];
xSecMirMin=xSecMirMinVar/.sol[[2]];
zSecMirMax=zSecMirMaxVar/.sol[[2]];
xSecMirMax=xSecMirMaxVar/.sol[[2]];
zSecMir=(zSecMirMin+zSecMirMax)/2/.sol[[2]];
xSecMir=(xSecMirMin+xSecMirMax)/2/.sol[[2]];
secMirNorm3D=Normalize[{-(xSecMirMax-xSecMirMin),+(zSecMirMax-zSecMirMin),0}];
thetaMinSecMir2=ArcTan[xSecMirMax/zSecMirMax];
miniBanner[" Flat mirror "];
Print[" Flat mirror ROC : ",radiusSecMir];
Print[" P4 *** {z} Flat mirror min     : ",nf1[zSecMirMin]," ----- {transverseCoordinate} Flat mirror min     : ",nf1[xSecMirMin]];
Print["        {z} Flat mirror center  : ",nf1[zSecMir],       " ----- {transverseCoordinate} Flat mirror center  : ",nf1[xSecMir]];
Print[" P3 *** {z} Flat mirror max     : ",nf1[zSecMirMax]," ----- {transverseCoordinate} Flat mirror max     : ",nf1[xSecMirMax]];
Print[" thetaMinSecMir (imposed): ",thetaMinSecMir," thetaMinSecMir (calculated) DEGREES: ",thetaMinSecMir2/Degree," ===>>> RADIANS: ",thetaMinSecMir2];
Print[" Tilt Flat mirror (with respect to the beam-line :=: positive z-axis) DEGREES: ",nf1[tiltSecMir/Degree//N]," RADIANS: ",nf1[tiltSecMir//N]];
Print[" Flat mirror width :     ",nf1[sizeTrnsvrsSecMir]," ----- Flat mirror ThrdDim :     ",nf1[sizeThrdDimSecMir]];
Return[{zSecMir,xSecMir,zSecMirMin,xSecMirMin,zSecMirMax,xSecMirMax}]
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
calcFS[zCc_,xCc_,radius_,tilt_]:=Module[{alpha,beta,gamma},
diffXCcIp=xCc;
diffZCcIp=-zCc;
CHToIPToCcAngle=ArcTan[diffXCcIp/diffZCcIp];
betaVrtx=CHToIPToCcAngle-tilt;
gamma[alpha_]:=ArcSin[(Sqrt[diffZCcIp^2+diffXCcIp^2]/radius)*Sin[alpha+CHToIPToCcAngle]];
nu[alpha_]:=ArcSin[2*Sin[gamma[alpha]]]-gamma[alpha];
beta[alpha_]:=alpha+CHToIPToCcAngle-gamma[alpha];
tau[alpha_]:=nu[alpha]+beta[alpha]-CHToIPToCcAngle;
edgeParaFSNear[[1]]=(radius/2)*Cos[tau[0]]+zCc;
edgeParaFSNear[[2]]=(radius/2)*Sin[tau[0]]+xCc;
edgeParaFSAway[[1]]=(radius/2)*Cos[tau[trnsvrsAcc]]+zCc;
edgeParaFSAway[[2]]=(radius/2)*Sin[tau[trnsvrsAcc]]+xCc;
Print[" CHToIPToCcAngle   ",nf1[CHToIPToCcAngle],"   --- betaVrtx   ",nf1[betaVrtx]];
miniBanner[" \n PD-PLANE ========================================================================= "];
Print[" P8 *** {z} PD-PLANE center  : ",nf1[zScreen]," ----- {transverseCoordinate} PD-PLANE center  : ",nf1[xScreen]];
(*Print[" Tilt PD-PLANE (with respect to the beam-line :=: negative z-axis) DEGREES : ",nf1[tiltScreen/Degree//N]," RADIANS: ",nf1[tiltScreen//N]];*)
Print[" PD-PLANE width :     ",nf1[sizeTrnsvrsScreen]," ----- PD-PLANE ThrdDim :     ",nf1[sizeThrdDimScreen]]
];


(* ::Subsubtitle::Initialization:: *)
(*(*Quartic solution to back - tracing*)*)


(* ::Input::Initialization:: *)
wp=50;
sumAB[p_,q_,d_]=ArcCos[(p^2+q^2-d^2)/(2 p q)];
eq1=Sin[\[Alpha]](radius/p-Cos[\[Beta]])-Sin[\[Beta]](radius/q-Cos[\[Alpha]])/.\[Beta]->sumAB[p,q,d]-\[Alpha]//TrigExpand//FullSimplify;
eq1=Sin[\[Alpha]](radius/p-Cos[\[Beta]])-Sin[\[Beta]](radius/q-Cos[\[Alpha]])/.\[Beta]->sumAB[p,q,d]-\[Alpha]//TrigExpand;
eq2=Sin[\[Alpha]]^2+Cos[\[Alpha]]^2-1;
eq2bis=eq2/.{Cos[\[Alpha]]->X,Sin[\[Alpha]]->Y};
eq1bis=eq1/.{Sin[\[Alpha]]^2->1-X^2,Cos[\[Alpha]]->X,Sin[\[Alpha]]->Y};
solY=Solve[eq1bis==0,{Y},WorkingPrecision->wp][[1]];
eq2tris=eq2bis/.solY;

solX=Solve[eq2tris==0,X,WorkingPrecision->wp];
resX[p_,q_,d_,radius_]=N[X/.solX,wp];
resY[p_,q_,d_,radius_]=N[Y/.solY/.solX,wp];




(* ::Subsubtitle::Initialization:: *)
(*(*SIMULATION/ANALYSIS/TRACING*)*)


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
trackGen[num_,minAcc_,maxYAcc_,maxXAcc_]:=Module[{\[Theta],\[Phi],zeta,radius,theta0X,theta0Y},
zSphe[radius_,\[Theta]_,\[Phi]_]=radius*Cos[\[Theta]];
xSphe[radius_,\[Theta]_,\[Phi]_]=radius*Sin[\[Theta]]*Cos[\[Phi]];
ySphe[radius_,\[Theta]_,\[Phi]_]=radius*Sin[\[Theta]]*Sin[\[Phi]];
xRect[zeta_,thetaX_,thetaY_]=zeta*Tan[thetaX];
yRect[zeta_,thetaX_,thetaY_]=zeta*Tan[thetaY];
thetaX={};
thetaY={};
phi=RandomReal[{0,+\[Pi]},num];
theta=RandomReal[{minAcc,Sqrt[maxYAcc^2+maxXAcc^2]},num];
(*Print[Histogram[phi]];
Print[Histogram[theta]];*)theta0X=ArcTan[xSphe[1,theta,phi]/zSphe[1,theta,phi]];
theta0Y=ArcTan[ySphe[1,theta,phi]/zSphe[1,theta,phi]];
Do[If[Abs[theta0Y[[k]]]>maxYAcc||Abs[theta0X[[k]]]>maxXAcc,Null,AppendTo[thetaX,theta0X[[k]]];AppendTo[thetaY,theta0Y[[k]]];],{k,1,num}];
angle=Transpose[{thetaX,thetaY}];
Length[angle];
Print[Graphics[Point[angle],GridLines->Automatic,Axes->True]];];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
localTrackUnitVectors[trackDir_]:=Module[{w,theTrackDir},
theTrackDir=Normalize[trackDir];
localPerpUnitVector=Normalize[Cross[theTrackDir,{0,0,1}]];
(*The following w must be the same expression as above!!!*)
(*w=Normalize[Cross[Normalize[{theTrackDir[[1]],theTrackDir[[2]],0}],{0,0,1}]];*)
(*Print[Norm[w-localPerpUnitVector]];*)
localThirdUnitVector=Normalize[Cross[localPerpUnitVector,theTrackDir]];
Return[{localPerpUnitVector,localThirdUnitVector}]
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
execBackTracing[re_,rd_,rc_,rv_]:=Module[{p,q,d,gamma1,gamma2,gammap,gammaq,unitPerp,unitCE,unit3,rvRec,err,trackPhotonPlaneUnitVector,trackUnitVector,projXLocal,projYLocal},
p=Norm[rd-rc];
q=Norm[re-rc];
d=Norm[rd-re];
angles[p,q,d,radiusPriMir];
gamma1=ArcTan[Sin[alpha]/(radiusPriMir/q-Cos[alpha])];
gamma2=ArcTan[Sin[beta]/(radiusPriMir/p-Cos[beta])];
gammaq=ArcCos[(radiusPriMir^2+Norm[rv-re]^2-q^2)/(2*radiusPriMir*Norm[rv-re])];
gammap=ArcCos[(radiusPriMir^2+Norm[rv-rd]^2-p^2)/(2*radiusPriMir*Norm[rv-rd])];
unitPerp=Normalize[Cross[re-rc,rd-rc]];
unitCE=Normalize[re-rc];
unit3=Normalize[Cross[unitPerp,unitCE]];
rvRec=unitCE*radiusPriMir*Cos[alpha]+unit3*radiusPriMir*Sin[alpha]+rc;
err=Norm[rv-rvRec];
(*Print["Err:    ",err];*)trackPhotonPlaneUnitVector=Normalize[Cross[trackDir,rvRec-re]];
{localPerpUnitVector,localThirdUnitVector}=localTrackUnitVectors[trackDir];
projXLocal=Dot[trackPhotonPlaneUnitVector,localPerpUnitVector];
projYLocal=Dot[trackPhotonPlaneUnitVector,localThirdUnitVector];
AppendTo[resChThe,VectorAngle[rvRec-re,trackDir]];
AppendTo[resChPhi,ArcTan[projXLocal,projYLocal]];
(*OLD CASINO BUGS*)(*trackUnitVector=Normalize[Cross[Normalize[{trackDir[[1]],trackDir[[2]],0}],{0,0,1}]];
Print[trackPhotonPlaneUnitVector];
Print[trackUnitVector];
Print[" A :",trackUnitVector];
Print[" B :",N[Cross[trackDir,{0,0,1}],30]];
projYPrime=Dot[trackPhotonPlaneUnitVector,{0,0,1}];
projXPrime=Dot[trackPhotonPlaneUnitVector,trackUnitVector];
trackDir2=trackDir;
trackPhotonPlaneUnitVector2=trackPhotonPlaneUnitVector;
trackUnitVector2=trackUnitVector;
trackUnitVector2BIS=Normalize[Cross[trackDir,{0,0,1}]];
third=-Normalize[Cross[trackDir,trackUnitVector2BIS]];
projXPrime2=Dot[trackPhotonPlaneUnitVector,trackUnitVector];
projXPrime2BIS=Dot[trackPhotonPlaneUnitVector,trackUnitVector2BIS];
projYPrime2=Dot[trackPhotonPlaneUnitVector,{0,0,1}];
projYPrime2BIS=Dot[trackPhotonPlaneUnitVector,third];*)
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
ClearAll[myFocalSurfaceAnalyze];
myFocalSurfaceAnalyze[points3DOnTheFS_,points2DOnTheFS_,pointsTiltOnTheFS_,tilt_(* RADIANS *),sensorPitch_:1]:=Module[{
sizeFSTrnsvrs,sizeFSThrdDim,areaFS,numSensors,resThetaProj,resTheta,
(*theDirScreenInCentralPlane,*)
pointsTiltProjOnTheFS,vvv,uuu,
trnsvrsMagnification,thrdDimMagnification,zPDACenter,xPDACenter,finalRaysDir
},
(*!@#$% changed for a split PD:pass all data and only do calculations here*)If[Length@points3DOnTheFS<=0||Length@points2DOnTheFS<=0,bigBanner[" ERROR ON myFocalSurfaceAnalyze - Returning "];Return[]];
(*improve:tilt screen can be determined by points3DOnTheFS*)
zPDACenter=Median[Transpose[points3DOnTheFS][[1]]];
xPDACenter=Median[Transpose[points3DOnTheFS][[2]]];
Histogram[Transpose[points2DOnTheFS][[1]],100,AspectRatio->1/2];
Histogram[Transpose[points2DOnTheFS][[2]],100,AspectRatio->1/2];
sizeFSTrnsvrs=Max[Transpose[points2DOnTheFS][[1]]]-Min[Transpose[points2DOnTheFS][[1]]];
sizeFSThrdDim=Max[Transpose[points2DOnTheFS][[2]]]-Min[Transpose[points2DOnTheFS][[2]]];
areaFS=sizeFSTrnsvrs*sizeFSThrdDim/1000000;
numSensors=sizeFSTrnsvrs*sizeFSThrdDim/sensorPitch^2;
(**)
resThetaProj={};resTheta={};
(*theDirScreenInCentralPlane={Cos[tilt],Sin[tilt],0};*)
finalRaysDir=Mean[ArcTan[Transpose[pointsTiltOnTheFS][[2]]/Transpose[pointsTiltOnTheFS][[1]]]]/Degree;
If[Length[pointsTiltOnTheFS]>0,
AppendTo[resTheta,1000*ArcCos[pointsTiltOnTheFS . {Cos[tilt],Sin[tilt],0}]];
pointsTiltProjOnTheFS=Transpose[{Transpose[pointsTiltOnTheFS][[1]],Transpose[pointsTiltOnTheFS][[2]],ConstantArray[0,Length[pointsTiltOnTheFS]]}];
uuu=Map[Normalize,pointsTiltProjOnTheFS];
vvv=Table[Cross[{Cos[tilt],Sin[tilt],0},uuu[[k]]],{k,1,Length[uuu]}];
AppendTo[resThetaProj,1000*ArcSin[Transpose[vvv][[3]]]],Print["zero length pointsTiltOnTheFS"];
Remove[uuu]
,
Print["zero length pointsTiltOnTheFS  "]
];
(**)
trnsvrsMagnification=sizeFSTrnsvrs/(2*halfOpenAngleMRad);
thrdDimMagnification=sizeFSThrdDim/(2*halfOpenAngleMRad);
resThetaProj=Flatten[resThetaProj];
resTheta=Flatten[resTheta];
Print[Histogram[resThetaProj,ChartElementFunction->"FadingRectangle",ChartStyle->Orange,PlotLabel->"resThetaProj (mrad)",AspectRatio->1/2,Frame->True]];
Print[Histogram[resTheta,ChartElementFunction->"FadingRectangle",ChartStyle->Orange,PlotLabel->"resTheta (mrad)",AspectRatio->1/2,Frame->True]];
Print["   zPDACenter                                                       ",nf1[zPDACenter]];
Print["   xPDACenter                                                       ",nf1[xPDACenter]];
Print["   finalRaysDir in plane z-x (degrees)                              ",nf1[finalRaysDir]];
Print["   Mean resThetaProj         (mrad)                                 ",nf1[Mean[resThetaProj]]];
Print["   Median resThetaProj       (mrad)                                 ",nf1[Median[resThetaProj]]];
Print["   Mean resTheta             (mrad)                                 ",nf1[Mean[resTheta]]];
Print["   Median resTheta           (mrad)                                 ",nf1[Median[resTheta]]];
Print["   Estimated size PD-plane local z-Trnsvrs coordinate (mm)          ",nf1[sizeFSTrnsvrs]];
Print["   Estimated size PD-plane ThrdDim (mm)                             ",nf1[sizeFSThrdDim]];
Print["   Estimated area of the PD-plane (m**2)                            ",nf1[areaFS]];
Print["   Estimated number of sensors (one half detector)                  ",nf1[numSensors]];
Print["   Assumed Nominal Sensor Pitch                                     ",nf1[sensorPitch]];
Print["   Transverse Magnification (mm/mrad) - meaningful for one single particle ray-tracing ",nf3[trnsvrsMagnification]];
Print["   ThrdDim Magnification    (mm/mrad) - meaningful for one single particle ray-tracing ",nf3[thrdDimMagnification]];
Print["   Average Magnification    (mm/mrad) - meaningful for one single particle ray-tracing ",nf3[average[trnsvrsMagnification,thrdDimMagnification]]];
miniBanner["For full PDA magnfication use (maxPos-asyRngRadius)/trackAngle"];
Print[{"zPDACenter","xPDACenter","sizeFSTrnsvrs","sizeFSThrdDim","Median[resThetaProj]","Median[resTheta]"}];
Return[{zPDACenter,xPDACenter,sizeFSTrnsvrs,sizeFSThrdDim,Median[resThetaProj],Median[resTheta]}];
];



(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
cherenkovPhotonsRandomGenerate[nTot_,partMass_,partMomentum_,thetaY_,thetaX_,chromatic_:0,phiMin_:0,phiMax_:2\[Pi],zeta_:0]:=Module[
{t,x0,y0,z0,d,photonEnergies,rWaveLength,rChZet,rChThe,rChPhi,rStart,photonDir,trackDir,idCntBlwThrMax,idCntBlwThr,localPerpUnitVector,localThirdUnitVector},
(*================================================================================================*)
(*                                                                                                         *)
(* Generate the TRUE photons                                                                               *)
(*                                                                                                         *)
(*================================================================================================*)
(*--------------------------------------------------------------------------------*)
(* zeta *)
(* !@#$% to setup carefully different options *)
Print[" >>>>>>>>>>>> Photon random generation "];
Print[" zBoxMin = ",zBoxMin];
Print[" zeta    = ",zeta];
Print[" zBoxMax = ",zBoxMax];
If[(zeta>=0)&&(zeta>zBoxMin)
,
Print[" \n Doing random zeta"];
rChZet=RandomReal[{zBoxMin,zeta},nTot]
,
Print[" \n Skipping random zeta"];
rChZet=Array[zeta&,nTot]
];
rStart=Transpose[{rChZet,rChZet*Tan[thetaY],rChZet*Tan[thetaX]}];
trackDir=Normalize[{1,Tan[thetaY],Tan[thetaX]}];
{localPerpUnitVector,localThirdUnitVector}=localTrackUnitVectors[trackDir];
debugPrint[" z_c = ",Round@rChZet];
zetaMax=zeta;
zetaMin=zBoxMin;
Print[" zetaMin = ",nf@zetaMin];
Print[" zetaMax = ",nf@zetaMax];
Print[" <<<<<<< END random zeta "];
(*--------------------------------------------------------------------------------*)
(* theta *)
If[chromatic==1
,
Print[" \n Doing chromaticity"];
photonEnergies=generatePhotonEnergy[nTot];(* !@#$% TAPULLO ??? *)
rWaveLength=\[Lambda][photonEnergies];
rChThe=chrnkvAngle[partMass,partMomentum,rWaveLength];
,
Print[" \n Skipping chromaticity"];
photonEnergies=Array[\[Epsilon][theWavLen]&,nTot];
rWaveLength=Array[theWavLen&,nTot];
rChThe=Array[chrnkvAngle[partMass,partMomentum,theWavLen]&,nTot]
];
debugPrint["  \[Lambda]  = ",Round@rWaveLength];
debugPrint[" \[Theta]_c = ",nf[rChThe,7,4]];
Print[" <<<<<<< END chromaticity "];
(*--------------------------------------------------------------------------------*)
(* phi *)
If[phiMin<phiMax
,
Print[" \n Doing random phi"];
rChPhi=RandomReal[{phiMin,phiMax},nTot]
,
Print[" \n Skipping random phi"];
d=(phiMax-phiMin)/nTot;
rChPhi=Table[k+d/2,{k,0,nTot-1}]
];
debugPrint[" \[Phi]_c = ",nf[rChPhi,7,4]];
Print[" <<<<<<< END random phi "];
photonDir={};
idCntBlwThr=0;
idCntBlwThrMax=5;
Do[
If[rChThe[[j]]==0
,
idCntBlwThr=idCntBlwThr+1;
exception[idCntBlwThr,idCntBlwThrMax," \[Theta]_C = 0 "]
];
AppendTo[photonDir,Cos[rChThe][[j]]*trackDir+Sin[rChThe][[j]]*(Cos[rChPhi][[j]]*localPerpUnitVector+Sin[rChPhi][[j]]*localThirdUnitVector)]
,{j,1,nTot}
];
(*debugPrint[" tilt = ",TableForm@nf@photonDir];*)
(*myTrack:=Move[SingleRay[],{zBoxMin,zBoxMin*Tan[thetaY],zBoxMin*Tan[thetaX]},trackDir];*)
(* !@#$% BEWARE: Optica wants waveln in microns *)
(* Save true values for later *)
exportTrueChPhi=rChPhi;
exportTrueChThe=rChThe;
exportTrueChZet=rChZet;
Return[CustomRays[{{RayStart,rStart},{RayTilt,photonDir},{WaveLength,N[rWaveLength/1000]}}]]
];



(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
doExecBackTracingSimul[method_,poisson_,pixel_,chromaticity_,theZeta_]:=Module[{backTracingSimulResults,resTThrdDim,resTTrnsvrs,resNTot,resNDet},
(*================================================================================================*)
(*                                                                                                          *)
bigBanner[" MAIN LOOP for backtracing - START "];
(*                                                                                                          *)
(*================================================================================================*)
resNTot={};resNDet={};resTThrdDim={};resTTrnsvrs={};
(*--------------------------------------------------------------------------------*)
(* START LOOP for creating tracks *)
(*--------------------------------------------------------------------------------*)
(*
nTrnsvrs=2;
nThrdDim=2;
Do[
tTrnsvrs=minAcc+(trnsvrsAcc-minAcc)*jTrnsvrs/(nTrnsvrs-1);
tThrdDim=(thrdDimAcc-minAcc)*jThrdDim/(nThrdDim-1);
tTrnsvrs=minThetaTrsvrsTrack+(trnsvrsAcc)*jTrnsvrs/(nTrnsvrs-1);
tThrdDim=(thrdDimAcc)*jThrdDim/(nThrdDim-1);
AppendTo[resTThrdDim,tThrdDim];
AppendTo[resTTrnsvrs,tTrnsvrs];
,{jThrdDim,0,nThrdDim-1}
,{jTrnsvrs,0,nTrnsvrs-2}
];
*)
(*--------------------------------------------------------------------------------*)
(* END LOOP for creating tracks *)
(*--------------------------------------------------------------------------------*)
(*--------------------------------------------------------------------------------*)
(* single test track *)
(*--------------------------------------------------------------------------------*)
(**)
bigBanner[" Start SIMULATE ONE TRACK "];
(**)
Print[" New Track at ****** ","tThrdDim   ",tThrdDim,"   --- tTrnsvrs   ",tTrnsvrs];
(*--------------------------------------------------------------------------------*)
(* back-tracking *)
(*--------------------------------------------------------------------------------*)
backTracingSimul[method,poisson,numGenPho,tTrnsvrs,tThrdDim,pixel,chromaticity,theZeta];
backTracingSimulResults=Transpose[{resTThrdDim,resTTrnsvrs,resNTot,resNDet}];
bigBanner[" End SIMULATE ONE TRACK "];
Print[" Summary results for loop with:"];
Print[" pixel        : ",pixel];
Print[" chromaticity : ",chromaticity];
Print[" theZeta      : ",theZeta];
(*
Transpose[{resTThrdDim,resTTrnsvrs,trackLength}]//TableForm;
ListPlot3D[Transpose[{resTThrdDim,resTTrnsvrs,trackLength}],Mesh\[Rule]8,InterpolationOrder\[Rule]0,ColorFunction\[Rule]"SouthwestColors"];
Print[nf1[res]];
*)
Return[backTracingSimulResults]
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
backTracingSimul[method_,poisson_,numGenPho_,thetaY_,thetaX_,pixel_,chromatic_,theZeta_]:=Module[{
opticalSystemLHCbRICHTheTrack,
nTot,nDet,tTracedSystem,rPD,rv,rStartTrack,rMidTra,rStrTra,rEndTra,myTrack,thetaHalfRange,tracedPointsFS,
rStrPho,rEndPriMirPho,tracedTrack,tracedTruePhotons,tracedPointsFS2D,tracedPointsFSDigitized},
(*================================================================================================*)
(*                                                                                                         *)
(* Generate the TRUE photons                                                                               *)
(*                                                                                                         *)
(*================================================================================================*)
(* global ! *)
resChThe={};
resChPhi={};
resChZet={};
trackLength={};
resNTot={};
resNDet={};
bestFitTrack={};
(*--------------------------------------------------------------------------------*)
(* Determine the geometry of the track as if it were a photon *)
(*--------------------------------------------------------------------------------*)
bigBanner[ " Create the TRACK geometry "];
trackDir=Normalize[{1,Tan[thetaY],Tan[thetaX]}];
(* The track starts from *)
If[theZeta==0,
rStartTrack={0,0,0}
,
If[theZeta>0,
rStartTrack={theZeta,theZeta*Tan[thetaY],theZeta*Tan[thetaX]}
,
rStartTrack={zBoxMin,zBoxMin*Tan[thetaY],zBoxMin*Tan[thetaX]}
];
];
myTrack:=Move[SingleRay[],rStartTrack,trackDir];
opticalSystemLHCbRICHTheTrack={myTrack,myOptics,myBoundary};
tracedTrack=AnalyzeSystem[opticalSystemLHCbRICHTheTrack,DefaultStyle->{AbsoluteThickness[5],AbsolutePointSize[5]}];
rStrTra=Flatten[ReadRays[tracedTrack,RayStart,onThePriMirror]];
rEndTra=Flatten[ReadRays[tracedTrack,RayEnd,onThePriMirror]];
AppendTo[trackLength,Norm[rEndTra-rStrTra]];
rMidTra=Map[Mean,Transpose[{rStrTra,rEndTra}]];
If[debugPrintEnabledFlag==True,
Print[" myTrack     = ",myTrack];
Print[" rStartTrack = ",rStartTrack," must be rStrTra==rStartTrack "];
Print[" rStrTra     = ",rStrTra," must be rStrTra==rStartTrack "];
Print[" rMidTra     = ",rMidTra];
Print[" rEndTra     = ",rEndTra];
Print[" <<<<<<< END generate one track "]
];
(*--------------------------------------------------------------------------------*)
(* Generate the true Cherenkov photons *)
(*--------------------------------------------------------------------------------*)
bigBanner[ " Generate the TRUE photons "];
Print["   poisson =   ",poisson," (1 = poissonized)          AVERAGE numGenPho =   ",numGenPho];
bigBanner[" Start generate the TRUE photons "];
If[poisson==1
,
(* Poissonize the numGenPho *)
nTot=RandomVariate[PoissonDistribution[numGenPho]];
Print[" Generate nTot = ",nTot,"        Poisson true photons - from Poissonization of numGenPho "];
If[nTot>0
,
myTrueCherenkovPhotons=cherenkovPhotonsRandomGenerate[nTot,partMass,partMomentum,thetaY,thetaX,chromatic,0,2\[Pi],rEndTra[[1]]]
,
Print[" ZERO number of generated photons - STOP "];
killStop
]
,
(* Do not Poissonize the numGenPho *)
nTot=numGenPho;
Print[" Generate nTot = ",nTot,"        exact true photons (no Poissonization) "];
myTrueCherenkovPhotons=cherenkovPhotonsRandomGenerate[nTot,partMass,partMomentum,thetaY,thetaX,chromatic,0,2\[Pi],rEndTra[[1]]]
];
debugPrint[" myTrueCherenkovPhotons as generated = ",TableForm@myTrueCherenkovPhotons];

(*--------------------------------------------------------------------------------*)
(* Trace the true Cherenkov photons *)
(*--------------------------------------------------------------------------------*)
opticalSystemLHCbRICHTruePhotons={myTrueCherenkovPhotons,myOptics,myBoundary};
tracedTruePhotons=AnalyzeSystem[opticalSystemLHCbRICHTruePhotons
(*,ColorView -> Red*)
];
tracedPointsFS=ReadRays[tracedTruePhotons,RayEnd,onTheFS];
rStrPho=ReadRays[tracedTruePhotons,RayStart,onThePriMirror];
rEndPriMirPho=ReadRays[tracedTruePhotons,RayEnd,onThePriMirror];
Print[Graphics3D[Point[Join[rEndPriMirPho,rEndPriMirPho]]]];
rv=ReadRays[tracedTruePhotons,RayEnd,onThePriMirror];

(*--------------------------------------------------------------------------------*)
(* Pixelization on the FS of the true Cherenkov photons *)
(*--------------------------------------------------------------------------------*)
tracedPointsFS2D=ReadRays[tracedTruePhotons,SurfaceCoordinates,onTheFS];
If[pixel>0
,
rPD=tracedPointsFSDigitized=pixelize[tracedPointsFS2D,pixel];
Print[" \n Doing pixelization"]
,
rPD=tracedPointsFS;
Print[" \n Skipping pixelization"]
];
(*--------------------------------------------------------------------------------*)
(* OLD: single spherical mirror: deprecated *)
(*--------------------------------------------------------------------------------*)
(*If[method\[Equal]"singleSphericalMirrorExactBackTracing"
,
Print[" Doing the only-one-spherical-mirror exact back-trace "];
(*OLD:exact for one spherical mirror only*)
If[theZeta\[Equal]-1
,
(*!@#$% you cant call again execBackTracing HERE!!!*)
Do[execBackTracing[tracedPointsEP[[j]],reflect3D[rPD[[j]],Normalize[secMirNorm3D]],centerPriMir3D,rv[[j]]],{j,1,Length[rPD]}];
Print["NOT Doing emission point error: assume true emission point "]
,
Do[execBackTracing[rStartTrack,reflect3D[rPD[[j]],Normalize[secMirNorm3D]],centerPriMir3D,rv[[j]]],{j,1,Length[rPD]}]]
];
*)
(*--------------------------------------------------------------------------------*)
(* NEW: totally general but quite slow... reconstruct true photons via forward tracking *)
(*--------------------------------------------------------------------------------*)
If[method=="generalBackTrace"
,
(*Print[" Doing the general back-trace "];*)
(*Print[" thetaX     ",thetaX];*)
(*Print[" thetaY     ",thetaY];*)
(*Print[" rStartTrack       = ",rStartTrack];*)
(*Print[" First@rStartTrack = ",First@rStartTrack];*)
Do[
(* !@#$% fix rStartTrack !*)
doExecGeneralForwardTrace[First@rStartTrack,thetaY,thetaX,rPD[[j]]]
,{j,1,Length[rPD]}
]
];
nDet=Length[tracedPointsFS];
Print[" number of generated photons           : ",nTot];
Print[" number of detected photons on the PDA : ",nDet];
If[nTot!=nDet,bigBanner[" WARNING: nTot\[NotEqual]nDet "]];
AppendTo[resNTot,nTot];
AppendTo[resNDet,nDet];
bigBanner[" "];
bigBanner[" END single track analysis - SUMMARY RESULTS "];
(*--------------------------------------------------------------------------------*)
(* Results *)
(*--------------------------------------------------------------------------------*)
thetaHalfRange=0.020;
Print[Histogram[resChPhi]];
Print[Histogram[resChPhi,{-\[Pi],+\[Pi],0.1},
AxesLabel->{" \!\(\*SubscriptBox[\(\[Phi]\), \(c\)]\) (rad) ",""},
Axes->{True,False}]
];
Print[Histogram[resChThe]];
Print[Histogram[resChThe,{halfOpenAngle -thetaHalfRange,halfOpenAngle +thetaHalfRange,0.001},
AxesLabel->{" \!\(\*SubscriptBox[\(\[Theta]\), \(c\)]\) (rad) ",""},
Axes->{True,False}]
];
Print[ListPlot[Transpose[{resChPhi,resChThe}],
AxesLabel->{" \!\(\*SubscriptBox[\(\[Phi]\), \(c\)]\) (rad) "," \!\(\*SubscriptBox[\(\[Theta]\), \(c\)]\) (rad) "},
Axes->{True,True},
AxesOrigin->{0,halfOpenAngle},
PlotRange->{{-\[Pi],+\[Pi]},{halfOpenAngle -thetaHalfRange,halfOpenAngle +thetaHalfRange}},
GridLines->Automatic]
];
Print[Histogram3D[Transpose[{resChPhi,resChThe}]]];
Print[Histogram[resChZet]];
Print[Histogram[resChThe,{zBoxMin,zBoxMax,10},
AxesLabel->{" z (mm) ",""},
Axes->{True,False}]
];
Print[ListPlot[Transpose[{resChZet,resChPhi}],
AxesLabel->{" z (mm) "," \!\(\*SubscriptBox[\(\[Phi]\), \(c\)]\) (rad) "},
Axes->{True,True},
AxesOrigin->{zBoxCen,0},
PlotRange->{{zBoxMin,zBoxMax},{-\[Pi],+\[Pi]}},
Filling->Axis,
FillingStyle->{Thickness[0.005]},
GridLines->Automatic]
];
Print[ListPlot[Transpose[{resChZet,resChThe}],
AxesLabel->{" z (mm) "," \!\(\*SubscriptBox[\(\[Theta]\), \(c\)]\) (rad) "},
Axes->{True,True},
AxesOrigin->{zBoxCen,halfOpenAngle},
PlotRange->{{zBoxMin,zBoxMax},{halfOpenAngle -thetaHalfRange,halfOpenAngle +thetaHalfRange}},
Filling->Axis,
FillingStyle->{Thickness[0.005]},
GridLines->Automatic]
];
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
doExecGeneralForwardTrace[zetaStartTrack_,thetaY_,thetaX_,target3D_]:=Module[{newPhi,newThe,newZet},
(*================================================================================================*)
(*                                                                                                         *)
(* Do backtrace via multipe forwardtraces                                                                  *)
(*                                                                                                         *)
(*================================================================================================*)
bestFitTestForwardTraceCherenkovPhotonThr=0.5; (* mm ! *)
bestFitPhoton={};
bigBanner[" Start general back-trace for one given photon emitted by a given track "];
Print[" zetaMin = ",zetaMin];
Print[" zetaMax = ",zetaMax];
(*--------------------------------------------------------------------------------*)
(* Scan independently theta and phi: slower but SAFER *)
(*--------------------------------------------------------------------------------*)
newThe=halfOpenAngle/1000;
newPhi=0;
newZet=(zetaMax+zetaMin)/2;
Print[" Starting phi for photon (rad) : ",nf1[reduceAngle[newPhi]]," +/- ",dPhi0];
Print[" Starting the for photon (rad) : ",nf1[newThe],                              " +/- ",dThe0];
Print[" Starting zet for photon (mm)  : ",nf1[newZet],                              " +/- ",dZet0];

bestFitTestForwardTraceCherenkovPhoton=1000000000; (* huge fake starting error *)

Print[" --- newPhi = ",nf1[newPhi]," --- newThe = ",nf1[newThe]," --- newZet = ",nf1[newZet]];
   (* Scan for phi, at the reference theta *)
If[bestFitTestForwardTraceCherenkovPhoton>bestFitTestForwardTraceCherenkovPhotonThr,
{newPhi,newThe,newZet}=forwardTrace[zetaStartTrack,thetaY,thetaX,   newPhi,newThe,newZet,   nPhi1,0,0,   dPhi1,0,0,   target3D]
,Print[" Target goal reached: stop iterating .... "];
];
Print[" --- newPhi = ",nf1[newPhi]," --- newThe = ",nf1[newThe]," --- newZet = ",nf1[newZet]];
   (* At newPhi, scan along theta *)
If[bestFitTestForwardTraceCherenkovPhoton>bestFitTestForwardTraceCherenkovPhotonThr,
{newPhi,newThe,newZet}=forwardTrace[zetaStartTrack,thetaY,thetaX,   newPhi,newThe,newZet,   0,nThe1,0,   0,dThe1,0,   target3D]
,Print[" Target goal reached: stop iterating .... "];
];
Print[" --- newPhi = ",nf1[newPhi]," --- newThe = ",nf1[newThe]," --- newZet = ",nf1[newZet]];
   (* At newThe, rescan for phi *)
If[bestFitTestForwardTraceCherenkovPhoton>bestFitTestForwardTraceCherenkovPhotonThr,
{newPhi,newThe,newZet}=forwardTrace[zetaStartTrack,thetaY,thetaX,   newPhi,newThe,newZet,   nPhi2,0,0,   dPhi2,0,0,   target3D]
,Print[" Target goal reached: stop iterating .... "];
];
Print[" --- newPhi = ",nf1[newPhi]," --- newThe = ",nf1[newThe]," --- newZet = ",nf1[newZet]];

   (* At newPhi, scan along theta *)
If[bestFitTestForwardTraceCherenkovPhoton>bestFitTestForwardTraceCherenkovPhotonThr,
{newPhi,newThe,newZet}=forwardTrace[zetaStartTrack,thetaY,thetaX,   newPhi,newThe,newZet,   0,nThe2,0,   0,dThe2,0,   target3D]
,Print[" Target goal reached: stop iterating .... "];
];
Print[" --- newPhi = ",nf1[newPhi]," --- newThe = ",nf1[newThe]," --- newZet = ",nf1[newZet]];
   (* At newThe and newPhi, scan for z *)
If[bestFitTestForwardTraceCherenkovPhoton>bestFitTestForwardTraceCherenkovPhotonThr,
{newPhi,newThe,newZet}=forwardTrace[zetaStartTrack,thetaY,thetaX,   newPhi,newThe,newZet,   0,0,nZet1,   0,0,dZet1,   target3D]
,Print[" Target goal reached: stop iterating .... "];
];
Print[" --- newPhi = ",nf1[newPhi]," --- newThe = ",nf1[newThe]," --- newZet = ",nf1[newZet]];
   (* At newThe and newPhi, scan for z *)
If[bestFitTestForwardTraceCherenkovPhoton>bestFitTestForwardTraceCherenkovPhotonThr,
{newPhi,newThe,newZet}=forwardTrace[zetaStartTrack,thetaY,thetaX,   newPhi,newThe,newZet,   0,0,nZet2,   0,0,dZet2,   target3D]
,Print[" Target goal reached: stop iterating .... "];
];
Print[" --- newPhi = ",nf1[newPhi]," --- newThe = ",nf1[newThe]," --- newZet = ",nf1[newZet]];

(* Hypercube scan  *)
If[bestFitTestForwardTraceCherenkovPhoton>bestFitTestForwardTraceCherenkovPhotonThr,
{newPhi,newThe,newZet}=forwardTrace[zetaStartTrack,thetaY,thetaX,   newPhi,newThe,newZet,   nPhi3,nThe3,nZet3,   dPhi3,dThe3,dZet3,   target3D]
,Print[" Target goal reached: stop iterating .... "];
];


Print[" --- newPhi = ",nf1[newPhi]," --- newThe = ",nf1[newThe]," --- newZet = ",nf1[newZet]];
If[bestFitTestForwardTraceCherenkovPhoton>bestFitTestForwardTraceCherenkovPhotonThr,
Print[" WARNING: bestFitTestForwardTraceCherenkovPhoton too LARGE ",bestFitTestForwardTraceCherenkovPhoton]
];

bigBanner[" ===>>> results for one single photon reconstruction "];

Print[" Estimated phi for photon (rad) : ",nf1[reduceAngle[newPhi]]," +/- ",dPhi2];
Print[" Estimated the for photon (rad) : ",nf1[newThe]," +/- ",dThe2];
Print[" Estimated zet for photon (mm)  : ",nf1[newZet]," +/- ",dZet2];

AppendTo[resChPhi,reduceAngle[newPhi]];
AppendTo[resChThe,newThe];
AppendTo[resChZet,newZet];
AppendTo[bestFitTrack,bestFitPhoton];

];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
forwardTrace[zetaStartTrack_,alphaY_,alphaX_,phi0_,the0_,zet0_,nPhi_,nThe_,nZet_,dPhi_,dThe_,dZet_,rPD_]:=Module[
{gridPhiTheZet,rTilt,rEmis,r0,trackDir,rForwardTraced,errorTestForwardTraceCherenkovPhoton,jbest,zetaPhotonEmission,localPerpUnitVector,localThirdUnitVector,numGridPoints,myTrack,myTestCherenkovPhotons,opticalSystemLHCbRICHTestPhotons,tracedTestPhotons,phiSol,theSol,zetSol},
(*================================================================================================*)
(*                                                                                                          *)
(* Do forwardtrace // !@#$% I should also scan in z!                                                       *)
(*                                                                                                          *)
(*================================================================================================*)
Print[" Target point on the FS: rPD = ",rPD];
(*================================================================================================*)
(* Canonical order: {phi,the,zet} *)
(*================================================================================================*)
gridPhiTheZet=
Flatten[N[Table[
{phi0+iPhi*dPhi,the0+iThe*dThe,zet0+iZet*dZet},
{iPhi,-nPhi,+nPhi},
{iThe,-nThe,+nThe},
{iZet,-nZet,+nZet}
]]
,2];
Print[" numGridPoints = ",numGridPoints=(2nPhi+1)*(2nThe+1)*(2nZet+1)];
debugPrint[" gridPhiTheZet = ",nicePrint[TableForm@gridPhiTheZet,10,5]];

(*--------------------------------------------------------------------------------*)
(* Geometry of the track - recalculate *)
(*--------------------------------------------------------------------------------*)
trackDir=Normalize[{1,Tan[alphaY],Tan[alphaX]}];
debugPrint[" trackDir = ",trackDir];
{localPerpUnitVector,localThirdUnitVector}=localTrackUnitVectors[trackDir];
debugPrint[" localPerpUnitVector = ",localPerpUnitVector];
debugPrint[" localThirdUnitVector = ",localThirdUnitVector];
myTrack:=Move[SingleRay[],{zetaStartTrack,zetaStartTrack*Tan[alphaY],zetaStartTrack*Tan[alphaX]},trackDir];
debugPrint[" myTrack = ",myTrack];
bigBanner[" Generate test photons "];
(*--------------------------------------------------------------------------------*)
(* Generate test photons *)
(*--------------------------------------------------------------------------------*)
rEmis={};
rTilt={};
Do[
zetaPhotonEmission=gridPhiTheZet[[j]][[3]];
AppendTo[rEmis,{zetaPhotonEmission,zetaPhotonEmission*Tan[alphaY],zetaPhotonEmission*Tan[alphaX]}];
AppendTo[rTilt,
Cos[gridPhiTheZet[[j]][[2]]]*trackDir+Sin[gridPhiTheZet[[j]][[2]]]*(Cos[gridPhiTheZet[[j]][[1]]]*localPerpUnitVector+Sin[gridPhiTheZet[[j]][[1]]]*localThirdUnitVector)]
,{j,1,Length[gridPhiTheZet]}
];
debugPrint[" zetaPhotonEmission ",zetaPhotonEmission];
debugPrint[" rEmis ",rEmis];
debugPrint[" rTilt ",rTilt];
myTestCherenkovPhotons=CustomRays[{{RayStart,rEmis},{RayTilt,rTilt}}];
debugPrint[" myTestCherenkovPhotons = ",myTestCherenkovPhotons];
(*--------------------------------------------------------------------------------*)
(* Trace this set of test photons *)
(*--------------------------------------------------------------------------------*)
opticalSystemLHCbRICHTestPhotons= {myTestCherenkovPhotons,myOptics,myBoundary};
tracedTestPhotons=AnalyzeSystem[opticalSystemLHCbRICHTestPhotons];
rForwardTraced=ReadRays[tracedTestPhotons,RayEnd,onTheFS];
debugPrint[" rForwardTraced ",rForwardTraced];
(*--------------------------------------------------------------------------------*)
(* Calculate some raw goodness *)
(*--------------------------------------------------------------------------------*)
errorTestForwardTraceCherenkovPhoton=Norm[rPD-#]&/@rForwardTraced;
(*debugPrint[" rForwardTraced ",rForwardTraced];*)
debugPrint[" errorTestForwardTraceCherenkovPhoton ",nf@errorTestForwardTraceCherenkovPhoton];
bestFitTestForwardTraceCherenkovPhoton=Min[errorTestForwardTraceCherenkovPhoton];
jbest=First[Flatten[Position[errorTestForwardTraceCherenkovPhoton,bestFitTestForwardTraceCherenkovPhoton],1]];
(* !@#$% makes sense only if 1-dim *)
If[jbest==1||jbest==Length[gridPhiTheZet],Print[" Warning, minimum at the limit ..... makes sense only if 1-dim ",
"   nThe = ",nThe,
"   nPhi = ",nPhi,
"   nZet = ",nZet
]];
phiSol=gridPhiTheZet[[jbest]][[1]];
theSol=gridPhiTheZet[[jbest]][[2]];
zetSol=gridPhiTheZet[[jbest]][[3]];
Print[" bestFitTestForwardTraceCherenkovPhoton = ",bestFitTestForwardTraceCherenkovPhoton];
AppendTo[bestFitPhoton,bestFitTestForwardTraceCherenkovPhoton];
If[debugPrintEnabledFlag==True,
Print[" --- >>> "];
Print[" jbest ",jbest," Lenght of grid ",Length[gridPhiTheZet]];
Print[" bestFitTestForwardTraceCherenkovPhoton = ",bestFitTestForwardTraceCherenkovPhoton];
Print[gridPhiTheZet[[jbest]]];
];
Print[" phiSol   =  ",nf1[phiSol]," dPhi     = ",dPhi];
Print[" theSol   =  ",nf1[theSol]," dThe     = ",dThe];
Print[" zetSol   =  ",nf1[zetSol]," dZet     = ",dZet];
Return[{phiSol,theSol,zetSol}]
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
simul[numIter_,numPhoAlongTrack_]:=Module[{u,v,tracedPointsDir,tracedPoints},
Do[Print[" iter ",nf0[k]];
(*Print[" iter ",nf0[k]," thetaX ",nf1[thetaX[[k]]]," thetaY ",nf1[thetaY[[k]]]," twist ",nf1[twist[[k]]]];*)mySource={CherenkovPhotonsXYUniformAlongTrack[halfOpenAngle,numPhoAlongTrack,1,thetaY[[k]],thetaX[[k]]]};
opticalSystemLHCbRICH={mySource,myOptics,myBoundary};
(*tTracedSystem=TurboPlot[opticalSystemLHCbRICH,SequentialTrace\[Rule]True];*)
tTracedSystem=TurboTrace[opticalSystemLHCbRICH,SequentialTrace->True];
tracedPoints=ReadTurboRays[tTracedSystem,SurfaceCoordinates,onTheFS];
tracedPointsDir=ReadTurboRays[tTracedSystem,RayTilt,onTheFS];
If[Length[tracedPointsDir]>0,AppendTo[resTheta,ArcCos[tracedPointsDir . dirScreen]/Degree],Print["zero length tracedPointsDir - iter: ",nf0[k]];];
(*OLD SLOW tracedPointsDir=ReadTurboRays[tTracedSystem,{RayTilt[[1]],RayTilt[[2]],0},onTheFS];*)If[Length[tracedPointsDir]>0,tracedPointsDir=Transpose[{Transpose[tracedPointsDir][[1]],Transpose[tracedPointsDir][[2]],ConstantArray[0,Length[tracedPointsDir]]}];
u=Map[Normalize,tracedPointsDir];
v=Table[Cross[dirScreen,u[[k]]],{k,1,Length[u]}];
AppendTo[resThetaProj,ArcSin[Transpose[v][[3]]]/Degree],Print["zero length tracedPointsDir"];];
numPho=Length[tracedPoints];
If[Length[tracedPoints]>1,sizeSpotTrnsvrs=Max[Transpose[tracedPoints][[1]]]-Min[Transpose[tracedPoints][[1]]];
sizeSpotThrdDim=Max[Transpose[tracedPoints][[2]]]-Min[Transpose[tracedPoints][[2]]];
sizeSpotTrnsvrsRMS=StandardDeviation[Transpose[tracedPoints][[1]]];
sizeSpotThrdDimRMS=StandardDeviation[Transpose[tracedPoints][[2]]];
maxDist=Sqrt[sizeSpotTrnsvrs^2+sizeSpotThrdDim^2];
maxDistRMS=Sqrt[sizeSpotTrnsvrsRMS^2+sizeSpotThrdDimRMS^2];
maxTrnsvrs=Max[maxTrnsvrs,Transpose[tracedPoints][[1]]];
minTrnsvrs=Min[minTrnsvrs,Transpose[tracedPoints][[1]]];
maxThrdDim=Max[maxThrdDim,Transpose[tracedPoints][[2]]];
minThrdDim=Min[minThrdDim,Transpose[tracedPoints][[2]]],sizeSpotTrnsvrs=0;
sizeSpotThrdDim=0;
sizeSpotTrnsvrsRMS=0;
sizeSpotThrdDimRMS=0;
maxDist=0;
maxDistRMS=0;
maxTrnsvrs=0;
minTrnsvrs=0;
maxThrdDim=0;
minThrdDim=0;
Print["zero length tracedPoints"]];
AppendTo[resSizeSpotTrnsvrs,sizeSpotTrnsvrsRMS];
AppendTo[resSizeSpotThrdDim,sizeSpotThrdDimRMS];
AppendTo[resNumPho,numPho];
AppendTo[resMaxDist,maxDist];
AppendTo[resMaxDistRMS,maxDistRMS],{k,1,numIter}]
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
doSimul[numIters_]:=Module[{},Print[myOptics//ColumnForm];
(*(*Choose thetaX and thetaY,use the below*)thetaY=Table[minAcc+k*(maxThetaTrnsvrs-minAcc)/numIters,{k,0,numIters}];
thetaX=Table[minAcc+k*(maxThetaThrdDim-minAcc)/numIters,{k,0,numIters}];
twist=Array[0 Degree&,Min[Length[thetaX],Length[thetaY]]];*)(*Random tracks,use the below*)trackGen[numIters,minAcc,maxYAcc,maxXAcc];
twist=RandomReal[{0,360},Min[Length[thetaX],Length[thetaY]]];
Print["Length[thetaX]: ",Length[thetaX]," thetaX ",thetaX];
Print["Length[thetaY]: ",Length[thetaY]," thetaY ",thetaY];
Print["Length[twist]:  ",Length[twist]," twist ",twist];
dirScreen={Cos[tiltScreen],Sin[tiltScreen],0};
resThetaProj={};resNumPho={};resMaxDist={};resMaxDistRMS={};resTheta={};resSizeSpotTrnsvrs={};resSizeSpotThrdDim={};
maxTrnsvrs=-100000;maxThrdDim=-100000;minTrnsvrs=+100000;minThrdDim=+100000;
simul[Min[Length[thetaX],Length[thetaY]],numPhoAlongTrack];
Print[myOptics//ColumnForm];
Print[" resNumPho :     ",Median[Flatten[resNumPho]]//N," +/- ",StandardDeviation[Flatten[resNumPho]]/Sqrt[Length[resNumPho]-1]//N];
Print[" eff       :     ",eff=Median[Flatten[resNumPho]]/numPhoAlongTrack//N];
Print[" resThetaProj :  ",Median[Flatten[resThetaProj]]," +/- ",StandardDeviation[Flatten[resThetaProj]]/Sqrt[Length[resThetaProj]-1]];
Print[" resTheta     :  ",Median[Flatten[resTheta]]," +/- ",StandardDeviation[Flatten[resTheta]]/Sqrt[Length[resTheta]-1]];
Print[" resMaxDist :    ",Median[Flatten[resMaxDist]]," +/- ",StandardDeviation[Flatten[resMaxDist]]/Sqrt[Length[resMaxDist]-1]];
Print[" resMaxDistRMS : ",Median[Flatten[resMaxDistRMS]]," +/- ",StandardDeviation[Flatten[resMaxDistRMS]]/Sqrt[Length[resMaxDistRMS]-1]];
Print[" minTrnsvrs : ",minTrnsvrs,"----- maxTrnsvrs : ",maxTrnsvrs,"----- Trnsvrs Size : ",maxTrnsvrs-minTrnsvrs];
Print[" minThrdDim : ",minThrdDim,"----- maxThrdDim : ",maxThrdDim,"----- ThrdDim Size : ",maxThrdDim-minThrdDim];
Print[" resSizeSpotTrnsvrs : ",Median[resSizeSpotTrnsvrs]," +/- ",StandardDeviation[Flatten[resSizeSpotTrnsvrs]]/Sqrt[Length[resSizeSpotTrnsvrs]-1]];
Print[" resSizeSpotThrdDim : ",Median[resSizeSpotThrdDim]," +/- ",StandardDeviation[Flatten[resSizeSpotThrdDim]]/Sqrt[Length[resSizeSpotThrdDim]-1]];
Histogram[Flatten[resNumPho],40];
Histogram[Flatten[resThetaProj],40];
Histogram[Flatten[resTheta],40];
Histogram[Flatten[resMaxDist],40];
Histogram[Flatten[resMaxDistRMS],40];
Histogram[Flatten[resSizeSpotTrnsvrs],40];
Histogram[Flatten[resSizeSpotThrdDim],40];
deltaTiltScreen=Median[Flatten[resThetaProj]];
Print["systemResults    ",systemResults//ColumnForm]];



(* ::Subsubtitle::Initialization::"Tags"-><|"UnusedVariable" -> <|"Module" -> <||>|>|>:: *)
(*(*Light sources for OPTICA*)*)


(* ::Input::Initialization::"Tags"-><|"UnusedVariable" -> <|"Module" -> <||>|>|>:: *)
(**************************************************************************************************)
lightGrid[gridSize_,gridPoints_,thetaY_,thetaX_]:=Module[{t,x0,y0,z0,zeta},
zeta=zFrstEmission;
x0=zeta*Tan[thetaX];y0=zeta*Tan[thetaY];z0=zeta;
MoveDirected[DistortionGrid[gridSize,gridPoints],{1.*z0,1.*y0,1.*x0},{0.8*z0,0.8*y0,0.8*x0}]];


(* ::Input::Initialization::"Tags"-><|"UnusedVariable" -> <|"Module" -> <||>|>|>:: *)
(**************************************************************************************************)
(* BOX *)
(**************************************************************************************************)
z0Step:=zBoxMin//N;
z1Step:=zBoxMin+(zBoxMax-zBoxMin)*1/4//N;
z2Step:=zBoxMin+(zBoxMax-zBoxMin)*2/4//N;
z3Step:=zBoxMin+(zBoxMax-zBoxMin)*3/4//N;
z4Step:=zBoxMax//N;
zBoxCen:=(zBoxMin+zBoxMax)/2;


(* ::Input::Initialization::"Tags"-><|"UnusedVariable" -> <|"Module" -> <||>|>|>:: *)
(**************************************************************************************************)
(*EMIT AT FIXED 'quarters' of track length*)
(**************************************************************************************************)
CherenkovPhotonsXY:={
chrPhoXYAtZ[halfOpenAngle,trnsvrsAcc,+thrdDimAcc,z0Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,trnsvrsAcc,0,z0Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,trnsvrsAcc,-thrdDimAcc,z0Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,(minAcc+trnsvrsAcc)/2,+thrdDimAcc,z0Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,(minAcc+trnsvrsAcc)/2,0,z0Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,(minAcc+trnsvrsAcc)/2,-thrdDimAcc,z0Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,minAcc,+thrdDimAcc,z0Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,minAcc,0,z0Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,minAcc,-thrdDimAcc,z0Step,numPhoInAzimuth],
(*chrPhoXYAtZ[halfOpenAngle,0,+minAcc,z0Step,numPhoInAzimuth],*)
(*chrPhoXYAtZ[halfOpenAngle,0,-minAcc,z0Step,numPhoInAzimuth],*)
chrPhoXYAtZ[halfOpenAngle,trnsvrsAcc,+thrdDimAcc,z1Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,trnsvrsAcc,0,z1Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,trnsvrsAcc,-thrdDimAcc,z1Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,(minAcc+trnsvrsAcc)/2,+thrdDimAcc,z1Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,(minAcc+trnsvrsAcc)/2,0,z1Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,(minAcc+trnsvrsAcc)/2,-thrdDimAcc,z1Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,minAcc,+thrdDimAcc,z1Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,minAcc,0,z1Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,minAcc,-thrdDimAcc,z1Step,numPhoInAzimuth],
(*chrPhoXYAtZ[halfOpenAngle,0,+minAcc,z1Step,numPhoInAzimuth],*)
(*chrPhoXYAtZ[halfOpenAngle,0,-minAcc,z1Step,numPhoInAzimuth],*)
chrPhoXYAtZ[halfOpenAngle,trnsvrsAcc,+thrdDimAcc,z2Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,trnsvrsAcc,0,z2Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,trnsvrsAcc,-thrdDimAcc,z2Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,(minAcc+trnsvrsAcc)/2,+thrdDimAcc,z2Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,(minAcc+trnsvrsAcc)/2,0,z2Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,(minAcc+trnsvrsAcc)/2,-thrdDimAcc,z2Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,minAcc,+thrdDimAcc,z2Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,minAcc,0,z2Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,minAcc,-thrdDimAcc,z2Step,numPhoInAzimuth],
(*chrPhoXYAtZ[halfOpenAngle,0,+minAcc,z2Step,numPhoInAzimuth],*)
(*chrPhoXYAtZ[halfOpenAngle,0,-minAcc,z2Step,numPhoInAzimuth],*)
chrPhoXYAtZ[halfOpenAngle,trnsvrsAcc,+thrdDimAcc,z3Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,trnsvrsAcc,0,z3Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,trnsvrsAcc,-thrdDimAcc,z3Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,(minAcc+trnsvrsAcc)/2,+thrdDimAcc,z3Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,(minAcc+trnsvrsAcc)/2,0,z3Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,(minAcc+trnsvrsAcc)/2,-thrdDimAcc,z3Step,numPhoInAzimuth],chrPhoXYAtZ[halfOpenAngle,minAcc,+thrdDimAcc,z3Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,minAcc,0,z3Step,numPhoInAzimuth],
chrPhoXYAtZ[halfOpenAngle,minAcc,-thrdDimAcc,z3Step,numPhoInAzimuth]
(*chrPhoXYAtZ[halfOpenAngle,0,+minAcc,z3Step,numPhoInAzimuth],*)
(*chrPhoXYAtZ[halfOpenAngle,0,-minAcc,z3Step,numPhoInAzimuth]*)
};


(* ::Input::Initialization::"Tags"-><|"UnusedVariable" -> <|"Module" -> <||>|>|>:: *)
(**************************************************************************************************)
rayFan[size_,thetaY_,thetaX_,zeta_,numRays_]:=Module[{t,x0,y0,z0},x0=zeta*Tan[thetaX];y0=zeta*Tan[thetaY];z0=zeta;
trackDir=Normalize[{z0,y0,x0}];
MoveDirected[GridOfRays[{size,size},NumberOfRays->numRays,RayLineRGB->Red],{1.*z0,1.*y0,1.*x0},{0.8*z0,0.8*y0,0.8*x0}]
];



(* ::Input::Initialization::"Tags"-><|"UnusedVariable" -> <|"Module" -> <||>|>|>:: *)
(**************************************************************************************************)
CherenkovPhotonsXYUniformAlongTrack[halfOpenAngle_,numPhoAlongTrack_,numPhoInAzimuth_,thetaY_,thetaX_,startSrc_:0,endSrc_:1,twist_:0]:=Module[{deltaZ},
deltaZ=(zLastEmission-zFrstEmission)/numPhoAlongTrack;
Table[chrPhoXYAtZ[halfOpenAngle,thetaY,thetaX,zFrstEmission+(k-1)*deltaZ,numPhoInAzimuth,startSrc,endSrc,twist],{k,1,numPhoAlongTrack}]
];



(* ::Input::Initialization::"Tags"-><|"UnusedVariable" -> <|"Module" -> <||>|>|>:: *)
(**************************************************************************************************)
ClearAll[chrPhoXYAtZ];
chrPhoXYAtZ[thetaCher_,thetaX_,thetaY_,zeta_,numRays_,startSrc_:0,endSrc_:1,twist_:0,wl_:defaultWavLen,id_:1234567890]:=Module[{t,x0,y0,z0},
x0=zeta*Tan[thetaX];
y0=zeta*Tan[thetaY];
z0=zeta;
(*debugPrint[" {z0,y0,x0} =   ",z0,"   ",y0,"   ",x0];*)
trackDir=Normalize[{z0,y0,x0}];
MoveDirected[
ConeOfRays[
2*thetaCher,
NumberOfRays->numRays,
RayLineRGB->Red,
SourceOffset->startSrc,
SourceFraction->(endSrc-startSrc),
WaveLength->wl,
SourceID->id
]
,{z0,y0,x0},{0.5*z0,0.5*y0,0.5*x0},TwistAngle->twist,SideOfObject->Before
]
];


(* ::Input::Initialization::"Tags"-><|"UnusedVariable" -> <|"Module" -> <||>|>|>:: *)
(**************************************************************************************************)
ClearAll[CherenkovPhotonsXYTrack];
CherenkovPhotonsXYTrack[halfOpenAngle_,numPhoAlongTrack_,numPhoInAzimuth_,thetaY_,thetaX_,startSrc_:0,endSrc_:1,twist_:0,wl_:defaultWavLen,id0_:1234567890]:=Module[{deltaZ,rEnt,rOFS,rStr,rMid,rEnd,w,y,zStart,theLastZ,id},
(* Photons are emitted inside the full box. Some photon is emitted after the optics: no way because I would need to put surfaces here! *)
If[(startSrc<0||startSrc>1)||(endSrc<0||endSrc>1)||(startSrc>endSrc),
Print[" ERROR in CherenkovPhotonsXYTrack - parameters "];
killStop
];
If[id0==0,
id=encodeTrackId[Round[1000*thetaY],Round[1000*thetaX]],
id=id0
];
y=getTrackGeometry[thetaY,thetaX];
(*debugPrint[" get track geometry output ",y];*)
If[Length@Flatten@y<1,Print[" ERROR in CherenkovPhotonsXYTrack - geometry - RETURN "];Return[]];
zStart=zFrstEmission;
rStr=y[[1]];
rEnt:={zStart,zStart*Tan[thetaY],zStart*Tan[thetaX]};
rEnd=y[[2]];
rOFS=y[[3]];
rMid:=(rEnt+rEnd)/2;
AppendTo[trackAngles,{thetaY,thetaX}];
AppendTo[trackImprintOnTheFS,rOFS];
AppendTo[trackPathLength,Norm[rEnt-rEnd]];
AppendTo[trackMidPath,rMid];
AppendTo[allREnd,rEnd];
(* w: a little margin to emit just before the end which is on the mirror...*)
w=(rEnd[[1]]-zStart)/1000;
theLastZ=zStart+(k-1) deltaZ/. k->numPhoAlongTrack;
If[numPhoAlongTrack>1,
deltaZ=(rEnd[[1]]-w-zStart)/(numPhoAlongTrack-1)
];
If[numPhoAlongTrack==1,
deltaZ=(rEnd[[1]]-w-zStart)/2;
zStart=zFrstEmission+deltaZ
];
(*If[debugPrintEnabledFlag==True,
Print[" r Str     = ",rStr];
Print[" r Ent     = ",rEnt];
Print[" r Mid     = ",rMid];
Print[" r End     = ",rEnd];
Print[" r OFS     = ",rOFS]
];*)
Table[
chrPhoXYAtZ[halfOpenAngle,thetaX,thetaY,
zStart+(k-1)*deltaZ,
numPhoInAzimuth,startSrc,endSrc,twist,wl+k/1000,id](*Add a tiny 0.1 wl to every successive emission point to mark emission point in the results*)
,{k,1,numPhoAlongTrack}
]
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
(* Determine the geometry of the track from the PV at rStartTrack=={0,0,0} as if it were a photon *)
(*--------------------------------------------------------------------------------*)
ClearAll[getTrackGeometry];
getTrackGeometry[theta0Y_,theta0X_,localDebugPrintFlag_:False,opticalsystem_:myOptics]:=Module[
{rStartTrack,thetaX,thetaY,rStrTra,rEndTra,rOnTheFS,rOnTheFS2D,numHits,opticalSystemLHCbRICHTheTrack},
(**)
getTrackGeometry::noPointOnFS= "WARNING on track geometry - no point on the FS (might be ok)";
(**)
Once[bigBanner[" WARNING : ONLY for high-momentum track this ring center is correct "],PersistenceTime->3600];
Once[miniBanner[ " getTrackGeometry - a straigth track as a photon to determine the ring center on the FS "],PersistenceTime->3600];
Once[miniBanner[ " !@#$% selection to be improved; also check for correctness when resonate or not "],PersistenceTime->3600];
(**)
thetaY=1.0*theta0Y;(*must be real!*)
thetaX=1.0*theta0X;(*must be real!*)
trackDir=Normalize[{1,Tan[thetaY],Tan[thetaX]}];
(* The track starts from : rStartTrack *)
rStartTrack={0.,0.,0.};
myTrack:=Move[SingleRay[],rStartTrack,trackDir];
AppendTo[allTracks,myTrack];
opticalSystemLHCbRICHTheTrack:={myTrack,opticalsystem,myBoundary};
(* TurboPlot found strange results: normal, it fails because of scout rays;
use PropagateSystem with careful seq/non-seq; it will be fast as it is one photon only *)
tracedTrack:=PropagateSystem[opticalSystemLHCbRICHTheTrack,SequentialTrace->True,DefaultStyle->{AbsoluteThickness[5],AbsolutePointSize[5]}];
(**)
allHits=Flatten[ReadRays[tracedTrack]];
If[localDebugPrintFlag==True,
Print[" straight track from : ",rStartTrack];
Print[" thetaX = ",thetaX];
Print[" thetaY = ",thetaY];
Print[" Number of calculated virtual hits from the track ",numHits=Length@allHits];
rayDump[tracedTrack];
Print@AnalyzeSystem[tracedTrack]
];
(**)
rStrTra=Flatten[ReadRays[tracedTrack,RayStart,{IntersectionNumber->1,GenerationNumber->1}]];
If[Length@rStrTra<1,Print[" ERROR on track geometry - no start point "];Return[]];
If[(* use only \[Equal], not === to avoid difference integer/float (OR something better) *)
checkEqualRealNumbers[Norm[rStartTrack-rStrTra],0,1000],
debugPrint[" OK on track geometry: rStartTrack == rStrTra ",localDebugPrintFlag],
Print[" ERROR on track geometry : rStartTrack =!= rStrTra "];
Return[]
];
(**)
rEndTra=Flatten[ReadRays[tracedTrack,RayEnd,{IntersectionNumber->1,GenerationNumber->1}]];
rOnTheFS=(*Flatten[ReadRays[tracedTrack,SurfaceCoordinates,onTheFS]]*)Last@ReadRays[tracedTrack,RayEnd];
rOnTheFS2D=Last@ReadRays[tracedTrack,SurfaceCoordinates];
If[Length@rOnTheFS<1,Message[getTrackGeometry::noPointOnFS]];
If[localDebugPrintFlag==True,
Print[" myTrack                     = ",myTrack];
Print[" rStartTrack                 = ",rStartTrack," must be rStrTra==rStartTrack "];
Print[" rStrTra                     = ",rStrTra," must be rStrTra==rStartTrack "];
Print[" rEndTra (first segment)     = ",rEndTra];
Print[" rOnTheFS (FS point)         = ",rOnTheFS];
Print[" rOnTheFS2D (FS point)       = ",rOnTheFS2D]
];
Return[{rStrTra,rEndTra,rOnTheFS,rOnTheFS2D}]
];


(* ::Input::Initialization::"Tags"-><|"UnusedVariable" -> <|"Module" -> <||>|>|>:: *)
Unprotect[offsetTrackId,scaleTrackId];
Clear[encodeTrackId,decodeTrackId];
offsetTrackId=1000000000;
scaleTrackId=1000;
Protect[offsetTrackId,scaleTrackId];
(**************************************************************************************************)
decodeTrackId[w_,offset_:offsetTrackId,scale_:scaleTrackId]:=Module[{z,t1,t2,t3},
z=w-offset;(*Print[z];*)
t1=Quotient[z,scale*scale];(*Print[t1];*)
t2=Quotient[Mod[z,scale*scale],scale];(*Print[t2];*)
t3=Mod[Mod[z,scale*scale],scale];(*Print[t3];*)
Return[{t1,t2,t3}]
];
(**************************************************************************************************)
encodeTrackId[t1_Integer,t2_Integer,t3_Integer:0,offset_:offsetTrackId,scale_:scaleTrackId]:=Module[{z},
miniBanner["so far only positive input: beware when using angles"];
If[t1<0||t1>scale,Print[" ERROR - encodeTrackId : t1 ",t1];Return[1234567890]];
If[t2<0||t2>scale,Print[" ERROR - encodeTrackId : t2 ",t2];Return[1234567890]];
If[t3<0||t3>scale,Print[" ERROR - encodeTrackId : t3 ",t3];Return[1234567890]];
z=offset+t1+scale*t2+scale*scale*t3;
debugPrint[" TrackId encoded into : ",z];
Return[z]
];
encodeTrackId[100,57,7];
decodeTrackId[%];


(* ::Subsubtitle::Initialization:: *)
(*(*pixels*)*)


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
digitize[x_,y_,pixelSize_,offset_]:=Module[{center},
xd=pixelSize*Floor[x/pixelSize]+pixelSize/2//N;
yd=pixelSize*Floor[y/pixelSize]+pixelSize/2//N];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------*)
pixelize[tracedPointsFS_,pixelSize_]:=Module[{x,y,res,tracedPointsFSDigitized,centerScreen},
tracedPointsFSDigitized={};
res={};
unitVectorScreen={Cos[tiltScreen],Sin[tiltScreen],0};
eX={-Sin[tiltScreen],+Cos[tiltScreen],0};
eY={0,0,1};
centerScreen={zScreen,xScreen,0};
x=Transpose[tracedPointsFS][[1]];
y=Transpose[tracedPointsFS][[2]];
digitize[x,y,pixelSize,0];
Do[AppendTo[tracedPointsFSDigitized,centerScreen+xd[[j]]*eX+yd[[j]]*eY],{j,1,Length[tracedPointsFS]}];
(*plt1=Graphics3D[Style[Point[tracedPointsFSDigitized],Green]];
plt2=Graphics3D[Style[Point[tracedPointsFS],Red]];
Show[plt1,plt2];
Histogram[xd];
Histogram[xd-x];
Histogram[yd];
Histogram[yd-y];
Transpose[{xd,yd}];
Dot[unitVectorScreen,centerScreen];
Print[Max[Map[Norm,tracedPointsFSDigitized-tracedPointsFS]]*Sqrt[2]];
Do[AppendTo[res,Norm[tracedPointsFSDigitized[[j]]-tracedPointsFS[[j]]]*Sqrt[2]],{j,1,Length[tracedPointsFS]}];
Print[Histogram[res]];*)
Return[tracedPointsFSDigitized]
];


(* ::Subtitle::Initialization:: *)
(*(*OPTICS DEFINITIONS - many historical as of 2024 - but don't delete as some may be called by others*)*)


(* ::Subsubtitle::Initialization:: *)
(*(*general*)*)


(* ::Input::Initialization:: *)
execDoCalc:=Module[{},
miniBanner[" INIT execDoCalc "];
Print[" RICH is : ",iRICH];

centerPriMirRefl={0,0};
edgeParaFSNear={0,0};
edgeParaFSAway={0,0};
edgeParaFSNearRefl={0,0};
edgeParaFSAwayRefl={0,0};
Print[" *LEGENDA ========================================================================================== "];
Print[" transverseCoordinate == perpendicular to beam-line, towards the PD-PLANE, that is : "];
Print["                         y, for vertical RICH // vertical "];
Print["                         x, for horizontal RICH // horizontal "];
Print[" thrdDim == perpendicular to beam-line and perpendicular to transverseCoordinate, that is :"];
Print["                         x, for vertical RICH "];
Print["                         y, for horizontal RICH "];
(*--------------------------------------------------------------------------------------------------------*)
(*to calcluate spherical mirro from known points*)
(*calcSphericalPrimaryMirrorOld[sizeTrnsvrsPriMir,tiltPriMir,radiusPriMir];*)
(*calcSphericalPrimaryMirror[sizeTrnsvrsPriMir,tiltPriMir,radiusPriMir,thetaMinPriMir,p2z];*)
(*--------------------------------------------------------------------------------------------------------*)
ecnf0=
{zSecMir,xSecMir,zSecMirMin,xSecMirMin,zSecMirMax,xSecMirMax}=calcFlatSecMirFromLowerAngle[sizeTrnsvrsSecMir,tiltSecMir,theThetaMinSecMir,p4z];
(*ecnf0=calcFlatSecMirFromLowerAngle[sizeTrnsvrsSecMir,tiltSecMir,theThetaMinSecMir,p4z];*)
Print["{zSecMir,xSecMir,zSecMirMin,xSecMirMin,zSecMirMax,xSecMirMax}",{zSecMir,xSecMir,zSecMirMin,xSecMirMin,zSecMirMax,xSecMirMax}];

zSecMirCen=ecnf0[[1]];
xSecMirCen=ecnf0[[2]];
zSecMirMin=ecnf0[[3]];
xSecMirMin=ecnf0[[4]];
zSecMirMax=ecnf0[[5]];
xSecMirMax=ecnf0[[6]];


(*--------------------------------------------------------------------------------------------------------*)
calcFS[centerPriMir[[1]],centerPriMir[[2]],radiusPriMir,Abs[\[Pi]-tiltPriMir]];
(*--------------------------------------------------------------------------------------------------------*)
reflect0[centerPriMir[[1]],centerPriMir[[2]],dirVect[zSecMirMin-zSecMirMax,xSecMirMin-xSecMirMax],zSecMir,xSecMir];
centerPriMirRefl[[1]]=reflectedPoint[[1]];
centerPriMirRefl[[2]]=reflectedPoint[[2]];
reflect0[edgeParaFSNear[[1]],edgeParaFSNear[[2]],dirVect[zSecMirMin-zSecMirMax,xSecMirMin-xSecMirMax],zSecMir,xSecMir];
edgeParaFSNearRefl[[1]]=reflectedPoint[[1]];
edgeParaFSNearRefl[[2]]=reflectedPoint[[2]];
reflect0[edgeParaFSAway[[1]],edgeParaFSAway[[2]],dirVect[zSecMirMin-zSecMirMax,xSecMirMin-xSecMirMax],zSecMir,xSecMir];
edgeParaFSAwayRefl[[1]]=reflectedPoint[[1]];
edgeParaFSAwayRefl[[2]]=reflectedPoint[[2]];
(*--------------------------------------------------------------------------------------------------------*)
miniBanner[" END execDoCalc "];
Return[]
];


(* ::Subsubtitle::Initialization:: *)
(*(*calc - calc the p points*)*)


(* ::Section::Initialization:: *)
(*(*Geometry of Rich1 according to DW survey*)*)


(* ::Input::Initialization::"Tags"-><|"PrefixPlus" -> <||>|>:: *)
calc2009RealRich1Geometry:=Module[{tt,ll,z,radius,sol},
miniBanner[" INIT calc2009RealRich1Geometry "];
radius=2710;
radiusPriMir=radius;
zc=average[-672.8,-671.8];
yc=average[+841.2,+840.8];
cc={zc,yc};
(**)

p1y=0;
sol=Solve[circumference[zc,yc,radius,z,p1y]==0,z];
p1z=z/.sol[[2]];
p1={p1z,p1y};
p2y=600;
sol=Solve[circumference[zc,yc,radius,z,p2y]==0,z];
p2z=z/.sol[[2]];
p2={p2z,p2y};
theTiltPriMir=180+ArcTan[-1/AngCoeff[p1z,p1y,p2z,p2y]]/Degree;
p3z=average[+1333.7,+1335.4];
p3y=average[+0349.0,+0351.3];
p3={p3z,p3y};
ll=800;
tt=average[0.2502,0.2506];
p4z=p3z+ll*Cos[\[Pi]/2+tt];
p4y=p3y+ll*Sin[\[Pi]/2+tt];
theTiltSecMir=ArcTan[-1/AngCoeff[p4z,p4y,p3z,p3y]]/Degree;
theThetaMinSecMir=ArcTan[p3y/p3z];
p8z=average[1491.125,1491.075];
p8y=average[1182.325,1182.75];
p8={p8z,p8y};
theTiltScreen=average[average[ArcSin[.8866],ArcSin[.8867]],average[ArcCos[.4624],ArcCos[.4623]]]/Degree;
miniBanner[" END calc2009RealRich1Geometry "];
Return[]
]


(* ::Section::Initialization:: *)
(*(*Geometry of Rich1 according to LHCb - 2004 - 121*)*)


(* ::Input::Initialization:: *)
calc2009Rich1Geometry:=Module[{z,radius,sol},
miniBanner[" INIT calc2009Rich1Geometry "];
radius=2700;
radiusPriMir=radius;
zc=-684.4;
yc=+837.9;
cc={zc,yc};
(**)

p1y=0;
sol=Solve[circumference[zc,yc,radius,z,p1y]==0,z];
p1z=z/.sol[[2]];
p1={p1z,p1y};
p2y=600;
sol=Solve[circumference[zc,yc,radius,z,p2y]==0,z];
p2z=z/.sol[[2]];
p2={p2z,p2y};
theTiltPriMir=180+ArcTan[-1/AngCoeff[p1z,p1y,p2z,p2y]]/Degree;
p3z=1310.0;
p3y=350.0;
p3={p3z,p3y};
p4y=1100.0;
p4z=1118.5;
p4={p4z,p4y};
theTiltSecMir=ArcTan[-1/AngCoeff[p4z,p4y,p3z,p3y]]/Degree;
theThetaMinSecMir=ArcTan[p3y/p3z];
p7z=1231.7;
p7y=1317.7;
p7={p7z,p7y};
p8z=1482.3;
p8y=1187.4;
p8={p8z,p8y};
p9z=1733.8;
p9y=1056.7;
p9={p9z,p9y};
theTiltScreen=ArcTan[-1/AngCoeff[p7z,p7y,p9z,p9y]]/Degree;
miniBanner[" END calc2009Rich1Geometry "];
Return[]
]


(* ::Section::Initialization:: *)
(*(*Geometry of Rich2 according to LHCb - 2002 - 009*)*)


(* ::Input::Initialization:: *)
calc2009Rich2Geometry:=Module[{z,y,radius,sol},
miniBanner[" INIT calc2009Rich2Geometry "];
radius=8600;
radiusPriMir=radius;
zc=3291.0;
yc=3270.0;
cc={zc,yc};
(**)

p1y=0;
sol=Solve[circumference[zc,yc,radius,z,p1y]==0,z];
p1z=z/.sol[[2]];
p1={p1z,p1y};
p2z=11705;
sol=Solve[circumference[zc,yc,radius,p2z,y]==0,y];
p2y=y/.sol[[1]];
p2={p2z,p2y};
theTiltPriMir=180+ArcTan[-1/AngCoeff[p1z,p1y,p2z,p2y]]/Degree;
(*p3z=(2848-1234)*Tan[.185]+9578;*)
p3z=9880;
p3y=1234.0;
p3={p3z,p3y};
p4y=2848.0;
p4z=9578.0;
p4={p4z,p4y};
theTiltSecMir=ArcTan[-1/AngCoeff[p4z,p4y,p3z,p3y]]/Degree;
theThetaMinSecMir=ArcTan[p3y/p3z];
p8z=10761.0;
p8y=3892.0;
p8={p8z,p8y};
p7=p8+{Cos[\[Pi]/2-1.065],-Sin[\[Pi]/2-1.065]}*682/2;
p9=p8-{Cos[\[Pi]/2-1.065],-Sin[\[Pi]/2-1.065]}*682/2;
p7z=p7[[1]];
p7y=p7[[2]];
p9z=p9[[1]];
p9y=p9[[2]];
theTiltScreen=1.065/Degree;
miniBanner[" END calc2009Rich2Geometry "];
Return[]
]


(* ::Subtitle:: *)
(*OLD layouts*)


(* ::Subsubtitle:: *)
(*OLD layouts still needed for LS2/2022*)


(* ::Section::Initialization:: *)
(*protected code*)


(* ::Input::Initialization:: *)
(**************************************************************************************************)
(* DEFAULT PARAMETES - POSSIBLY TO BE REDEFINED LATER *)
(* All input angles in radians. Note that Optica requires input tilt data in Degrees:CONVERT! *)
(**************************************************************************************************)

setBoundaryParametersOLD:=Module[{},
miniBanner[" INIT setBoundaryParametersOLD "];
Print[" RICH is : ",iRICH];
(**)
theSensorPitch=1; (* mm *)
thetaMinPriMir=0.0;
radiusSecMir=0.0;
pixelSize=3;
(**)
If[(iRICH!=1)&&(iRICH!=2)&&(iRICH!=9),killStop];
(**************************************************************************************************)
(**)
If[iRICH==1,(*+/- 300 mrad acceptance real-HOR*)
minZ=985.0;
maxZ=2170.0;
minAcc=25.0/1000.0;
maxYAcc:=trnsvrsAcc;(*X<->Y swapped between the two riches*)
maxXAcc:=thrdDimAcc;(*X<->Y swapped between the two riches*)
minThetaTrsvrsTrack=0.050;
(**)
(*use 1000mm path length*)
];
(**************************************************************************************************)
(**)
If[iRICH==2,(*+/- 120 mrad acceptance real-HOR*)
minZ=9450;(*ok with LHCb-PUB-2016-XXX EDMS 1685891 13th May 2016*)
maxZ=11900;(*ok with LHCb-PUB-2016-XXX EDMS 1685891 13th May 2016*)
minAcc=15.0/1000.0;
maxXAcc:=trnsvrsAcc;(*X<->Y swapped between the two riches*)
maxYAcc:=thrdDimAcc;(*X<->Y swapped between the two riches*)
minThetaTrsvrsTrack=0.030;
(**)
(*use 2000mm path length*)
l000z=(11245-9450);
l000:=l000z;
l120z=(11705-9450);
l120:=l120z/Cos[.12];
printD@l000;
printD@l120;
printD@Mean[{l000,l120}];
];
(**)
miniBanner[" END setBoundaryParametersOLD "];
Return[]
];




(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------------------------------*)
setData2022Rich1:=Module[{},
(*--------------------------------------------------------------------------------------------------------*)
(*bigBanner[" I DONT LIKE ----- INIT setData2022Rich1 - NEW TO CHECK "];
bigBanner[" changed structure wrt setData2022Rich1/setData2022Rich2 : probably was better.... "];*)
printD@iRICH;
setBoundaryParametersOLD;
Print[" New vertical Rich1 - final official version presented on 17-06-2013 - "];
Print[" Fine-Tuned from RICH1-Optical-Layout-EDMS-1390002-v2-CF160401-1050.pdf on Oct. 14th, 2020 "];
(* OK *)zBoxMin=985;
(* OK *)zBoxMax=2245;
(* OK *)p2z=2145.001;
(* OK *)p4z=1099.242;
(* OK *)thrdDimAcc=0.300;
(* OK *)trnsvrsAcc=0.250;
(* OK *)minAcc=0.025;
(* OK *)thrdDimMinAcc=minAcc;
(* OK *)trnsvrsMinAcc=minAcc;
(* OK *)thetaMinSecMir=trnsvrsAcc;theThetaMinSecMir=thetaMinSecMir(*duplicate info... why ? cleanup*);
(* IT IS INPUT! OK *)sizeTrnsvrsPriMir=650.;
(* OK *)sizeTrnsvrsSecMir=883.;
(* OK *)sizeTrnsvrsScreen=621.5+200;
(* OK *)sizeThrdDimPriMir=1500.0;
(* OK *)sizeThrdDimSecMir=1489.0;
(* OK *)sizeThrdDimScreen=1500.0;
(* OK *)radiusPriMir=3650;
(* OK *)tiltPriMir=+170.3Degree;
(* OK *)tiltSecMir=0.25656*180/Pi Degree;
(* OK *)tiltScreen=(90-0.561996*180/Pi)Degree;
(* OK *)zScreen=1641.417;
(* OK *)xScreen=1407.716;
PDADepth=300; (* Rough Estimate // Graphics Only *)
(*Print[" INFO: deltaSphMirr = 30 is just a bit more than enough ... "];deltaSphMirr=0;Print[" deltaSphMirr = ",deltaSphMirr];*)
execDoCalc;
miniBanner[" END setData2022Rich1 "];
Return[]
];

(*
(*----------------------------------------------------------------------------------------------------------------------*)
setData2022Rich1:=Module[{},
(*--------------------------------------------------------------------------------------------------------*)
miniBanner[" INIT setData2022Rich1 - Setting default data for Rich1-2022 "];
miniBanner[" TEMPORARILY SWITCHED-OFF BY PUTTING DATA BY HAND .... TO FIX "];
printD@iRICH;

setData2022Rich1NewToCheck;(*TEMPORARY*)
(**)
(*setData2009Rich1;*) (* NO!!! RICH1 has changed *)
(*execDoCalc;*)(*no: called already by setData2009Rich1*)


miniBanner[" END setData2022Rich1 "];
Return[]
];*)


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------------------------------*)
(*--------------------------------------------------------------------------------------------------------*)
setData2009Rich2:=Module[{},
(*--------------------------------------------------------------------------------------------------------*)
(*Current RICH2 from LHCb 2002-009*)
(*Print[" Current RICH2 from LHCb 2002-009 - EDR "];*)
miniBanner[" INIT setData2009Rich2 "];
printD@iRICH;
setBoundaryParametersOLD;
calc2009Rich2Geometry;
halfOpenAngle=0.0313*(180/\[Pi]);
sizeThrdDimPriMir=2500.;
sizeThrdDimSecMir=2000.;
sizeThrdDimScreen=1500.;
zBoxMin=9578.0;
zBoxMax=11705.0;
thrdDimAcc=100/1000.0;
trnsvrsAcc=120/1000.0;
sizeTrnsvrsPriMir=dist[p1z,p1y,p2z,p2y];
sizeTrnsvrsSecMir=dist[p3z,p3y,p4z,p4y];
sizeTrnsvrsScreen=dist[p7z,p7y,p9z,p9y];
thetaMinSecMir=theThetaMinSecMir;
xScreen=p8y;
zScreen=p8z;
tiltPriMir=theTiltPriMir Degree;
tiltSecMir=theTiltSecMir Degree;
tiltScreen=theTiltScreen Degree;
Print[" deltaSphMirr=0 ... "];
deltaSphMirr=0;
PDADepth=20;
execDoCalc;
miniBanner[" END setData2009Rich2 "];
Return[]
];


(* ::Input::Initialization:: *)
(*----------------------------------------------------------------------------------------------------------------------*)
setData2022Rich2:=Module[{},
(*--------------------------------------------------------------------------------------------------------*)
miniBanner[" INIT setData2022Rich2 - Setting default data for Rich2-2022 "];
printD@iRICH;
setData2009Rich2; (* RICH2 has NOT changed *)
(*execDoCalc;*)(*no: called already by setData2009Rich2*)
miniBanner[" END setData2022Rich2 "];
Return[]
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------------------------------*)
setDataReal2002Rich1:=Module[{},
(*--------------------------------------------------------------------------------------------------------*)
(*Current RICH1 from DW survey*)
(*Print[" Current RICH1 from DW survey and LHCb DB "];*)
miniBanner[" INIT setDataReal2002Rich1 "];
printD@iRICH;
setBoundaryParametersOLD;
calc2009RealRich1Geometry;
zBoxMin=1118.5;
zBoxMax=2005.1;
thrdDimAcc=300/1000.0;
trnsvrsAcc=250/1000.0;
sizeTrnsvrsPriMir=dist[p1z,p1y,p2z,p2y];
sizeTrnsvrsSecMir=dist[p3z,p3y,p4z,p4y];
sizeTrnsvrsScreen=1000;
thetaMinSecMir=theThetaMinSecMir;
xScreen=p8y;
zScreen=p8z;
tiltPriMir=theTiltPriMir Degree;
tiltSecMir=theTiltSecMir Degree;
tiltScreen=theTiltScreen Degree;
execDoCalc;
miniBanner[" END setDataReal2002Rich1 "];
Return[]
];


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------------------------------*)
setData2009Rich1:=Module[{},
(*--------------------------------------------------------------------------------------------------------*)(*Current RICH1 from LHCb 2004-121*)
(*Print[" Current RICH1 from LHCb 2004-121 - EDR "];*)
miniBanner[" INIT setData2009Rich1 "];
printD@iRICH;
setBoundaryParametersOLD;
calc2009Rich1Geometry;
zBoxMin=1118.5;
zBoxMax=2005.1;
thrdDimAcc=300/1000.0;
trnsvrsAcc=250/1000.0;
sizeTrnsvrsPriMir=dist[p1z,p1y,p2z,p2y];
sizeTrnsvrsSecMir=dist[p3z,p3y,p4z,p4y];
sizeTrnsvrsScreen=dist[p7z,p7y,p9z,p9y];
thetaMinSecMir=theThetaMinSecMir;
xScreen=p8y;
zScreen=p8z;
tiltPriMir=theTiltPriMir Degree;
tiltSecMir=theTiltSecMir Degree;
tiltScreen=theTiltScreen Degree;
execDoCalc;
miniBanner[" END setData2009Rich1 "];
Return[]
];


(* ::Subsubtitle::Initialization:: *)
(*(*OLD layout but good but no more useful*)*)


(* ::Section:: *)
(*protected code*)


(* ::Input::Initialization:: *)
(*(*--------------------------------------------------------------------------------------------------------*)*)
(*setDataHorizontalRich1:=Module[{},*)
(*(*--------------------------------------------------------------------------------------------------------*)*)
(*miniBanner[" INIT setDataHorizontalRich1 - HORIZONTAL!!! "];*)
(*printD@iRICH;*)
(*setBoundaryParametersOLD;*)
(*(*New horizontal RICH1*)*)
(*zBoxMin=1090;*)
(*zBoxMax=2085;*)
(*thrdDimAcc=250/1000.0;*)
(*trnsvrsAcc=300/1000.0;*)
(*(*HORIZONTAL!!!*)*)
(*maxYAcc:=thrdDimAcc;*)
(*maxXAcc:=trnsvrsAcc;*)
(*thetaMinSecMir=trnsvrsAcc;*)
(*sizeTrnsvrsPriMir=750;*)
(*sizeTrnsvrsSecMir=900;*)
(*sizeTrnsvrsScreen=1200;*)
(*radiusPriMir=3800;*)
(*xScreen=1668;*)
(*(*zScreen=(zBoxMin+zBoxMax)/2;*)*)
(*zScreen=(minZ+maxZ)/2;*)
(*tiltPriMir=+170Degree;*)
(*tiltSecMir=+16Degree;*)
(*tiltScreen=+62 Degree;*)
(*execDoCalc;*)
(*miniBanner[" END setDataHorizontalRich1 "];*)
(*Return[]*)
(*];*)


(* ::Input::Initialization:: *)
(*(*--------------------------------------------------------------------------------------------------------*)*)
(*setDataNewVerticalRich1A:=Module[{},*)
(*(*--------------------------------------------------------------------------------------------------------*)*)
(*setBoundaryParametersOLD;*)
(*(*New vertical RICH1 A -first official version rich2019-*)*)
(*Print[" New vertical Rich1 A - first official version rich2019 - "];*)
(*deltaZBoxMin=0;*)
(*deltaZBoxMax=0;*)
(*zBoxMin=1118.5+deltaZBoxMin;*)
(*zBoxMax=2005.1+deltaZBoxMax;*)
(*p2z=zBoxMax;*)
(*p4z=zBoxMin;*)
(*thirdDimAcc=300/1000.0;*)
(*trnsvrsAcc=250/1000.0;*)
(*thetaMinSecMir=trnsvrsAcc;*)
(*sizeTrnsvrsPriMir=570;*)
(*sizeTrnsvrsSecMir=850;*)
(*sizeTrnsvrsScreen=1500;*)
(*radiusPriMir=3800;*)
(*xScreen=1600;*)
(*(*zScreen=(zBoxMin+zBoxMax)/2;*)*)
(*zScreen=(minZ+maxZ)/2;*)
(*tiltPriMir=+166Degree;*)
(*tiltSecMir=+16Degree;*)
(*xScreen=1569.7265;*)
(*xScreen=1569.7265+200-125;*)
(*zScreen=1626.7100;*)
(*tiltScreen=67.5929 Degree;*)
(*(*v7C*)*)
(*Rh1PlaneUpgradeFocalPlaneShift=100;*)
(*Rh1PhDetTopAngleFromVert=ArcCos[0.928981];*)
(*xScreen=xScreen+Rh1PlaneUpgradeFocalPlaneShift*Sin[Rh1PhDetTopAngleFromVert]+Rh1PlaneUpgradeFocalPlaneShift*Cos[Rh1PhDetTopAngleFromVert];*)
(*zScreen=zScreen-Rh1PlaneUpgradeFocalPlaneShift*Cos[Rh1PhDetTopAngleFromVert]+Rh1PlaneUpgradeFocalPlaneShift*Sin[Rh1PhDetTopAngleFromVert];*)
(*tiltScreen=ArcCos[0.370127];*)
(*execDoCalc;*)
(*];*)
(*(*--------------------------------------------------------------------------------------------------------*)*)


(* ::Input::Initialization:: *)
(*(*--------------------------------------------------------------------------------------------------------*)*)
(*setDataNewVerticalRich1B:=Module[{},*)
(**)
(*setBoundaryParametersOLD;*)
(*(*--------------------------------------------------------------------------------------------------------*)(*New vertical RICH1 B -work-*)*)
(*Print[" New vertical Rich1 B - work - "];*)
(*deltaZBoxMin=-100;*)
(*deltaZBoxMax=100;*)
(*zBoxMin=1118.5+deltaZBoxMin;*)
(*zBoxMax=2005.1+deltaZBoxMax;*)
(*p2z=zBoxMax;*)
(*p4z=zBoxMin+100;*)
(*thirdDimAcc=300/1000.0;*)
(*trnsvrsAcc=250/1000.0;*)
(*thetaMinSecMir=trnsvrsAcc;*)
(*sizeTrnsvrsPriMir=650.;*)
(*sizeTrnsvrsSecMir=900.;*)
(*sizeTrnsvrsScreen=1500.;*)
(*radiusPriMir=3800;*)
(*(*PDA*)xScreen=1600;*)
(*zScreen=(minZ+maxZ)/2;*)
(*(*Tilts*)tiltPriMir=+166Degree;*)
(*tiltSecMir=+16Degree;*)
(*tiltScreen=70 Degree;*)
(*(*ReCalculated*)tiltScreen=66.9 Degree;*)
(*zScreen=1633.1;*)
(*xScreen=1682.3;*)
(*(*TEST*)tiltPriMir=+168.5 Degree;*)
(*tiltSecMir=12 Degree;*)
(*tiltScreen=53 Degree;*)
(*zScreen=1751;*)
(*xScreen=1563;*)
(*tiltScreen=57 Degree;*)
(*execDoCalc;*)
(*];*)
(*(*--------------------------------------------------------------------------------------------------------*)*)


(* ::Input::Initialization:: *)
(*(*--------------------------------------------------------------------------------------------------------*)*)
(*setDataNewVerticalRich1C:=Module[{},*)
(**)
(*setBoundaryParametersOLD;*)
(*(*--------------------------------------------------------------------------------------------------------*)(*New vertical RICH1 C-final official version presented on 17-06-2013-*)*)
(*Print[" New vertical Rich1 C - final official version presented on 17-06-2013 - "];*)
(*zBoxMin=1080;*)
(*zBoxMax=2150;*)
(*p2z=2145;*)
(*p4z=1100;*)
(*thirdDimAcc=300/1000.0;*)
(*trnsvrsAcc=250/1000.0;*)
(*thetaMinSecMir=trnsvrsAcc;*)
(*sizeTrnsvrsPriMir=650.;*)
(*sizeTrnsvrsSecMir=880.;*)
(*sizeTrnsvrsScreen=650.;*)
(*radiusPriMir=3800;*)
(*(*PDA*)*)
(*xScreen=1600;*)
(*zScreen=(minZ+maxZ)/2;*)
(*(*Tilts*)*)
(*tiltPriMir=+170Degree;*)
(*tiltSecMir=+16Degree;*)
(*tiltScreen=61. Degree;*)
(*(*Tuned*)*)
(*tiltSecMir=14.5 Degree;*)
(*tiltScreen=57.3 Degree;*)
(*zScreen=1694.705;*)
(*xScreen=1492.335;*)
(*PDADepth=270;*)
(*Print[" PATCHING Sajan ... (normal average incidence for zero polar angle tracks)"];*)
(*tiltScreen=tiltScreen+1.5 Degree;*)
(*Print[" INFO: deltaSphMirr = 30 is just a bit more than enough ... "];*)
(*deltaSphMirr=0;*)
(*Print[" deltaSphMirr = ",deltaSphMirr];*)
(*execDoCalc;*)
(*];*)
(*(*--------------------------------------------------------------------------------------------------------*)*)


(* ::Input::Initialization:: *)
(*(*--------------------------------------------------------------------------------------------------------*)*)
(*setDataNewVerticalRich1D:=Module[{},*)
(**)
(*setBoundaryParametersOLD;*)
(*(*--------------------------------------------------------------------------------------------------------*)(*New vertical RICH1 D*)*)
(*Print[" New vertical Rich1 D "];*)
(*zBoxMin=1080;*)
(*zBoxMax=2150;*)
(*p2z=2145;*)
(*p4z=1100;*)
(*thirdDimAcc=300/1000.0;*)
(*trnsvrsAcc=250/1000.0;*)
(*thetaMinSecMir=trnsvrsAcc;*)
(*sizeTrnsvrsPriMir=650.;*)
(*sizeTrnsvrsSecMir=880.;*)
(*sizeTrnsvrsScreen=1500.;*)
(*radiusPriMir=3600;*)
(*(*PDA*)*)
(*xScreen=1600;*)
(*zScreen=(minZ+maxZ)/2;*)
(*(*Tilts*)*)
(*tiltPriMir=+170Degree;*)
(*tiltSecMir=+16Degree;*)
(*tiltScreen=61. Degree;*)
(*(*Tuned*)*)
(*tiltSecMir=14.5 Degree;*)
(*tiltScreen=57.4 Degree;*)
(*zScreen=1694.705-100*Cos[tiltScreen];*)
(*xScreen=1492.335-100*Sin[tiltScreen];*)
(*PDADepth=370;*)
(*execDoCalc;*)
(*];*)
(*(*--------------------------------------------------------------------------------------------------------*)*)


(* ::Input::Initialization:: *)
(*(*--------------------------------------------------------------------------------------------------------*)*)
(*setDataNewVerticalRich1E:=Module[{},*)
(**)
(*setBoundaryParametersOLD;*)
(**)
(*(*New vertical RICH1 E-spherical second mirror-*)*)
(*Print[" New vertical Rich1 E - spherical second mirror - "];*)
(*zBoxMin=1080;*)
(*zBoxMax=2150;*)
(*p2z=2145;*)
(*p4z=1100;*)
(*thirdDimAcc=300/1000.0;*)
(*trnsvrsAcc=250/1000.0;*)
(*thetaMinSecMir=trnsvrsAcc;*)
(*sizeTrnsvrsPriMir=650.;*)
(*sizeTrnsvrsSecMir=880.;*)
(*sizeTrnsvrsScreen=800.;*)
(*radiusPriMir=3000;*)
(*radiusSecMir=-10000;*)
(*(*PDA*)*)
(*zScreen=1486;*)
(*xScreen=1202;*)
(*(*Tilts*)*)
(*tiltPriMir=+170Degree;*)
(*tiltSecMir=14.5 Degree;*)
(*tiltScreen=57.5 Degree;*)
(*PDADepth=370;*)
(*execDoCalc;*)
(*];*)
(*(*--------------------------------------------------------------------------------------------------------*)*)
(**)


(* ::Subtitle::Initialization:: *)
(*(*END BASE*)*)


(* ::Input::Initialization:: *)
(*!@#$%I CANT GET THE PACKAGE TO WORK DUE TO SHADOWING WITH OPTICA EM:TO FIX!!!*)
(*Begin["`Private`"];*) (* Begin Private Context *)
(*End[]; *)(* End Private Context *)
(*EndPackage[];*)


(* ::Subsubtitle:: *)
(*end notebook initialization cells*)


(* ::Input::Initialization:: *)
endEvalPrintOut[];
