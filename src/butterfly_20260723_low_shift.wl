(* ::Package:: *)

(* ::Subsection::Initialization:: *)
(* RICH1 Upgrade-II butterfly split optics: LOW to the left, HIGH to the top. *)
(* 2026-07-23: added an in-plane translation of the LOW flat mirror.          *)


(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------------------------------*)
bigBanner["-->> butterfly: LOW left / HIGH top"];
(*--------------------------------------------------------------------------------------------------------*)
checkNewCreatedSymbols;

Map[Unprotect,
  Complement[
    Join[
      Names["tiltQuartz*"], Names["tiltPriMir*"], Names["tiltSecMir*"],
      Names["tiltTerMir*"], Names["tiltScreen*"]],
    Names["tilt*Var*"]]];
Map[Unprotect,
  Complement[
    Join[
      Names["zQuartz*"], Names["zPriMir*"], Names["zSecMir*"],
      Names["zTerMir*"], Names["zScreen*"]],
    Names["z*Var*"]]];
Map[Unprotect,
  Complement[
    Join[
      Names["xQuartz*"], Names["xPriMir*"], Names["xSecMir*"],
      Names["xTerMir*"], Names["xScreen*"]],
    Names["x*Var*"]]];
Map[Unprotect,
  Complement[
    Join[
      Names["yQuartz*"], Names["yPriMir*"], Names["ySecMir*"],
      Names["yTerMir*"], Names["yScreen*"]],
    Names["y*Var*"]]];
Map[Unprotect,
  Complement[
    Join[
      Names["sizeQuartz*"], Names["sizePriMir*"], Names["sizeSecMir*"],
      Names["sizeTerMir*"], Names["sizeScreen*"]],
    Names["size*Var*"]]];

Clear[apertureL, apertureH];

(*=======================================================================*)
(* Coordinate convention                                                 *)
(*                                                                       *)
(* All triples are ordered as {z,x,y}.                                   *)
(* z: beam direction; x: horizontal (positive towards the left);         *)
(* y: vertical (positive towards the top).                               *)
(*                                                                       *)
(* LOW is the small-polar-angle/high-occupancy branch.                    *)
(* HIGH is the large-polar-angle/lower-occupancy branch.                  *)
(*=======================================================================*)

azH = 90 Degree;      (* HIGH optical plane: z-y, folded to the top. *)

tiltVectorFromAzimuth[az_, tilt_] :=
  Normalize[{Cos[tilt], Sin[tilt] Cos[az], Sin[tilt] Sin[az]}];

shiftAlongNormal[{z_, x_, y_}, d_, az_, tilt_] :=
  N[{z, x, y} + d tiltVectorFromAzimuth[az, tilt]];

shiftAlongVector[{z_, x_, y_}, d_, normal_] :=
  N[{z, x, y} + d Normalize[normal]];

reflectDirection[direction_, normal_] :=
  Module[{d = Normalize[direction], n = Normalize[normal]},
    Normalize[d - 2 (d.n) n]];

(*=======================================================================*)
(* Optical sizes                                                         *)
(*                                                                       *)
(* These are the sizes of the optimized all-vertical split layout.       *)
(* LOW keeps the wide and shallow aperture of the upper vertical branch. *)
(*=======================================================================*)

(* LOW vertical acceptance: tracks up to 82 mrad from the interaction point. *)
(* At z = 2030 mm, including the largest Cherenkov angle (53.543 mrad),     *)
(* the required height is 276.85 mm; 282 mm includes a 5 mm safety margin.  *)
sizeTrnsvrsPriMirL = 282.;
sizeTrnsvrsPriMirH = 700.;

sizeTrnsvrsSecMirL = 500.;
sizeTrnsvrsSecMirH = 400.;

(* Temporarily oversized focal planes for photon-acceptance studies. *)
(* Nominal transverse sizes were 520 mm (LOW) and 320 mm (HIGH).   *)
sizeTrnsvrsScreenL = 1200.;
sizeTrnsvrsScreenH = 800.;

(* CustomMirror uses half sizes in its polygon aperture. *)
sizeThirdDimPriMir0 = 800.;
sizeThirdDimPriMirL := sizeThirdDimPriMir0;
sizeThirdDimPriMirH := sizeThirdDimPriMir0;

(* SphericalMirror and Screen use full sizes in the third dimension. *)
sizeThirdDimSecMir0 = 2 sizeThirdDimPriMir0;
sizeThirdDimSecMirL := sizeThirdDimSecMir0;
sizeThirdDimSecMirH := sizeThirdDimSecMir0;

