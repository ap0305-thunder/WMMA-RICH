(* ::Package:: *)
(* Native Optica adapter, using the documented Optica package API.
   Requires licensed Optica. Use PropagateSystem/DrawSystem, not TurboTrace:
   the exact trimming hooks below are ordinary Wolfram Language functions.
   Executed with OpticaEM 5.90 on 2026-11-08 (arc.nb); see the Rotate fix in place[] below.
   All surfaces are in mm; Optica wavelengths are in micrometres.
   Global frame {Z beam, X, Y} from ARCBarrel.wl (2026-11-13): the Optica first axis is the beam axis,
   as in the LHCb optics. The adapter works in the ARCBarrel.wl frame and needed no change. *)
(* FIX 2026-11-08: Optica is installed here as OpticaEM`OpticaEM` (OpticaEM 5.90, as in src/optics.wl), not Optica`Optica`.
   It is loaded only if not loaded yet, and the check no longer uses Check[Needs[...]] (the OpticaEM loader can issue messages
   and still load). OpticaEM`OpticaEM` is not a BeginPackage dependency (it would be reloaded when it is not listed in $Packages):
   it is put on $ContextPath inside the package and again after EndPackage. *)

If[!MemberQ[$Packages,"ARCBarrel`"],Get[FileNameJoin[{DirectoryName[$InputFileName],"ARCBarrel.wl"}]]];
If[Names["OpticaEM`OpticaEM`PropagateSystem"]==={},Quiet[Needs["OpticaEM`OpticaEM`"]]];
If[Names["OpticaEM`OpticaEM`PropagateSystem"]==={},
  Print["Optica (OpticaEM) non disponibile: caricare ARCBarrel.wl per la geometria Mathematica indipendente."];Abort[]];

BeginPackage["ARCBarrelOptica`",{"ARCBarrel`"}];
ARCOpticaComponents::usage="ARCOpticaComponents[barrel] constructs the native finite Optica surfaces. FullBoundaryModel->True includes all solid boundary faces.";
ARCOpticaSystem::usage="ARCOpticaSystem[barrel] wraps all native surfaces in an Optica Resonate for nonsequential tracing.";
ARCOpticaRays::usage="ARCOpticaRays[point,directions,wavelengthNM,medium] builds CustomRays. medium is \"Gas\" or \"Aerogel\"; point and directions are global.";
ARCOpticaMedia::usage="ARCOpticaMedia[] registers the two active XML refractive-index tables and returns their Optica medium labels.";
ARCOpticaMediaSelfCheck::usage="ARCOpticaMediaSelfCheck[] checks Optica's MediumNameQ and reports the gas/aerogel refractive indices at 400 nm.";
ARCOpticaClipSelfCheck::usage="ARCOpticaClipSelfCheck[] verifies that a clipped Optica plane accepts and rejects the documented {distance,s,t} intersection format.";

