param(
    [string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot),
    [ValidateSet("calculator", "optics", "geometricalOptics")]
    [string]$Case = "optics",
    [switch]$Check
)

$ErrorActionPreference = "Stop"

$resolvedRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path
$caseConfiguration = switch ($Case) {
    "calculator" {
        @{
            NativeRelativePath = "validation\native-sources\calculator-native.wl"
            DestinationRelativePath = "src\calculator.wl"
            TitleText = "(*---... SETUP*)"
            TitleLabel = "SETUP and CALCULATOR"
            TitleSectionCount = 2
            Role = "interactive-top-level"
            Context = 'calculator`'
            VersionSymbol = 'calculator`Private`versionTAG'
            VersionValue = "v.08-08-2026"
            HeaderLines = @(
                "   produced by Wolfram Save As. The SETUP and CALCULATOR Title sections are"
                "   selected; CALCULATOR BODY and every later interactive section are excluded."
                "   Wolfram expressions are neither parsed nor reserialized. *)"
            )
            FormatReplacements = [ordered]@{}
            RuntimeReplacements = [ordered]@{
                ([string]::Join([Environment]::NewLine, @(
                    'navHistory = {};'
                    'pushHistory[] := AppendTo[navHistory,'
                    '    First @ SelectedCells @ EvaluationNotebook[]'
                    '];'
                    'goBack[] := If[navHistory =!= {},'
                    '    SelectionMove[Last[navHistory], All, Cell];'
                    '(*    navHistory = Most[navHistory];*)'
                    '];'
                ))) = '(* Docked-cell navigation is owned by myNotebookInit` and installed below. *)'
                'loadMyFile["myDockedCells.wl"]' =
                    'If[!TrueQ[Global`$RICHProjectManagedLoad],myNotebookInit`installDockedCells[]]'
                '(*Once[*)myNotebookInit`loadMyFile["cellStyleDataRules.m"](*,"Notebook"]*)' =
                    'If[!TrueQ[Global`$RICHProjectManagedLoad],myNotebookInit`loadMyFile["cellStyleDataRules.m"]]'
                '(*Once[*)myNotebookInit`loadMyFile["RICH.m",NotebookDirectory[]](*,"KernelSession"];*)' =
                    'If[!TrueQ[Global`$RICHProjectManagedLoad],myNotebookInit`loadMyFile["RICH.wl",DirectoryName[$InputFileName]]]'
                'End[] (* End Private Context *)' =
                    'End[]; (* End Private Context *)'
                'EndPackage[]' =
                    'EndPackage[];'
            }
            RuntimeRegexReplacements = @(
                @{
                    Pattern = '(?ms)^\(\*[^\r\n]*External Load Tracker[^\r\n]*\*\)\r?\n.*?^Print\["Load Tracker ready\..*?ClearLoadLog\[\]"\]\r?$'
                    Replacement = '(* Explicit load tracking is owned by myNotebookInit` during managed project loading. *)'
                }
                @{
                    Pattern = '(?ms)^Module\[\{dir,pkg\},\r?\ndir=Quiet@NotebookDirectory\[\];.*?^If\[!TrueQ\[Global`\$RICHProjectManagedLoad\],myNotebookInit`installDockedCells\[\]\]\r?$'
                    Replacement = '(* The common notebook bootstrap is owned by LoadProject.wl. *)'
                }
            )
            FooterLines = @(
                'myNotebookInit`endEvalPrintOut[];',
                '',
                'myNotebookInit`packageBanner["END calculator"];'
            )
            ForbiddenFullFormHeads = @()
        }
    }
    "optics" {
        @{
            NativeRelativePath = "validation\native-sources\optics-native.wl"
            DestinationRelativePath = "src\optics.wl"
            TitleText = "(*---... OPTICS*)"
            TitleLabel = "OPTICS"
            TitleSectionCount = 1
            Role = "interactive-top-level"
            Context = 'Global` (legacy Optica-compatible source)'
            VersionSymbol = 'optics`Private`versionTAG'
            VersionValue = "v_16-06-2026"
            HeaderLines = @(
                "   produced by Wolfram Save As. Only the OPTICS Title section is selected;"
                "   Wolfram expressions are neither parsed nor reserialized. Five explicit"
                "   logical-disjunction heads from the notebook are rewritten as ||. *)"
            )
            FormatReplacements = [ordered]@{
                'Or[{0}=!=Union@Im[flattened],False===And@@NumericQ/@flattened]' =
                    '{0}=!=Union@Im[flattened]||False===And@@NumericQ/@flattened'
                'Or[False===MatrixQ[data],2=!=Last@Dimensions@data,invalidMatrix@data]' =
                    'False===MatrixQ[data]||2=!=Last@Dimensions@data||invalidMatrix@data'
                'Or[List=!=Head@e,2=!=Length@e]' =
                    'List=!=Head@e||2=!=Length@e'
                'Or[Symbol=!=Head@x,Symbol=!=Head@y]' =
                    'Symbol=!=Head@x||Symbol=!=Head@y'
                'Or["System`"===Context[x],"System`"===Context[y]]' =
                    '"System`"===Context[x]||"System`"===Context[y]'
            }
            RuntimeReplacements = [ordered]@{}
            RuntimeRegexReplacements = @()
            FooterLines = @(
                'myNotebookInit`endEvalPrintOut[];',
                '',
                'myNotebookInit`packageBanner["END optics"];'
            )
            ForbiddenFullFormHeads = @(
                "CompoundExpression", "Power", "Plus", "Times", "Or",
                "Set", "SetDelayed", "List", "Rule"
            )
        }
    }
    "geometricalOptics" {
        @{
            NativeRelativePath = "validation\native-sources\geometricalOptics-native.wl"
            DestinationRelativePath = "src\geometricalOptics.wl"
            TitleText = "(*---... geometricalOptics*)"
            TitleLabel = "geometricalOptics"
            TitleSectionCount = 1
            Role = "interactive-top-level"
            Context = 'geometricalOptics`'
            VersionSymbol = 'geometricalOptics`Private`versionTAG'
            VersionValue = "v.16-01-2025"
            HeaderLines = @(
                "   produced by Wolfram Save As. Only the geometricalOptics Title section is"
                "   selected; Wolfram expressions are neither parsed nor reserialized. Legacy"
                "   notebook-cleanup calls are suppressed during managed project loading. *)"
            )
            FormatReplacements = [ordered]@{}
            RuntimeReplacements = [ordered]@{
                'versionTAG="v.16-01-2025"' =
                    'geometricalOptics`Private`versionTAG="v.16-01-2025"'
                'End[] (* End Private Context *)' =
                    'End[]; (* End Private Context *)'
                'EndPackage[]' =
                    'EndPackage[];'
                'NotebookDelete[Cells[nb,GeneratedCell->True]];' =
                    'If[!TrueQ[Global`$RICHProjectManagedLoad],NotebookDelete[Cells[nb,GeneratedCell->True]]];'
                'FrontEndExecute[FrontEndToken[nb,"SelectAll"]];' =
                    'If[!TrueQ[Global`$RICHProjectManagedLoad],FrontEndExecute[FrontEndToken[nb,"SelectAll"]]];'
                'FrontEndTokenExecute["SelectionCloseAllGroups"];' =
                    'If[!TrueQ[Global`$RICHProjectManagedLoad],FrontEndTokenExecute["SelectionCloseAllGroups"]];'
            }
            RuntimeRegexReplacements = @()
            FooterLines = @(
                'myNotebookInit`endEvalPrintOut[];',
                '',
                'myNotebookInit`packageBanner["END geometricalOptics"];'
            )
            ForbiddenFullFormHeads = @()
        }
    }
}