(* Nominal long side was 2000 mm. *)
sizeThirdDimScreen0 = 2400.;
sizeThirdDimScreenL := sizeThirdDimScreen0;
sizeThirdDimScreenH := sizeThirdDimScreen0;

(* Backward-compatible aliases used by the original definition. *)
sizeThrdDimPriMirL := sizeThirdDimPriMirL;
sizeThrdDimPriMirH := sizeThirdDimPriMirH;
sizeThrdDimSecMirL := sizeThirdDimSecMirL;
sizeThrdDimSecMirH := sizeThirdDimSecMirH;
sizeThrdDimScreenL := sizeThirdDimScreenL;
sizeThrdDimScreenH := sizeThirdDimScreenH;

(*=======================================================================*)
(* Orientations                                                          *)
(*=======================================================================*)

(* LOW apertures are defined directly with their long side along local x. *)
(* No 90-degree twist is therefore required to make them wide and low.  *)
rollPriMirL = 0.;
rollPriMirH = 0.;
rollSecMirL = 0.;
rollSecMirH = 0.;
rollScreenL = 0.;
rollScreenH = 0.;

tiltPriMirLDegree = 0.;
tiltPriMirL := tiltPriMirLDegree Degree;
tiltPriMirHDegree = -7.;
tiltPriMirH := tiltPriMirHDegree Degree;

tiltSecMirLVerticalDegree = 26.;
tiltSecMirLVertical := tiltSecMirLVerticalDegree Degree;
tiltSecMirHDegree = 23.;
tiltSecMirH := tiltSecMirHDegree Degree;

tiltScreenLDegree = 50.;
tiltScreenL := tiltScreenLDegree Degree;
tiltScreenHDegree = 58.;
tiltScreenH := tiltScreenHDegree Degree;

(*=======================================================================*)
(* Positions                                                             *)
(*                                                                       *)
(* Both spherical mirrors remain above the beam pipe.                     *)
(* HIGH is folded vertically. For LOW, only the reflected leg downstream  *)
(* of the flat mirror is rotated by 90 degrees towards the left.           *)
(* The LOW flat-to-PDA distance is therefore identical to the optimized    *)
(* all-vertical layout.                                                    *)
(*=======================================================================*)

zPriMirL = 2030.; xPriMirL = 0.;   yPriMirL = 0.;
zPriMirH = 2100.; xPriMirH = 0.;   yPriMirH = 0.;

zSecMirL = 1063.; xSecMirL = 0.;   ySecMirL = 211.;
zSecMirH = 1060.; xSecMirH = 0.;   ySecMirH = 668.;

(* Optimized vertical LOW focal-plane centre, used to construct the fold. *)
zScreenLVertical0 = 2119.58;
xScreenLVertical0 = 0.;
yScreenLVertical0 = 1427.19;

(* Rotate the old transverse displacement about the LOW flat-mirror centre: *)
(* +y (top) -> +x (left).                                                  *)
zScreenL0 = zScreenLVertical0;
xScreenL0 = yScreenLVertical0 - ySecMirL;
yScreenL0 = ySecMirL;
zScreenH0 = 1459.41; xScreenH0 = 0.;       yScreenH0 = 1293.02;

(* Component normals. *)
normalPriMirL = {1., 0., 0.};
normalPriMirH := tiltVectorFromAzimuth[azH, tiltPriMirH];
normalSecMirH := tiltVectorFromAzimuth[azH, tiltSecMirH];
normalScreenL := tiltVectorFromAzimuth[0 Degree, tiltScreenL];
normalScreenH := tiltVectorFromAzimuth[azH, tiltScreenH];

(* Reconstruct the LOW incident chief ray from the optimized vertical fold. *)
normalSecMirLVertical :=
  tiltVectorFromAzimuth[90 Degree, tiltSecMirLVertical];
directionSecToScreenLVertical :=
  Normalize[
    {zScreenLVertical0 - zSecMirL,
     xScreenLVertical0 - xSecMirL,
     yScreenLVertical0 - ySecMirL}];
directionIncidentOnSecMirL :=
  reflectDirection[directionSecToScreenLVertical, normalSecMirLVertical];

(* Desired reflected direction towards the lateral LOW photodetector plane. *)
directionSecToScreenL :=
  Normalize[
    {zScreenL0 - zSecMirL,
     xScreenL0 - xSecMirL,
     yScreenL0 - ySecMirL}];

