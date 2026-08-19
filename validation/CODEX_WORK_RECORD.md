# Codex validation work record

## Completed - 2026-08-01 15:47 Europe/Rome

The notebook restructuring and strict behavioral-equivalence validation are
complete. The installed aggregate report is **PASS** for all seven cases, with
zero missing canonical symbols, zero definition differences, and zero assigned
value differences in every case. No Wolfram validation process remains active.

| Case | Status | Original symbols | Restructured symbols | Missing | Definition differences | Value differences |
|---|---:|---:|---:|---:|---:|---:|
| base | PASS | 251 | 263 | 0 | 0 | 0 |
| physicsGeneral | PASS | 0 | 307 | 0 | 0 | 0 |
| statDataAnal | PASS | 178 | 312 | 0 | 0 | 0 |
| inputDataForRICH | PASS | 117 | 438 | 0 | 0 | 0 |
| calculator | PASS | 114 | 750 | 0 | 0 | 0 |
| RICH-source | PASS | 297 | 739 | 0 | 0 | 0 |
| CellStyleDataRules-source | PASS | 0 | 10 | 0 | 0 | 0 |

### Final installed evidence

- Report: `validation/results/current/VALIDATION_REPORT.md`
- Report SHA-256:
  `CEF1D7CBD186A399B02A3E2DB1CFDA4D8D7C53EAFB4B5948118EDC626F967819`
- Installed result files: 62
- Previous installed results archived at
  `validation/results/archive/20260801-154705-pre-final-equivalence-install/`
- The final RICH pair was captured without temporary diagnostic text fields and
  against a disposable `src/` tree whose 11 files matched the project tree by
  SHA-256.

### Corrections completed after the paused checkpoint

- Removed six `RICH.nb` example cells marked `Evaluatable -> False` from the
  executable generated source. This eliminated the apparent numerical stall.
- Replaced the readable RICH extraction with context-preserving FullForm so
  common names such as `nf`, `num`, `x`, and `numSim` cannot be captured by the
  `statDataAnal`` dependency context.
- Explicitly resolved two legacy `killStop` references to
  `myNotebookInit`killStop`.
- Repaired two escaped `StyleBox` label strings that `NotebookImport` had
  interpreted as multiplication expressions.
- Made those RICH source repairs part of `RegenerateSources.wls`; a fresh
  regeneration reproduced the validated `src/RICH.wl` byte-for-byte with
  SHA-256
  `1EC933E7EA05341811B5D95B5B8A30ECC5EC892D0EFB07440B0C8E8E5F554696`.
- Scoped dynamic context aliases to the records they canonicalize, preserved
  quoted strings during normalization, and retained explicit package aliases
  for cross-context comparisons.
- Preserved the pre-FullForm readable RICH source at
  `validation/backup-before-codex/20260801-context-preserving-rich/RICH-readable-before-fullform.wl`.

The following paused checkpoints are retained as historical recovery notes and
are superseded by this completed result.

## Paused checkpoint - 2026-08-01 06:47

The resumed equivalence task was stopped cleanly because the execution-time
window was approaching its limit. The owned controller (PID 25496) and its
Wolfram child (PID 31924) were stopped after the restructured `RICH-source`
evaluation remained CPU-active for more than five minutes in the same
`FindRoot`/numerical-integration block. A follow-up audit found zero running
Wolfram processes.

### Progress completed in this session

- Fixed all five restructured notebook loaders so their requested case is set
  as `Global`$RICHProjectCase`; previously every stub silently loaded the full
  `RICH-source` case.
- Made `src/LoadProject.wl` discover that explicit global case value safely.
- Added case-scoped filtering for random demo values, notebook-path runtime
  bookkeeping, and the RICH new-symbol inventories `symbolsNew` and
  `symbolsSave`.
- Added full `rich`` context canonicalization with a source-derived symbol
  vocabulary, exact-canonical-record preference, `::shdw` message filtering,
  token-boundary matching, and quoted-string preservation.
