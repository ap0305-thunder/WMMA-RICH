(* ::Package:: *)

(* \[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine] *)
(*  NAVIGATION HELPERS  \[LongDash] put these in an Initialization Cell                 *)
(*  so they are available when the docked buttons are clicked                 *)
(* \[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine] *)
navHistory = {};
pushHistory[] := AppendTo[navHistory,
    First @ SelectedCells @ EvaluationNotebook[]
];
goBack[] := If[navHistory =!= {},
    SelectionMove[Last[navHistory], All, Cell];
    navHistory = Most[navHistory];
];

(* \[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine] *)
(*  DOCKED CELL TOOLBAR                                                        *)
(*  Colours:  green = navigation/editing  |  blue = back/mark nav             *)
(*            orange = evaluation         |  red  = danger                    *)
(* \[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine] *)

SetOptions[EvaluationNotebook[], DockedCells -> {

  Cell[BoxData[TagBox[

    GridBox[
      {{
        (* \[HorizontalLine]\[HorizontalLine] LEFT COLUMN: notebook label (currently empty) \[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine] *)
        ItemBox[
          TemplateBox[
            {
              TemplateBox[{10}, "Spacer1"],
              StyleBox["\"\"", 8, Bold, FontFamily -> "Helvetica"],  (* \[LeftArrow] fill in title *)
              StyleBox["\"\"", 8, Bold, FontFamily -> "Helvetica"]   (* \[LeftArrow] fill in subtitle *)
            },
            "RowWithSeparator"
          ],
          Alignment -> Left, StripOnInput -> False
        ],

        (* \[HorizontalLine]\[HorizontalLine] RIGHT COLUMN: button bar \[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine] *)
        ItemBox[
          InterpretationBox[

            (* DISPLAY form (BoxData rendered in FE) *)
            GridBox[
              {{
                (*----------------------------------------------------------*)
                (* --- GREEN buttons: navigation & editing ------------------- *)
                (*----------------------------------------------------------*)
                ButtonBox[
                  StyleBox["\"Evl Cel\"",  10, FontColor -> RGBColor[0, 2/3, 0], Bold, Background -> RGBColor[0.88, 1, 0.88], StripOnInput -> False],
                  ButtonFunction :> FrontEndTokenExecute["EvaluateCells"],
                  FrameMargins -> 1, Appearance -> {"AbuttingRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                ButtonBox[
                  StyleBox["\"GTo Evl\"",  10, FontColor -> RGBColor[0, 2/3, 0], Bold, Background -> RGBColor[0.88, 1, 0.88], StripOnInput -> False],
                  ButtonFunction :> FrontEndTokenExecute["FindEvaluatingCell"],
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                ButtonBox[
                  StyleBox["\"Sel All\"",  10, FontColor -> RGBColor[0, 2/3, 0], Bold, Background -> RGBColor[0.88, 1, 0.88], StripOnInput -> False],
                  ButtonFunction :> FrontEndTokenExecute["SelectAll"],
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                ButtonBox[
                  StyleBox["\"Clo Sel\"",  10, FontColor -> RGBColor[0, 2/3, 0], Bold, Background -> RGBColor[0.88, 1, 0.88], StripOnInput -> False],
                  ButtonFunction :> FrontEndTokenExecute["SelectionCloseAllGroups"],
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                ButtonBox[
                  StyleBox["\"Opn Sel\"",  10, FontColor -> RGBColor[0, 2/3, 0], Bold, Background -> RGBColor[0.88, 1, 0.88], StripOnInput -> False],
                  ButtonFunction :> FrontEndTokenExecute["SelectionOpenAllGroups"],
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                ButtonBox[
                  StyleBox["\"Cel Grp\"",  10, FontColor -> RGBColor[0, 2/3, 0], Bold, Background -> RGBColor[0.88, 1, 0.88], StripOnInput -> False],
                  ButtonFunction :> FrontEndTokenExecute["CellGroup"],
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                ButtonBox[
                  StyleBox["\"Sav\"",      10, FontColor -> RGBColor[0, 2/3, 0], Bold, Background -> RGBColor[0.88, 1, 0.88], StripOnInput -> False],
                  ButtonFunction :> FrontEndTokenExecute["Save"],
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                (*----------------------------------------------------------*)
                (* --- BLUE buttons: back / mark navigation ------------------ *)
                (*----------------------------------------------------------*)
                ButtonBox[
                  StyleBox["\"Scan\"",     10, FontColor -> RGBColor[0, 0.4, 0.8], Bold, Background -> RGBColor[0.88, 0.94, 1], StripOnInput -> False],
                  ButtonFunction :> cellStylesScannerPalette,
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                
                ButtonBox[
                  StyleBox["\"Edit\"",     10, FontColor -> RGBColor[0, 0.4, 0.8], Bold, Background -> RGBColor[0.88, 0.94, 1], StripOnInput -> False],
                  ButtonFunction :> cellStylesEditorPalette,
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],

                ButtonBox[
                  StyleBox["\"Mark\"",     10, FontColor -> RGBColor[0, 0.4, 0.8], Bold, Background -> RGBColor[0.88, 0.94, 1], StripOnInput -> False],
                  ButtonFunction :> pushHistory[],
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                ButtonBox[
                  StyleBox["\"Back\"",     10, FontColor -> RGBColor[0, 0.4, 0.8], Bold, Background -> RGBColor[0.88, 0.94, 1], StripOnInput -> False],
                  ButtonFunction :> goBack[],
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                (*----------------------------------------------------------*)
                (* --- ORANGE buttons: evaluation control -------------------- *)
                (*----------------------------------------------------------*)
                ButtonBox[
                  StyleBox["\"Evl Ini\"",  10, FontColor -> RGBColor[1, 0.5, 0], Bold, Background -> RGBColor[1, 0.9, 0.8], StripOnInput -> False],
                  ButtonFunction :> FrontEndTokenExecute["EvaluateInitialization"],
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                ButtonBox[
                  StyleBox["\"Evl Ntb\"",  10, FontColor -> RGBColor[1, 0.5, 0], Bold, Background -> RGBColor[1, 0.9, 0.8], StripOnInput -> False],
                  ButtonFunction :> FrontEndTokenExecute["EvaluateNotebook"],
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                ButtonBox[
                  StyleBox["\"Del Out\"",  10, FontColor -> RGBColor[1, 0.5, 0], Bold, Background -> RGBColor[1, 0.9, 0.8], StripOnInput -> False],
                  ButtonFunction :> FrontEndTokenExecute["DeleteGeneratedCells"],
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                ButtonBox[
                  StyleBox["\"Cel Mrg\"",  10, FontColor -> RGBColor[1, 0.5, 0], Bold, Background -> RGBColor[1, 0.9, 0.8], StripOnInput -> False],
                  ButtonFunction :> FrontEndTokenExecute["CellMerge"],
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                (*----------------------------------------------------------*)
                (* --- RED buttons: danger zone ----------------------------- *)
                (*----------------------------------------------------------*)
                ButtonBox[
                  StyleBox["\"Abort\"",    10, FontColor -> RGBColor[1, 0, 0], Bold, Background -> RGBColor[1, 0.85, 0.85], StripOnInput -> False],
                  ButtonFunction :> FrontEndTokenExecute["EvaluatorAbort"],
                  FrameMargins -> 1, Appearance -> {"AbuttingLeftRight"}, Evaluator -> Automatic, Method -> "Preemptive"
                ],
                ButtonBox[
                  StyleBox["\"Quit\"",     10, FontColor -> RGBColor[1, 0, 0], Bold, Background -> RGBColor[1, 0.85, 0.85], StripOnInput -> False],
                  ButtonFunction :> FrontEndTokenExecute["EvaluatorQuit"],
                  FrameMargins -> 1, Appearance -> {"AbuttingLeft"}, Evaluator -> Automatic, Method -> "Preemptive"
                ]
              }},
              AutoDelete -> False,
              GridBoxItemSize -> {"Columns" -> {{Automatic}}, "Rows" -> {{Automatic}}},
              ColumnSpacings -> 0
            ],

            (* INTERPRETATION form (kernel-side ButtonBar) *)
            ButtonBar[
              {
                Style["Evl Cel",     10, FontColor -> RGBColor[0, 2/3, 0],   Bold, Background -> RGBColor[0.88, 1, 0.88]]    :> FrontEndTokenExecute["EvaluateCells"],
                Style["GTo Evl",     10, FontColor -> RGBColor[0, 2/3, 0],   Bold, Background -> RGBColor[0.88, 1, 0.88]]    :> FrontEndTokenExecute["FindEvaluatingCell"],
                Style["Sel All",     10, FontColor -> RGBColor[0, 2/3, 0],   Bold, Background -> RGBColor[0.88, 1, 0.88]]    :> FrontEndTokenExecute["SelectAll"],
                Style["Clo Sel",     10, FontColor -> RGBColor[0, 2/3, 0],   Bold, Background -> RGBColor[0.88, 1, 0.88]]    :> FrontEndTokenExecute["SelectionCloseAllGroups"],
                Style["Opn Sel",     10, FontColor -> RGBColor[0, 2/3, 0],   Bold, Background -> RGBColor[0.88, 1, 0.88]]    :> FrontEndTokenExecute["SelectionOpenAllGroups"],
                Style["Cel Grp",     10, FontColor -> RGBColor[0, 2/3, 0],   Bold, Background -> RGBColor[0.88, 1, 0.88]]    :> FrontEndTokenExecute["CellGroup"],
                Style["Sav",         10, FontColor -> RGBColor[0, 2/3, 0],   Bold, Background -> RGBColor[0.88, 1, 0.88]]    :> FrontEndTokenExecute["Save"],
                Style["Scan",        10, FontColor -> RGBColor[0, 0.4, 0.8], Bold, Background -> RGBColor[0.88, 0.94, 1]]    :> cellStylesScannerPalette,
                Style["Edit",        10, FontColor -> RGBColor[0, 0.4, 0.8], Bold, Background -> RGBColor[0.88, 0.94, 1]]    :> cellStylesEditorPalette,
                Style["Mark",        10, FontColor -> RGBColor[0, 0.4, 0.8], Bold, Background -> RGBColor[0.88, 0.94, 1]]    :> pushHistory[],
                Style["Back",        10, FontColor -> RGBColor[0, 0.4, 0.8], Bold, Background -> RGBColor[0.88, 0.94, 1]]    :> goBack[],
                Style["Evl Ini",     10, FontColor -> RGBColor[1, 0.5, 0],   Bold, Background -> RGBColor[1, 0.9, 0.8]]      :> FrontEndTokenExecute["EvaluateInitialization"],
                Style["Evl Ntb",     10, FontColor -> RGBColor[1, 0.5, 0],   Bold, Background -> RGBColor[1, 0.9, 0.8]]      :> FrontEndTokenExecute["EvaluateNotebook"],
                Style["Del Out",     10, FontColor -> RGBColor[1, 0.5, 0],   Bold, Background -> RGBColor[1, 0.9, 0.8]]      :> FrontEndTokenExecute["DeleteGeneratedCells"],
                Style["Cel Mrg",     10, FontColor -> RGBColor[1, 0.5, 0],   Bold, Background -> RGBColor[1, 0.9, 0.8]]      :> FrontEndTokenExecute["CellMerge"],
                Style["Abort",       10, FontColor -> RGBColor[1, 0, 0],     Bold, Background -> RGBColor[1, 0.85, 0.85]]    :> FrontEndTokenExecute["EvaluatorAbort"],
                Style["Quit",        10, FontColor -> RGBColor[1, 0, 0],     Bold, Background -> RGBColor[1, 0.85, 0.85]]    :> FrontEndTokenExecute["EvaluatorQuit"]
              },
              FrameMargins -> 1, Appearance -> {Automatic}
            ]

          ],  (* end InterpretationBox *)
          Alignment -> Right, StripOnInput -> False
        ]

      }},  (* end outer GridBox row *)
      AutoDelete -> False,
      GridBoxItemSize -> {"Columns" -> {Scaled[0.3], Scaled[0.7]}}
    ],

    "Grid"
  ]],  (* end TagBox / BoxData *)
  "DockedCell",
  Background -> RGBColor[1, 0.992, 0.866]
  ]

}]  (* end SetOptions *)