(* The plane normal bisects the incident and reflected chief-ray directions. *)
normalSecMirLRaw :=
  Normalize[directionIncidentOnSecMirL - directionSecToScreenL];
normalSecMirL :=
  If[normalSecMirLRaw[[1]] < 0., -normalSecMirLRaw, normalSecMirLRaw];

(*=======================================================================*)
(* In-plane translation of the LOW flat mirror                           *)
(*                                                                       *)
(* The finite LOW-mirror aperture can be moved towards the left without  *)
(* moving the optical plane. This leaves the reflection law, the outgoing *)
(* rays and the LOW focal plane unchanged.                               *)
(*                                                                       *)
(* shiftSecMirL is measured in mm along the mirror surface:              *)
(*   shiftSecMirL > 0  -> left (+x);                                     *)
(*   shiftSecMirL < 0  -> right (-x).                                    *)
(*                                                                       *)
(* Keep the initial value at zero until the complete photon-hit envelope *)
(* on an oversized diagnostic LOW mirror has been measured.              *)
(*=======================================================================*)

normalSecMirLReference = N[normalSecMirL];

(* Horizontal direction contained in the LOW-mirror plane.               *)
(* Coordinates are ordered as {z,x,y}; the sign is chosen towards +x.    *)
(* For the present geometry it is approximately {-0.4151,0.9098,0.}.     *)
directionLeftSecMirL =
  Normalize[Cross[{0., 0., 1.}, normalSecMirLReference]];

(* Edit this value and reload the optical definition.                     *)
shiftSecMirL = 0.;

centerSecMirLBeforeShift = {zSecMirL, xSecMirL, ySecMirL};
centerSecMirLAfterShift =
  N[centerSecMirLBeforeShift +
    shiftSecMirL directionLeftSecMirL];

zSecMirL = centerSecMirLAfterShift[[1]];
xSecMirL = centerSecMirLAfterShift[[2]];
ySecMirL = centerSecMirLAfterShift[[3]];

(* Freeze the previously reconstructed normal: the translation is exactly *)
(* tangent to the mirror and must not trigger a new optical orientation.   *)
normalSecMirL = normalSecMirLReference;

(* Useful diagnostics.                                                    *)
deltaZSecMirL := zSecMirL - centerSecMirLBeforeShift[[1]];
deltaXSecMirL := xSecMirL - centerSecMirLBeforeShift[[2]];
deltaYSecMirL := ySecMirL - centerSecMirLBeforeShift[[3]];

(* Diagnostic angles; approximately tilt=24.58 deg and azimuth=3.94 deg. *)
tiltSecMirL := ArcCos[normalSecMirL[[1]]];
tiltSecMirLDegree := N[tiltSecMirL/Degree];
azSecMirL := ArcTan[normalSecMirL[[2]], normalSecMirL[[3]]];
azSecMirLDegree := N[azSecMirL/Degree];

(* Normal offsets provide a safe one-parameter fine focus scan in Optica. *)
focusOffsetL = 0.;
focusOffsetH = 0.;

screenCenterL :=
  shiftAlongVector[
    {zScreenL0, xScreenL0, yScreenL0}, focusOffsetL, normalScreenL];
zScreenL := screenCenterL[[1]];
xScreenL := screenCenterL[[2]];
yScreenL := screenCenterL[[3]];

screenCenterH :=
  shiftAlongVector[
    {zScreenH0, xScreenH0, yScreenH0}, focusOffsetH, normalScreenH];
zScreenH := screenCenterH[[1]];
xScreenH := screenCenterH[[2]];
yScreenH := screenCenterH[[3]];

(*=======================================================================*)
(* Radii                                                                 *)
(*=======================================================================*)

radiusSecMir = 0.;
radiusSecMirL := radiusSecMir;
radiusSecMirH := radiusSecMir;

radiusRefToday = 3650.;
radiusL := radiusRefToday Sqrt[2.];
radiusH := radiusRefToday;
radiusPriMirL := radiusL;
radiusPriMirH := radiusH;

(*=======================================================================*)
(* HIGH-primary aperture parameters                                      *)
(*=======================================================================*)

fullBackMirror = True;
delta2PriMirHTrnsvrs = 0.;
delta2PriMirHThirdDim = 10.;
sizeTrnsvrsPriMirH2 := sizeTrnsvrsPriMirH;
delta1PriMirHTrnsvrs := 2 sizeTrnsvrsPriMirH2/3;
delta1PriMirHThirdDim := 2 sizeThirdDimPriMirH/3;

