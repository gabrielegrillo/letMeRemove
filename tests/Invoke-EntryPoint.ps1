# Child-process harness: loads only the offline MicrosoftTeams fixture.
param([string] $Repository, [string] $Scenario, [string] $Interface = 'Plain', [ValidateRange(0, 30000)][int] $ServiceDelayMs = 0, [int] $LoginDelayMs = 0)
$ErrorActionPreference = 'Stop'
$env:PSModulePath = (Join-Path $PSScriptRoot 'fixtures') + [IO.Path]::PathSeparator + $env:PSModulePath
Import-Module (Join-Path $PSScriptRoot 'fixtures/MicrosoftTeams/MicrosoftTeams.psd1') -Force
$one = '00000000-0000-0000-0000-000000000001'
$two = '00000000-0000-0000-0000-000000000002'
$global:LmrTest = @{
    Account = 'self@example.test'; Login = @{}; LoginFailure = $false
    FetchFailure = $false; DisconnectFailure = $false; Disconnected = 0
    Calls = [Collections.Generic.List[object]]::new(); FailId = ''; DelayMs = $ServiceDelayMs; LoginDelayMs = $LoginDelayMs
    Teams = @(
        [pscustomobject]@{ DisplayName = 'One'; GroupId = $one }
        [pscustomobject]@{ DisplayName = 'Two'; GroupId = $two }
    )
}
$entry = Join-Path $Repository 'letMeRemove.ps1'
$global:LASTEXITCODE = 0
$display = @{ Interface = $Interface; NoBrowser = $true; WorkerMode = $true }
switch ($Scenario) {
    'List' { & $entry -ListOnly @display }
    'Preview' { & $entry -GroupId $one -WhatIf -NonInteractive @display }
    'Remove' { & $entry -GroupId $one -Confirm:$false @display }
    'PassThru' {
        $results = @(& $entry -GroupId $one -WhatIf -PassThru @display)
        if ($results.Count -ne 1 -or $results[0].Status -ne 'Preview') { throw 'Invalid structured output' }
    }
    'Demo' {
        & $entry -Demo @display
        if ($global:LmrTest.Login.Count -ne 0 -or $global:LmrTest.Calls.Count -ne 0) { throw 'Demo accessed service' }
        exit 0
    }
    'Decline' { & $entry -GroupId $one -Confirm:$true @display }
    'PartialFailure' {
        $global:LmrTest.FailId = $one
        & $entry -GroupId $one,$two -Confirm:$false @display
    }
    'Invalid' { & $entry -GroupId '00000000-0000-0000-0000-000000000099' -WhatIf @display }
    default { throw 'Unknown test scenario' }
}
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
if ($Scenario -in @('List', 'Preview', 'Decline') -and $global:LmrTest.Calls.Count -ne 0) { throw 'Unexpected removal' }
if ($Scenario -eq 'Remove' -and $global:LmrTest.Calls.Count -ne 1) { throw 'Expected one removal' }
if ($global:LmrTest.Disconnected -ne 1) { throw 'Expected cleanup' }
