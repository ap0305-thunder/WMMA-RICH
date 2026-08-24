(* ::Package:: *)

(* ===== RICH managed source =====
   Name: geometricalOptics
   Role: interactive-top-level
   Context: geometricalOptics`
   Version symbol: geometricalOptics`Private`versionTAG
*)
geometricalOptics`Private`versionTAG = "v.16-01-2025";

(* Derived textually from validation/native-sources/geometricalOptics-native.wl,
   produced by Wolfram Save As. Only the geometricalOptics Title section is
   selected; Wolfram expressions are neither parsed nor reserialized. Legacy
   notebook-cleanup calls are suppressed during managed project loading. *)

(* ::Title::Initialization:: *)
(*---... geometricalOptics*)


(* ::Subtitle::Initialization:: *)
(*>>> INIT PACKAGE*)


(* ::Input::Initialization:: *)
BeginPackage["geometricalOptics`",{"rich`","base`","statDataAnal`"}]
(**)
Print[" loading geometricalOptics "]



(* ::Subsubtitle::Initialization::Closed:: *)
(*GENERAL DEFINITIONS FOR THIS NOTEBOOK*)


(* ::Section::Initialization::Closed:: *)
(*definitions*)


(* ::Input::Initialization:: *)
(* Temporary assumptions for the init part vector analysis *)
$Assumptions={(a|b|c|\[Alpha]|\[Alpha]1|\[Alpha]2|\[Nu]|p0|x0|xp|rc|p1|p2|n|u|n0)\[Element]Vectors[3,Reals],(k|t|t1|t2)\[Element]Reals};


(* ::Section::Initialization::Closed:: *)
(*formulas*)


(* ::Input::Initialization:: *)
TensorExpand[(b\[Cross]c) . a,Assumptions->a\[Element]Vectors[3,Reals]]
(a\[Cross]b) . c//TensorExpand
a\[Cross](b\[Cross]c)//TensorExpand
(a\[Cross]b)\[Cross]c==-c\[Cross](a\[Cross]b)==-a(b . c)+b(a . c)//TensorExpand
a\[Cross](b\[Cross](c\[Cross]d))==b(a . (c\[Cross]d))-(a . b)c\[Cross]d//TensorExpand
ap=b\[Cross]c/a . b\[Cross]c;bp=c\[Cross]a/a . b\[Cross]c;cp=a\[Cross]b/a . b\[Cross]c;
Outer[Dot,{a,b,c},{ap,bp,cp}]//TensorExpand
TensorExpand[(p1\[Cross]p2) . (p1\[Cross]p2)]
assumptions=Element[#,Vectors[2,Reals]]&/@{a,b};
Reduce@TensorReduce[(a+b) . (a+b)==(a-b) . (a-b),Assumptions->assumptions]
ClearAll[pV1,pV2,pV3,qV1,m]
pV1/:pV1 . pV1:=m^2;
pV2/:pV1 . pV2:=0;
TensorExpand[2(pV1 . qV1)(pV3 . pV2)+(pV1 . pV2)^2+3(pV1 . pV1)^2,Assumptions->(pV1|pV2|pV3|qV1)\[Element]Vectors[d]]
TensorExpand[Dot[a,k(b)],Assumptions->k\[Element]Reals]
TensorExpand[Dot[a,(y . u)b],Assumptions->k\[Element]Reals]
TensorExpand[Dot[a,perpComp[a,n]]]/.n->UnitVector[3,2]


(* ::Input::Initialization:: *)
(**************************************************************************************************)
(**)
(**************************************************************************************************)
ClearAll[normalVector,fn];
fn[x_,y_,z_]:=(10r^2-r*x^2-5y^2-4z^2)
normalVector[fn_,x1_,y1_,z1_]:=Module[{nv,pt,func,tanpt,x,y,z},
func[x_,y_,z_]=fn[x,y,z];
nv={D[func[x,y],x],D[func[x,y],y],-1};
nv=nv/Norm[nv]/.{x->x1,y->y1};
pt={x1,y1,func[x1,y1]};
tanpt={x,y,z};
Return[Assuming[r>0,Simplify@nv]]
]
normalVector[fn,110,0,6]/.r->10//FullSimplify//N


(* ::Input::Initialization:: *)
(**************************************************************************************************)
(**)
(**************************************************************************************************)
Clear[module];
module[x_]:=Sqrt[Dot[x,x]];
(**)
Clear[paraComp];
paraComp[\[Alpha]_,\[Nu]_]:=Module[{result,assumptions},
assumptions=(\[Alpha]|\[Nu])\[Element]Vectors[3,Reals];
If[assumptions!=True,Return["ERROR"]];
result=Simplify[TensorReduce[\[Nu] (\[Alpha] . \[Nu])/(\[Nu] . \[Nu])],assumptions];
Return[result]
];
(**)
Clear[perpComp];
perpComp[\[Alpha]_,\[Nu]_]:=Module[{result,assumptions},
assumptions=(\[Alpha]|\[Nu])\[Element]Vectors[3,Reals];
If[assumptions!=True,Return["ERROR"]];
result=Simplify[TensorReduce[(\[Nu]\[Cross](\[Alpha]\[Cross]\[Nu]))/(\[Nu] . \[Nu])],assumptions];
Return[result]
];
(**)
Clear[reflect];
(* TO NORMALIZE !!! *)
reflect[\[Alpha]_,\[Nu]_]:=Module[{\[Alpha]1},
\[Alpha]1=\[Alpha]-2*\[Nu]*Dot[\[Alpha],\[Nu]];
Return[\[Alpha]1]
];
reflect[\[Alpha],+\[Nu]]-reflect[\[Alpha],-\[Nu]]//TensorExpand
(**)
Clear[refract];
refract[\[Alpha]_,\[Nu]_,k_]:=Module[{\[Alpha]1,sinT},
(* k:= n2/n1 *)
(*sinT=Sqrt@Dot[perpComp[\[Alpha],\[Nu]],perpComp[\[Alpha],\[Nu]]];*)
sinT=module[perpComp[\[Alpha],\[Nu]]];
(*Print[sinT];*)
\[Alpha]1=(perpComp[\[Alpha],\[Nu]]/k)+\[Nu]*Sqrt[1-(sinT/k)^2]*Dot[\[Alpha],\[Nu]]/Abs[Dot[\[Alpha],\[Nu]]];
Return[\[Alpha]1]
];
refract[\[Alpha],+\[Nu],k]-refract[\[Alpha],-\[Nu],k]//TensorExpand
(**)


(* ::Input::Initialization:: *)
(**)
taylorSeries[expr_,vars_,start_,order_Integer]:=Normal[Series[expr/. Thread[vars->t*(vars-start)+start],{t,0,order}]]/. t->1
(**)
Normal[Series[f[(x-x0) t+x0,(y-y0) t+y0],{t,0,2}]]/. t->1
(**)
ser=Series[f[x,y],{x,x0,2},{y,y0,2}];
Normal[ser]/.Derivative[m__][f][args__]/;Plus[m]>2:>0
(**)
multiTaylor[f_,{vars_?VectorQ,pt_?VectorQ,n_Integer?NonNegative}]:=Sum[Nest[(vars-pt) . #&,(D[f,{vars,var}]/. Thread[vars->pt]),var]/var!,{var,0,n},Method->"Procedural"]
multiTaylor[f[x,y],{{x,y},{0,0},2}]
f[0,0]+y*Derivative[0,1][f][0,0]+x*Derivative[1,0][f][0,0]+(y*(y*Derivative[0,2][f][0,0]+x*Derivative[1,1][f][0,0])+x*(y*Derivative[1,1][f][0,0]+x*Derivative[2,0][f][0,0]))/2


(* ::Input::Initialization:: *)
(**************************************************************************************************)
(**)
(**************************************************************************************************)
cosAngleLineLine[u_,\[Nu]_]:=
FullSimplify[Cos[VectorAngle[u,\[Nu]]],(u|\[Nu])\[Element]Vectors[3,Reals]&&$Assumptions];
cosAngleLinePlane[u_,\[Nu]_]:=
FullSimplify[Dot[u,perpComp[u,\[Nu]]]/(Norm[u]*Norm[perpComp[u,\[Nu]]]),(u|\[Nu])\[Element]Vectors[3,Reals]&&$Assumptions];
cosAnglePlanePlane[\[Nu]a1_,\[Nu]a2_,\[Nu]b1_,\[Nu]b2_]:=
FullSimplify[Dot[\[Nu]a1\[Cross]\[Nu]a2,\[Nu]b1\[Cross]\[Nu]b2]/(Norm[\[Nu]a1\[Cross]\[Nu]a2]*Norm[\[Nu]b1\[Cross]\[Nu]b2]),(\[Nu]a1|\[Nu]a2|\[Nu]b1|\[Nu]b2)\[Element]Vectors[3,Reals]&&$Assumptions];


(* ::Input::Initialization:: *)
TensorExpand[Dot[perpComp[u,n],perpComp[u,n]],Assumptions->(u|n)\[Element]Vectors[d]]
TensorExpand[Dot[paraComp[u,n],paraComp[u,n]],Assumptions->(u|n)\[Element]Vectors[d]]
TensorReduce[Dot[paraComp[u,n],perpComp[u,n]],Assumptions->(u|n)\[Element]Vectors[d]]
TensorReduce[u-paraComp[u,n]-perpComp[u,n],Assumptions->(u|n)\[Element]Vectors[d]]


(* ::Input::Initialization:: *)
(* Beware: geodetic circles!!! *)
(* Spherical trigonometry // 3 common-origin unit vectors in space <==> angle between vectors is NOT the same as angle between planes containing vectors *)
(* Plane trigonometry// 3 common-origin unit vectors in plane <==> angle between vectors is ALL the story *)
rule={a . b->Cos[\[Gamma]],b . c->Cos[\[Alpha]],a . c->Cos[\[Beta]],a . a->1,b . b->1,c . c->1};
eq=FullSimplify[Cos[A]-TensorExpand[(a\[Cross]b) . (a\[Cross]c) /(Sqrt[(a\[Cross]b) . (a\[Cross]b)]Sqrt[(a\[Cross]c) . (a\[Cross]c)])]//.rule,Assumptions->{Sin[\[Beta]]>=0, Sin[\[Gamma]]>=0}]
Solve[eq==0,Cos[\[Alpha]]]//Expand


(* ::Input::Initialization:: *)
solSecDeg[a_,b_,c_]:=Module[{s, sol,sol1,sol2},
sol=Solve[a s^2+b s + c == 0,s,Reals];
Simplify[sol,Assumptions->{(a|b|c)\[Element]Reals,a!=0}];
sol1=s/.sol[[1]];
sol2=s/.sol[[2]];
Return[Normal[{sol1,sol2}]]
];
solSecDeg[a,b,c]


(* ::Input::Initialization:: *)
grids[min_,max_,step_:1]:=Table[If[EvenQ[i],{i,Red},{i,Blue}],{i,Ceiling[min],Floor[max],step}];
Graphics[{Circle[{0,0},30]},Frame->True,GridLines->grids]


(* ::Input::Initialization:: *)
swap[v_]:=Module[{},If[Length[v]!=2,Print["ERROR"];Return[],Return[{v[[2]],v[[1]]}]]];
xyDist[v_List,w_List]:=If[(Length@v==2)&&(Length@w==2),Norm[v-w],Print["ERROR"]];


(* ::Input::Initialization:: *)
1/2 (-(-2 rc . u+2 u . p0)+Sqrt[(-2 rc . u+2 u . p0)^2- 4 (p0 . p0-2 rc . p0+rc . rc-r^2)])//FullSimplify
Dot[u,rc-p0]+Sqrt[  (rc . u-u . p0)^2     -(rc-p0)^2   +r^2  ]
-p0 . p0+2 rc . p0-rc . rc+(rc . u-u . p0)^2//TensorExpand//FullSimplify
solSecDeg[1,(-2 rc . u+2 u . p0),p0 . p0-2 rc . p0+rc . rc]


(* ::Input::Initialization:: *)
TensorReduce[cosAngleLinePlane[u,n],Assumptions->(u|n)\[Element]Vectors[d,Reals]]


(* ::Input::Initialization:: *)
EulerMatrix[{\[Alpha],\[Beta],\[Gamma]}]/.{Cos[x_]:>Subscript[c, x],Sin[x_]:>Subscript[s, x]}//MatrixForm
(* the 3D rotation matrix formed by rotating by \[Alpha] around the initial z axis, then by \[Beta] around the initial y axis, and then by \[Gamma] around the initial x axis *)
RollPitchYawMatrix[{\[Alpha],\[Beta],\[Gamma]}]/.{Cos[x_]:>Subscript[c, x],Sin[x_]:>Subscript[s, x]}//MatrixForm
tra=TranslationTransform[{x0,y0,z0}]
rot=RotationTransform[\[Theta], {{1,1, 1},{1,-2,1}}]


(* ::Input::Initialization:: *)
(* Rodrigues // unused so far *)
rotMat=TransformationMatrix[rot][[1;;3,1;;3]]
MatrixForm[rotMat]
Tr[rotMat]//FullSimplify
ArcCos[(Tr[rotMat]-1)/2]


(* ::Input::Initialization::"Tags"-><|"NoVariables" -> <|"Module" -> <||>|>|>:: *)
(*(*Block[{sol,x,x0,u,t,n,n0},*)
x[t_]:=x0+t*u;
sol=Solve[TensorExpand[Dot[n,(x[t]-n0)]]==0,{t},Reals];
thePoint:=TensorExpand[x[t]/.sol[[1]]];
theTime:=t/.sol[[1]];
Print[" { theTime , thePoint } = {",theTime,",{",thePoint,"}}"]
Clear[sol];
(*];*)
intersectLineToPlane[n_,n0_,x0_,u_]:=Module[{},Return[{(n.n0-n.x0)/n.u,x0+(u n.n0)/n.u-(u n.x0)/n.u}]];
intersectLineToPlane[n,n0,x0,u]
*)
(*Block[{sol,x,start,velo,t,norm,pnt0},*)
Clear[x,pnt0,norm,velo,start,intersectLineToPlane];
$Assumptions={(start|velo|norm|pnt0)\[Element]Vectors[3,Reals],(k|t|t1|t2)\[Element]Reals};
x[w_]:=start+w*velo;
sol=Solve[TensorExpand[Dot[norm,(x[w]-pnt0)]]==0,w,Reals];
thePoint:=TensorExpand[x[w]/.sol[[1]]];
theTime:=w/.sol[[1]];
Print[" { theTime , thePoint } = {",theTime,",{",thePoint,"}}"];
(*intersectLineToPlane[norm_,pnt0_,start_,velo_]:=Module[{},Return[{(norm.pnt0-norm.start)/norm.velo,start+(velo norm.pnt0)/norm.velo-(velo norm.start)/norm.velo}]];*)
intersectLineToPlane[norm_,pnt0_,start_,velo_]:={(norm . pnt0-norm . start)/norm . velo,start+(velo norm . pnt0)/norm . velo-(velo norm . start)/norm . velo}
(*];*)
intersectLineToPlane[norm,pnt0,start,velo]


(* ::Input::Initialization:: *)
brute[x_]:=Normal[x,ConditionalExpression];
blob[x_]:=Rationalize@Chop@FullSimplify[x,$Assumptions];


(* ::Input::Initialization:: *)
(* always check signs during use... *)
calcVectImpaPar[pole_,strt_,dir_]:=Cross[(strt-pole),dir]/Norm[dir];(* like angular momentum *)
(* calcVectImpaPar[{0,0,0},{1,0,0},{0,1,0}] = {0,0,1} *)
calcPeriCentPnt[pole_,strt_,dir_]:=Cross[dir,calcVectImpaPar[pole,strt,dir]]/(Norm[dir])^2; (* To the axis/track from the point pole; regardless particle verse *)
(* Simplify[ calcPeriCentPnt[{0,0,0},{1,0,0},Normalize[{0,k,0}]] ,Assumptions->k>0] *)


(* ::Input::Initialization:: *)
distancePointToLine[xp_,x0_,n_]:=Norm[calcPeriCentPnt[xp,x0,n]]
lineByTwoPoints[p1__,p2__]:=p1+t*(p2-p1);


(* ::Text::Initialization:: *)
(*Move[PRI-MIR-NOW,{{zSpheMirrVar,2104.5326523},{xSpheMirrVar,317.91087325}},{tiltSpheMirrVar,170.3}];Move[SEC-MIR-NOW,{{zPlanMirrVar,1211.2746805},{xPlanMirrVar,764.94493772}},{tiltPlanMirrVar,14.699805192}];Move[QUA-WIN-NOW,{{zScreenVar,1534.841748},{xScreenVar,1238.4773647}},{tiltScreenVar,57.800001097}];Move[THE-PDA-NOW,{{zScreenVar,1641.417},{xScreenVar,1407.716}},{tiltScreenVar,57.800001097}];*)
(**LEGENDA=========================================================================================================transverseCoordinate==perpendicular to beam-line,towards the PD-PLANE,that is:y,for vertical RICH*)
(*x,for horizontal RICH*)
(*thirdDim==perpendicular to beam-line and perpendicular to transverseCoordinate,that is:x,for vertical RICH*)
(*y,for horizontal RICH*)
(*SPHERICAL MIRROR=============================================================================================================Spherical mirror ROC:3650*)
(*P1***{z} Spherical mirror min:+2035.48290-----{transverseCoordinate} Spherical mirror min:+0.00000*)
(*{z} Spherical mirror Vrtx:+2104.53265-----{transverseCoordinate} Spherical mirror Vrtx:+317.91087*)
(*P2***{z} Spherical mirror max:+2145.00100-----{transverseCoordinate} Spherical mirror max:+640.70725*)
(*Tilt Spherical mirror (with respect to the beam-line:=:negative z-axis) DEGREES:+9.70000 RADIANS:+0.16930*)
(*Tilt Spherical mirror (LHCb convention) DEGREES:+14.80844 RADIANS:+0.25846*)
(*COC Spherical mirror {z,transverseCoordinate}:{-1493.28501,+932.89711}*)
(*Vrtx Spherical mirror {z,transverseCoordinate}:{+2104.53265,+317.91087}*)
(*Center of the Sagitta Spherical mirror {z,transverseCoordinate}:{+2090.24195,+320.35363}*)
(*Spherical mirror width:+650.00000------ Spherical mirror ThirdDim:+1500.00000*)
(*PLANE MIRROR=============================================================================================================Plane mirror ROC:0.*)
(*P4***{z} Plane mirror min:+1099.24200-----{transverseCoordinate} Plane mirror min:+1191.99403*)
(*{z} Plane mirror center:+1211.27468-----{transverseCoordinate} Plane mirror center:+764.94494*)
(*P3***{z} Plane mirror max:+1323.30736-----{transverseCoordinate} Plane mirror max:+337.89584*)
(*thetaMinPlanMirr (imposed):0.25 thetaMinPlanMirr (calculated) DEGREES:14.323944878 RADIANS:0.25*)
(*Tilt Plane mirror (with respect to the beam-line:=:positive z-axis) DEGREES:+14.69981 RADIANS:+0.25656*)
(*Plane mirror width:+883.00000-----Plane mirror ThirdDim:+1489.00000*)
(*CHToIPToCcAngle+0.55840---betaVrtx+0.38911*)
(*PD-PLANE=============================================================================================================P8***{z} PD-PLANE center:+1641.41700-----{transverseCoordinate} PD-PLANE center:+1407.71600*)
(*Tilt PD-PLANE (with respect to the beam-line:=:negative z-axis) DEGREES:+57.80000 RADIANS:+1.00880*)
(*PD-PLANE width:+621.50000-----PD-PLANE ThirdDim:+1230.40000*)
(*RICH=1*)
(**==================================================================================================**)
(**)


(* ::Input::Initialization::"Tags"-><|"UnexpectedLetterlikeCharacter" -> <|Enabled -> False|>, "PrefixPlus" -> <||>|>:: *)
(**************************************************************************************************)
(* LHCb RICH1-2022 optics data *)
(**************************************************************************************************)
(**************************************************************************************************)
tiltPlanMirr=14.699805192 Degree;
zPlanMirr=+1211.27468;
xPlanMirr=+764.94494;
centerSpheMirr={zPlanMirr,xPlanMirr}={\!\(\*
TagBox[
InterpretationBox[
StyleBox["\<\"-1493.28501\"\>",
ShowStringCharacters->False],
-1493.2850098353492`,
AutoDelete->True],
NumberForm[#, {12, 5}, NumberSigns -> {"-", "+"}]& ]\),\!\(\*
TagBox[
InterpretationBox[
StyleBox["\<\"+932.89711\"\>",
ShowStringCharacters->False],
932.8971086610493,
AutoDelete->True],
NumberForm[#, {12, 5}, NumberSigns -> {"-", "+"}]& ]\)};
center=Flatten@{centerSpheMirr,0};
tiltScreen=(90-0.561996*180/\[Pi])Degree
tiltScreenDegree=tiltScreen/Degree
(* tan(angle) is approx 2/3 *)(*ArcTan[2/3]*)
With[{d=N[90-tiltScreenDegree]},Defer[d \[Degree]]];
(* not from the screen *)
(**)


(* ::Input::Initialization:: *)
(* !@#$% HERE big problems with def/redef variables sca/vec .... u, v, w....*)
(*
plt=Show[Graphics3D[Line[{{0,3,0},{1,1,0}}]]];
rt=ReflectionTransform[{1,0,0}];
rt[{x,y,z}];
rtPlt=MapAt[GeometricTransformation[#,rt]&,plt,{1}];
Show[plt,rtPlt,AspectRatio->Automatic,Axes\[Rule]True];
rt=ReflectionTransform[{u,v,w}]//Simplify[#,{Element[{u,v,w},Reals],u^2+v^2+w^2\[Equal]1}]&;
plt=Show[Graphics3D[Line[{{0,0,0},{0,1000,0}}]]];
rt=ReflectionTransform[{Cos[tiltPlanMirr],Sin[tiltPlanMirr],0},{zPlanMirr,xPlanMirr,0}];
rt[{x,y,z}];
rtPlt=MapAt[GeometricTransformation[#,rt]&,plt,{1}];
Show[Graphics3D[Point[{zPlanMirr,xPlanMirr,0}]],plt,rtPlt,AspectRatio->Automatic,Axes\[Rule]True]
*)


(* ::Input::Initialization:: *)
theRotation[angle_,axis_?VectorQ,vector_?VectorQ]:=Module[{result,unitVector},
unitVector=Normalize[axis];
result=vector+Sin[angle]Cross[unitVector,vector]+(1-Cos[angle])Cross[unitVector,Cross[unitVector,vector]];
Return[result]
];
Series[theRotation[#,{0,0,1},{vx,vy,vz}],{a,0,1}]&


(* ::Input::Initialization:: *)
First@{b*{Cos[\[Beta]],Sin[\[Beta]]}+t*{Sin[\[Beta]],-Cos[\[Beta]]}}/.\[Beta]->(\[Pi]/2+\[Alpha])
Coefficient[%,t,1]
Coefficient[%%,t,0]


(* ::Input::Initialization:: *)
dirTheRay:={0,+Sin[\[Alpha]],+Cos[\[Alpha]]};
rot=RotationTransform[\[Theta],{-1,0,0}]
dirTheRay
rot[dirTheRay]
Simplify@rot[dirTheRay]/.\[Theta]->-\[Alpha]


(* ::Section::Initialization::Closed:: *)
(*Change of coordinate systems formulas*)


(* ::Input::Initialization:: *)
toHA[\[CapitalTheta]_,\[CapitalPhi]_]:=Module[{hei,azi},
(* just one quadrant, no problem *)
hei=ArcSin[Sin[Rationalize[\[CapitalTheta]]]Sin[Rationalize[\[CapitalPhi]]]];
hei=Assuming[ 0<= hei<=\[Pi]/2  ,Simplify[hei]];
(* two quadrants: ArcCos is not ok!!! *)
(*
azi=ArcCos[Cos[Rationalize[\[CapitalTheta]]]/Sqrt[1-(Sin[hei])^2]];
azi=Assuming[ -\[Pi]/2<= azi<=+\[Pi]/2  ,Simplify[azi]];
*)
azi=ArcSin[Sin[Rationalize[\[CapitalTheta]]]Cos[Rationalize[\[CapitalPhi]]]/Sqrt[1-(Sin[hei])^2]];
azi=Assuming[ -\[Pi]/2<= azi<=+\[Pi]/2  ,Simplify[azi]];
Return[N@{hei,azi}]
];
toTP[\[ScriptCapitalH]_,\[ScriptCapitalA]_]:=Module[{the,phi},
(* just one quadrant, no problem *)
the=ArcCos[Cos[Rationalize[\[ScriptCapitalH]]]Cos[Rationalize[\[ScriptCapitalA]]]];
the=Assuming[ 0<= the<=\[Pi]/2  ,Simplify[the]];
(* two quadrants: ArcSin is not ok!!! *)
(*
phi=ArcSin[Sin[Rationalize[\[ScriptCapitalH]]]/Sqrt[1-(Cos[the])^2]];
phi=Assuming[ 0<= phi<=\[Pi]  ,Simplify[phi]];
*)
phi=ArcCos[Cos[Rationalize[\[ScriptCapitalH]]]Sin[Rationalize[\[ScriptCapitalA]]]/Sqrt[1-(Cos[the])^2]];
phi=Assuming[ 0<= phi<=\[Pi]  ,Simplify[phi]];
Return[N@{the,phi}]
];
checkUnityTP[\[CapitalTheta]_,\[CapitalPhi]_]:=Module[{res,dg=5},
Print[">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>."];
res=toTP[toHA[\[CapitalTheta],\[CapitalPhi]][[1]],toHA[\[CapitalTheta],\[CapitalPhi]][[2]]];
If[
N[res,dg]==N[{\[CapitalTheta],\[CapitalPhi]},dg]
,
Print["OK"]
,
Print["NOT...................OK"];
Print[" input  ",N[{\[CapitalTheta],\[CapitalPhi]},dg]];
Print[" output ",N[res,dg]];
Print[" delta  ",res-N[{\[CapitalTheta],\[CapitalPhi]},dg]];
]
]
checkUnityTP[Pi/180,Pi/8];
checkUnityAA[\[ScriptCapitalH]_,\[ScriptCapitalA]_]:=Module[{res,dg=5},
Print[">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>."];
res=toHA[toTP[\[ScriptCapitalH],\[ScriptCapitalA]][[1]],toTP[\[ScriptCapitalH],\[ScriptCapitalA]][[2]]];
If[
N[res,dg]==N[{\[ScriptCapitalH],\[ScriptCapitalA]},dg]
,
Print["OK"]
,
Print["NOT...................OK"];
Print[" input  ",N[{\[ScriptCapitalH],\[ScriptCapitalA]},dg]];
Print[" output ",N[res,dg]];
Print[" delta  ",res-N[{\[ScriptCapitalH],\[ScriptCapitalA]},dg]];
]
]
checkUnityAA[Pi/180,Pi/8]


(* ::Input::Initialization:: *)
num=13;
Map[checkUnityTP[#[[1]],#[[2]]]&,Transpose[{RandomReal[{0,\[Pi]/2},{num}],RandomReal[{0,\[Pi]},{num}]}]];
num=13;
Map[checkUnityAA[#[[1]],#[[2]]]&,Transpose[{RandomReal[{0,\[Pi]/2},{num}],RandomReal[{-\[Pi]/2,+\[Pi]/2},{num}]}]];


(* ::Input::Initialization:: *)
nf[toTP[0.25,+0.3],10,5]
nf[toTP[0.25,0.00],10,5]
nf[toTP[0.25,-0.3],10,5]


(* ::Input::Initialization:: *)
nf[toTP[0.00001,+Pi/2],10,5]
nf[toTP[0.00001,0.00],10,5]
nf[toTP[0.00001,-Pi/2],10,5]


(* ::Input::Initialization:: *)
Table[nf[toTP[0.25000,k],10,5],{k,-0.30,+0.30,0.05}]//TableForm
Table[nf[toTP[0.00001,k],10,5],{k,-0.30,+0.30,0.05}]//TableForm


(* ::Subsubtitle::Initialization::Closed:: *)
(*GENERAL OPTIONS FOR THIS NOTEBOOK*)


(* ::Section::Initialization:: *)
(*MISCELLANEA OPTIONS*)


(* ::Subtitle::Initialization::Closed:: *)
(*<<< END PACKAGE*)


(* ::Input::Initialization:: *)
(**)
Begin["`Private`"] (* Begin Private Context *)

End[]; (* End Private Context *)
$Context
$ContextPath


(* ::Input::Initialization:: *)
(**)
(*NotebookDelete[Cells[nb,CellStyle\[Rule]{"Output"}]];*)
(**)
If[!TrueQ[Global`$RICHProjectManagedLoad],NotebookDelete[Cells[nb,GeneratedCell->True]]];
(**)
(*FrontEndExecute[FrontEndToken["DeleteGeneratedCells"]]*)
(**)
If[!TrueQ[Global`$RICHProjectManagedLoad],FrontEndExecute[FrontEndToken[nb,"SelectAll"]]];
If[!TrueQ[Global`$RICHProjectManagedLoad],FrontEndTokenExecute["SelectionCloseAllGroups"]];
(*FrontEndTokenExecute["SelectionOpenAllGroups"]*)
(**)


(* ::Input::Initialization:: *)
EndPackage[];

myNotebookInit`endEvalPrintOut[];

myNotebookInit`packageBanner["END geometricalOptics"];
