(* Structural verification for the canonical project stylesheet. *)

ClearAll[fail, styleCell, directOption];
fail[message_String] := (Print["ERROR: ", message]; Exit[2]);

styleCell[expression_Notebook, name_String] := FirstCase[
  expression,
  cell : Cell[StyleData[name], ___] :> cell,
  Missing["NotFound"],
  Infinity
];

directOption[cell_Cell, option_Symbol] := FirstCase[
  cell,
  HoldPattern[Rule[option, value_]] :> value,
  Missing["NotFound"],
  {1}
];

root = DirectoryName[DirectoryName[$InputFileName]];
stylePath = FileNameJoin[{root, "myStyle.nb"}];
stylesheet = Quiet @ Check[Get[stylePath], $Failed];

If[! MatchQ[stylesheet, _Notebook],
  fail["myStyle.nb did not parse as a Notebook expression."]
];

outputCell = styleCell[stylesheet, "Output"];
printCell = styleCell[stylesheet, "Print"];
If[MissingQ[outputCell] || MissingQ[printCell],
  fail["Output or Print StyleData is missing."]
];

If[
  directOption[outputCell, CellFrame] =!= {{1, 1}, {1, 0}} ||
    directOption[outputCell, CellMargins] =!= {{60, 10}, {7, 0}},
  fail["Output does not close the shared result block as expected."]
];

If[
  directOption[printCell, CellFrame] =!= {{1, 1}, {0, 0}} ||
    directOption[printCell, CellMargins] =!= {{60, 10}, {0, 0}},
  fail["Print cells do not form a compact, continuous result block."]
];

Print["Stylesheet check passed."];
