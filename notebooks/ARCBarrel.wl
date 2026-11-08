(* ::Package:: *)
(* ARC barrel geometry. Coordinates and distances: mm; angles: rad.
   Load with Get["/absolute/path/ARCBarrel.wl"]. Does not require Optica.
   See README_IT.md for source conventions and retained source-code details. *)

BeginPackage["ARCBarrel`"];
$ARCBarrelData::usage = "Association extracted from the XML and the active ARCBARREL_T C++ constructor.";
ARCBarrel::usage = "ARCBarrel[\"Row\"->1,\"Phi\"->0] builds all eta cells with centres at physical azimuth Phi. Row may be 1,2,or \"Both\"; Phi->Automatic preserves the ZIP orientation.";
ARCToGlobal::usage = "ARCToGlobal[cell,{u,v,w}] maps cell coordinates to global {X,Y,Z}; Z is the beam axis.";
ARCToLocal::usage = "ARCToLocal[cell,{X,Y,Z}] is the inverse of ARCToGlobal.";
ARCCellContainsQ::usage = "ARCCellContainsQ[cell,p] tests membership in the exact local hexagonal cell prism. Also accepts symbolic p.";
ARCVolumeContainsQ::usage = "ARCVolumeContainsQ[cell,kind,p] tests the local Mirror, Sensor, Aerogel, or Cooling solid, including the C++ Boolean intersections.";
ARCVolumeRegion::usage = "ARCVolumeRegion[cell,kind] returns an exact global ImplicitRegion/TransformedRegion; Coordinates->\"Local\" returns a local region.";
ARCMirrorW::usage = "ARCMirrorW[cell,u,v,\"Inner\"|\"Outer\"] gives the radial coordinate of a spherical optical surface in the local cell frame.";
ARCBarrelTable::usage = "ARCBarrelTable[barrel] returns a Dataset of positions, radii and tilts.";
ARCBarrelGraphics::usage = "ARCBarrelGraphics[barrel] shows the trimmed optical surfaces and cell wireframes in global coordinates.";
ARCBarrelSection::usage = "ARCBarrelSection[barrel] shows the v=0 meridional section in {beam Z, radial R} mm. Use one row at a time.";
ARCIndex::usage = "ARCIndex[\"Gas\"|\"Aerogel\", wavelengthNM] linearly interpolates the active XML RINDEX table in photon energy, as in the source tables; endpoints are clamped.";
ARCCherenkovCone::usage = "ARCCherenkovCone[direction,theta,n] returns n unit directions on a Cherenkov cone (no photon-yield model).";

Begin["`Private`"];
$ARCBarrelData = Get[FileNameJoin[{DirectoryName[$InputFileName],"ARCGeometryData.wl"}]];

ry[a_] := {{Cos[a],0,Sin[a]},{0,1,0},{-Sin[a],0,Cos[a]}};
hexNormals = N[Table[{Cos[k Pi/3],Sin[k Pi/3]}, {k,0,5}]];
hexVertices[a_] := N[a/Cos[Pi/6] Table[{Cos[Pi/6+k Pi/3],Sin[Pi/6+k Pi/3]},{k,0,5}]];