- Fixed a genuine package-context migration defect in `src/RICH.wl`: two
  executable bare `killStop` calls now explicitly invoke
  `myNotebookInit`killStop`, matching the legacy notebook definitions.
- The last complete aggregate comparison before that source fix reported six
  PASS cases and one RICH failure. Its only residuals were the two affected
  function definitions (`calcDetectedPhotons`, `calcRICHYield`) and the two
  audited symbol-inventory values (`symbolsNew`, `symbolsSave`).

### Exact current result state

The disposable workspace remains:
`%TEMP%\WolframRICHValidation-c1f6954141a04a4983d0d6bccbc8639c`.

The final-attempt original `RICH-source` artifact completed successfully at
06:40:14 using the current harness and source. The restructured side was
stopped before capture and did not write a corresponding current artifact.
Consequently the disposable raw pair and its existing aggregate report are now
mixed-generation and must not be installed or treated as final. The project
`validation/results/current` directory also intentionally remains the older
installed all-case result rather than this incomplete attempt.

### Exact resume point

1. Verify no Wolfram process is active.
2. Synchronize `src/RICH.wl`, `validation/RunNotebookCase.wls`,
   `validation/ValidationConfig.wl`, and `validation/CompareBaselines.wls` into
   the disposable workspace (their hashes matched immediately before the run).
3. Re-run `original RICH-source` and `restructured RICH-source`, then run
   `CompareBaselines.wls` over all seven cases. The approved launcher writes
   `validation/results/current/rich-final-rerun.log` in the disposable copy.
   Although the original artifact is complete, rerun both sides so the pair is
   unquestionably coherent.
4. If the restructured numerical block stalls again, diagnose why execution of
   the now-correct `myNotebookInit`killStop` references changes the standalone
   source path before relaxing any comparison rule.
5. Only after an all-PASS coherent report, archive the project's current result,
   install the disposable result directory, and update this work record.

## Paused checkpoint - 2026-07-31 15:06

The resumed equivalence task is again paused at a safe boundary. No Wolfram
validation process started by this session remains active.

### Harness corrections completed

- `RunNotebookCase.wls` now records only symbols with actual kernel state: at
  least one own value, definition, attribute, option, or message. A symbol name
  created only because a held notebook/front-end expression mentions it is not
  behavioral state.
- `CompareBaselines.wls` applies the same defined-symbol predicate when reading
  older WXF artifacts, so existing results remain comparable.
- `ValidationConfig.wl` excludes the audited front-end runtime aliases `nb` and
  `nbFileName` (both unqualified and in the `myNotebookInit` context). Their
  values and definitions can contain the disposable validation notebook object
  or its generated filename.
- A comparison-only pass over the retained artifacts confirmed that the
  defined-symbol filter is narrow: `physicsGeneral` changed from FAIL to PASS,
  while the genuine `statDataAnal` and `RICH-source` differences remained.
  That intermediate report showed 3 PASS and 4 FAIL, but it is not the final
  result because the old artifacts predate the new runtime-alias exclusions.

### Fresh evaluations completed

- `physicsGeneral`: original Success (0 defined symbols), restructured
  Success (836 defined symbols).
- `statDataAnal`: original Success (181 defined symbols), restructured Success
  (836 defined symbols).
- `inputDataForRICH` original: Success (117 defined symbols). Its front-end
  generated-cell collection took about 76 minutes, from 13:49:03 to 15:05:34,
  but it eventually reached the normal result-writing boundary.

The execution-layer monitor unexpectedly remained blocked during that long
collection. Once control returned, the sequential chain had just started the
restructured `inputDataForRICH` process. The owned chain and newly started
Wolfram process were stopped before that case wrote a result, and a subsequent
process audit found no remaining Wolfram validation process.

### Exact resume point

The disposable workspace is still:
`%TEMP%\WolframRICHValidation-c1f6954141a04a4983d0d6bccbc8639c`.

Resume with these evaluations, in this order:

1. restructured `inputDataForRICH` (the original side is fresh),
2. original and restructured `calculator`,
3. original and restructured `RICH-source`,
4. original and restructured `CellStyleDataRules-source`,
5. run `CompareBaselines.wls` for all seven cases.

Do not reinstall the disposable report into the project until all remaining
evaluations and the aggregate comparison finish. The project's installed
`validation/results/current` report remains the previously verified base-only
PASS result.

