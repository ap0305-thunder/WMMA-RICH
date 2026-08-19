[CmdletBinding()]
param(
    [string]$WolframExecutable,
    [string[]]$Cases = @(
        "base",
        "physicsGeneral",
        "statDataAnal",
        "inputDataForRICH",
        "calculator",
        "RICH",
        "cellStyleDataRules"
    ),
    [switch]$InPlace,
    [switch]$KeepWorkspace,
    [int]$ProcessTimeoutSeconds = 300
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Write-LauncherLog {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Message
    )
    $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    Write-Host $line
    Add-Content -LiteralPath $Path -Value $line -Encoding UTF8
}

function Find-WolframExecutable {
    param([string]$Requested)

    if ($Requested) {
        if (Test-Path -LiteralPath $Requested) {
            $resolved = (Resolve-Path -LiteralPath $Requested).Path
        }
        else {
            $command = Get-Command $Requested -ErrorAction SilentlyContinue
            if (-not $command) {
                throw "Wolfram executable not found: $Requested"
            }
            $resolved = $command.Source
        }

        $requestedName = [System.IO.Path]::GetFileName($resolved)
        if ($requestedName -ieq "Mathematica.exe" -or
            $requestedName -ieq "WolframDesktop.exe") {
            throw "Use wolframscript.exe, wolfram.exe, or WolframKernel.exe, not $requestedName. The desktop executable opens a GUI and does not run this command-line harness correctly."
        }
        return $resolved
    }

    $command = Get-Command "wolframscript.exe" -ErrorAction SilentlyContinue
    if (-not $command) {
        $command = Get-Command "wolframscript" -ErrorAction SilentlyContinue
    }
    if ($command) {
        return $command.Source
    }

    $candidates = @(
        "C:\Program Files\Wolfram Research\WolframScript\wolframscript.exe",
        "C:\Program Files\Wolfram Research\Wolfram\15.0\wolfram.exe",
        "C:\Program Files\Wolfram Research\Wolfram\15.0\WolframKernel.exe",
        "C:\Program Files\Wolfram Research\Mathematica\15.0\wolframscript.exe",
        "C:\Program Files\Wolfram Research\Mathematica\15.0\WolframKernel.exe"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return $candidate
        }
    }

    throw @"
No Wolfram command-line executable was found.
Specify wolframscript.exe, wolfram.exe, or WolframKernel.exe explicitly, for example:
  .\validation\RunValidation.ps1 -WolframExecutable "C:\Program Files\Wolfram Research\Wolfram\15.0\wolfram.exe" -Cases base
"@
}

function Quote-ProcessArgument {
    param([Parameter(Mandatory = $true)][string]$Value)
    if ($Value -notmatch '[\s"]') {
        return $Value
    }
    return '"' + $Value.Replace('"', '\"') + '"'
}