(*=======================================================================*)
(* No parameter changes below this line.                                 *)
(*=======================================================================*)

Map[Protect,
  Complement[
    Join[
      Names["tiltQuartz*"], Names["tiltPriMir*"], Names["tiltSecMir*"],
      Names["tiltTerMir*"], Names["tiltScreen*"]],
    Names["tilt*Var*"]]];
Map[Protect,
  Complement[
    Join[
      Names["zQuartz*"], Names["zPriMir*"], Names["zSecMir*"],
      Names["zTerMir*"], Names["zScreen*"]],
    Names["z*Var*"]]];
Map[Protect,
  Complement[
    Join[
      Names["xQuartz*"], Names["xPriMir*"], Names["xSecMir*"],
      Names["xTerMir*"], Names["xScreen*"]],
    Names["x*Var*"]]];
Map[Protect,
  Complement[
    Join[
      Names["yQuartz*"], Names["yPriMir*"], Names["ySecMir*"],
      Names["yTerMir*"], Names["yScreen*"]],
    Names["y*Var*"]]];
Map[Protect,
  Complement[
    Join[
      Names["sizeQuartz*"], Names["sizePriMir*"], Names["sizeSecMir*"],
      Names["sizeTerMir*"], Names["sizeScreen*"]],
    Names["size*Var*"]]];

(*=======================================================================*)
(* Primary mirrors                                                       *)
(*=======================================================================*)

zc0L := -radiusL;
xc0L = 0.;
yc0L = 0.;
{a1, b1, c1} = {1., 1., 1.};

apertureL := {
  {-sizeThirdDimPriMirL, 0.},
  { sizeThirdDimPriMirL, 0.},
  { sizeThirdDimPriMirL, sizeTrnsvrsPriMirL},
  {-sizeThirdDimPriMirL, sizeTrnsvrsPriMirL}};

If[Length[apertureL] != Length[DeleteDuplicates[apertureL]],
  bigBanner["STOP: duplicate points in LOW primary aperture"];
  killStop];

