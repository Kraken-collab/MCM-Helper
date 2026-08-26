param(
    [Parameter(Mandatory = $true)]
    [string]$Source,

    [Parameter(Mandatory = $true)]
    [string]$Destination
)

$ErrorActionPreference = 'Stop'
$vanilla = Join-Path $Source 'scripts\vanilla'
$modified = Join-Path $Source 'scripts\modified'
$target = Join-Path $Destination 'Scripts\Source'

if (-not (Test-Path $vanilla -PathType Container) -or -not (Test-Path $modified -PathType Container)) {
    throw "SKSE script sources were not found under $Source"
}

Remove-Item $Destination -Recurse -Force -ErrorAction SilentlyContinue
New-Item $target -ItemType Directory -Force | Out-Null

Get-ChildItem $vanilla -File | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $target $_.Name)
}

Get-ChildItem $modified -File | ForEach-Object {
    $output = Join-Path $target $_.Name
    if (Test-Path $output) {
        $separator = [Text.Encoding]::ASCII.GetBytes("`r`n`r`n")
        $base = [IO.File]::ReadAllBytes($output)
        $overlay = [IO.File]::ReadAllBytes($_.FullName)
        [IO.File]::WriteAllBytes($output, $base + $separator + $overlay)
    } else {
        Copy-Item $_.FullName $output
    }
}
