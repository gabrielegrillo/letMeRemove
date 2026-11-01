# Internal CLI process entry point. No authentication state leaves this process.
param([Parameter(Mandatory)][string] $ConfigurationPath)
$ErrorActionPreference = 'Stop'
$config = Import-Clixml -LiteralPath $ConfigurationPath
$options = $config.Options
& (Join-Path $PSScriptRoot '../letMeRemove.ps1') @options -WorkerMode
exit $LASTEXITCODE
