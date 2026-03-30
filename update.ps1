$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$RepoDir = $PSScriptRoot
$ConfigurationDir = Join-Path $RepoDir 'configuration'
$GramFile = Join-Path $ConfigurationDir 'wanxiang-lts-zh-hans.gram'
$VersionFile = Join-Path $RepoDir 'version.md'
$DeleteFilesList = Join-Path $RepoDir 'delete-files.txt'
$GramUrl = 'https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram'

function Invoke-ExternalCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter()]
        [string[]]$ArgumentList = @(),

        [Parameter()]
        [string]$WorkingDirectory = $RepoDir
    )

    Push-Location -LiteralPath $WorkingDirectory
    try {
        & $FilePath @ArgumentList
        if ($LASTEXITCODE -ne 0) {
            throw "Command failed with exit code ${LASTEXITCODE}: $FilePath $($ArgumentList -join ' ')"
        }
    }
    finally {
        Pop-Location
    }
}

if (-not $env:PROJECT_DIR) {
    throw 'PROJECT_DIR environment variable is required.'
}

if (-not $env:WEASEL_DIR) {
    throw 'WEASEL_DIR environment variable is required.'
}

$PlumInstaller = Join-Path $env:PROJECT_DIR 'plum\rime-install.bat'
if (-not (Test-Path -LiteralPath $PlumInstaller)) {
    throw "rime-install.bat not found: $PlumInstaller"
}

Invoke-ExternalCommand -FilePath $PlumInstaller -ArgumentList @('iDvel/rime-ice:others/recipes/full')
Invoke-WebRequest -Uri $GramUrl -OutFile $GramFile

$CurrentTime = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$CurrentMd5 = (Get-FileHash -LiteralPath $GramFile -Algorithm MD5).Hash.ToLowerInvariant()

$OldRows = @()
if (Test-Path -LiteralPath $VersionFile) {
    $OldRows = @(Get-Content -LiteralPath $VersionFile | Where-Object { $_ -match '^\| \d{4}-' })
}

$VersionLines = @(
    '# 更新记录'
    ''
    '| 更新时间 | wanxiang-lts-zh-hans.gram文件MD5 |'
    '| --- | --- |'
    "| $CurrentTime | $CurrentMd5 |"
)

if ($OldRows.Count -gt 0) {
    $VersionLines += $OldRows | Select-Object -First 9
}

Set-Content -LiteralPath $VersionFile -Value $VersionLines -Encoding utf8

if (Test-Path -LiteralPath $DeleteFilesList) {
    Get-Content -LiteralPath $DeleteFilesList |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        ForEach-Object {
            $targetPath = Join-Path $ConfigurationDir $_.Trim()
            if (Test-Path -LiteralPath $targetPath) {
                Remove-Item -LiteralPath $targetPath -Recurse -Force
            }
        }
}

$GitStatus = git -C $RepoDir status --porcelain
if ($LASTEXITCODE -ne 0) {
    throw 'git status failed.'
}

if ($GitStatus) {
    $CurrentBranch = (git -C $RepoDir rev-parse --abbrev-ref HEAD).Trim()
    if ($LASTEXITCODE -ne 0) {
        throw 'git branch detection failed.'
    }

    Invoke-ExternalCommand -FilePath 'git' -ArgumentList @('-C', $RepoDir, 'add', '-A')
    Invoke-ExternalCommand -FilePath 'git' -ArgumentList @('-C', $RepoDir, 'commit', '-m', 'update')
    Invoke-ExternalCommand -FilePath 'git' -ArgumentList @('-C', $RepoDir, 'push', 'origin', $CurrentBranch)
}