Options[ARCBarrel] = {"Row"->1, "Phi"->0., "SourcePhiIndex"->20};
ARCBarrel::row = "Row must be 1, 2, or \"Both\".";
ARCBarrel[OptionsPattern[]] := Module[{d=$ARCBarrelData,ns,phi=OptionValue["Phi"],phin=OptionValue["SourcePhiIndex"],row=OptionValue["Row"],cells},
  If[!MemberQ[{1,2,"Both"},row], Message[ARCBarrel::row]; Return[$Failed]];
  ns=Select[d["SourceSignedCellNumbers"], row==="Both" || If[OddQ[Abs[#]],1,2]===row &];
  If[phi===Automatic, phi=Mod[phin d["PhiStep"]+Pi,2 Pi]];
  cells=makeCell[#, N[phi], phin]& /@ ns;
  cells=SortBy[cells, #["CentreZ"]&];
  <|"Units"-><|"Length"->"mm","Angle"->"rad"|>,"Row"->row,"BasePhysicalPhi"->N[phi],
    "SourcePhiIndex"->phin,"Data"->d,"Cells"->cells|>
];

makeCell[n_,phi_,phin_] := Module[{d=$ARCBarrelData,p,sgn,z,a,ph,q,sc,ac,cc,mc,rs,e,v,normal,sourceIndex},
  p=First[Select[d["RawCells"], #["Number"]===Abs[n]&]];
  sgn=If[n<0,-1.,1.];
  z=sgn (p["Column"] d["ZStep"]-If[p["Row"]===2,d["ZStep"]/2,0.]);
  a=sgn p["SensorTilt"];
  ph=phi+If[p["Row"]===2,d["PhiStep"]/2,0.];
  (* Columns are +beam Z, -azimuth, +radial: det(q)=+1. *)
  q={{0.,Sin[ph],Cos[ph]},{0.,-Cos[ph],Sin[ph]},{1.,0.,0.}};
  mc={sgn p["MirrorU"],0.,d["MirrorRadialOrigin"]+p["MirrorWOffset"]};
  sc={sgn p["SensorU"],0.,d["SensorRadialOrigin"]+p["SensorWOffset"]};
  ac=sc+{0.,0.,d["AerogelRadialOffset"]};
  cc=sc-{0.,0.,d["CoolingRadialOffset"]};
  rs=ry[Pi-a]; (* Ry[Pi/2].Ry[Pi/2-a] from the C++ sensorTr. *)
  e={Cos[a],0.,Sin[a]};v={0.,1.,0.};normal={-Sin[a],0.,Cos[a]};
  sourceIndex=First[FirstPosition[d["SourceSignedCellNumbers"],n]]-1;
  <|"SignedNumber"->n,"Number"->Abs[n],"Row"->p["Row"],"Column"->p["Column"],
    "CentreZ"->z,"PhysicalPhi"->ph,"Rotation"->q,"Translation"->{0.,0.,z},
    "CellApothem"->d["CellApothem"],"HexVertices"->hexVertices[d["CellApothem"]],
    "RadialLimits"->d["CellRadialLimits"],"MirrorCentre"->mc,
    "MirrorOuterRadius"->p["Radius"],"MirrorInnerRadius"->p["Radius"]-d["MirrorThickness"],
    "MirrorThetaMaximum"->d["MirrorThetaMaximum"],
    "SensorCentre"->sc,"SensorTilt"->a,"SensorRotation"->rs,
    "SensorHalfSizes"->Append[d["SensorSides"]/2,d["SensorThickness"]/2],
    "PlaneE"->e,"PlaneV"->v,"PlaneN"->normal,
    "SensorFront"->sc+normal d["SensorThickness"]/2,
    "AerogelCentre"->ac,"AerogelHalfThickness"->d["AerogelThickness"]/2,
    "CoolingCentre"->cc,"CoolingHalfThickness"->d["CoolingHalfThickness"],
    "PlateCylinderRadius"->d["PlateCylinderRadius"],
    "EtaAtSensorRadius"->ArcSinh[z/sc[[3]]],
    "SourceCellCounter"->sourceIndex,"SourceSensorCellNumberID"->(3 sourceIndex+2),
    "SourceName"->("ARCBARREL_cell"<>ToString[Abs[n]]<>"_ref"<>If[n<0,"1","0"]<>"_phi"<>ToString[phin])|>
];

ARCToGlobal[c_Association,p_List] := c["Rotation"].p+c["Translation"];
ARCToLocal[c_Association,p_List] := Transpose[c["Rotation"]].(p-c["Translation"]);

ARCCellContainsQ[c_Association,p_List] := And[
  c["RadialLimits"][[1]] <= p[[3]] <= c["RadialLimits"][[2]],
  And@@Thread[hexNormals.p[[{1,2}]] <= c["CellApothem"]]
];

ARCVolumeContainsQ[c_Association,"Mirror",p_List] := Module[{d=p-c["MirrorCentre"],rr},
  rr=d.d;
  ARCCellContainsQ[c,p] && c["MirrorInnerRadius"]^2 <= rr <= c["MirrorOuterRadius"]^2 &&
    d[[3]]>=Cos[c["MirrorThetaMaximum"]] Sqrt[rr]
];
ARCVolumeContainsQ[c_Association,"Sensor",p_List] := Module[{s=Transpose[c["SensorRotation"]].(p-c["SensorCentre"])},
  And@@Thread[Abs[s]<=c["SensorHalfSizes"]]
];
ARCVolumeContainsQ[c_Association,kind: ("Aerogel"|"Cooling"),p_List] := Module[{s,h,cen},
  cen=c[kind<>"Centre"];h=c[kind<>"HalfThickness"];
  s=Transpose[c["SensorRotation"]].(p-cen);
  ARCCellContainsQ[c,p] && s[[1]]^2+s[[2]]^2<=c["PlateCylinderRadius"]^2 && -h<=s[[3]]<=h
];
ARCVolumeContainsQ[c_Association,"Cell",p_List] := ARCCellContainsQ[c,p];

Options[ARCVolumeRegion]={"Coordinates"->"Global"};
ARCVolumeRegion[c_Association,kind_String,OptionsPattern[]] := Module[{u,v,w,r},
  r=ImplicitRegion[Evaluate[ARCVolumeContainsQ[c,kind,{u,v,w}]],{u,v,w}];
  If[OptionValue["Coordinates"]==="Local",r,
    TransformedRegion[r,AffineTransform[{c["Rotation"],c["Translation"]}]]]
];

ARCMirrorW[c_Association,u_,v_,side_:"Inner"] := Module[{m=c["MirrorCentre"],r=c["Mirror"<>side<>"Radius"]},
  m[[3]]+Sqrt[r^2-(u-m[[1]])^2-v^2]
];

ARCBarrelTable[b_Association] := Dataset[Map[Function[c,<|
  "Cell"->c["SignedNumber"],"Row"->c["Row"],"Zcell_mm"->c["CentreZ"],"EtaCentre"->c["EtaAtSensorRadius"],
  "Phi_rad"->c["PhysicalPhi"],"MirrorCentreXYZ_mm"->ARCToGlobal[c,c["MirrorCentre"]],
  "MirrorRadiusGasSide_mm"->c["MirrorInnerRadius"],
  "SensorCentreXYZ_mm"->ARCToGlobal[c,c["SensorCentre"]],"SensorTilt_rad"->c["SensorTilt"],
  "AerogelCentreXYZ_mm"->ARCToGlobal[c,c["AerogelCentre"]]|>],b["Cells"]]];

ARCIndex::wave="Wavelength must be positive.";
ARCIndex[material: ("Gas"|"Aerogel"),lambda_?NumericQ] := Module[{key,t,energy},
  If[lambda<=0,Message[ARCIndex::wave];Return[$Failed]];
  key=If[material==="Gas","RINDEX__C4F10_PFRICH","RINDEX__Aerogel_PFRICH"];
  t=$ARCBarrelData["MaterialTablesEV"][key];
  energy=Clip[1239.8419843320026/lambda, {t[[1,1]],t[[-1,1]]}];
  Interpolation[t,InterpolationOrder->1][energy]
];

ARCCherenkovCone[direction_List,theta_?NumericQ,n_Integer:36] := Module[{t,e1,e2},
  t=Normalize[direction];e1=Normalize[Cross[t,If[Abs[t[[3]]]<.9,{0.,0.,1.},{0.,1.,0.}]]];e2=Cross[t,e1];
  Table[Cos[theta] t+Sin[theta](Cos[a] e1+Sin[a] e2),{a,0.,2 Pi-2 Pi/n,2 Pi/n}]
];

cellWire[c_] := Module[{vertices=c["HexVertices"],w=c["RadialLimits"],rings},
  rings=Table[ARCToGlobal[c,Append[#,h]]& /@ vertices,{h,w}];
  {GrayLevel[.62],Thin,Line[Append[#,First[#]]]& /@ rings,
   MapThread[Line[{#1,#2}]&,rings]}
];

mirrorPlot[c_,side_:"Inner"] := Module[{u,v,a=c["CellApothem"],r=c["Mirror"<>side<>"Radius"],mc=c["MirrorCentre"],w},
  w=mc[[3]]+Sqrt[Max[0,r^2-(u-mc[[1]])^2-v^2]];
  ParametricPlot3D[Evaluate[ARCToGlobal[c,{u,v,w}]],{u,-a,a},{v,-2 a/Sqrt[3],2 a/Sqrt[3]},
    RegionFunction->Function[{x,y,z,uu,vv}, TrueQ[ARCCellContainsQ[c,{uu,vv,ARCToLocal[c,{x,y,z}][[3]]}]] &&
      (uu-mc[[1]])^2+vv^2<r^2],
    Mesh->None,PlotStyle->Directive[RGBColor[.86,.65,.19],Opacity[.9]],PlotPoints->22,MaxRecursion->1]
];

platePlot[c_,sgn_] := Module[{s,t,h=c["AerogelHalfThickness"],a=c["CellApothem"],p},
  p=c["AerogelCentre"]+c["PlaneE"] s+c["PlaneV"] t+sgn h c["PlaneN"];
  ParametricPlot3D[Evaluate[ARCToGlobal[c,p]],{s,-2 a,2 a},{t,-2 a,2 a},
    RegionFunction->Function[{x,y,z,ss,tt},TrueQ[ARCCellContainsQ[c,ARCToLocal[c,{x,y,z}]]] &&
      ss^2+tt^2<=c["PlateCylinderRadius"]^2],
    PlotStyle->Directive[RGBColor[.95,.47,.3],Opacity[.38]],Mesh->None,PlotPoints->20,MaxRecursion->1]
];

sensorPolygon[c_] := Module[{f=c["SensorFront"],e=c["PlaneE"],v=c["PlaneV"],h=c["SensorHalfSizes"]},
  {RGBColor[.75,.08,.11],Polygon[ARCToGlobal[c,f+#[[1]] h[[1]] e+#[[2]] h[[2]] v]& /@
    {{-1,-1},{1,-1},{1,1},{-1,1}}]}
];

Options[ARCBarrelGraphics]={"CellWireframes"->True,"Aerogel"->True,ImageSize->1000};
ARCBarrelGraphics[b_Association,OptionsPattern[]] := Module[{cs=b["Cells"],parts},
  parts=Join[mirrorPlot /@ cs,If[TrueQ[OptionValue["Aerogel"]],Flatten[Table[platePlot[c,s],{c,cs},{s,{-1,1}}],1],{}],
    {Graphics3D[Join[sensorPolygon /@ cs,If[TrueQ[OptionValue["CellWireframes"]],cellWire /@ cs,{}]]]}];
  Show[parts,Axes->True,AxesLabel->{"X [mm]","Y [mm]","Z beam [mm]"},BoxRatios->Automatic,
    PlotRange->All,ImageSize->OptionValue[ImageSize],Lighting->"Neutral",ViewPoint->{3,-5,2}]
];

Options[ARCBarrelSection]={ImageSize->1100};
ARCBarrelSection[b_Association,OptionsPattern[]] := Module[{d=b["Data"],prims={},c,a,u,w,points,sc,ac,n,e,vertices},
  Do[
    a=c["CellApothem"];
    AppendTo[prims,{GrayLevel[.8],Line[{{c["CentreZ"]-a,c["RadialLimits"][[1]]},{c["CentreZ"]+a,c["RadialLimits"][[1]]},
      {c["CentreZ"]+a,c["RadialLimits"][[2]]},{c["CentreZ"]-a,c["RadialLimits"][[2]]},{c["CentreZ"]-a,c["RadialLimits"][[1]]}}]}];
    points=Table[w=ARCMirrorW[c,u,0.];If[Im[N[w]]==0. && TrueQ[ARCCellContainsQ[c,{u,0.,Re[w]}]],
      {c["CentreZ"]+u,Re[w]},Nothing],{u,-a,a,2 a/300}];
    AppendTo[prims,{RGBColor[.72,.48,.05],Thick,Line[points]}];
    sc=c["SensorCentre"];ac=c["AerogelCentre"];n=c["PlaneN"];e=c["PlaneE"];
    AppendTo[prims,{RGBColor[.8,.07,.1],Thick,Line[({c["CentreZ"]+#[[1]],#[[3]]}& /@
      {c["SensorFront"]-c["SensorHalfSizes"][[1]] e,c["SensorFront"]+c["SensorHalfSizes"][[1]] e})]}];
    Do[
      vertices=Table[ac+e u+s c["AerogelHalfThickness"] n,{u,-2 a,2 a,4 a/500}];
      vertices=Select[vertices,TrueQ[ARCCellContainsQ[c,#]] && Abs[(#-ac).e]<=c["PlateCylinderRadius"]&];
      AppendTo[prims,{RGBColor[.95,.4,.22],Line[({c["CentreZ"]+#[[1]],#[[3]]}& /@ vertices)]}],{s,{-1,1}}],
    {c,b["Cells"]}];
  Graphics[prims,Frame->True,FrameLabel->{"Z beam [mm]","R [mm]"},AspectRatio->.2,
    PlotRange->All,ImageSize->OptionValue[ImageSize]]
];

End[];
EndPackage[];
