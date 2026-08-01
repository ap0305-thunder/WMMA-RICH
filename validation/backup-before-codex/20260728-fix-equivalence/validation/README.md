# Wolfram 15 behavioural validation (v5)

This version fixes two diagnostic problems in the previous launcher:

1. logs are written directly to the real project under `validation/results/current/logs`, even when evaluation runs in a temporary workspace;
2. each Wolfram process has a PowerShell-enforced hard timeout and a heartbeat in `launcher.log`.

It also evaluates only the initialization cells of the original `base.nb`, matching the content extracted into `src/base.wl`.


## v5 command-line argument correction

When the standalone kernel is launched with `wolfram.exe -script`, Wolfram 15 leaves `$ScriptCommandLine` empty. The v5 runners therefore read the trailing script arguments from `$CommandLine`, while retaining `$ScriptCommandLine` support for `wolframscript.exe -file`. If argument parsing ever fails again, both variables are printed in the stdout log.

## First test: base only

From PowerShell in the project root:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\validation\RunValidation.ps1 -Cases base -ProcessTimeoutSeconds 240 -KeepWorkspace
```

Use `wolframscript.exe`, `wolfram.exe`, or `WolframKernel.exe`, not `Mathematica.exe` or `WolframDesktop.exe`:

```powershell
.\validation\RunValidation.ps1 `
  -Cases base `
  -ProcessTimeoutSeconds 240 `
  -KeepWorkspace `
  -WolframExecutable "C:\Program Files\Wolfram Research\Wolfram\15.0\wolfram.exe"
```

## Logs available while it is running

Inspect:

```text
validation\results\current\logs\launcher.log
validation\results\current\logs\original-base.log.stdout.log
validation\results\current\logs\original-base.log.stderr.log
```

`launcher.log` is created before Wolfram starts and receives a heartbeat every ten seconds. A process that does not exit is forcibly terminated after the selected timeout.

The combined log is written to:

```text
validation\results\current\logs\original-base.log
```

## Diagnostic interpretation

- No `launcher.log`: the PowerShell script was not started from this package.
- `launcher.log` stops before `Started PID`: executable discovery or `Start-Process` failed.
- PID heartbeat with zero-byte stdout/stderr: Wolfram itself has not reached script output, commonly because command-line startup or Front End startup is blocked.
- The stdout log reaches `Opening source notebook` but not `Reading notebook expression`: `NotebookOpen` or Front End startup is blocked.
- It reaches `Evaluating initialization cells`: notebook initialization code is running or blocked.


## Command-line switch used

The launcher selects the switch from the executable name:

- `wolfram.exe`, `WolframKernel.exe`, `MathKernel.exe`: `-script`
- `wolframscript.exe`: `-file`

Using `wolfram.exe -file` opens an interactive kernel at `In[1]:=` and the harness will eventually time out.

## v6 correction

Before validation, `RegenerateSources.wls` rebuilds every notebook-derived `.wl`
file with `NotebookImport[..., "InputText"]`, the programmatic equivalent of
**Copy As -> Input Text**. This prevents nested cell-group lists and blank lines
from being serialized as malformed expressions such as `{expr1, , expr2}`.
Script targets are evaluated from a temporary notebook, so `EvaluationNotebook[]`,
`NotebookDirectory[]`, styles, and other Front End-dependent code have a real
notebook context.


## v8 corrections

- Correctly selects explicit evaluatable initialization `Input`/`Code` cells from notebook expressions.
- Treats zero selected cells as an error instead of silently creating empty `.wl` files.
- Emits and recovers an explicit Wolfram exit-code marker when Windows PowerShell reports a blank native exit code.

## v8 source-selection correction

The source regenerator now matches the literal notebook options `InitializationCell -> True` and `Evaluatable -> False` directly. Earlier generic rule-head matching failed to recognize these options and incorrectly reported zero initialization code cells. The regeneration log now prints the number of selected initialization Input/Code cells and, on failure, diagnostic counts for all Input/Code cells and initialization options.


## v9 corrections

- The temporary source notebook now formats the path argument with `StandardForm`, so its input cell evaluates `Get["..."]` instead of producing `ToBoxes::boxfmt`.
- `None` values in comparison metadata are converted to JSON `null`, preventing `Export::jsonstrictencoding`.


## v10 runner correction

Script targets are evaluated directly with `Get` in the same validation kernel whose symbols are captured. The project `src`, `legacy-original`, and working directories are added temporarily to `$Path`. The comparer now limits itself to the cases requested on the PowerShell command line.