## Paused checkpoint — 2026-07-30 20:29

The resumed equivalence task is paused at a clean boundary. No validation job
started by this session remains active.

### Completed in this resumed session

- Added explicit, audited symbol-context canonicalization to
  `RunNotebookCase.wls`, `CompareBaselines.wls`, and `ValidationConfig.wl`.
- Excluded only volatile validation bookkeeping and the ambiguous legacy
  unqualified `versionTAG`; unexpected context changes remain reportable.
- Re-ran strict `base` validation. Current installed result:
  **PASS**, 478 original canonical symbols, 496 restructured canonical symbols,
  zero missing symbols, zero definition differences, and zero value differences.
- Verified all seven sources regenerate successfully with context-preserving
  FullForm serialization.
- Ran all six remaining cases in the retained disposable workspace
  `%TEMP%\WolframRICHValidation-c1f6954141a04a4983d0d6bccbc8639c`.
  All twelve evaluations completed successfully, including both
  `calculator` sides; the former multi-hour calculator blockage is gone.
- The disposable all-case comparison currently reports:
  2 PASS (`base`, `CellStyleDataRules-source`) and 5 FAIL
  (`physicsGeneral`, `statDataAnal`, `inputDataForRICH`,
  `calculator`, `RICH-source`). Its report is at
  `validation/results/current/VALIDATION_REPORT.md` inside that disposable
  workspace. The project’s installed report intentionally remains the verified
  base-only PASS result.

### Important finding

`src/base (2).wl` contains five sensible hand fixes, but direct loading did not
return within 60 seconds and matches the pattern of the pre-existing Wolfram
process left from 2026-07-29. Do not replace `src/base.wl` with that file
wholesale. The mechanically regenerated source returns normally.

### Recovery and next step

- Pre-resume copies are under
  `validation/backup-before-codex/20260730-resume/`.
- A pre-existing Wolfram process (PID 28284, started 2026-07-29 18:49) was not
  terminated because ownership could not be proven.
- Resume by analyzing the five remaining all-case failures from the disposable
  report. The quickest wins are the notebook-runtime-only differences
  (`myNotebookInit\`nb`, `myNotebookInit\`nbFileName`) and the two navigation
  helpers (`rich\`goBack`, `rich\`pushHistory`); the large `RICH-source`
  context migration requires separate, careful treatment.

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
| physicsGeneral | FAIL | 3 | 1075 | 3 | 0 | 0 | yes |
| statDataAnal | FAIL | 386 | 1075 | 0 | 0 | 7 | no |
| inputDataForRICH | FAIL | 264 | 1077 | 2 | 0 | 2 | no |
| calculator | NOT RUN | 0 | 0 | 0 | 0 | 0 | no |
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
| physicsGeneral.wl | 16 | 16 | 34 |
| statDataAnal.wl | 25 | 25 | 52 |
| inputDataForRICH.wl | 112 | 112 | 226 |
| calculator.wl | 38 | 38 | 78 |
| RICH.wl | 62 | 62 | 126 |

## Remaining genuine differences

- `base`: 95 original symbols are absent under their original unqualified names.
  The regenerated package creates the corresponding definitions principally in
  `base\`Private\``. Assigned values differ for
  `base\`Private\`searchForGivenNamesAndPrintRegExp`, `initialContexts`, and
  `myNotebookInit\`Private\`$LoadLog`.
