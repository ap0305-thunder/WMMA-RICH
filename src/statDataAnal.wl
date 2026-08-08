(* ::Package:: *)

(* ::Text:: *)
(*This package/notebook defines tools for statistical data analysis.*)


(* ::Input::Initialization:: *)
checkNewCreatedSymbols[]


(* ::Input::Initialization:: *)
(*$NewSymbol=Print["New symbol: ",#2,#1]&*)


(* ::Title:: *)
(*SETUP*)


(* ::Input::Initialization:: *)
Print["*==================================================================================================*"];
Print["*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*"];
Print["***--- statDataAnal ---***"];
Print["*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*"];
Print["*==================================================================================================*"];


(* ::Title:: *)
(*statDataAnal*)


(* ::Subtitle::Initialization:: *)
(*INITIALIZATION*)


(* ::Input::Initialization:: *)
(*Once[*)
If[
  ! TrueQ[Global`$RICHProjectManagedLoad],
  myNotebookInit`loadMyFile[
    "CellStyleDataRules.wl",
    DirectoryName[$InputFileName]
  ]
]
(*,"Notebook"]*)


(* ::Input::Initialization:: *)

showContextInfo[]
(**)
BeginPackage["statDataAnal`",{"myNotebookInit`","base`"}]
(**)
Print[" loading statDataAnal "]
(**)
absSpread::usage =
  "absSpread[data] returns Max[data] - Min[data].";
relSpread::usage =
  "relSpread[data] returns the absolute spread divided by Median[data].";
standardErrorOfSampleMedian::usage =
  "standardErrorOfSampleMedian[data] estimates the sample median error.";
sampleSkewness::usage =
  "sampleSkewness[data] returns the bias-corrected sample skewness.";
standardErrorOfSampleSkewness::usage =
  "standardErrorOfSampleSkewness[data] estimates the sample skewness error.";
sampleKurtosis::usage =
  "sampleKurtosis[data] returns the sample kurtosis.";
standardErrorOfSampleKurtosis::usage =
  "standardErrorOfSampleKurtosis[data] estimates the sample kurtosis error.";
errSquarSum::usage =
  "errSquarSum[data] returns the square root of the sum of squares.";
sumInQuadr::usage =
  "sumInQuadr[values] returns the values added in quadrature.";
descriptiveStatistics::usage =
  "descriptiveStatistics[data] returns the package statistics summary.";
descriptivestatistics::usage =
  "descriptivestatistics[data] is the legacy spelling of descriptiveStatistics.";
descriptiveStatisticsSimpleHisto::usage =
  "descriptiveStatisticsSimpleHisto[data] builds the histogram statistics panel.";
simpleHistogramWithStatistics::usage =
  "simpleHistogramWithStatistics[data] builds a histogram and statistics grid.";
displayHistoStats::usage =
  "displayHistoStats[data, ...] displays detailed statistics and a histogram.";
bootstrap::usage =
  "bootstrap[data, count, function] estimates a statistic by resampling.";
bigBannerHisto::usage =
  "bigBannerHisto[message] prints the statistics banner.";
statsDisplay::usage =
  "statsDisplay[data, ...] is the legacy detailed statistics display.";
errorProp::usage =
  "errorProp[expression, variables] performs first-order error propagation.";

thisDataHisto::usage =
  "thisDataHisto contains the data used by the legacy dynamic statistics values.";
hdr::usage =
  "hdr contains the column headings used by descriptive statistics displays.";
tds::usage =
  "tds is the formatted statistics vector for thisDataHisto.";
ltxt::usage =
  "ltxt is the legacy formatted statistics label vector.";
lgd::usage =
  "lgd is the legacy statistics legend.";
tdsFn::usage =
  "tdsFn[data] returns the formatted statistics vector for data.";
ltxtFn::usage =
  "ltxtFn[data] returns formatted statistics labels for data.";
lgdFn::usage =
  "lgdFn[data] returns the statistics legend for data.";

Begin["`Private`"]; (* Begin Private Context *)
(**)


(* ::Input::Initialization:: *)



(* ::Subtitle::Initialization:: *)
(*PROBABILITY AND STATISTICS FUNCTIONS*)


(* ::Input::Initialization:: *)
Clear[absSpread,relSpread];
absSpread[z_]:=Max[z]-Min[z];
relSpread[z_]:=(Max[z]-Min[z])/Median[z];
(**)


(* ::Input::Initialization:: *)
(* Only for normal distribution *)
Clear[standardErrorOfSampleMedian];
standardErrorOfSampleMedian[list_]:=Module[{num,result},
num=Length[list];
If[num>0,
result=Sqrt[Pi/2]*(StandardDeviation[list]/Sqrt[num])
];
Return[N[result]]
];


(* ::Input::Initialization:: *)
(*https://www.itl.nist.gov/div898/handbook/eda/section3/eda35b.htm*)
Clear[sampleSkewness];
sampleSkewness[list_]:=Module[{num,result},
num=Length[list];
result=Skewness[list];
Return[N[result]]
];
(**)


(* ::Input::Initialization:: *)
(*https://www.itl.nist.gov/div898/handbook/eda/section3/eda35b.htm*)
(* Only for normal distribution *)
Clear[standardErrorOfSampleSkewness];
standardErrorOfSampleSkewness[list_]:=Module[{num,result},
num=Length[list];
If[num>2,
result=Sqrt[((6*num*(num-1))/((num-2)*(num+1)*(num+3)))]
];
Return[N[result]]
];
(**)


(* ::Input::Initialization:: *)
(*https://www.itl.nist.gov/div898/handbook/eda/section3/eda35b.htm*)
Clear[sampleKurtosis];
sampleKurtosis[list_]:=Module[{num,result},
num=Length[list];
result=Kurtosis[list];
Return[N[result]]
];
(**)


(* ::Input::Initialization:: *)
(*https://www.itl.nist.gov/div898/handbook/eda/section3/eda35b.htm*)
(* Only for normal distribution *)
Clear[standardErrorOfSampleKurtosis];
standardErrorOfSampleKurtosis[list_]:=Module[{num,result},
num=Length[list];
If[num>3,
result=Sqrt[((24*num*(num-1)^2)/((num-3)*(num-2)*(num+3)*(num+5)))]
];
Return[N[result]]
];
(**)


(* ::Input::Initialization:: *)
ClearAll[errSquarSum];
errSquarSum[x_List]:=Sqrt@Total[Map[#^2&,x]];
ClearAll[sumInQuadr];
sumInQuadr[x__]:=Sqrt[Total[Map[#^2&,x]]];


(* ::Input::Initialization:: *)
(**)
(**************************************************************************************************)
(* NEW Statistics Palette *)
(**************************************************************************************************)
Unprotect[descriptiveStatistics,descriptivestatistics,tds,ltxt,lgd,descriptiveStatisticsSimpleHisto,simpleHistogramWithStatistics,tdsFn,ltxtFn,lgdFn];
ClearAll[thisDataHisto,descriptiveStatistics,descriptivestatistics,tds,ltxt,lgd,descriptiveStatisticsSimpleHisto,simpleHistogramWithStatistics,tdsFn,ltxtFn,lgdFn];

thisDataHisto=RandomReal[{0,1},1000];  (*default test data,unchanged*)

hdr={"   #  ","  Min ","  Max "," Mean ","Median","StdDev","Skewn.","Kurto."};

(*\[HorizontalLine]\[HorizontalLine] new canonical function \[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]*)
descriptiveStatistics[data_]:=Module[{sss},sss=StandardDeviation[data];
{Length[data],Min[data],Max[data],Mean[data],Median[data],sss,If[sss>0,Skewness[data],-1],If[sss>0,Kurtosis[data],-1]}];

(*\[HorizontalLine]\[HorizontalLine] back-compat alias \[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]*)
descriptivestatistics[data_]:=descriptiveStatistics[data];

(*unchanged from original\[LongDash]OwnValues,back-compat preserved*)
tds:=ToString@PaddedForm[#,{5,3}]&/@descriptiveStatistics[thisDataHisto];
ltxt:=StringJoin[hdr[[#]],":",tds[[#]]]&/@Range[Length[hdr]];
lgd:=Text[Style[ltxt[[#]],Bold,FontFamily->"Courier"],Scaled[{0.9,1-0.04#}],{0,0}]&/@Range[Length[hdr]];

(*new parametric versions\[LongDash]different names,no clash*)
tdsFn[data_]:=ToString@PaddedForm[#,{5,3}]&/@descriptiveStatistics[data];
ltxtFn[data_]:=StringJoin[hdr[[#]],":",tdsFn[data][[#]]]&/@Range[Length[hdr]];
lgdFn[data_]:=Text[Style[ltxtFn[data][[#]],Bold,FontFamily->"Courier"],Scaled[{0.9,1-0.04#}],{0,0}]&/@Range[Length[hdr]];


(*\[HorizontalLine]\[HorizontalLine] unchanged \[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]\[HorizontalLine]*)
descriptiveStatisticsSimpleHisto[data_]:={Panel@Grid@Transpose@{{"Min","Max","Mean","Median","StdDev","Skew","Kurt"},
Module[{sss=StandardDeviation[data]},
z=N@Flatten[data];
If[!VectorQ[z,NumericQ]||Length[z]==0,Return[$Failed]];
{Min[z],Max[z],Mean[z],Median[z],sss,If[sss>0,Skewness[z],-1],If[sss>0,Kurtosis[z],-1]}
]
}
};

simpleHistogramWithStatistics[data_]:=GraphicsGrid[{{Histogram[data,ImageSize->Medium],descriptiveStatisticsSimpleHisto@data}}];

Protect[descriptiveStatistics,descriptivestatistics,tds,ltxt,lgd,descriptiveStatisticsSimpleHisto,simpleHistogramWithStatistics,tdsFn,ltxtFn,lgdFn];


(* ::Input::Initialization:: *)
(*==================================================================================================*)
(* NEWER than statsdisplay *)
(*==================================================================================================*)
(**************************************************************************************************)
(* displayHistoStats *)
(**************************************************************************************************)
(* Beware: default bspec and hspec do not work, forse boh.... *)
Unprotect[displayHistoStats];
ClearAll[displayHistoStats];
Options[displayHistoStats]={"BootstrapSamples"->1000,"RandomSeed"->Automatic};
displayHistoStats[z0_,
bspec:(_Integer|_List|Automatic):10,hspec_String:"Probability",optsDisplayHistoStats:OptionsPattern[{displayHistoStats,Histogram}]
]:=
Module[{z,num,nBootstrap,\[Mu],\[Sigma],med,cm4,ske,kur,medDev,
sigmaMean=-1,sigmaSigm=-1,sigmaStdDev=-1,sigmaMedian=-1,sigmaSkewness=-1,sigmaKurtosis=-1,plot$local},
(**)
nBootstrap=OptionValue["BootstrapSamples"];

miniBanner[" Histogram statistics summary --- !!! Assume at least 5 data elements OR die !!! "];
nBootstrap=1000;

z=N@Flatten[z0];(* Make z float !!! *)
num=Length[z];
(**)
If[num<=4,Print[" !@#$% displayHistoStats : # of data = ",num,"  ... too few data // Return "];Return[$Failed]];
(**)
\[Mu]=Mean[z];
\[Sigma]=StandardDeviation[z];
med=Median[z];
medDev=MedianDeviation[z];
cm4=CentralMoment[z,4];
sigmaMean=\[Sigma]/Sqrt[num];
ske=sampleSkewness[z];
kur=sampleKurtosis[z];
(**)
If[\[Sigma]<=0,Print[" !@#$% displayHistoStats : non positive \[Sigma] = ",\[Sigma],"  // Return "];Return[$Failed]];
(**)
(* this is derived from the exact for variance with propagation // for ANY distribution *)
sigmaSigm=Sqrt[(1/(4*num*\[Sigma]^2))*(cm4-((num-3)/(num-1))*\[Sigma]^4)];
sigmaMedian=bootstrap[z,nBootstrap,Median];
sigmaStdDev=bootstrap[z,nBootstrap,StandardDeviation];
sigmaSkewness=bootstrap[z,nBootstrap,Skewness];
sigmaKurtosis=bootstrap[z,nBootstrap,Kurtosis];
(**)
Print[" Number of data        = ",num];
Print[" Mean                  = ",nfpm5[\[Mu]]," \[PlusMinus]",nfpm5[sigmaMean]];
Print[" StDv                  = ",nfpm5[\[Sigma]]," \[PlusMinus]",nfpm5[sigmaSigm]];
If[\[Sigma]>0 ,
Print[" Min                   = ",nfpm5[Min[z]]];
Print[" Max                   = ",nfpm5[Max[z]]];
Print[" Range                 = ",nfpm5[Max[z]-Min[z]]];
Print[" MedianDeviation       = ",nfpm5[medDev]];
Print[" Median                = ",nfpm5[med]," \[PlusMinus]",nfpm5[standardErrorOfSampleMedian[z]]," (gaussian hypothesis)"];
Print["                 Bootstrap median std error     = ",nfpm5[sigmaMedian]];
Print[" StandardDeviation     = ",nfpm5[\[Sigma]]," \[PlusMinus]",nfpm5[sigmaSigm]," (propagated from exact for variance)"];
Print["                 Bootstrap StandardDeviation std error     = ",nfpm5[sigmaStdDev]];
Print[" Skewness (naive)      = ",nfpm5[ske]," \[PlusMinus]",nfpm5[standardErrorOfSampleSkewness[z]]," (gaussian hypothesis)"];
Print["                 Bootstrap skewness std error   = ",nfpm5[sigmaSkewness]];
Print[" Kurtosis (naive)      = ",nfpm5[kur]," \[PlusMinus]",nfpm5[standardErrorOfSampleKurtosis[z]]," (gaussian hypothesis)"];
Print["                 Bootstrap kurtosis std error   = ",nfpm5[sigmaKurtosis]];
(**)
plot$local=Histogram[z,bspec,hspec,
Sequence@@FilterRules[{optsDisplayHistoStats},Options[Histogram]],
Epilog->lgdFn[z]];
Print[plot$local];
miniBanner["{num, \[Mu], \[Sigma], skew, kurt , sigmaMean, sigmaSigm, sigmaSkew, sigmaKurt, med, medDev}"];
          Return[{plot$local,
{num,\[Mu],\[Sigma],ske,kur,  sigmaMean,  sigmaSigm  ,standardErrorOfSampleSkewness[z], standardErrorOfSampleKurtosis[z],med,medDev}
}];
]
];
Protect[displayHistoStats];
(**)


(* ::Input::Initialization:: *)
data={7.05,2.49,16.09,21.3,19.21,14.88,16.41,0.19,9.71,10.18,8.81,2.93,18.11,22.2,9.79,14.74,4.54,16.76,8.46,24.9};
Print[TableForm[{hdr,descriptivestatistics[data]},TableAlignments->Center]];
(**)
ClearAll[bootstrap];
bootstrap[data_,numSamples_,func__]:=Module[{ests,qBootstrapResult},
ests=Table[func[RandomChoice[data,Length[data]]],{numSamples}];
(*Print[Histogram[ests]];*)
qBootstrapResult={Mean[ests],StandardDeviation[ests]};
Return[qBootstrapResult]
];


(* ::Input::Initialization:: *)
(* APPLICATION *)
(* BOOTSTRAP fit parameters *)
numSim=1000;
numBoo=100;
(*Subscript[\[Alpha], 0]=.;Subscript[\[Beta], 0]=.;*)
Mean[GammaDistribution[Subscript[\[Alpha], 0],Subscript[\[Beta], 0]]]
Subscript[\[Alpha], 0]=2;
Subscript[\[Beta], 0]=30;
Plot[PDF[GammaDistribution[Subscript[\[Alpha], 0],Subscript[\[Beta], 0]],x],{x,0,Quantile[GammaDistribution[Subscript[\[Alpha], 0],Subscript[\[Beta], 0]],0.9]}]
gdata=BlockRandom[SeedRandom[1];RandomVariate[GammaDistribution[Subscript[\[Alpha], 0],Subscript[\[Beta], 0]],numSim]];
Histogram[gdata]
(*FindDistributionParameters[gdata,GammaDistribution[\[Alpha],\[Beta]]];*)
(*FindDistributionParameters[RandomChoice[gdata,Length[gdata]],GammaDistribution[\[Alpha],\[Beta]]];*)
params:={\[Alpha],\[Beta]}/.FindDistributionParameters[RandomChoice[gdata,Length[gdata]],GammaDistribution[\[Alpha],\[Beta]]]
ests=Table[params,{numBoo}]
Map[Histogram,Transpose[ests]]
Correlation[ests]//MatrixForm



(* ::Input::Initialization:: *)
bigBannerHisto[w__:""]:=Module[{},
(*Print[" \n\n\n "];*)
Print["*==================================================================================================*"];
Print["*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*"];
       Print["***\n",w,"\n ***"];
Print["*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*"];
       Print["*==================================================================================================*"];
];


(* ::Input::Initialization:: *)
(*==================================================================================================*)
(*OLD*)
(*==================================================================================================*)
Clear@statsDisplay;
statsDisplay[z0_,showOut_:True,nBootstrap_:0,nBins_:100,title_:""]:=Module[
{num,cm1,cm2,cm3,cm4,z,sigmaMedian,sigmaSkewness,sigmaKurtosis,nf,\[Mu],\[Sigma],sigmaMean,sigmaSigma},
nf[z_]:=PaddedForm[N[z], {10,6}];
num=Length[z0];
If[num<=3,
Print[" ERROR : only ******* ",num," ******* data: too few for all statistics here"];Return[]
];
z = N[z0];(* Make z Real !!! *)
\[Mu]=cm1=Mean[z];
\[Sigma]=cm2=StandardDeviation[z];
cm3=CentralMoment[z,3];
cm4=CentralMoment[z,4];
sigmaMean=\[Sigma]/\[Sqrt]num;
sigmaSigma=\[Sqrt]((1/(4*num*\[Sigma]^2))*(cm4-((num-3)/(num-1))\[Sigma]^4 ));
If[nBootstrap>0,
sigmaMedian=bootstrap[z,nBootstrap,Median];
sigmaSkewness=bootstrap[z,nBootstrap,Skewness];
sigmaKurtosis=bootstrap[z,nBootstrap,Kurtosis]
,
sigmaMedian=-1;
sigmaSkewness=-1;
sigmaKurtosis=-1
];
If[showOut==True
,
miniBanner[" Histogram statistics summary --- !!! Assume at least 5 data elements OR die !!! "];
Print[" Stats :  # f data  =   ",num];
Print[" Stats :  Mean      = ",nf[\[Mu]]," \[PlusMinus] ",nf[sigmaMean]];
Print[" Stats :  StdDev    = ",nf[\[Sigma]]," \[PlusMinus] ",nf[sigmaSigma]];
Print[" Stats :  Var       = ",nf[\[Sigma]^2]," \[PlusMinus] ",nf[2*\[Sigma]*sigmaSigma]];
Print[" Stats :  Min       = ",nf[Min[z]]];
Print[" Stats :  Max       = ",nf[Max[z]]];
Print[" Stats :  Range     = ",nf[Max[z]-Min[z]]];
Print[" Stats :  Sq. RMS   = ",nf[(Max[z]-Min[z])/Sqrt[12]]];
Print[" Stats :  median    = ",nf[Median[z]]," \[PlusMinus]",nf[standardErrorOfSampleMedian[z]]," (gaussian hypothesis)"];
If[nBootstrap>0,Print["                 Bootstrap median StdErr     =",nf[sigmaMedian]]];
Print[" Stats :  skewness (naive)      = ",nf[sampleSkewness[z]]," \[PlusMinus]",nf[standardErrorOfSampleSkewness[z]]," (gaussian hypothesis)"];If[nBootstrap>0,Print["                 Bootstrap skewness StdErr   =",nf[sigmaSkewness]]];Print[" Stats :  kurtosis (naive)      = ",nf[sampleKurtosis[z]]," \[PlusMinus]",nf[standardErrorOfSampleKurtosis[z]]," (gaussian hypothesis)"];If[nBootstrap>0,Print["                 Bootstrap kurtosis StdErr   =",nf[sigmaKurtosis]]]
];
Show[Histogram[Flatten[z],nBins,PlotLabel->title]]
];


(* ::Subsection::Initialization:: *)
(*error propagation formulas*)


(* ::Input::Initialization:: *)
Manipulate[varlist=ToExpression[variables];
funct=ToExpression[function];
errorFunction[variables,function],{variables,"{M,m}"},{function,"g*(M-m)/(M+m)"},LabelStyle->{FontSize->17},AutoAction->False,Initialization:>(errorFunction[v_,theFunc_]:=(varlist=ToExpression[v];
funct=ToExpression[theFunc];
varlength=Length[Variables[varlist]];
theoretical=Sqrt[(Total[Table[(D[funct,Part[varlist,n]]*Subscript[U,Part[varlist,n]])^2,{n,1,varlength}]])];
Part[theoretical,1];
varlist;
uncert=Table[Subscript[U,Part[varlist,n]],{n,1,varlength}];
uncert=DeleteCases[uncert,Alternatives@@{0}];
theoretical=Simplify[theoretical];
Column[{Row[{Grid[{{"Variables",varlist},{"Uncertainties",uncert},{"Function",function},{"Uncertainty Function",theoretical}},Alignment->Left,Spacings->{2,1},Frame->All,ItemStyle->{"Text",FontSize->20},Background->{{LightGray,None}}]}],Row[{Grid[{{"Brian Gennow  March/24/2015"}},Alignment->Left,Spacings->{2,1},ItemStyle->"Text",Background->{{None}}]}]}]))]


(* ::Input::Initialization:: *)
ClearAll[errorProp];
errorProp[func_,vars_]:=Module[{derivs=Table[0,{Length[vars]}],funcErrorForm,funcEval,funcErrorEval,rplcVals,rplcErrors},
(*For[
ii=1,ii<=Length[vars],ii++,derivs[[ii]]=D[func,vars[[ii,1]]];
];*)
Table[
derivs[[ii]]=D[func,vars[[ii,1]]],{ii,1,Length[vars]}
];
funcErrorForm=Sqrt[Sum[(derivs[[ii]]*vars[[ii,3]])^2,{ii,Length[vars]}]];
SetAttributes[rplcVals,Listable];
rplcVals=Table[Evaluate[vars[[ii,1]]]:>Evaluate[vars[[ii,2]]],{ii,Length[vars]}];
SetAttributes[rplcErrors,Listable];
rplcErrors=Table[Evaluate[vars[[ii,3]]]:>Evaluate[vars[[ii,4]]],{ii,Length[vars]}];
funcEval=func/. rplcVals;
funcErrorEval=funcErrorForm/. rplcVals/. rplcErrors;
Return[{funcErrorForm,funcEval,funcErrorEval}];];


(* ::Input::Initialization:: *)
(*Module[{dx,dy,x,y},
ClearAll[test];
test=Exp[Sqrt[1/y]-x/y];
errorProp[test,{{x,0.3,dx,0.005},{y,0.9,dy,0.1}}]
]*)


(* ::Subtitle::Initialization:: *)
(*END*)


(* ::Input::Initialization:: *)
End[]; (* End Private Context *)

EndPackage[]


(* ::Input::Initialization:: *)
checkNewCreatedSymbols[]


(* ::Input::Initialization:: *)
endEvalPrintOut[];
