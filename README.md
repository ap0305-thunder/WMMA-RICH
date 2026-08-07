# WolframMMAProjectRICH-Git

- `notebooks/`: working visual notebooks loading `src/LoadProject.wl`
- `src/`: textual Wolfram Language sources
- `tests/`: smoke-test scaffold
- `validation/`: clean-kernel original/restructured behavioural comparison
- `legacy-original/`: every supplied file, unchanged
- `docs/RESTRUCTURING_REPORT.md`: scope, limitations and validation procedure

The project stylesheet is resolved portably: `myStyle.nb` in the project root
is preferred; if it is absent, the Front End searches its standard stylesheet
locations for `myStyle.nb`.

When a generated `src/*.wl` file is opened in the Wolfram package editor, its
original initialization-cell boundaries and structural notebook headers are
shown as separate cells. Header cells are stored as comments and do not affect
evaluation with `Get`.

The working `calculator-reboot.nb` includes the complete `---... CALCULATOR BODY`
top-level group and excludes everything after it.

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

The baseline runner now stages the missing original `CellStyleDataRules.m`
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
