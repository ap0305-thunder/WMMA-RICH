param(
    [string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot),
    [switch]$Check
)

$ErrorActionPreference = "Stop"

$sourcePath = Join-Path $ProjectRoot "src\myNotebookInit.wl"
$text = [System.IO.File]::ReadAllText($sourcePath)
$newline = if ($text.Contains("`r`n")) { "`r`n" } else { "`n" }
$marker = "(* ===== Public API (lowercase-first) ===== *)"
$privateMarker = 'Begin["`Private`"]'
$markerIndex = $text.IndexOf($marker, [System.StringComparison]::Ordinal)
$privateIndex = $text.IndexOf(
    $privateMarker,
    $markerIndex + $marker.Length,
    [System.StringComparison]::Ordinal
)
if ($markerIndex -lt 0 -or $privateIndex -lt 0) {
    throw "Could not locate the public API declaration block in $sourcePath"
}

$blockStart = $markerIndex + $marker.Length
$block = $text.Substring($blockStart, $privateIndex - $blockStart)
$usagePattern = '(?ms)^([^\s:]+)::usage\s*=\s*(?:"((?:\\.|[^"])*)"|StringJoin\[(.*?)\])\s*;'
$matches = [regex]::Matches($block, $usagePattern)
if ($matches.Count -eq 0) {
    throw "No usage declarations were found in $sourcePath"
}

$rows = foreach ($match in $matches) {
    $name = $match.Groups[1].Value
    if ($match.Groups[2].Success) {
        $value = $match.Groups[2].Value
    }
    else {
        $parts = [regex]::Matches(
            $match.Groups[3].Value,
            '"((?:\\.|[^"])*)"'
        )
        $value = ($parts | ForEach-Object { $_.Groups[1].Value }) -join ""
    }
    [pscustomobject]@{
        Name = $name
        SortKey = (($name -replace '^.*`', '') -replace '^\$', '')
        Line = $name + '::usage = "' + $value + '";'
    }
}

$remainingBlock = [regex]::Replace($block, $usagePattern, "")
$remainingBlock = $remainingBlock.Replace(
    "(* ===== Public messages ===== *)",
    ""
).Trim()
$remainingBlock = [regex]::Replace(
    $remainingBlock,
    '(?:\r?\n[ \t]*){3,}',
    $newline + $newline
)
$usageLines = ($rows | Sort-Object SortKey | ForEach-Object { $_.Line }) -join $newline
$normalizedBlock = $newline + $newline + $usageLines + $newline + $newline
if ($remainingBlock.Length -gt 0) {
    $normalizedBlock +=
        "(* ===== Public messages ===== *)" + $newline +
        $remainingBlock + $newline + $newline
}
$normalizedText =
    $text.Substring(0, $blockStart) +
    $normalizedBlock +
    $text.Substring($privateIndex)

if ($Check) {
    if ($normalizedText -cne $text) {
        throw "Usage declarations in src\myNotebookInit.wl are not normalized."
    }
    Write-Output "Verified sorted, single-line usage declarations in src\myNotebookInit.wl."
    return
}

$utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($sourcePath, $normalizedText, $utf8WithoutBom)
Write-Output "Normalized $($matches.Count) usage declarations in src\myNotebookInit.wl."
