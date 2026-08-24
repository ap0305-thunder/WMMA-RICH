# WolframMMAProjectRICH-Git

- `notebooks/`: working visual notebooks loading `src/LoadProject.wl`
- `src/`: textual Wolfram Language sources
- `output/`: generated plots, tables and exported notebook cells
- `backups/`: versioned notebook and text copies
- `tests/`: smoke-test scaffold
- `validation/`: clean-kernel original/restructured behavioural comparison
- `legacy-original/`: supplied archival files, with project-wide naming normalization only
- `docs/RESTRUCTURING_REPORT.md`: scope, limitations and validation procedure

The sole working copy of the project stylesheet is `myStyle.nb` in the project
root. Working notebooks and generated sources resolve that canonical copy;
the unchanged archival copy remains under `legacy-original/`.

When a generated `src/*.wl` file is opened in the Wolfram package editor, its
original initialization-cell boundaries and structural notebook headers are
shown as separate cells. Header cells are stored as comments and do not affect
evaluation with `Get`.

The working `calculator.nb` includes the complete `---... CALCULATOR BODY`
top-level group and excludes everything after it.

All nine managed notebooks begin with the same three-cell structure: a tagged
role/source header, a tagged `---... SETUP` title, and the structurally
identical universal initialization cell. The cell reads `"RICHProjectCase"`
from the notebook's `TaggingRules`, resolves `src/LoadProject.wl` relative to
the saved notebook, and calls `RICHNotebookBootstrap[case]`. The three
interactive top-level notebooks are `optics.nb`, `calculator.nb`, and
`geometricalOptics.nb`; the other six—including `RICH.nb`—are
package-bootstrap notebooks with no additional executable initialization
cells. `src/optics.wl` remains the sole executable copy of the extracted optics
initialization; content beginning at `OPTICAL SYSTEM DESIGN` remains
interactive in `optics.nb`. Likewise, `src/geometricalOptics.wl` contains only
the extracted `---... geometricalOptics` initialization section, while content
beginning at `THIS NOTEBOOK` remains interactive in `geometricalOptics.nb`.

`RICHNotebookBootstrap` loads `myNotebookInit.wl` once, applies the common
notebook/window/style settings, loads the selected dependency chain, applies
the plotting defaults shared by the legacy top-level setup blocks,
and initializes the backward-compatible run timestamp symbols. It does not
install global `Get`/`Needs` hooks or restore machine-specific paths from the
legacy calculator setup.

The former `src/myDockedCells.wl` side-effect script is merged into
`myNotebookInit.wl`. Its toolbar is an optional API rather than a package-load
side effect: `RICHNotebookBootstrap` calls `installDockedCells[]` only for the
three top-level cases: `calculator`, `optics`, and `geometricalOptics`.
Navigation history is private to `myNotebookInit`` and toolbar callbacks are
explicitly package-qualified.

Every managed notebook source ends with the same explicitly owned lifecycle
footer: ``myNotebookInit`endEvalPrintOut[]`` followed by
``myNotebookInit`packageBanner["END ..."]``. This keeps source endings parallel
and prevents post-`EndPackage[]` calls from resolving in ``Global` ``.

Every managed notebook source also begins with a canonical metadata header
that declares its name, architectural role, working context, and one
context-owned `versionTAG`. Native Wolfram Save As files remain unchanged;
both source-generation paths add and validate this runtime header.

`LoadRICHFiles` explicitly records every component path in the
`myNotebookInit` load tracker through `recordExternalLoad`; this includes the
initial `myNotebookInit.wl` bootstrap load. `summarizeLoads[]` therefore reports
project-loader activity without redefining the protected system `Get` or
`Needs` functions.

To reinstall or verify the shared cell after editing a notebook, run:

```powershell
wolfram.exe -script validation\InstallUniversalBootstrap.wls
wolfram.exe -script validation\CheckUniversalBootstrap.wls
```

The two optics-related runtime sources are deterministic textual derivations of
their Wolfram Save As baselines. Rebuild or check either source with:

```powershell
.\validation\BuildTopLevelSourceFromNative.ps1 -Case optics
.\validation\BuildTopLevelSourceFromNative.ps1 -Case geometricalOptics -Check
```

## Portable project paths

`src/LoadProject.wl` initializes portable defaults using the project root:

- generated results: `output/`
- versioned notebook copies: `backups/`
- disposable intermediate files: `$TemporaryDirectory/WolframMMAProjectRICH`

Use `configureRICHPaths[]` from an interactive notebook to choose different
directories. Choices are saved per user as JSON below `$UserBaseDirectory` and
do not modify the portable project defaults. `RICHOutputPath[...]`,
`RICHBackupPath[...]`, and `RICHTemporaryPath[...]` construct platform-safe
paths and create required directories. The historical `$dirOut`, `$dirBackup`,
`$dirSWRoot`, and `$dirSW` symbols remain as compatibility aliases.

## Run the behavioural validation

On a Windows computer with Wolfram 15 installed, open PowerShell in the project
root and run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\validation\RunValidation.ps1
```

See `validation/README.md` for executable-path examples, selected-case runs,
result interpretation and the files to upload for review.


## Validation v2 correction

The baseline runner now stages the missing original `cellStyleDataRules.m`
dependency, avoids evaluating initialization cells twice, reports progress by
phase, and excludes the `base.nb` cell explicitly marked
`Evaluatable -> False` from `src/base.wl`.

## Validation v3 note

The validation launcher now writes immediate external logs, emits a ten-second heartbeat, and enforces a hard process timeout. For the first check, run:

```powershell
.\validation\RunValidation.ps1 -Cases base -ProcessTimeoutSeconds 240 -KeepWorkspace
```

See `validation/README.md`.


### Validation launcher v4 correction

For Wolfram 15 installations using `wolfram.exe`, the validation launcher now invokes the standalone kernel with `-script`. `-file` is used only with `wolframscript.exe`.


### Validation launcher v5 correction

The Wolfram runner now parses arguments from `$CommandLine` when invoked through the standalone kernel (`wolfram.exe -script`). Wolfram documents that `$ScriptCommandLine` is empty outside the `wolframscript` mechanism.

### Validation v6

The validator now regenerates notebook-derived `.wl` files using Wolfram's
`NotebookImport[..., "InputText"]` conversion before running comparisons. This
removes malformed list artifacts created by the earlier static extractor. Source
files are evaluated inside a temporary notebook so Front End-dependent setup code
has a valid `EvaluationNotebook[]` and `NotebookDirectory[]`.


Validation harness revision: v8.


Validation v10 evaluates `.wl` targets directly in the inspected kernel and compares only requested cases.