function Invoke-WolframFile {
    param(
        [Parameter(Mandatory = $true)][string]$Executable,
        [Parameter(Mandatory = $true)][string]$Script,
        [Parameter(Mandatory = $true)][string[]]$ScriptArguments,
        [Parameter(Mandatory = $true)][string]$LogPath,
        [Parameter(Mandatory = $true)][string]$LauncherLog,
        [Parameter(Mandatory = $true)][int]$TimeoutSeconds
    )

    $name = [System.IO.Path]::GetFileName($Executable)
    $kernelExecutables = @("wolfram.exe", "WolframKernel.exe", "MathKernel.exe")
    if ($kernelExecutables -contains $name) {
        # Standalone kernels use -script. Using -file here starts an interactive
        # kernel and leaves it waiting forever at In[1]:=.
        $arguments = @("-script", $Script) + $ScriptArguments
        $invocationMode = "standalone kernel (-script)"
    }
    elseif ($name -ieq "wolframscript.exe" -or $name -ieq "wolframscript") {
        $arguments = @("-file", $Script) + $ScriptArguments
        $invocationMode = "wolframscript (-file)"
    }
    else {
        throw "Unsupported Wolfram command-line executable: $name"
    }

    $stdoutPath = $LogPath + ".stdout.log"
    $stderrPath = $LogPath + ".stderr.log"
    $argumentLine = ($arguments | ForEach-Object { Quote-ProcessArgument $_ }) -join " "

    Write-LauncherLog -Path $LauncherLog -Message ("Invocation mode: " + $invocationMode)
    Write-LauncherLog -Path $LauncherLog -Message ("Starting: {0} {1}" -f $Executable, $argumentLine)
    Set-Content -LiteralPath $LogPath -Value ("Command: {0} {1}" -f $Executable, $argumentLine) -Encoding UTF8

    $process = Start-Process `
        -FilePath $Executable `
        -ArgumentList $argumentLine `
        -PassThru `
        -NoNewWindow `
        -RedirectStandardOutput $stdoutPath `
        -RedirectStandardError $stderrPath

    # Windows PowerShell 5.1 can otherwise expose a blank ExitCode for an
    # asynchronously started process. Forcing the native handle here keeps
    # the exit information available after the process terminates.
    $null = $process.Handle

    Write-LauncherLog -Path $LauncherLog -Message ("Started PID {0}; hard timeout {1} seconds" -f $process.Id, $TimeoutSeconds)
    $started = Get-Date
    $nextHeartbeat = $started.AddSeconds(10)
    $timedOut = $false

    while (-not $process.HasExited) {
        Start-Sleep -Seconds 1
        $process.Refresh()
        $now = Get-Date

        if ($now -ge $nextHeartbeat) {
            $elapsed = [int](($now - $started).TotalSeconds)
            Write-LauncherLog -Path $LauncherLog -Message ("PID {0} still running after {1} seconds; stdout={2} bytes, stderr={3} bytes" -f `
                $process.Id, $elapsed,
                $(if (Test-Path -LiteralPath $stdoutPath) { (Get-Item -LiteralPath $stdoutPath).Length } else { 0 }),
                $(if (Test-Path -LiteralPath $stderrPath) { (Get-Item -LiteralPath $stderrPath).Length } else { 0 }))
            $nextHeartbeat = $now.AddSeconds(10)
        }

        if (($now - $started).TotalSeconds -ge $TimeoutSeconds) {
            $timedOut = $true
            Write-LauncherLog -Path $LauncherLog -Message ("Hard timeout reached; terminating PID {0}" -f $process.Id)
            Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
            break
        }
    }

    $process.WaitForExit()

    Add-Content -LiteralPath $LogPath -Value "`r`n--- STANDARD OUTPUT ---" -Encoding UTF8
    if (Test-Path -LiteralPath $stdoutPath) {
        Get-Content -LiteralPath $stdoutPath -ErrorAction SilentlyContinue |
            Add-Content -LiteralPath $LogPath -Encoding UTF8
    }
    Add-Content -LiteralPath $LogPath -Value "`r`n--- STANDARD ERROR ---" -Encoding UTF8
    if (Test-Path -LiteralPath $stderrPath) {
        Get-Content -LiteralPath $stderrPath -ErrorAction SilentlyContinue |
            Add-Content -LiteralPath $LogPath -Encoding UTF8
    }

    if ($timedOut) {
        Add-Content -LiteralPath $LogPath -Value "`r`nPROCESS TIMEOUT" -Encoding UTF8
        return 124
    }

    $process.Refresh()
    $exitCode = $null
    try {
        $exitCode = $process.ExitCode
    }
    catch {
        $exitCode = $null
    }

    # Some Windows PowerShell 5.1 installations still return a blank native
    # ExitCode. Every Wolfram script emits an explicit marker before Exit[].
    if ($null -eq $exitCode) {
        $stdoutText = if (Test-Path -LiteralPath $stdoutPath) {
            Get-Content -LiteralPath $stdoutPath -Raw -ErrorAction SilentlyContinue
        }
        else {
            ""
        }
        $marker = [regex]::Match($stdoutText, "(?m)^__WOLFRAM_EXIT_CODE__=(\d+)\s*$")
        if ($marker.Success) {
            $exitCode = [int]$marker.Groups[1].Value
            Write-LauncherLog -Path $LauncherLog -Message ("Recovered Wolfram exit code {0} from stdout marker" -f $exitCode)
        }
        else {
            $exitCode = 125
            Write-LauncherLog -Path $LauncherLog -Message "Native exit code was blank and no Wolfram exit marker was found; using 125"
        }
    }

    Write-LauncherLog -Path $LauncherLog -Message ("PID {0} exited with code {1}" -f $process.Id, $exitCode)
    return [int]$exitCode
}

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$originalResults = Join-Path $projectRoot "validation\results"
$currentResults = Join-Path $originalResults "current"
$archiveResults = Join-Path $originalResults "archive"

New-Item -ItemType Directory -Force -Path $originalResults | Out-Null
if (Test-Path -LiteralPath $currentResults) {
    $hasContent = Get-ChildItem -LiteralPath $currentResults -Force -ErrorAction SilentlyContinue
    if ($hasContent) {
        New-Item -ItemType Directory -Force -Path $archiveResults | Out-Null
        $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
        Move-Item -LiteralPath $currentResults -Destination (Join-Path $archiveResults $stamp)
    }
    else {
        Remove-Item -LiteralPath $currentResults -Recurse -Force
    }
}

$hostLogs = Join-Path $currentResults "logs"
New-Item -ItemType Directory -Force -Path $hostLogs | Out-Null
$launcherLog = Join-Path $hostLogs "launcher.log"
Set-Content -LiteralPath $launcherLog -Value "Wolfram validation launcher" -Encoding UTF8
Write-LauncherLog -Path $launcherLog -Message ("Project root: " + $projectRoot)
Write-LauncherLog -Path $launcherLog -Message ("Cases: " + ($Cases -join ", "))

$executable = Find-WolframExecutable -Requested $WolframExecutable
Write-LauncherLog -Path $launcherLog -Message ("Wolfram executable: " + $executable)

$workspace = $null
$runRoot = $projectRoot
if (-not $InPlace) {
    $workspace = Join-Path $env:TEMP ("WolframRICHValidation-" + [guid]::NewGuid().ToString("N"))
    Write-LauncherLog -Path $launcherLog -Message ("Creating validation workspace: " + $workspace)
    New-Item -ItemType Directory -Force -Path $workspace | Out-Null

    Get-ChildItem -LiteralPath $projectRoot -Force |
        Where-Object { $_.Name -ne ".git" } |
        Copy-Item -Destination $workspace -Recurse -Force

    $workspaceResults = Join-Path $workspace "validation\results"
    if (Test-Path -LiteralPath $workspaceResults) {
        Remove-Item -LiteralPath $workspaceResults -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path (Join-Path $workspaceResults "current") | Out-Null
    $runRoot = $workspace
    Write-LauncherLog -Path $launcherLog -Message ("Workspace copy completed: " + $workspace)
}

$runResults = Join-Path $runRoot "validation\results\current"
New-Item -ItemType Directory -Force -Path $runResults | Out-Null

$runner = Join-Path $runRoot "validation\RunNotebookCase.wls"
$comparer = Join-Path $runRoot "validation\CompareBaselines.wls"
$runFailures = @()
$stagedFiles = @()

# Native Wolfram Save As files are validation baselines kept outside src so
# project loaders cannot treat them as runtime components. Validation must
# never regenerate or rewrite them from the legacy notebooks.
$generationLog = Join-Path $hostLogs "source-regeneration.log"
$requiredSourcePaths = @(
    "src\cellStyleDataRules.wl",
    "src\base.wl",
    "src\physicsGeneral.wl",
    "src\statDataAnal.wl",
    "src\inputDataForRICH.wl",
    "src\RICH.wl",
    "src\calculator.wl",
    "validation\native-sources\calculator-native.wl",
    "validation\native-sources\optics-native.wl"
)
$missingRequiredSources = @(
    foreach ($relativeSourcePath in $requiredSourcePaths) {
        $sourcePath = Join-Path $runRoot $relativeSourcePath
        if (-not (Test-Path -LiteralPath $sourcePath)) {
            $sourcePath
        }
    }
)
if ($missingRequiredSources.Count -gt 0) {
    throw "Missing required source files: $($missingRequiredSources -join ', ')"
}

$opticsBuilder = Join-Path $runRoot "validation\BuildOpticsFromNative.ps1"
& $opticsBuilder -ProjectRoot $runRoot -Check

$calculatorSource = Join-Path $runRoot "src\calculator.wl"
$calculatorText = [System.IO.File]::ReadAllText($calculatorSource)
$calculatorMarker = "CALCULATOR BODY"
$calculatorMarkerCount = ([regex]::Matches(
    $calculatorText,
    [regex]::Escape($calculatorMarker)
)).Count
if ($calculatorMarkerCount -ne 1) {
    throw "Expected exactly one CALCULATOR BODY marker in src\calculator.wl; found $calculatorMarkerCount."
}

$calculatorNativeSource = Join-Path $runRoot "validation\native-sources\calculator-native.wl"
$calculatorSourceHash = (Get-FileHash `
    -LiteralPath $calculatorSource `
    -Algorithm SHA256
).Hash
$calculatorNativeHash = (Get-FileHash `
    -LiteralPath $calculatorNativeSource `
    -Algorithm SHA256
).Hash
if ($calculatorSourceHash -cne $calculatorNativeHash) {
    throw "src\calculator.wl differs from validation\native-sources\calculator-native.wl."
}

@(
    "Native Wolfram Save As sources preserved; no regeneration performed.",
    "Verified source files: $($requiredSourcePaths -join ', ')",
    "Verified src\optics.wl is derived textually from the Wolfram Save As source.",
    "Verified one CALCULATOR BODY marker in src\calculator.wl.",
    "Verified src\calculator.wl matches validation\native-sources\calculator-native.wl."
) | Set-Content -LiteralPath $generationLog -Encoding UTF8
Write-LauncherLog -Path $launcherLog -Message "Native WL sources verified without modification."

# base.nb expects cellStyleDataRules.m beside the original notebook.
$baseDependencySource = Join-Path $runRoot "src\cellStyleDataRules.wl"
$baseDependencyDestinations = @(
    (Join-Path $runRoot "legacy-original\cellStyleDataRules.m"),
    (Join-Path $runRoot "notebooks\cellStyleDataRules.m")
)
if (Test-Path -LiteralPath $baseDependencySource) {
    foreach ($baseDependencyDestination in $baseDependencyDestinations) {
        if (-not (Test-Path -LiteralPath $baseDependencyDestination)) {
            Copy-Item -LiteralPath $baseDependencySource -Destination $baseDependencyDestination
            $stagedFiles += $baseDependencyDestination
            Write-LauncherLog -Path $launcherLog -Message ("Temporarily staged: " + $baseDependencyDestination)
        }
    }
}

try {
    foreach ($case in $Cases) {
        foreach ($mode in @("original", "restructured")) {
            $log = Join-Path $hostLogs ($mode + "-" + $case + ".log")
            $exitCode = Invoke-WolframFile `
                -Executable $executable `
                -Script $runner `
                -ScriptArguments @($runRoot, $mode, $case) `
                -LogPath $log `
                -LauncherLog $launcherLog `
                -TimeoutSeconds $ProcessTimeoutSeconds

            if ($exitCode -ne 0) {
                $runFailures += ($mode + "/" + $case + " (exit " + $exitCode + ")")
                Write-Warning ("Validation run reported a problem: " + $runFailures[-1])
            }
        }
    }

    $compareLog = Join-Path $hostLogs "comparison.log"
    $compareExit = Invoke-WolframFile `
        -Executable $executable `
        -Script $comparer `
        -ScriptArguments @($runRoot, ($Cases -join ",")) `
        -LogPath $compareLog `
        -LauncherLog $launcherLog `
        -TimeoutSeconds $ProcessTimeoutSeconds

    if (-not $InPlace) {
        Copy-Item -Path (Join-Path $runResults "*") -Destination $currentResults -Recurse -Force -ErrorAction SilentlyContinue
    }

    $report = Join-Path $currentResults "VALIDATION_REPORT.md"
    Write-LauncherLog -Path $launcherLog -Message ("Validation finished. Report: " + $report)

    if ($runFailures.Count -gt 0) {
        Write-Warning ("Runs requiring inspection: " + ($runFailures -join ", "))
    }
    if ($compareExit -ne 0) {
        Write-Warning "The strict comparison found failures. See VALIDATION_REPORT.md."
    }
}
finally {
    foreach ($stagedFile in $stagedFiles) {
        if (Test-Path -LiteralPath $stagedFile) {
            Remove-Item -LiteralPath $stagedFile -Force
        }
    }

    if ($workspace -and -not $KeepWorkspace -and (Test-Path -LiteralPath $workspace)) {
        Remove-Item -LiteralPath $workspace -Recurse -Force
    }
    elseif ($workspace) {
        Write-LauncherLog -Path $launcherLog -Message ("Workspace retained: " + $workspace)
    }
}
