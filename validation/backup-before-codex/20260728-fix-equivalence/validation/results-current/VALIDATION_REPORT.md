# Wolfram behavioural validation report

Generated: Tue 28 Jul 2026 08:42:03

Overall strict status: **FAIL**

- PASS: 1
- WARNING: 0
- FAIL: 5
- NOT RUN: 1

The strict comparison checks captured symbol definitions and assigned values. It separately compares generated Output, Message and Print cells. Automatically generated symbols ending in `$<digits>` are excluded.

| Case | Status | Original symbols | Restructured symbols | Missing | Definition differences | Value differences | Outputs identical |
|---|---:|---:|---:|---:|---:|---:|---:|
| base | **FAIL** | 482 | 477 | 95 | 0 | 3 | yes |
| physics-general | **FAIL** | 3 | 1075 | 3 | 0 | 0 | yes |
| statDataAnal | **FAIL** | 386 | 1075 | 0 | 0 | 7 | no |
| inputDataForRICH | **FAIL** | 264 | 1077 | 2 | 0 | 2 | no |
| calculator-reboot | **NOT RUN** | 0 | 0 | 0 | 0 | 0 | no |
| RICH-source | **FAIL** | 742 | 1075 | 0 | 3 | 4 | yes |
| CellStyleDataRules-source | **PASS** | 0 | 1075 | 0 | 0 | 0 | yes |

## base - FAIL

Captured symbol definitions or assigned values differ.

- Original evaluation: `Success`
- Restructured evaluation: `Success`
- Outputs: 11 original, 0 restructured; first difference: `1`
- Messages: 0 original, 0 restructured; first difference: `None`
- Prints: 6 original, 0 restructured; first difference: `1`

### Missing symbols

- `base`
- `ceiling`
- `ceilingTrim`
- `checkEqualRealNumbers`
- `cleanNum`
- `cleanText`
- `debugPrint`
- `debugPrintEnabledFlag`
- `decimals`
- `digits`
- `dropFirst`
- `edge`
- `eps`
- `epsFact`
- `epsilonQuantum`
- `errorFunction`
- `errorFunctionDemo`
- `exception`
- `exists`
- `findNotebooks`
- `fmt`
- `fmt$`
- `insertCol`
- `insertRow`
- `lookupVal`
- `matrixCore`
- `matrixInfo`
- `myNicePrint`
- `nf`
- `nf0`
- `nf1`
- `nf2`
- `nf3`
- `nf4`
- `nf5`
- `nf6`
- `nfl`
- `nfl0`
- `nfl1`
- `nfl2`
- `nfl3`
- `nfPad`
- `nfpm`
- `nfpm0`
- `nfpm1`
- `nfpm2`
- `nfpm3`
- `nfpm4`
- `nfpm5`
- `nfpm6`
- `nfpml`
- `nfpml0`
- `nfpml1`
- `nfpml2`
- `nfpml3`
- `nfpmPad`
- `niceSymbolsOrder`
- `nnff`
- `nnffpm`
- `normalizeString`
- `numCol`
- `numFormat`
- `numFormatPad`
- `numRow`
- `partialSumToEnd`
- `printa`
- `printa1`
- `prn`
- `reorderSymbols`
- `rewrite`
- `rll`
- `roundDigits`
- `searchForGivenNames`
- `searchForGivenNamesAndPrint`
- `searchForGivenNamesRegExp`
- `sll`
- `sortByColumn`
- `sortMatrixCols`
- `sortMatrixRows`
- `sumCol`
- ... and 15 more

### Different definitions

- None

### Different assigned values

- `base\`Private\`searchForGivenNamesAndPrintRegExp`
- `initialContexts`
- `myNotebookInit\`Private\`$LoadLog`

### Extra restructured symbols

