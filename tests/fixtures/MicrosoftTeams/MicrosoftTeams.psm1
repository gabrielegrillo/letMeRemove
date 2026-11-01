# Offline fixture. Never authenticates or sends requests.
function Connect-MicrosoftTeams {
    [CmdletBinding(SupportsShouldProcess)]
    param([switch] $UseDeviceAuthentication, [switch] $DisableWAM, [string] $TenantId)
    if ($global:LmrTest.ContainsKey('LoginDelayMs')) { Start-Sleep -Milliseconds $global:LmrTest.LoginDelayMs }
    $global:LmrTest.Login = @{} + $PSBoundParameters
    if ($global:LmrTest.LoginFailure) { throw 'Sign-in failed' }
    [pscustomobject]@{ Account = $global:LmrTest.Account }
}
function Get-Team {
    [CmdletBinding()]
    param([string] $User)
    if ($global:LmrTest.ContainsKey('DelayMs') -and $global:LmrTest.DelayMs -gt 0) {
        Start-Sleep -Milliseconds $global:LmrTest.DelayMs
    }
    if ($global:LmrTest.FetchFailure) { throw 'Fetch failed' }
    $global:LmrTest.Teams
}
function Remove-TeamUser {
    [CmdletBinding()]
    param([string] $GroupId, [string] $User)
    if ($global:LmrTest.ContainsKey('DelayMs') -and $global:LmrTest.DelayMs -gt 0) {
        Start-Sleep -Milliseconds $global:LmrTest.DelayMs
    }
    $global:LmrTest.Calls.Add(@{ GroupId = $GroupId; User = $User })
    if ($GroupId -eq $global:LmrTest.FailId) { Write-Error 'Forbidden by tenant policy' }
}
function Disconnect-MicrosoftTeams {
    [CmdletBinding(SupportsShouldProcess)]
    param()
    $global:LmrTest.Disconnected++
    if ($global:LmrTest.DisconnectFailure) { throw 'Disconnect failed' }
}
