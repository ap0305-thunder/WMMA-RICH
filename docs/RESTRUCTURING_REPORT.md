# Restructuring report

## Applied changes

- Preserved the supplied archive verbatim in `legacy-original/`.
- Created working notebooks in `notebooks/` and textual source files in `src/`.
- Removed extracted initialization Input/Code cells from the supporting working notebooks and inserted loader cells. `calculator.nb` retains its calculator-specific initialization after the replaced leading setup. `optics.nb` has no duplicate initialization code.
- Retained style notebooks beside working notebooks because the styles use relative filenames.
- Kept `calculator.nb` only through the complete `---... CALCULATOR BODY` group; later top-level groups were excluded.
- Replaced the leading setup in both `optics.nb` and `calculator.nb` with one structurally identical universal bootstrap cell. Each notebook stores only its case name in `TaggingRules`; `RICHNotebookBootstrap` owns shared settings and dependency loading.
- Preserved `optics.nb` from `OPTICAL SYSTEM DESIGN` onward for interactive work. The former `---... OPTICS` initialization remains extracted in `src/optics.wl` and is loaded by the universal case bootstrap.

## Universal bootstrap review

The legacy setup comparison found 22 initialization code cells in optics and
24 in calculator, with only 6 exact cell bodies in common. The merged
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
| `calculator.nb` | 38 | 1 | `src/calculator.wl` |
| `optics.nb` (`---... OPTICS` Title section only) | 59 | 0 | `src/optics.wl` |
| `CellStyleDataRules.nb` | 9 | 0 | `src/CellStyleDataRules.wl` |

## Behavioural validation

Run from PowerShell in the project root:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\validation\RunValidation.ps1
```

The launcher uses a temporary copy of the project by default, runs every original/restructured case in a separate Wolfram process, enforces the calculator-body cutoff, removes the obsolete `LHCb-optics.m` cell only from the temporary original calculator copy, and writes `validation/results/current/VALIDATION_REPORT.md`.

The installed report generated on 2026-08-01 is **PASS** for all seven cases:

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