- `base\`Private\`ceiling`
- `base\`Private\`ceilingTrim`
- `base\`Private\`checkEqualRealNumbers`
- `base\`Private\`cleanNum`
- `base\`Private\`cleanText`
- `base\`Private\`debugPrint`
- `base\`Private\`debugPrintEnabledFlag`
- `base\`Private\`decimals`
- `base\`Private\`digits`
- `base\`Private\`dropFirst`
- `base\`Private\`edge`
- `base\`Private\`epsFact`
- `base\`Private\`exception`
- `base\`Private\`exists`
- `base\`Private\`findNotebooks`
- `base\`Private\`fmt`
- `base\`Private\`fmt$`
- `base\`Private\`insertCol`
- `base\`Private\`insertRow`
- `base\`Private\`lookupVal`
- `base\`Private\`matrixCore`
- `base\`Private\`matrixInfo`
- `base\`Private\`myNicePrint`
- `base\`Private\`nf`
- `base\`Private\`nf0`
- `base\`Private\`nf1`
- `base\`Private\`nf2`
- `base\`Private\`nf3`
- `base\`Private\`nf4`
- `base\`Private\`nf5`
- `base\`Private\`nf6`
- `base\`Private\`nfl`
- `base\`Private\`nfl0`
- `base\`Private\`nfl1`
- `base\`Private\`nfl2`
- `base\`Private\`nfl3`
- `base\`Private\`nfPad`
- `base\`Private\`nfpm`
- `base\`Private\`nfpm0`
- `base\`Private\`nfpm1`
- `base\`Private\`nfpm2`
- `base\`Private\`nfpm3`
- `base\`Private\`nfpm4`
- `base\`Private\`nfpm5`
- `base\`Private\`nfpm6`
- `base\`Private\`nfpml`
- `base\`Private\`nfpml0`
- `base\`Private\`nfpml1`
- `base\`Private\`nfpml2`
- `base\`Private\`nfpml3`
- `base\`Private\`nfpmPad`
- `base\`Private\`niceSymbolsOrder`
- `base\`Private\`nnff`
- `base\`Private\`nnffpm`
- `base\`Private\`normalizeString`
- `base\`Private\`numCol`
- `base\`Private\`numFormat`
- `base\`Private\`numFormatPad`
- `base\`Private\`numRow`
- `base\`Private\`partialSumToEnd`
- `base\`Private\`printa`
- `base\`Private\`printa1`
- `base\`Private\`prn`
- `base\`Private\`reorderSymbols`
- `base\`Private\`rewrite`
- `base\`Private\`rll`
- `base\`Private\`roundDigits`
- `base\`Private\`searchForGivenNames`
- `base\`Private\`searchForGivenNamesAndPrint`
- `base\`Private\`searchForGivenNamesRegExp`
- `base\`Private\`sll`
- `base\`Private\`sortByColumn`
- `base\`Private\`sortMatrixCols`
- `base\`Private\`sortMatrixRows`
- `base\`Private\`sumCol`
- `base\`Private\`sumRow`
- `base\`Private\`swap`
- `base\`Private\`tableOfContents`
- `base\`Private\`takeFirstCol`
- `base\`Private\`takeFirstRow`
- ... and 10 more

## physics-general - FAIL

Captured symbol definitions or assigned values differ.

- Original evaluation: `Success`
- Restructured evaluation: `Success`
- Outputs: 0 original, 0 restructured; first difference: `None`
- Messages: 0 original, 14 restructured; first difference: `1`
- Prints: 0 original, 2 restructured; first difference: `1`

### Missing symbols

- `myNotebookInit\`cellStylesEditorPalette`
- `myNotebookInit\`cellStylesScannerPalette`
- `myNotebookInit\`loadMyFile`

### Different definitions

- None

### Different assigned values

- None

### Extra restructured symbols