- `physicsGeneral`: the restructured loader initializes the full project state
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
- `calculator`: the original notebook eventually produced an artifact
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
- `validation/results/current/raw/original/calculator.json`
- `validation/results/current/raw/original/calculator.wxf`
- `validation/results/current/raw/original/CellStyleDataRules-source.json`
- `validation/results/current/raw/original/CellStyleDataRules-source.wxf`
- `validation/results/current/raw/original/inputDataForRICH.json`
- `validation/results/current/raw/original/inputDataForRICH.wxf`
- `validation/results/current/raw/original/physicsGeneral.json`
- `validation/results/current/raw/original/physicsGeneral.wxf`
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
- `validation/results/current/raw/restructured/physicsGeneral.json`
- `validation/results/current/raw/restructured/physicsGeneral.wxf`
- `validation/results/current/raw/restructured/RICH-source.json`
- `validation/results/current/raw/restructured/RICH-source.wxf`
- `validation/results/current/raw/restructured/statDataAnal.json`
- `validation/results/current/raw/restructured/statDataAnal.wxf`
- `validation/results/current/evaluated-notebooks/original/base.m`
- `validation/results/current/evaluated-notebooks/original/base.nb`
- `validation/results/current/evaluated-notebooks/original/calculator.m`
- `validation/results/current/evaluated-notebooks/original/calculator.nb`
- `validation/results/current/evaluated-notebooks/original/CellStyleDataRules-source.m`
- `validation/results/current/evaluated-notebooks/original/CellStyleDataRules-source.nb`
- `validation/results/current/evaluated-notebooks/original/inputDataForRICH.m`
- `validation/results/current/evaluated-notebooks/original/inputDataForRICH.nb`
- `validation/results/current/evaluated-notebooks/original/physicsGeneral.m`
- `validation/results/current/evaluated-notebooks/original/physicsGeneral.nb`
- `validation/results/current/evaluated-notebooks/original/RICH-source.m`
- `validation/results/current/evaluated-notebooks/original/RICH-source.nb`
- `validation/results/current/evaluated-notebooks/original/statDataAnal.m`
- `validation/results/current/evaluated-notebooks/original/statDataAnal.nb`
- `validation/results/current/evaluated-notebooks/restructured/inputDataForRICH.m`
- `validation/results/current/evaluated-notebooks/restructured/inputDataForRICH.nb`
- `validation/results/current/evaluated-notebooks/restructured/physicsGeneral.m`
- `validation/results/current/evaluated-notebooks/restructured/physicsGeneral.nb`
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

## Resumed validation — 2026-08-07

The interrupted run was traced to antivirus termination of PowerShell. Work
resumed in a disposable project copy using hidden direct Wolfram processes;
the user's open Wolfram session was not stopped or modified.

The source generator now assigns dependency contexts from audited public
exports rather than every symbol seen in a dependency, preventing local RICH
symbols from being rewritten into `statDataAnal``. Managed project loads also
preserve dependency order and suppress RICH's legacy nested dependency loads.
`LoadProject.wl` now loads physics and input-data dependencies before RICH.

The behavioral validator now ignores `::usage` documentation when hashing
runtime definitions and no longer discards an otherwise valid symbol record
because an unrelated message occurred. Four additional legacy Global-to-
`myNotebookInit`` migrations were added to the audited equivalence table.

After regenerating the derived sources, a completely fresh run evaluated all
seven original/restructured pairs successfully. The strict comparison report
is PASS: 7, WARNING: 0, FAIL: 0, NOT RUN: 0, with zero missing symbols, zero
definition differences, zero value differences, and identical compared
outputs in every case. The intentionally deleted `src/base (2).wl` was neither
restored nor included in validation.

## Package-editor structure recovery — 2026-08-07

Generated `src/*.wl` files now include Wolfram package-editor metadata. Each
recovered initialization Input/Code cell has an
`(* ::Input::Initialization:: *)` boundary, and the original Title/Chapter/
Subtitle/Subsubtitle/Section/Subsection/Subsubsection cells are reinserted in
source order as non-evaluating commented header cells. The generator produces
this structure automatically on every regeneration.

A fresh regeneration and clean-kernel validation of every original and
restructured case completed with 7 PASS, 0 WARNING, 0 FAIL, and 0 NOT RUN.

## Portable stylesheet resolution — 2026-08-07

`myStyle.nb` is now installed at the project root. `LoadProject.wl` resolves
the stylesheet from that location first and otherwise supplies the bare name
`myStyle.nb`, allowing the Front End to use its standard stylesheet search
path. Generated sources consume the resolved setting. The two working
notebooks that retained legacy absolute metadata now store
`StyleDefinitions -> "myStyle.nb"` and `WindowTitle -> Automatic`.

Both modified notebook expressions passed syntax/option checks. A fresh source
regeneration and complete clean-kernel comparison again produced 7 PASS,
0 WARNING, 0 FAIL, and 0 NOT RUN.
