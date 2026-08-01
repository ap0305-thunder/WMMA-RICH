# Validation v11 changes

This revision fixes the `Syntax::sntx` failure in regenerated `base.wl`.

The previous generator converted complete notebook cells to `InputText`. A single
notebook cell can contain several separately evaluatable expressions, and that
text conversion did not preserve those expression boundaries reliably in a
package file.

Version 11 instead:

- imports each initialization-cell expression under `HoldComplete`;
- serializes each held expression separately in `InputForm` without evaluating it;
- writes one complete expression at a time to the `.wl` source;
- parses the complete generated source with `ReadList[..., Hold[Expression]]`
  before any evaluation;
- refuses to run a source file that fails this syntax preflight;
- excludes symbols whose names contain `killStop` from state capture.

Run the base validation with:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

.\validation\RunValidation.ps1 `
    -Cases base `
    -ProcessTimeoutSeconds 300 `
    -KeepWorkspace `
    -WolframExecutable "C:\Program Files\Wolfram Research\Wolfram\15.0\wolfram.exe"
```

The source-regeneration log should now report both an imported-expression count
and an equal parsed-expression count. The restructured log should contain a
line similar to:

```text
Source preflight parsed 123 held expressions
```

The exact number depends on the notebook contents.
