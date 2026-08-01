# Codex validation work record

Completed: 2026-07-28

## Safeguards

- Treated the workspace as an ordinary local folder; no Git commands were used.
- Created pre-edit backups under
  `validation/backup-before-codex/20260727-start/validation/`.
- Did not write to the project `legacy-original/` tree. Its newest file timestamp
  remains `2026-07-26T20:23:26`, before this work began.
- Temporary validation-only dependencies were staged only inside the disposable
  copy under `%TEMP%\WolframRICHValidation-c1f6954141a04a4983d0d6bccbc8639c`.

## Validation result

Overall strict status: **FAIL**

| Case | Status | Original symbols | Restructured symbols | Missing | Definition differences | Value differences | Outputs identical |
|---|---:|---:|---:|---:|---:|---:|---:|
| base | FAIL | 482 | 477 | 95 | 0 | 3 | yes |
| physics-general | FAIL | 3 | 1075 | 3 | 0 | 0 | yes |
| statDataAnal | FAIL | 386 | 1075 | 0 | 0 | 7 | no |
| inputDataForRICH | FAIL | 264 | 1077 | 2 | 0 | 2 | no |
| calculator-reboot | NOT RUN | 0 | 0 | 0 | 0 | 0 | no |
| RICH-source | FAIL | 742 | 1075 | 0 | 3 | 4 | yes |
| CellStyleDataRules-source | PASS | 0 | 1075 | 0 | 0 | 0 | yes |

Completed-case totals are 1,877 original symbol captures and 5,854
restructured symbol captures. These are sums of per-case captures, not unique
project-wide symbol counts; loader cases intentionally capture overlapping
state.

Source regeneration succeeded for all seven notebook-derived files:

| Source | Selected initialization cells | Imported held expressions | Parsed source expressions |
|---|---:|---:|---:|
| CellStyleDataRules.wl | 9 | 9 | 20 |
| base.wl | 69 | 69 | 140 |
| physics-general.wl | 16 | 16 | 34 |
| statDataAnal.wl | 25 | 25 | 52 |
| inputDataForRICH.wl | 112 | 112 | 226 |
| calculator-reboot.wl | 38 | 38 | 78 |
| RICH.wl | 62 | 62 | 126 |

## Remaining genuine differences

- `base`: 95 original symbols are absent under their original unqualified names.
  The regenerated package creates the corresponding definitions principally in
  `base\`Private\``. Assigned values differ for
  `base\`Private\`searchForGivenNamesAndPrintRegExp`, `initialContexts`, and
  `myNotebookInit\`Private\`$LoadLog`.
- `physics-general`: the restructured loader initializes the full project state
  (1,075 symbols) while the original captures only 3. The original-only symbols
  are `myNotebookInit\`cellStylesEditorPalette`,
  `myNotebookInit\`cellStylesScannerPalette`, and
  `myNotebookInit\`loadMyFile`. Restructured evaluation also emits 14 messages
  and 2 prints where the original emits none.
- `statDataAnal`: assigned values differ for `data`, `ests`, `func`,
  `myNotebookInit\`Private\`$LoadLog`, `thisDataHisto`, `title`, and
  `versionTAG`; notebook outputs/messages/prints also differ.
- `inputDataForRICH`: original-only `rich\`goBack` and `rich\`pushHistory`;
  assigned values differ for `myNotebookInit\`Private\`$LoadLog` and
  `versionTAG`; notebook outputs/messages/prints also differ.
- `calculator-reboot`: the original notebook eventually produced an artifact
  only after approximately 43,769 seconds. The restructured notebook was
  terminated after the documented five-minute ceiling, so there is no paired
  readable result and no valid symbol comparison.
- `RICH-source`: definitions differ for `calcDetectedPhotons`,
  `descriptivestatistics`, and `displayHistoStats`; assigned values differ for
  `initialContexts`, `myNotebookInit\`Private\`$LoadLog`, `title`, and
  `versionTAG`.
- `CellStyleDataRules-source`: captured original state matches; notebook side
  effects were intentionally excluded by configuration.

## Files changed and reasons

Permanent hand-edited files:

- `validation/RegenerateSources.wls` — distinguish whole-cell import failure
  from a literal `$Failed` inside held notebook code; serialize multi-argument
  `HoldComplete` results as explicit `CompoundExpression[...]` using FullForm
  output so regenerated source is syntactically unambiguous.
- `validation/V11_NOTES.md` — document the corrected held FullForm serializer
  and clarify why parsed-expression counts can exceed selected-cell counts.
- `validation/CODEX_WORK_RECORD.md` — record safeguards, results, differences,
  changed files, and commands.

Diagnostic files created:

- `validation/codex-base-run.stdout.log`
- `validation/codex-base-run.stderr.log`

Pre-edit backups created:

- `validation/backup-before-codex/20260727-start/validation/RegenerateSources.wls`
- `validation/backup-before-codex/20260727-start/validation/V11_NOTES.md`
- `validation/backup-before-codex/20260727-start/validation/results-current/`

Intermediate result sets were preserved rather than deleted:

- `validation/results/archive/20260727-194408/`
- `validation/results/archive/20260727-194433/`
- `validation/results/archive/20260727-194513/`
- `validation/results/archive/20260727-194546/`
- `validation/results/archive/20260727-195356/`
- `validation/results/archive/20260728-084203-codex-pre-final/`

The final generated result set contains these 53 files:

- `validation/results/current/VALIDATION_REPORT.md`
- `validation/results/current/comparison.json`
- `validation/results/current/manual-all-cases.log`
- `validation/results/current/manual-base-rerun.log`
- `validation/results/current/manual-comparison.log`
- `validation/results/current/manual-remaining-cases.log`
- `validation/results/current/manual-source-regeneration.log`
- `validation/results/current/raw/original/base.json`
- `validation/results/current/raw/original/base.wxf`
- `validation/results/current/raw/original/calculator-reboot.json`
- `validation/results/current/raw/original/calculator-reboot.wxf`
- `validation/results/current/raw/original/CellStyleDataRules-source.json`
- `validation/results/current/raw/original/CellStyleDataRules-source.wxf`
- `validation/results/current/raw/original/inputDataForRICH.json`
- `validation/results/current/raw/original/inputDataForRICH.wxf`
- `validation/results/current/raw/original/physics-general.json`
- `validation/results/current/raw/original/physics-general.wxf`
- `validation/results/current/raw/original/RICH-source.json`
- `validation/results/current/raw/original/RICH-source.wxf`
- `validation/results/current/raw/original/statDataAnal.json`
- `validation/results/current/raw/original/statDataAnal.wxf`
- `validation/results/current/raw/restructured/base.json`
- `validation/results/current/raw/restructured/base.wxf`
- `validation/results/current/raw/restructured/CellStyleDataRules-source.json`
- `validation/results/current/raw/restructured/CellStyleDataRules-source.wxf`
- `validation/results/current/raw/restructured/inputDataForRICH.json`
- `validation/results/current/raw/restructured/inputDataForRICH.wxf`
- `validation/results/current/raw/restructured/physics-general.json`
- `validation/results/current/raw/restructured/physics-general.wxf`
- `validation/results/current/raw/restructured/RICH-source.json`
- `validation/results/current/raw/restructured/RICH-source.wxf`
- `validation/results/current/raw/restructured/statDataAnal.json`
- `validation/results/current/raw/restructured/statDataAnal.wxf`
- `validation/results/current/evaluated-notebooks/original/base.m`
- `validation/results/current/evaluated-notebooks/original/base.nb`
- `validation/results/current/evaluated-notebooks/original/calculator-reboot.m`
- `validation/results/current/evaluated-notebooks/original/calculator-reboot.nb`
- `validation/results/current/evaluated-notebooks/original/CellStyleDataRules-source.m`
- `validation/results/current/evaluated-notebooks/original/CellStyleDataRules-source.nb`
- `validation/results/current/evaluated-notebooks/original/inputDataForRICH.m`
- `validation/results/current/evaluated-notebooks/original/inputDataForRICH.nb`
- `validation/results/current/evaluated-notebooks/original/physics-general.m`
- `validation/results/current/evaluated-notebooks/original/physics-general.nb`
- `validation/results/current/evaluated-notebooks/original/RICH-source.m`
- `validation/results/current/evaluated-notebooks/original/RICH-source.nb`
- `validation/results/current/evaluated-notebooks/original/statDataAnal.m`
- `validation/results/current/evaluated-notebooks/original/statDataAnal.nb`
- `validation/results/current/evaluated-notebooks/restructured/inputDataForRICH.m`
- `validation/results/current/evaluated-notebooks/restructured/inputDataForRICH.nb`
- `validation/results/current/evaluated-notebooks/restructured/physics-general.m`
- `validation/results/current/evaluated-notebooks/restructured/physics-general.nb`
- `validation/results/current/evaluated-notebooks/restructured/statDataAnal.m`
- `validation/results/current/evaluated-notebooks/restructured/statDataAnal.nb`

## Commands run

Material commands and command families used:

1. Read-only inventory and inspection:
   `Get-ChildItem`, `rg --files`, `rg -n`, `Get-Content`, `Select-String`,
   `Get-Item`, and `Get-Process`.
2. Backups and integrity checks:
   `New-Item`, `Copy-Item`, `Get-FileHash`, and `Compare-Object`.
3. Initial launcher attempts:
   `.\validation\RunValidation.ps1 -Cases base ...` and
   `powershell.exe -ExecutionPolicy Bypass -File
   .\validation\RunValidation.ps1 ...`.
4. Wolfram diagnostics:
   `wolfram.exe -noprompt -run ...` to verify FullForm/OutputForm
   serialization behavior.
5. Isolated source regeneration:
   `wolfram.exe -script validation\RegenerateSources.wls
   <temporary-project> <case-list>`.
6. Clean per-case evaluation:
   `wolfram.exe -script validation\RunNotebookCase.wls
   <temporary-project> <original|restructured> <case>`.
7. Aggregate comparison:
   `wolfram.exe -script validation\CompareBaselines.wls
   <temporary-project> <case-list>`.
8. Background orchestration and monitoring:
   WMI `Win32_Process.Create`, hidden `cmd.exe` chains, `Start-Sleep`,
   `Get-Process`, and log-tail `Get-Content`.
9. Timeout enforcement:
   `Stop-Process -Id 32180,21680,17396,45984,40096 -Force` for the
   restructured calculator process tree after five minutes.
10. Result installation:
    verified destination paths, archived the intermediate `current` directory
    with `Move-Item`, recreated it with `New-Item`, and installed the isolated
    results with `Copy-Item`.

No Git command and no write command targeting the project `legacy-original/`
directory was run.

## Concise change report

The validation harness could not previously regenerate valid source for all
notebooks because it confused literal `$Failed` code with import failures and
serialized multi-argument held cells ambiguously. The generator now preserves
those cells as unambiguous held FullForm compound expressions, and all seven
derived sources pass syntax regeneration. Full behavioral validation then
completed for six of seven cases, exposing five genuine failures, one pass, and
one calculator timeout/not-run case.