$nativePath = Join-Path $resolvedRoot $caseConfiguration.NativeRelativePath
$destinationPath = Join-Path $resolvedRoot $caseConfiguration.DestinationRelativePath

if (-not (Test-Path -LiteralPath $nativePath -PathType Leaf)) {
    throw "Missing Wolfram Save As source: $nativePath"
}

$nativeLines = [System.IO.File]::ReadAllLines($nativePath)
$titleText = $caseConfiguration.TitleText
$titleTextIndex = [Array]::IndexOf($nativeLines, $titleText)
if ($titleTextIndex -lt 1) {
    throw "Could not find the $($caseConfiguration.TitleLabel) title in $nativePath"
}

$sectionStart = $titleTextIndex - 1
if (-not $nativeLines[$sectionStart].StartsWith("(* ::Title::")) {
    throw "The $($caseConfiguration.TitleLabel) title is not preceded by a Wolfram Title marker."
}

$sectionEnd = -1
$followingTitleCount = 0
for ($index = $titleTextIndex + 1; $index -lt $nativeLines.Count; $index++) {
    if ($nativeLines[$index].StartsWith("(* ::Title::")) {
        $followingTitleCount++
        if ($followingTitleCount -ge $caseConfiguration.TitleSectionCount) {
            $sectionEnd = $index
            break
        }
    }
}
if ($sectionEnd -lt 0) {
    throw "Could not find the Title marker following the $($caseConfiguration.TitleLabel) section."
}