- `a`
- `absSpread`
- `allDetectorResults`
- `allDetectorResultsExport`
- `allEff`
- `allEff0`
- `allRefrIndexAtWavLenMean`
- `allTheDetectorResultsExport`
- `allTheDetectorResultsExportShow`
- `allTheDetectorResultsExportShowPrint`
- `allTheEfficiencies`
- `analyticIntegratedSpectrum`
- `angleChrData`
- `angleChrData$`
- `angleChrHistoBis`
- `angleChrHistoBis$`
- `angleChrHistoOne`
- `angleChrHistoOne$`
- `angleChrHistoTer`
- `angleChrHistoTer$`
- `applySettings`
- `approxEmissionYieldEnePerMeter`
- `approxEmissionYieldEnePerMeter$`
- `availableSettings`
- `averageMirrorReflectivityFunctionEnergy`
- `averageMirrorReflectivityFunctionWavLen`
- `averagePDE`
- `averagePDE$`
- `a$`
- `b`
- `bannerLine`
- `base\`Private\`a`
- `base\`Private\`allMatchedValues`
- `base\`Private\`allMatchedValues$`
- `base\`Private\`ape`
- `base\`Private\`arg`
- `base\`Private\`args`
- `base\`Private\`b`
- `base\`Private\`cat`
- `base\`Private\`ceiling`
- `base\`Private\`ceilingTrim`
- `base\`Private\`checkEqualRealNumbers`
- `base\`Private\`cleanNum`
- `base\`Private\`cleanText`
- `base\`Private\`cnt`
- `base\`Private\`cntMax`
- `base\`Private\`d`
- `base\`Private\`dat`
- `base\`Private\`debugPrint`
- `base\`Private\`debugPrintEnabledFlag`
- `base\`Private\`debug$debugPrint`
- `base\`Private\`decimals`
- `base\`Private\`dg`
- `base\`Private\`digits`
- `base\`Private\`dir`
- `base\`Private\`divisions`
- `base\`Private\`dropFirst`
- `base\`Private\`dummySomething`
- `base\`Private\`dummySomething$`
- `base\`Private\`d$`
- `base\`Private\`edge`
- `base\`Private\`eee`
- `base\`Private\`elem`
- `base\`Private\`epsFact`
- `base\`Private\`exception`
- `base\`Private\`exists`
- `base\`Private\`exp`
- `base\`Private\`expr`
- `base\`Private\`expr$`
- `base\`Private\`f`
- `base\`Private\`f1`
- `base\`Private\`f2`
- `base\`Private\`findNotebooks`
- `base\`Private\`fmt`
- `base\`Private\`fmt$`
- `base\`Private\`headerCells`
- `base\`Private\`headerCells$`
- `base\`Private\`headerTypes`
- `base\`Private\`headerTypes$`
- `base\`Private\`i`
- ... and 995 more

## statDataAnal - FAIL

Captured symbol definitions or assigned values differ.

- Original evaluation: `Success`
- Restructured evaluation: `Success`
- Outputs: 7 original, 0 restructured; first difference: `1`
- Messages: 2 original, 14 restructured; first difference: `1`
- Prints: 4 original, 2 restructured; first difference: `1`

### Missing symbols

- None

### Different definitions

- None

### Different assigned values

- `data`
- `ests`
- `func`
- `myNotebookInit\`Private\`$LoadLog`
- `thisDataHisto`
- `title`
- `versionTAG`

### Extra restructured symbols

