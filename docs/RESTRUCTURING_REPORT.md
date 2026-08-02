# Restructuring report

## Applied changes

- Preserved the supplied archive verbatim in `legacy-original/`.
- Created working notebooks in `notebooks/` and textual source files in `src/`.
- Removed extracted initialization Input/Code cells from the main working notebooks and inserted a loader cell. In `calculator-reboot.nb`, the original initialization cells remain visible but are disabled, while the loader supplies the extracted definitions.
- Retained style notebooks beside working notebooks because the styles use relative filenames.
- Kept `calculator-reboot.nb` only through the complete `---... CALCULATOR BODY` group; later top-level groups were excluded.

## Important limitations

- The restructuring has been executed and validated locally with Wolfram 15. The harness under `validation/` performs separate clean-process original and restructured runs, captures notebook side effects and project-symbol state, and produces a strict comparison report.
- Ordinary box-form input was converted to textual Wolfram Language. Special front-end constructs retain an exact `ToExpression[..., StandardForm, HoldComplete]` wrapper.

## Extraction summary

| Notebook | Initialization code cells | Exact-box fallbacks | Source |
|---|---:|---:|---|
| `base.nb` | 69 | 1 | `src/base.wl` |
| `physics-general.nb` | 16 | 0 | `src/physics-general.wl` |
| `statDataAnal.nb` | 25 | 0 | `src/statDataAnal.wl` |
| `inputDataForRICH.nb` | 112 | 0 | `src/inputDataForRICH.wl` |
| `RICH.nb` | 62 | 0 | `src/RICH.wl` |
| `calculator-reboot.nb` | 38 | 1 | `src/calculator-reboot.wl` |
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