Begin["`Private`"];
(* Keep both dependency contexts visible also in compatible interpreters
   that implement BeginPackage's dependency argument only partially. *)
$ContextPath=DeleteDuplicates[Join[{"ARCBarrel`","OpticaEM`OpticaEM`"},$ContextPath]];
eps=10.^-6; (* mm, only for floating-point membership comparisons. *)

(* Frame columns: normal optical x, transverse optical y, transverse optical z. *)
frame[n_List] := Module[{nn=Normalize[N[n]],e},
  e=Normalize[Cross[nn,If[Abs[nn[[3]]]<.9,{0.,0.,1.},{0.,1.,0.}]]];
  Transpose[{nn,e,Cross[nn,e]}]
];

inCell[c_,p_] := c["RadialLimits"][[1]]-eps<=p[[3]]<=c["RadialLimits"][[2]]+eps &&
  Max[Table[{Cos[k Pi/3],Sin[k Pi/3]}.p[[{1,2}]],{k,0,5}]]<=c["CellApothem"]+eps;
inSolid[c_,kind_,p_] := Module[{q,r},Switch[kind,
  "Mirror",q=p-c["MirrorCentre"];r=Norm[q];
    inCell[c,p] && c["MirrorInnerRadius"]-eps<=r<=c["MirrorOuterRadius"]+eps &&
      q[[3]]>=Cos[c["MirrorThetaMaximum"]] r-eps,
  "Sensor",q=Transpose[c["SensorRotation"]].(p-c["SensorCentre"]);
    Max[Abs[q]-c["SensorHalfSizes"]]<=eps,
  "Aerogel"|"Cooling",q=Transpose[c["SensorRotation"]].(p-c[kind<>"Centre"]);
    inCell[c,p] && q[[1]]^2+q[[2]]^2<=(c["PlateCylinderRadius"]+eps)^2 &&
      Abs[q[[3]]]<=c[kind<>"HalfThickness"]+eps,
  _,False]];

(* SurfaceIntersectionFunction receives six ray coordinates and returns
   {{distance, transverseParameter1, transverseParameter2},...}.
   It does NOT return global {X,Y,Z} points. {-1,0,0} denotes no hit. *)
planeIntersector[o_,f_,accept_] := With[{oo=N[o],ff=N[f],ok=accept},
  Function[{xs,ys,zs,dx,dy,dz},Module[{dist,hit},
    If[Abs[dx]<10.^-14,Return[{{-1.,0.,0.}}]];
    dist=-xs/dx;hit={0.,ys+dist dy,zs+dist dz};
    If[dist>10.^-7 && TrueQ[ok[oo+ff.hit]],{{dist,hit[[2]],hit[[3]]}},{{-1.,0.,0.}}]
  ]]
];

sphereIntersector[o_,f_,centre_,radius_,accept_] := With[
  {oo=N[o],ff=N[f],co=Transpose[N[f]].N[centre-o],rr=N[radius],ok=accept},
  Function[{xs,ys,zs,dx,dy,dz},Module[{p={xs,ys,zs},d={dx,dy,dz},a,b,disc,roots,hit,result={}},
    a=d.d;b=(p-co).d;disc=b b-a ((p-co).(p-co)-rr rr);
    If[a<=0. || disc<0.,Return[{{-1.,0.,0.}}]];
    roots=Sort[{(-b-Sqrt[disc])/a,(-b+Sqrt[disc])/a}];
    Do[If[t>10.^-7,hit=p+t d;
      If[hit[[1]]>=co[[1]] && TrueQ[ok[oo+ff.hit]],AppendTo[result,{t,hit[[2]],hit[[3]]}]]],{t,roots}];
    If[result==={},{{-1.,0.,0.}},result]
  ]]
];

tubeIntersector[o_,f_,centre_,radius_,sgn_,accept_] := With[
  {oo=N[o],ff=N[f],co=Transpose[N[f]].N[centre-o],rr=N[radius],ss=sgn,ok=accept},
  Function[{xs,ys,zs,dx,dy,dz},Module[{p={xs,ys,zs},d={dx,dy,dz},a,b,disc,roots,hit,result={}},
    a=dx dx+dy dy;b=(xs-co[[1]]) dx+(ys-co[[2]]) dy;
    disc=b b-a ((xs-co[[1]])^2+(ys-co[[2]])^2-rr rr);
    If[a<10.^-20 || disc<0.,Return[{{-1.,0.,0.}}]];
    roots=Sort[{(-b-Sqrt[disc])/a,(-b+Sqrt[disc])/a}];
    Do[If[t>10.^-7,hit=p+t d;
      If[ss (hit[[1]]-co[[1]])>=0. && TrueQ[ok[oo+ff.hit]],AppendTo[result,{t,hit[[2]],hit[[3]]}]]],{t,roots}];
    If[result==={},{{-1.,0.,0.}},result]
  ]]
];

setRule[rules_,key_,new_] := Append[DeleteCases[rules,HoldPattern[Rule[key,_]]],key->new];
installIntersection::layout="Optica did not return the documented Component / Surfaces representation. Inspect the installed Optica version before tracing.";
installIntersection[obj_,fun_] := Module[{surf,changed},
  surf=Cases[obj,HoldPattern[Rule[Surfaces,v_]]:>v,Infinity];
  If[Length[surf]=!=1,Message[installIntersection::layout];Throw[$Failed]];
  surf=First[surf];
  If[!ListQ[surf] || surf==={} || !AllTrue[surf,ListQ],Message[installIntersection::layout];Throw[$Failed]];
  changed=Map[Function[s,setRule[setRule[s,SurfaceIntersectionFunction,fun],BoundaryChecked,True]],surf];
  (* Keep native deflection, surface parametrisation, normals and material rules. *)
  obj /. HoldPattern[Rule[Surfaces,_]] :> (Surfaces->changed)
];

(*FIX 2026-11-08: OpticaEM Rotate[obj, matrix] applies the TRANSPOSE of the given matrix, so the matrix is transposed here.
  Found on the ARC cell 1 trace: with the old line the mirror centre came out at u = -2.0 mm instead of +2.0 mm and the
  aerogel and sensor planes were tilted by 0.029 rad; a model with the transposed rotation reproduces the traced end points to 0.001 mm.*)
place[obj_,c_,o_,f_] := Translate[Rotate[obj,N[Transpose[c["Rotation"].f]]],N[ARCToGlobal[c,o]]];
makeBase["Mirror",fun_,ap_,label_,medium_] := CustomMirror[fun,ap,label];
makeBase["Aerogel",fun_,ap_,label_,medium_] := CustomLensSurface[fun,ap,label,ComponentMedium->medium];
makeBase["Cooling"|"Sensor",fun_,ap_,label_,medium_] := CustomBaffle[fun,ap,label];

plane[c_,kind_,o_,normal_,label_,medium_] := Module[{f=frame[normal],base,test,fn},
  test=With[{cc=c,kk=kind},Function[p,inSolid[cc,kk,p]]];
  (* A bounding rectangle is only a search/rendering aperture. The analytical
     intersection hook supplies the exact Boolean solid clipping. *)
  base=makeBase[kind,Function[0.],{1200.,1200.},label,medium];
  fn=planeIntersector[o,f,test];
  place[installIntersection[base,fn],c,o,f]
];

sphere[c_,side_,medium_] := Module[{r=c["Mirror"<>side<>"Radius"],mc=c["MirrorCentre"],o,f,fun,base,test},
  f={{0.,1.,0.},{0.,0.,1.},{1.,0.,0.}};
  o={0.,0.,mc[[3]]+Sqrt[Max[0.,r^2-mc[[1]]^2]]};
  fun=With[{rad=r,cx=mc[[1]],cw=mc[[3]],origin=o[[3]]},
    Function[{u,v},cw+Sqrt[Max[0.,rad^2-(u-cx)^2-v^2]]-origin]];
  (* Max protects the extension outside the physical sphere. Such points are
     always rejected by the analytical intersector, never reflected there. *)
  base=CustomMirror[fun,c["HexVertices"],"Mirror"<>side<>"_"<>ToString[c["SignedNumber"]]];
  test=With[{cc=c},Function[p,inSolid[cc,"Mirror",p]]];
  place[installIntersection[base,sphereIntersector[o,f,mc,r,test]],c,o,f]
];

tubeSide[c_,kind_,sgn_,medium_] := Module[{r=c["PlateCylinderRadius"],centre=c[kind<>"Centre"],h=c[kind<>"HalfThickness"],o,f,fun,base,test},
  (* Positive optical x points into the tube material on either half. *)
  f=Transpose[{-sgn c["PlaneE"],c["PlaneV"],-sgn c["PlaneN"]}];
  o=centre+sgn r c["PlaneE"];
  fun=With[{rad=r},Function[{y,z},rad-Sqrt[Max[0.,rad^2-y^2]]]];
  base=makeBase[kind,fun,{2 r,2 h},kind<>"Cylinder_"<>ToString[c["SignedNumber"]]<>"_"<>ToString[sgn],medium];
  test=With[{cc=c,kk=kind},Function[p,inSolid[cc,kk,p]]];
  place[installIntersection[base,tubeIntersector[o,f,centre,r,-1,test]],c,o,f]
];

cellCutPlanes[c_,kind_,medium_] := Module[{a=c["CellApothem"],w=c["RadialLimits"],o,n},
  Join[Table[n={Cos[k Pi/3],Sin[k Pi/3],0.};o=a n+{0.,0.,Mean[w]};
    plane[c,kind,o,-n,kind<>"HexCut_"<>ToString[c["SignedNumber"]]<>"_"<>ToString[k],medium],{k,0,5}],
    Table[plane[c,kind,{0.,0.,w[[k]]},If[k==1,{0.,0.,1.},{0.,0.,-1.}],
      kind<>"RadialCut_"<>ToString[c["SignedNumber"]]<>"_"<>ToString[k],medium],{k,1,2}]]
];

sensorFaces[c_,medium_] := Module[{axes={c["PlaneE"],c["PlaneV"],c["PlaneN"]},h=c["SensorHalfSizes"]},
  Flatten[Table[plane[c,"Sensor",c["SensorCentre"]+s h[[k]] axes[[k]],-s axes[[k]],
    If[k==3 && s==1,"SensorFront_","SensorOther_"]<>ToString[c["SignedNumber"]]<>"_"<>ToString[k]<>"_"<>ToString[s],medium],
    {k,1,3},{s,{-1,1}}],1]
];

cellComponents[c_,full_,medium_,cool_] := Module[{out={},centre,n},
  AppendTo[out,sphere[c,"Inner",medium]];
  If[full,AppendTo[out,sphere[c,"Outer",medium]];out=Join[out,cellCutPlanes[c,"Mirror",medium]]];
  Do[centre=c[kind<>"Centre"];n=c["PlaneN"];
    Do[AppendTo[out,plane[c,kind,centre+s c[kind<>"HalfThickness"] n,-s n,
      kind<>"Face_"<>ToString[c["SignedNumber"]]<>"_"<>ToString[s],medium]],{s,{-1,1}}];
    If[full,out=Join[out,Table[tubeSide[c,kind,s,medium],{s,{-1,1}}],cellCutPlanes[c,kind,medium]]],
    {kind,If[cool,{"Aerogel","Cooling"},{"Aerogel"}]}];
  If[full,out=Join[out,sensorFaces[c,medium]],
    AppendTo[out,plane[c,"Sensor",c["SensorFront"],-c["PlaneN"],"SensorFront_"<>ToString[c["SignedNumber"]],medium]]];
  out
];

(* Optica calls a refractive-index model with a Ray/rule container, not a
   bare wavelength. This is the same argument convention documented for
   IndexFunction: Function[expression /. #]. Wavelength is in micrometres. *)
energyIndexModel[tab_List] := With[
  {ip=Interpolation[tab,InterpolationOrder->1],lo=tab[[1,1]],hi=tab[[-1,1]]},
  Function[ip[Min[hi,Max[lo,1.2398419843320026/(WaveLength /. #)]]]]
];

ARCOpticaMedia::invalid="Optica could not validate medium `1` with MediumNameQ. Run ARCOpticaMediaSelfCheck[] after loading the corrected adapter.";
ARCOpticaMedia[] := Module[{protected=MemberQ[Attributes[ModelRefractiveIndex],Protected],d=$ARCBarrelData,tab,fn,bad},
  Unprotect[ModelRefractiveIndex];
  Do[
    tab=d["MaterialTablesEV"][If[m==="Gas","RINDEX__C4F10_PFRICH","RINDEX__Aerogel_PFRICH"]];
    fn=energyIndexModel[tab];
    If[m==="Gas",ModelRefractiveIndex[ARCGas]=fn,ModelRefractiveIndex[ARCAerogel]=fn],{m,{"Gas","Aerogel"}}];
  If[protected,Protect[ModelRefractiveIndex]];
  bad=Select[{ARCGas,ARCAerogel},!TrueQ[Quiet[Check[MediumNameQ[#],False]]]&];
  If[bad=!={},Scan[Message[ARCOpticaMedia::invalid,#]&,bad];Return[$Failed]];
  <|"Gas"->ARCGas,"Aerogel"->ARCAerogel|>
];

ARCOpticaMediaSelfCheck[] := Module[{media=ARCOpticaMedia[],ray={WaveLength->.4}},
  If[media===$Failed,Return[$Failed]];
  <|"GasAccepted"->TrueQ[MediumNameQ[media["Gas"]]],
    "AerogelAccepted"->TrueQ[MediumNameQ[media["Aerogel"]]],
    "GasIndex400nm"->N[ModelRefractiveIndex[media["Gas"]][ray]],
    "AerogelIndex400nm"->N[ModelRefractiveIndex[media["Aerogel"]][ray]]|>
];

Options[ARCOpticaComponents]={"FullBoundaryModel"->True,"IncludeCooling"->True};
ARCOpticaComponents[b_Association,OptionsPattern[]] := Catch[Module[{media=ARCOpticaMedia[],cs},
  If[media===$Failed,Return[$Failed]];
  cs=Flatten[cellComponents[#,TrueQ[OptionValue["FullBoundaryModel"]],media["Aerogel"],
    TrueQ[OptionValue["IncludeCooling"]]]& /@ b["Cells"]];
  <|"Components"->cs,"Media"->media,"Barrel"->b,"FullBoundaryModel"->OptionValue["FullBoundaryModel"],
    "LengthUnit"->"mm","WaveLengthUnit"->"micrometre","TraceFunction"->PropagateSystem|>
]];

Options[ARCOpticaSystem]=Options[ARCOpticaComponents];
ARCOpticaSystem[b_Association,opts:OptionsPattern[]] := Module[{a=ARCOpticaComponents[b,opts]},
  If[a===$Failed,Return[$Failed]];
  Resonate[a["Components"],"ARCBarrel"]
];

ARCOpticaRays[p_List,dirs_List,lambda_:400.,medium_:"Gas"] := Module[{m=ARCOpticaMedia[]},
  If[m===$Failed,Return[$Failed]];
  CustomRays[{{RayStart,ConstantArray[N[p],Length[dirs]]},{RayTilt,Normalize[N[#]]& /@ dirs}},
    WaveLength->N[lambda/1000.],IntrinsicMedium->m["Gas"],OpticalMedium->m[medium]]
];

ARCOpticaClipSelfCheck[] := Module[{base,hook,changed,fn,pass,fail},
  base=Screen[{20.,20.},"ARCClipSelfCheck"];
  hook=planeIntersector[{0.,0.,0.},IdentityMatrix[3],Function[p,Abs[p[[2]]]<=1. && Abs[p[[3]]]<=1.]];
  changed=Catch[installIntersection[base,hook]];If[changed===$Failed,Return[False]];
  fn=SurfaceIntersectionFunction/.First[First[Cases[changed,HoldPattern[Rule[Surfaces,v_]]:>v,Infinity]]];
  pass=fn[-5.,0.,0.,1.,0.,0.];fail=fn[-5.,2.,0.,1.,0.,0.];
  TrueQ[pass==={{5.,0.,0.}} && fail==={{-1.,0.,0.}}]
];

End[];
EndPackage[];
$ContextPath=DeleteDuplicates[Prepend[$ContextPath,"OpticaEM`OpticaEM`"]];(*FIX 2026-11-08: Optica functions visible after loading*)