- `a`
- `allDetectorResults`
- `allDetectorResultsExport`
- `allEff`
- `allEff0`
- `allRefrIndexAtWavLenMean`
- `allTheDetectorResultsExport`
- `allTheDetectorResultsExportShow`
- `allTheDetectorResultsExportShowPrint`
- `allTheEfficiencies`
- `analyticIntegratedSpectrum`
- `angleChrData`
- `angleChrData$`
- `angleChrHistoBis`
- `angleChrHistoBis$`
- `angleChrHistoOne`
- `angleChrHistoOne$`
- `angleChrHistoTer`
- `angleChrHistoTer$`
- `approxEmissionYieldEnePerMeter`
- `approxEmissionYieldEnePerMeter$`
- `averageMirrorReflectivityFunctionEnergy`
- `averageMirrorReflectivityFunctionWavLen`
- `averagePDE`
- `averagePDE$`
- `a$`
- `b`
- `base\`Private\`a`
- `base\`Private\`allMatchedValues`
- `base\`Private\`allMatchedValues$`
- `base\`Private\`ape`
- `base\`Private\`arg`
- `base\`Private\`args`
- `base\`Private\`b`
- `base\`Private\`cat`
- `base\`Private\`ceiling`
- `base\`Private\`ceilingTrim`
- `base\`Private\`checkEqualRealNumbers`
- `base\`Private\`cleanNum`
- `base\`Private\`cleanText`
- `base\`Private\`cnt`
- `base\`Private\`cntMax`
- `base\`Private\`d`
- `base\`Private\`dat`
- `base\`Private\`debugPrint`
- `base\`Private\`debugPrintEnabledFlag`
- `base\`Private\`debug$debugPrint`
- `base\`Private\`decimals`
- `base\`Private\`dg`
- `base\`Private\`digits`
- `base\`Private\`dir`
- `base\`Private\`divisions`
- `base\`Private\`dropFirst`
- `base\`Private\`dummySomething`
- `base\`Private\`dummySomething$`
- `base\`Private\`d$`
- `base\`Private\`edge`
- `base\`Private\`eee`
- `base\`Private\`elem`
- `base\`Private\`epsFact`
- `base\`Private\`exception`
- `base\`Private\`exists`
- `base\`Private\`exp`
- `base\`Private\`expr`
- `base\`Private\`expr$`
- `base\`Private\`f`
- `base\`Private\`f1`
- `base\`Private\`f2`
- `base\`Private\`findNotebooks`
- `base\`Private\`fmt`
- `base\`Private\`fmt$`
- `base\`Private\`headerCells`
- `base\`Private\`headerCells$`
- `base\`Private\`headerTypes`
- `base\`Private\`headerTypes$`
- `base\`Private\`i`
- `base\`Private\`iCol`
- `base\`Private\`input`
- `base\`Private\`insertCol`
- `base\`Private\`insertRow`
- ... and 609 more

## inputDataForRICH - FAIL

Captured symbol definitions or assigned values differ.

- Original evaluation: `Success`
- Restructured evaluation: `Success`
- Outputs: 5 original, 0 restructured; first difference: `1`
- Messages: 0 original, 14 restructured; first difference: `1`
- Prints: 15 original, 2 restructured; first difference: `1`

### Missing symbols

- `rich\`goBack`
- `rich\`pushHistory`

### Different definitions

- None

### Different assigned values

- `myNotebookInit\`Private\`$LoadLog`
- `versionTAG`

### Extra restructured symbols

- `a`
- `absSpread`
- `allDetectorResults`
- `allDetectorResultsExport`
- `allEff`
- `allEff0`
- `allRefrIndexAtWavLenMean`
- `allTheDetectorResultsExport`
- `allTheDetectorResultsExportShow`
- `allTheDetectorResultsExportShowPrint`
- `allTheEfficiencies`
- `analyticIntegratedSpectrum`
- `angleChrData`
- `angleChrData$`
- `angleChrHistoBis`
- `angleChrHistoBis$`
- `angleChrHistoOne`
- `angleChrHistoOne$`
- `angleChrHistoTer`
- `angleChrHistoTer$`
- `approxEmissionYieldEnePerMeter`
- `approxEmissionYieldEnePerMeter$`
- `averageMirrorReflectivityFunctionEnergy`
- `averageMirrorReflectivityFunctionWavLen`
- `averagePDE`
- `averagePDE$`
- `a$`
- `b`
- `base\`Private\`a`
- `base\`Private\`allMatchedValues`
- `base\`Private\`allMatchedValues$`
- `base\`Private\`ape`
- `base\`Private\`arg`
- `base\`Private\`args`
- `base\`Private\`b`
- `base\`Private\`cat`
- `base\`Private\`ceiling`
- `base\`Private\`ceilingTrim`
- `base\`Private\`checkEqualRealNumbers`
- `base\`Private\`cleanNum`
- `base\`Private\`cleanText`
- `base\`Private\`cnt`
- `base\`Private\`cntMax`
- `base\`Private\`d`
- `base\`Private\`dat`
- `base\`Private\`debugPrint`
- `base\`Private\`debugPrintEnabledFlag`
- `base\`Private\`debug$debugPrint`
- `base\`Private\`decimals`
- `base\`Private\`dg`
- `base\`Private\`digits`
- `base\`Private\`dir`
- `base\`Private\`divisions`
- `base\`Private\`dropFirst`
- `base\`Private\`dummySomething`
- `base\`Private\`dummySomething$`
- `base\`Private\`d$`
- `base\`Private\`edge`
- `base\`Private\`eee`
- `base\`Private\`elem`
- `base\`Private\`epsFact`
- `base\`Private\`exception`
- `base\`Private\`exists`
- `base\`Private\`exp`
- `base\`Private\`expr`
- `base\`Private\`expr$`
- `base\`Private\`f`
- `base\`Private\`f1`
- `base\`Private\`f2`
- `base\`Private\`findNotebooks`
- `base\`Private\`fmt`
- `base\`Private\`fmt$`
- `base\`Private\`headerCells`
- `base\`Private\`headerCells$`
- `base\`Private\`headerTypes`
- `base\`Private\`headerTypes$`
- `base\`Private\`i`
- `base\`Private\`iCol`
- `base\`Private\`input`
- `base\`Private\`insertCol`
- ... and 735 more

