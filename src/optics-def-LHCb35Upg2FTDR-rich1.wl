(* ::Package:: *)

(* ::Input::Initialization:: *)
(*--------------------------------------------------------------------------------------------------------*)
bigBanner[" loading optics : "<>ToString[whichOptics]<>" for RICH : "<>ToString[iRICH]];
(*--------------------------------------------------------------------------------------------------------*)
doResetAllVariables[]; 
setExternalParameters[];

(**)
If[(whichOptics=="LHCb35Upg2FTDR")&&(iRICH==1),
miniBanner["TO BE WRITTEN"]
];
