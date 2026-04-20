$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$RepoDir = $PSScriptRoot
$ConfigurationDir = Join-Path $RepoDir 'configuration'
$GramFile = Join-Path $ConfigurationDir 'wanxiang-lts-zh-hans.gram'
$GramUrl = 'https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram'

Invoke-WebRequest -Uri $GramUrl -OutFile $GramFile