## calculator-reboot - NOT RUN

One or both result files are missing or unreadable.

- Original evaluation: `Unknown`
- Restructured evaluation: `Unknown`
- Outputs: 0 original, 0 restructured; first difference: `None`
- Messages: 0 original, 0 restructured; first difference: `None`
- Prints: 0 original, 0 restructured; first difference: `None`

### Missing symbols

- None

### Different definitions

- None

### Different assigned values

- None

### Extra restructured symbols

- None

## RICH-source - FAIL

Captured symbol definitions or assigned values differ.

- Original evaluation: `Success`
- Restructured evaluation: `Success`
- Outputs: 0 original, 0 restructured; first difference: `None`
- Messages: 0 original, 0 restructured; first difference: `None`
- Prints: 0 original, 0 restructured; first difference: `None`

### Missing symbols

- None

### Different definitions

- `calcDetectedPhotons`
- `descriptivestatistics`
- `displayHistoStats`

### Different assigned values

- `initialContexts`
- `myNotebookInit\`Private\`$LoadLog`
- `title`
- `versionTAG`

### Extra restructured symbols

- `absSpread`
- `base\`Private\`a`
- `base\`Private\`allMatchedValues`
- `base\`Private\`allMatchedValues$`
- `base\`Private\`ape`
- `base\`Private\`arg`
- `base\`Private\`args`
- `base\`Private\`b`
- `base\`Private\`cat`
- `base\`Private\`ceiling`
- `base\`Private\`ceilingTrim`
- `base\`Private\`checkEqualRealNumbers`
- `base\`Private\`cleanNum`
- `base\`Private\`cleanText`
- `base\`Private\`cnt`
- `base\`Private\`cntMax`
- `base\`Private\`d`
- `base\`Private\`dat`
- `base\`Private\`debugPrint`
- `base\`Private\`debugPrintEnabledFlag`
- `base\`Private\`debug$debugPrint`
- `base\`Private\`decimals`
- `base\`Private\`dg`
- `base\`Private\`digits`
- `base\`Private\`dir`
- `base\`Private\`divisions`
- `base\`Private\`dropFirst`
- `base\`Private\`dummySomething`
- `base\`Private\`dummySomething$`
- `base\`Private\`d$`
- `base\`Private\`edge`
- `base\`Private\`eee`
- `base\`Private\`elem`
- `base\`Private\`epsFact`
- `base\`Private\`exception`
- `base\`Private\`exists`
- `base\`Private\`exp`
- `base\`Private\`expr`
- `base\`Private\`expr$`
- `base\`Private\`f`
- `base\`Private\`f1`
- `base\`Private\`f2`
- `base\`Private\`findNotebooks`
- `base\`Private\`fmt`
- `base\`Private\`fmt$`
- `base\`Private\`headerCells`
- `base\`Private\`headerCells$`
- `base\`Private\`headerTypes`
- `base\`Private\`headerTypes$`
- `base\`Private\`i`
- `base\`Private\`iCol`
- `base\`Private\`input`
- `base\`Private\`insertCol`
- `base\`Private\`insertRow`
- `base\`Private\`iRow`
- `base\`Private\`jdAllMatchVal`
- `base\`Private\`jdAllMatchVal$`
- `base\`Private\`jdMatchVal`
- `base\`Private\`jdMatchVal$`
- `base\`Private\`jdNumMatch`
- `base\`Private\`jdNumMatch$`
- `base\`Private\`jdRowMatch`
- `base\`Private\`jdRowMatch$`
- `base\`Private\`l`
- `base\`Private\`list`
- `base\`Private\`ll`
- `base\`Private\`lookupVal`
- `base\`Private\`low`
- `base\`Private\`l$`
- `base\`Private\`mat`
- `base\`Private\`matchVal`
- `base\`Private\`matchVal$`
- `base\`Private\`matrix`
- `base\`Private\`matrixCore`
- `base\`Private\`matrixInfo`
- `base\`Private\`messageText`
- `base\`Private\`mouse`
- `base\`Private\`myNicePrint`
- `base\`Private\`myPrint`
- `base\`Private\`n`
- ... and 253 more

