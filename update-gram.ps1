$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$RepoDir = $PSScriptRoot
$ConfigurationDir = Join-Path $RepoDir 'configuration'
$GramFile = Join-Path $ConfigurationDir 'wanxiang-lts-zh-hans.gram-new'
$GramUrl = 'https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram'
$GramProxy = 'http://127.0.0.1:1081'

Invoke-WebRequest -Uri $GramUrl -OutFile $GramFile -Proxy $GramProxy