$header = @(
    "(* ::Package:: *)",
    "",
    "(* ===== RICH managed source =====",
    "   Name: $Case",
    "   Role: $($caseConfiguration.Role)",
    "   Context: $($caseConfiguration.Context)",
    "   Version symbol: $($caseConfiguration.VersionSymbol)",
    "*)",
    "$($caseConfiguration.VersionSymbol) = `"$($caseConfiguration.VersionValue)`";",
    "",
    "(* Derived textually from $($caseConfiguration.NativeRelativePath.Replace('\', '/')),"
) + $caseConfiguration.HeaderLines + @(
    ""
)
$trimmedSectionLines = New-Object 'System.Collections.Generic.List[string]'
foreach ($line in $nativeLines[$sectionStart..($sectionEnd - 1)]) {
    $trimmedSectionLines.Add($line.TrimEnd())
}
while (
    $trimmedSectionLines.Count -gt 0 -and
    $trimmedSectionLines[$trimmedSectionLines.Count - 1] -eq ""
) {
    $trimmedSectionLines.RemoveAt($trimmedSectionLines.Count - 1)
}
$sectionLines = $trimmedSectionLines.ToArray()
$expectedText = [string]::Join(
    [Environment]::NewLine,
    [string[]]($header + $sectionLines)
) + [Environment]::NewLine

# Keep each Wolfram Save As baseline untouched. Apply only explicit,
# reviewable textual changes to the derived runtime source.
foreach ($entry in $caseConfiguration.FormatReplacements.GetEnumerator()) {
    if (-not $expectedText.Contains($entry.Key)) {
        throw "Expected native formatting target was not found: $($entry.Key)"
    }
    $expectedText = $expectedText.Replace($entry.Key, $entry.Value)
}
foreach ($entry in $caseConfiguration.RuntimeReplacements.GetEnumerator()) {
    if (-not $expectedText.Contains($entry.Key)) {
        throw "Expected runtime adaptation target was not found: $($entry.Key)"
    }
    $expectedText = $expectedText.Replace($entry.Key, $entry.Value)
}
foreach ($entry in @($caseConfiguration.RuntimeRegexReplacements)) {
    $updatedText = [regex]::Replace(
        $expectedText,
        $entry.Pattern,
        $entry.Replacement
    )
    if ($updatedText -ceq $expectedText) {
        throw "Expected runtime regex target was not found: $($entry.Pattern)"
    }
    $expectedText = $updatedText
}

$versionAssignmentPattern =
    '(?m)^[ \t]*(?:versionTAG|' +
    [regex]::Escape($caseConfiguration.VersionSymbol) +
    ')="[^"]*";?[ \t]*\r?$'
$expectedText = [regex]::Replace($expectedText, $versionAssignmentPattern, '')

$expectedText = [regex]::Replace(
    $expectedText,
    '(?m)^(\s*)endEvalPrintOut\[\];?\s*$',
    ''
)
$expectedText = $expectedText.TrimEnd() +
    [Environment]::NewLine + [Environment]::NewLine +
    [string]::Join([Environment]::NewLine, $caseConfiguration.FooterLines) +
    [Environment]::NewLine

foreach ($head in $caseConfiguration.ForbiddenFullFormHeads) {
    if ($expectedText.Contains($head + "[")) {
        throw "FullForm spelling remains in derived $($caseConfiguration.DestinationRelativePath): $head["
    }
}

if ($Check) {
    if (-not (Test-Path -LiteralPath $destinationPath -PathType Leaf)) {
        throw "Missing derived runtime source: $destinationPath"
    }
    $currentText = [System.IO.File]::ReadAllText($destinationPath)
    if ($currentText -cne $expectedText) {
        throw "$($caseConfiguration.DestinationRelativePath) is not the expected textual derivation of $($caseConfiguration.NativeRelativePath)."
    }
    Write-Output "Verified $($caseConfiguration.DestinationRelativePath) against the Wolfram Save As source."
    return
}

$temporaryPath = $destinationPath + ".tmp"
try {
    $utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($temporaryPath, $expectedText, $utf8WithoutBom)
    Move-Item -LiteralPath $temporaryPath -Destination $destinationPath -Force
}
finally {
    if (Test-Path -LiteralPath $temporaryPath) {
        Remove-Item -LiteralPath $temporaryPath -Force
    }
}

Write-Output "Built $($caseConfiguration.DestinationRelativePath) from the Wolfram Save As source."