## CellStyleDataRules-source - PASS

Captured symbol state matches; notebook side effects were intentionally not compared.

- Original evaluation: `Success`
- Restructured evaluation: `Success`
- Outputs: 0 original, 0 restructured; first difference: `None`
- Messages: 0 original, 0 restructured; first difference: `None`
- Prints: 4 original, 0 restructured; first difference: `1`

### Missing symbols

- None

### Different definitions

- None

### Different assigned values

- None

### Extra restructured symbols

- `a`
- `absSpread`
- `allDetectorResults`
- `allDetectorResultsExport`
- `allEff`
- `allEff0`
- `allRefrIndexAtWavLenMean`
- `allTheDetectorResultsExport`
- `allTheDetectorResultsExportShow`
- `allTheDetectorResultsExportShowPrint`
- `allTheEfficiencies`
- `analyticIntegratedSpectrum`
- `angleChrData`
- `angleChrData$`
- `angleChrHistoBis`
- `angleChrHistoBis$`
- `angleChrHistoOne`
- `angleChrHistoOne$`
- `angleChrHistoTer`
- `angleChrHistoTer$`
- `applySettings`
- `approxEmissionYieldEnePerMeter`
- `approxEmissionYieldEnePerMeter$`
- `availableSettings`
- `averageMirrorReflectivityFunctionEnergy`
- `averageMirrorReflectivityFunctionWavLen`
- `averagePDE`
- `averagePDE$`
- `a$`
- `b`
- `bannerLine`
- `base\`Private\`a`
- `base\`Private\`allMatchedValues`
- `base\`Private\`allMatchedValues$`
- `base\`Private\`ape`
- `base\`Private\`arg`
- `base\`Private\`args`
- `base\`Private\`b`
- `base\`Private\`cat`
- `base\`Private\`ceiling`
- `base\`Private\`ceilingTrim`
- `base\`Private\`checkEqualRealNumbers`
- `base\`Private\`cleanNum`
- `base\`Private\`cleanText`
- `base\`Private\`cnt`
- `base\`Private\`cntMax`
- `base\`Private\`d`
- `base\`Private\`dat`
- `base\`Private\`debugPrint`
- `base\`Private\`debugPrintEnabledFlag`
- `base\`Private\`debug$debugPrint`
- `base\`Private\`decimals`
- `base\`Private\`dg`
- `base\`Private\`digits`
- `base\`Private\`dir`
- `base\`Private\`divisions`
- `base\`Private\`dropFirst`
- `base\`Private\`dummySomething`
- `base\`Private\`dummySomething$`
- `base\`Private\`d$`
- `base\`Private\`edge`
- `base\`Private\`eee`
- `base\`Private\`elem`
- `base\`Private\`epsFact`
- `base\`Private\`exception`
- `base\`Private\`exists`
- `base\`Private\`exp`
- `base\`Private\`expr`
- `base\`Private\`expr$`
- `base\`Private\`f`
- `base\`Private\`f1`
- `base\`Private\`f2`
- `base\`Private\`findNotebooks`
- `base\`Private\`fmt`
- `base\`Private\`fmt$`
- `base\`Private\`headerCells`
- `base\`Private\`headerCells$`
- `base\`Private\`headerTypes`
- `base\`Private\`headerTypes$`
- `base\`Private\`i`
- ... and 995 more