priMirrorL :=
  Move[
    CustomMirror[
      Function[
        Evaluate[
          ellipse3D[a1, b1, c1, radiusL, #1, #2, zc0L, xc0L, yc0L]]],
      apertureL,
      "PRI-MIR-L",
      SurfaceRayIntersections -> Symbol,
      LabelPositions -> {{0, 0, 0}}],
    {{zPriMirLVar, zPriMirL},
     {xPriMirLVar, xPriMirL},
     {yPriMirLVar, yPriMirL}},
    normalPriMirL,
    TwistAngle -> rollPriMirL];

zc0H := -radiusH;
xc0H = 0.;
yc0H = 0.;
{a2, b2, c2} = {1., 1., 1.};

apertureH :=
  If[fullBackMirror,
    {
      {0., -sizeThirdDimPriMirH},
      {sizeTrnsvrsPriMirH, -sizeThirdDimPriMirH},
      {sizeTrnsvrsPriMirH, sizeThirdDimPriMirH},
      {0., sizeThirdDimPriMirH}},
    {
      {-sizeTrnsvrsPriMirH2 + delta1PriMirHTrnsvrs - delta2PriMirHTrnsvrs,
       delta2PriMirHThirdDim},
      {-sizeTrnsvrsPriMirH2 + delta1PriMirHTrnsvrs,
       sizeThirdDimPriMirH - delta1PriMirHThirdDim},
      {-sizeTrnsvrsPriMirH2,
       sizeThirdDimPriMirH - delta1PriMirHThirdDim},
      {-sizeTrnsvrsPriMirH2, sizeThirdDimPriMirH},
      {sizeTrnsvrsPriMirH2, sizeThirdDimPriMirH},
      {sizeTrnsvrsPriMirH2, -sizeThirdDimPriMirH},
      {-sizeTrnsvrsPriMirH2, -sizeThirdDimPriMirH},
      {-sizeTrnsvrsPriMirH2,
       -sizeThirdDimPriMirH + delta1PriMirHThirdDim},
      {-sizeTrnsvrsPriMirH2 + delta1PriMirHTrnsvrs,
       -sizeThirdDimPriMirH + delta1PriMirHThirdDim},
      {-sizeTrnsvrsPriMirH2 + delta1PriMirHTrnsvrs - delta2PriMirHTrnsvrs,
       -delta2PriMirHThirdDim}}];

If[Length[apertureH] != Length[DeleteDuplicates[apertureH]],
  bigBanner["STOP: duplicate points in HIGH primary aperture"];
  killStop];

priMirrorH :=
  Move[
    CustomMirror[
      Function[
        Evaluate[
          ellipse3D[a2, b2, c2, radiusH, #1, #2, zc0H, xc0H, yc0H]]],
      apertureH,
      "PRI-MIR-H",
      SurfaceRayIntersections -> Symbol,
      LabelPositions -> {{0, 0, 0}}],
    {{zPriMirHVar, zPriMirH},
     {xPriMirHVar, xPriMirH},
     {yPriMirHVar, yPriMirH}},
    normalPriMirH,
    TwistAngle -> rollPriMirH];

(*=======================================================================*)
(* Secondary flat mirrors                                                *)
(*=======================================================================*)

secMirrorL :=
  Move[
    SphericalMirror[
      {radiusSecMirLVar, radiusSecMirL},
      {sizeThirdDimSecMirL, sizeTrnsvrsSecMirL},
      "SEC-MIR-L",
      FlatSubstrate -> False,
      FrontSurface -> True],
    {{zSecMirLVar, zSecMirL},
     {xSecMirLVar, xSecMirL},
     {ySecMirLVar, ySecMirL}},
    normalSecMirL,
    TwistAngle -> rollSecMirL];

secMirrorH :=
  Move[
    SphericalMirror[
      {radiusSecMirHVar, radiusSecMirH},
      {sizeThirdDimSecMirH, sizeTrnsvrsSecMirH},
      "SEC-MIR-H",
      FlatSubstrate -> False,
      FrontSurface -> True],
    {{zSecMirHVar, zSecMirH},
     {xSecMirHVar, xSecMirH},
     {ySecMirHVar, ySecMirH}},
    normalSecMirH,
    TwistAngle -> rollSecMirH];

(*=======================================================================*)
(* Photodetector planes                                                  *)
(*=======================================================================*)

thePDAL :=
  Move[
    Screen[
      {sizeTrnsvrsScreenL, sizeThirdDimScreenL},
      "PDA-L",
      Transmittance -> 0,
      GraphicDesign -> Wire],
    {{zScreenLVar, zScreenL},
     {xScreenLVar, xScreenL},
     {yScreenLVar, yScreenL}},
    normalScreenL,
    TwistAngle -> rollScreenL];

thePDAH :=
  Move[
    Screen[
      {sizeThirdDimScreenH, sizeTrnsvrsScreenH},
      "PDA-H",
      Transmittance -> 0,
      GraphicDesign -> Wire],
    {{zScreenHVar, zScreenH},
     {xScreenHVar, xScreenH},
     {yScreenHVar, yScreenH}},
    normalScreenH,
    TwistAngle -> rollScreenH];

(*=======================================================================*)
(* Optics lists and component numbering                                  *)
(*=======================================================================*)

printD[resonate];

If[resonate === True,
  priMirrorNumber = 1;
  secMirrorNumber = 2;
  terMirrorNumber = 0;
  focalSurfaceNumber = 3;
  boxNumber = 4;

  onThePriMirror = {ComponentNumber -> priMirrorNumber};
  onTheSecMirror = {ComponentNumber -> secMirrorNumber};
  onTheFS = {ComponentNumber -> focalSurfaceNumber};
  onTheBox = {ComponentNumber -> boxNumber};
  theTrackOrigin = {ComponentNumber -> priMirrorNumber};

  myOptics := {
    Resonate[{priMirrorL, priMirrorH}, "PRI-MIR"],
    Resonate[{secMirrorL, secMirrorH}, "SEC-MIR"],
    Resonate[{thePDAL, thePDAH}, "PD"]},

  priMirrorNumber = 1;
  secMirrorNumber = 3;
  terMirrorNumber = 0;
  focalSurfaceNumber = 5;
  boxNumber = 7;

  myOptics :=
    {priMirrorL, priMirrorH, secMirrorL, secMirrorH, thePDAL, thePDAH}];

myOpticsL := {priMirrorL, secMirrorL, thePDAL};
myOpticsH := {priMirrorH, secMirrorH, thePDAH};

(*=======================================================================*)
(* Symmetric lower half                                                  *)
(*                                                                       *)
(* It is obtained from this definition through the point symmetry        *)
(* {z,x,y} -> {z,-x,-y}: LOW goes right and HIGH goes down.              *)
(*=======================================================================*)

checkNewCreatedSymbols;
