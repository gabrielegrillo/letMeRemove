#Requires -Version 7.2
<#
.SYNOPSIS
Choose, review and leave your Microsoft Teams from the terminal.
.DESCRIPTION
Signs in through Microsoft's device-code flow by default. Rich terminals get
live search, keyboard selection and animated activity. Plain mode is available
for basic terminals and accessibility. Leaving also removes backing group access.
.PARAMETER Authentication
DeviceCode (default) or Browser. Organizational sign-in policies still apply.
.PARAMETER TenantId
Optional tenant GUID restricting sign-in.
.PARAMETER GroupId
One or more exact team GUIDs, validated against your memberships before changes.
.PARAMETER ListOnly
List your team names and IDs without changing memberships.
.PARAMETER NonInteractive
Skip selection prompts with explicit IDs and WhatIf or Confirm:$false. This does
not make Microsoft authentication unattended. Can also be used with ListOnly.
.PARAMETER Interface
Auto (default), Rich or Plain. Unsupported rich terminals fall back to plain mode.
.PARAMETER NoAnimation
Disable activity spinners while retaining rich styling.
.PARAMETER PassThru
Return structured objects instead of displaying the CLI summary.
.PARAMETER LoginTimeoutSeconds
Maximum sign-in wait, in seconds (default 60). Browser tabs cannot be monitored.
.PARAMETER NoBrowser
Do not open the Microsoft device login page automatically.
.PARAMETER Demo
Try the interface with offline example teams, without Microsoft authentication.
.EXAMPLE
./letMeRemove.ps1 -WhatIf
.EXAMPLE
./letMeRemove.ps1 -GroupId '00000000-0000-0000-0000-000000000000' -Confirm:$false
.EXAMPLE
./letMeRemove.ps1 -Demo
.EXAMPLE
./letMeRemove.ps1 -ListOnly -PassThru | Export-Csv ./my-teams.csv -NoTypeInformation
#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param(
    [ValidateSet('DeviceCode', 'Browser')][string] $Authentication = 'DeviceCode',
    [guid] $TenantId = [guid]::Empty,
    [guid[]] $GroupId,
    [switch] $ListOnly,
    [switch] $NonInteractive,
    [ValidateSet('Auto', 'Rich', 'Plain')][string] $Interface = 'Auto',
    [switch] $NoAnimation,
    [switch] $PassThru,
    [switch] $Demo,
    [switch] $NoBrowser,
    [ValidateRange(1, 900)][int] $LoginTimeoutSeconds = 60,
    [Parameter(DontShow)][switch] $WorkerMode
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
try {
    if (-not [Console]::IsInputRedirected -and -not [Console]::IsOutputRedirected -and $Host.UI.SupportsVirtualTerminal) {
        [Console]::Write("`e[2J`e[H")
    }
    Import-Module (Join-Path $PSScriptRoot 'src/LetMeRemove.psd1') -Force -ErrorAction Stop
    # Dedicated CLI worker: even a blocked native SDK cannot trap the launcher.
    # PassThru stays in-process to preserve actual PowerShell objects in pipelines.
    if (-not $WorkerMode -and -not $PassThru) {
        $launchOptions = @{}
        foreach ($key in $PSBoundParameters.Keys) {
            if ($key -ne 'WorkerMode') {
                $value = $PSBoundParameters[$key]
                $launchOptions[$key] = if ($value -is [System.Management.Automation.SwitchParameter]) { $value.IsPresent } else { $value }
            }
        }
        $launchOptions.LoginTimeoutSeconds = $LoginTimeoutSeconds
        $code = & (Get-Module LetMeRemove) { param($o,$t) Invoke-SupervisedCli -Options $o -LoginTimeoutSeconds $t } $launchOptions $LoginTimeoutSeconds
        exit $code
    }
    if ($Demo) {
        if ($GroupId -or $ListOnly -or $NonInteractive -or $PassThru -or
            $PSBoundParameters.ContainsKey('Authentication') -or $PSBoundParameters.ContainsKey('TenantId')) {
            throw '-Demo only accepts interface, animation and common display options.'
        }
        Invoke-LetMeRemoveDemo -Interface $Interface -NoAnimation:$NoAnimation
        exit 0
    }
    $options = @{}
    foreach ($key in $PSBoundParameters.Keys) {
        if ($key -notin @('Demo', 'PassThru', 'WorkerMode')) { $options[$key] = $PSBoundParameters[$key] }
    }
    $results = @(Invoke-LetMeRemove @options)
    if ($PassThru) { $results }
    else {
        try { Show-LetMeRemoveResult -Results $results -Interface $(if ($NonInteractive) { 'Plain' } else { $Interface }) }
        catch {
            Write-Warning 'Could not render the summary. Showing plain results; no requests will be repeated.'
            $results | Format-Table -AutoSize -Wrap | Out-Host
        }
    }
    if (-not $ListOnly -and @($results | Where-Object Status -EQ 'Failed').Count -gt 0) { exit 2 }
    exit 0
}
catch [OperationCanceledException] {
    Write-Host 'Cancelled.'
    exit 130
}
catch [System.Management.Automation.PipelineStoppedException] { exit 130 }
catch {
    Write-Error -Message $_.Exception.Message -ErrorAction Continue
    exit 1
}
