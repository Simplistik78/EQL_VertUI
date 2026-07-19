<#
.SYNOPSIS
    Builds a RESTORE_ zip containing the stock skin files that a mod zip would overwrite.

.DESCRIPTION
    Maintainer utility. Reads the file list out of a mod zip, copies those same filenames
    from the live skin folder, and writes RESTORE_<modzipname>.zip alongside the mod zip.
    Run this BEFORE installing a mod for the first time, while the skin folder still
    holds stock art.

    Users never run this. Users only extract zips.

.PARAMETER SkinPath
    Path to the skin folder holding the current (stock) assets.

.PARAMETER ModZip
    Path to the mod zip whose file list defines what to capture.

.PARAMETER Force
    Overwrite an existing RESTORE zip.

.EXAMPLE
    .\New-RestoreZip.ps1 -SkinPath 'C:\Users\Public\Games\EQLegends\uifiles\aumaar' `
                         -ModZip   '.\Classic-RoF2-Gems\Classic-RoF2-Gems_Full.zip'
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param
(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $SkinPath,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $ModZip,

    [Parameter(Mandatory = $false)]
    [switch] $Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.IO.Compression.FileSystem

if (-not (Test-Path -LiteralPath $SkinPath -PathType Container))
{
    throw "Skin folder not found: $SkinPath"
}

if (-not (Test-Path -LiteralPath $ModZip -PathType Leaf))
{
    throw "Mod zip not found: $ModZip"
}

$modZipItem  = Get-Item -LiteralPath $ModZip
$restorePath = Join-Path $modZipItem.DirectoryName ("RESTORE_" + $modZipItem.Name)

if ((Test-Path -LiteralPath $restorePath -PathType Leaf) -and -not $Force)
{
    throw "Restore zip already exists: $restorePath. Use -Force to overwrite."
}

# --- Read the mod's file list ---------------------------------------------

$entries = @()
$archive = [System.IO.Compression.ZipFile]::OpenRead($modZipItem.FullName)

try
{
    foreach ($entry in $archive.Entries)
    {
        if (-not [string]::IsNullOrWhiteSpace($entry.Name))
        {
            if ($entry.FullName -ne $entry.Name)
            {
                Write-Warning "Mod zip is not flat: '$($entry.FullName)'. Convention expects files at the zip root."
            }
            $entries += $entry.Name
        }
    }
}
finally
{
    $archive.Dispose()
}

if ($entries.Count -eq 0)
{
    throw "No files found inside $ModZip."
}

# --- Collect the stock copies ---------------------------------------------

$staging = Join-Path ([System.IO.Path]::GetTempPath()) ("restore-" + [System.Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $staging -Force | Out-Null

$missing = @()
$found   = 0

try
{
    foreach ($name in $entries)
    {
        $source = Join-Path $SkinPath $name

        if (Test-Path -LiteralPath $source -PathType Leaf)
        {
            Copy-Item -LiteralPath $source -Destination (Join-Path $staging $name) -Force
            $found++
        }
        else
        {
            $missing += $name
        }
    }

    if ($missing.Count -gt 0)
    {
        Write-Warning "Not present in the skin folder, so not captured:"
        $missing | ForEach-Object { Write-Warning "  $_" }
        Write-Warning "These currently fall back to uifiles\default. Copy the intended stock version"
        Write-Warning "into the skin folder first if the restore zip should carry it."
    }

    if ($found -eq 0)
    {
        throw "None of the mod's files exist in $SkinPath. Nothing to capture."
    }

    if ($PSCmdlet.ShouldProcess($restorePath, 'Create restore zip'))
    {
        if (Test-Path -LiteralPath $restorePath -PathType Leaf)
        {
            Remove-Item -LiteralPath $restorePath -Force
        }

        [System.IO.Compression.ZipFile]::CreateFromDirectory(
            $staging,
            $restorePath,
            [System.IO.Compression.CompressionLevel]::Optimal,
            $false)
    }
}
finally
{
    Remove-Item -LiteralPath $staging -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Restore zip created." -ForegroundColor Green
Write-Host "  Source skin : $SkinPath"
Write-Host "  Mod zip     : $($modZipItem.Name)"
Write-Host "  Captured    : $found of $($entries.Count) file(s)"
Write-Host "  Written to  : $restorePath"
Write-Host ""
