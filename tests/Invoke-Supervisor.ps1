param([int] $TimeoutSeconds = 60)
$ErrorActionPreference = 'Stop'
Add-Type -Path (Join-Path $PSScriptRoot '../src/Terminal/CliSupervisor.cs')
$stage = [IO.Path]::GetTempFileName()
try {
    $executable = Join-Path $PSHOME $(if ($IsWindows) { 'pwsh.exe' } else { 'pwsh' })
    $code = [LetMeRemove.Terminal.CliSupervisor]::Run($executable, @(
        '-NoProfile', '-File', (Join-Path $PSScriptRoot 'fixtures/BlockedLogin.ps1')
    ), $stage, $TimeoutSeconds)
    exit $code
}
finally { Remove-Item -LiteralPath $stage -Force }
