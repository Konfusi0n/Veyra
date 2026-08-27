[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repoRoot = Split-Path -Parent $PSScriptRoot
$binaryPath = Join-Path $repoRoot 'RootGlass.exe'
$checksumPath = Join-Path $repoRoot 'CHECKSUMS.txt'
$manifestPath = Join-Path $repoRoot 'RELEASE_MANIFEST.json'
$launcherPath = Join-Path $repoRoot 'Veyra.cmd'

function Assert-True {
    param(
        [Parameter(Mandatory)] [bool] $Condition,
        [Parameter(Mandatory)] [string] $Message
    )

    if (-not $Condition) {
        throw $Message
    }
}

foreach ($requiredPath in @($binaryPath, $checksumPath, $manifestPath, $launcherPath)) {
    Assert-True (Test-Path -LiteralPath $requiredPath -PathType Leaf) "Required package file is missing: $requiredPath"
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$checksumLine = (Get-Content -LiteralPath $checksumPath -Raw).Trim()
$checksumMatch = [regex]::Match($checksumLine, '^(?<hash>[0-9a-fA-F]{64})\s+\*?(?<name>[^\r\n]+)$')

Assert-True $checksumMatch.Success 'CHECKSUMS.txt must contain one SHA-256 and one filename.'
Assert-True ($checksumMatch.Groups['name'].Value -eq 'RootGlass.exe') 'CHECKSUMS.txt must bind RootGlass.exe.'
Assert-True ($manifest.binary.path -eq 'RootGlass.exe') 'Manifest binary.path must match the repository package layout.'
Assert-True ($manifest.target.os -eq 'windows') 'Manifest target.os must be windows.'
Assert-True ($manifest.target.architecture -eq 'amd64') 'Manifest target.architecture must be amd64.'
Assert-True ($manifest.mode -eq 'read-only') 'Manifest mode must preserve the declared read-only boundary.'

$binary = Get-Item -LiteralPath $binaryPath
$actualHash = (Get-FileHash -LiteralPath $binaryPath -Algorithm SHA256).Hash.ToLowerInvariant()
$checksumHash = $checksumMatch.Groups['hash'].Value.ToLowerInvariant()
$manifestHash = ([string] $manifest.binary.sha256).ToLowerInvariant()

Assert-True ($binary.Length -eq [int64] $manifest.binary.sizeBytes) "Binary size mismatch: actual $($binary.Length), manifest $($manifest.binary.sizeBytes)."
Assert-True ($actualHash -eq $checksumHash) "Binary SHA-256 does not match CHECKSUMS.txt. Actual: $actualHash"
Assert-True ($actualHash -eq $manifestHash) "Binary SHA-256 does not match RELEASE_MANIFEST.json. Actual: $actualHash"

$bytes = [System.IO.File]::ReadAllBytes($binaryPath)
Assert-True ($bytes.Length -ge 512) 'Binary is too small to be a valid PE file.'
Assert-True ($bytes[0] -eq 0x4D -and $bytes[1] -eq 0x5A) 'Binary does not have an MZ header.'

$peOffset = [BitConverter]::ToInt32($bytes, 0x3C)
Assert-True ($peOffset -gt 0 -and ($peOffset + 24) -lt $bytes.Length) 'PE header offset is invalid.'
Assert-True (
    $bytes[$peOffset] -eq 0x50 -and
    $bytes[$peOffset + 1] -eq 0x45 -and
    $bytes[$peOffset + 2] -eq 0x00 -and
    $bytes[$peOffset + 3] -eq 0x00
) 'Binary does not have a PE signature.'

$machine = [BitConverter]::ToUInt16($bytes, $peOffset + 4)
$optionalHeaderOffset = $peOffset + 24
$optionalMagic = [BitConverter]::ToUInt16($bytes, $optionalHeaderOffset)
$subsystem = [BitConverter]::ToUInt16($bytes, $optionalHeaderOffset + 68)

Assert-True ($machine -eq 0x8664) ('Expected AMD64 machine type 0x8664, got 0x{0:X4}.' -f $machine)
Assert-True ($optionalMagic -eq 0x20B) ('Expected PE32+ optional header 0x020B, got 0x{0:X4}.' -f $optionalMagic)
Assert-True ($subsystem -eq 2) "Expected Windows GUI subsystem 2, got $subsystem."

$signature = Get-AuthenticodeSignature -LiteralPath $binaryPath
Assert-True ($signature.Status -eq 'NotSigned') "Manifest declares an unsigned alpha, but Authenticode status is $($signature.Status)."
Assert-True (-not [bool] $manifest.binary.authenticodeSigned) 'Manifest must declare authenticodeSigned=false for this alpha.'

$receipt = [ordered]@{
    schema = 'veyra.portable-verification.v1'
    commit = $env:GITHUB_SHA
    binary = [ordered]@{
        path = 'RootGlass.exe'
        sizeBytes = $binary.Length
        sha256 = $actualHash
        machine = 'amd64'
        format = 'PE32+'
        subsystem = 'windows-gui'
        authenticode = $signature.Status.ToString()
    }
    package = [ordered]@{
        checksumMatches = $true
        manifestMatches = $true
        compatibilityLauncher = 'Veyra.cmd'
    }
    proofBoundary = @(
        'Verifies package byte identity, declared manifest coherence, PE target, and unsigned status.',
        'Does not verify source provenance, read-only runtime behavior, collector correctness, or live Windows outcomes.'
    )
}

$receiptPath = Join-Path $repoRoot 'portable-verification.json'
$receipt | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $receiptPath -Encoding utf8

Write-Host '[VERIFIED] Portable package identity and PE structure are coherent.'
Write-Host "SHA-256: $actualHash"
Write-Host 'Boundary: package coherence only; source and runtime proof remain separate.'
