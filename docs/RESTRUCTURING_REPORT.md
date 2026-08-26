# Restructuring report

## Applied changes

- Preserved supplied notebook content in `legacy-original/`, apart from the
  project-wide filename/symbol capitalization normalization.
- Created working notebooks in `notebooks/` and textual source files in `src/`.
- Removed extracted initialization Input/Code cells from the supporting working notebooks and inserted loader cells. Top-level notebooks retain their interactive sections without duplicate package initialization code.
- Retained style notebooks beside working notebooks because the styles use relative filenames.
- Kept `calculator.nb` from `---... CALCULATOR BODY` through every later
  top-level section. Calculator-specific initialization is generated into
  `src/calculator.wl` and loaded by the calculator project profile.
- Standardized all nine working notebooks on one three-cell opening: a tagged role/source header, a tagged setup title, and one structurally identical universal bootstrap. Case, role, and source filename live in `TaggingRules`; `RICHNotebookBootstrap` owns shared settings and dependency loading. The restored `notebooks/RICH.nb` is a package-bootstrap notebook, not a toolbar/top-level case.
- Preserved `optics.nb` from `OPTICAL SYSTEM DESIGN` onward for interactive work. The former `---... OPTICS` initialization remains extracted in `src/optics.wl` and is loaded by the universal case bootstrap.
- Preserved `geometricalOptics.nb` from `THIS NOTEBOOK` onward. Its 30-cell legacy setup and 33-cell package section were replaced by the universal bootstrap; the package section is derived textually as `src/geometricalOptics.wl`.
- Merged the former `src/myDockedCells.wl` script into `myNotebookInit.wl` as the optional `installDockedCells[]` API. Only the three top-level notebook cases—`calculator`, `optics`, and `geometricalOptics`—install it explicitly; `RICH` and the other package-bootstrap notebooks remain free of docked-cell side effects.
- Standardized every notebook-backed runtime source on one opening metadata block (name, role, context, and context-owned `versionTAG`) and one qualified lifecycle footer. The source builders enforce both boundaries without modifying the native Wolfram Save As baselines.

## Universal bootstrap review

The legacy setup comparison found 22 initialization code cells in optics, 24
in calculator, and 30 in geometricalOptics. The merged
bootstrap retains portable loader discovery, common notebook and plotting
defaults, explicit load tracking, shared dependencies, and run timestamps.
Hard-coded user paths, duplicated package loads, automatic installation of a
stylesheet into the user profile, undefined legacy setup calls, and the
calculator-only overrides of protected `Get` and `Needs` were deliberately not
carried forward.

The optics-only `clearAllProtected` helper was still referenced by interactive
optics cells after its old setup block was removed. It now lives in
`myNotebookInit.wl`, preserves listable held-symbol behavior, and refuses to
clear symbols in `System``.

## Important limitations

- The restructuring has been executed and validated locally with Wolfram 15. The harness under `validation/` performs separate clean-process original and restructured runs, captures notebook side effects and project-symbol state, and produces a strict comparison report.
- Ordinary box-form input was converted to textual Wolfram Language. Special front-end constructs retain an exact `ToExpression[..., StandardForm, HoldComplete]` wrapper.

## Extraction summary

| Notebook | Initialization code cells | Exact-box fallbacks | Source |
|---|---:|---:|---|
| `base.nb` | 69 | 1 | `src/base.wl` |
| `physicsGeneral.nb` | 16 | 0 | `src/physicsGeneral.wl` |
| `statDataAnal.nb` | 25 | 0 | `src/statDataAnal.wl` |
| `inputDataForRICH.nb` | 112 | 0 | `src/inputDataForRICH.wl` |
| `RICH.nb` | 62 | 0 | `src/RICH.wl` |
| `calculator.nb` (legacy `SETUP` and `CALCULATOR` sections) | 37 | 1 | `src/calculator.wl` |
| `optics.nb` (`---... OPTICS` Title section only) | 59 | 0 | `src/optics.wl` |
| `geometricalOptics.nb` (`---... geometricalOptics` Title section only) | 33 | 0 | `src/geometricalOptics.wl` |
| `cellStyleDataRules.nb` | 9 | 0 | `src/cellStyleDataRules.wl` |

## Behavioural validation

Run from PowerShell in the project root:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\validation\RunValidation.ps1
```

The launcher uses a temporary copy of the project by default, runs every original/restructured case in a separate Wolfram process, verifies that the calculator runtime source stops before `CALCULATOR BODY`, removes the obsolete `LHCb-optics.m` cell only from the temporary original calculator copy, and writes `validation/results/current/VALIDATION_REPORT.md`.

The installed report generated on 2026-08-01 predates the geometricalOptics
addition and is **PASS** for its original seven cases:

- 7 PASS, 0 WARNING, 0 FAIL, 0 NOT RUN;
- zero missing canonical symbols;
- zero definition differences;
- zero assigned-value differences.

See `validation/results/current/VALIDATION_REPORT.md` for the complete evidence. The six RICH example cells marked `Evaluatable -> False` are intentionally excluded from executable source generation.

## Suggested Git commits

1. `Preserve original notebooks before source extraction`
2. `Add project layout and loader`
3. `Extract initialization code to WL sources`
4. `Trim calculator notebook after calculator body`
5. `Add smoke tests and repository attributes`
