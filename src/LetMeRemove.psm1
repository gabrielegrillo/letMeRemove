Set-StrictMode -Version Latest
$script:ToolRoot = Split-Path $PSScriptRoot -Parent

foreach ($file in @('Text', 'Authentication', 'Selection', 'Terminal', 'Supervisor')) {
    . (Join-Path $PSScriptRoot "Private/$file.ps1")
}

function Invoke-LetMeRemove {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [ValidateSet('DeviceCode', 'Browser')][string] $Authentication = 'DeviceCode',
        [guid] $TenantId = [guid]::Empty,
        [guid[]] $GroupId,
        [switch] $ListOnly,
        [switch] $NonInteractive,
        [ValidateSet('Auto', 'Rich', 'Plain')][string] $Interface = 'Auto',
        [switch] $NoAnimation,
        [switch] $NoBrowser,
    [ValidateRange(1, 900)][int] $LoginTimeoutSeconds = 60
    )
    $ErrorActionPreference = 'Stop'
    if ($ListOnly -and $GroupId) { throw 'Use either -ListOnly or -GroupId.' }
    if ($NonInteractive -and -not $ListOnly -and -not $GroupId) { throw '-NonInteractive requires -GroupId or -ListOnly.' }
    if ($NonInteractive -and -not $ListOnly -and -not $WhatIfPreference -and
        (-not $PSBoundParameters.ContainsKey('Confirm') -or $PSBoundParameters['Confirm'])) {
        throw '-NonInteractive requires -Confirm:$false for removal, or -WhatIf for a preview. Authentication still requires user sign-in.'
    }
    $ui = New-TerminalUi -Interface $Interface -NoAnimation:$NoAnimation -NonInteractive:$NonInteractive
    Write-ToolBanner -Ui $ui -Preview:$WhatIfPreference
    if (-not (Get-Module -ListAvailable -Name MicrosoftTeams)) {
        throw 'MicrosoftTeams is missing. Install explicitly: Install-Module MicrosoftTeams -Scope CurrentUser -Repository PSGallery'
    }
    Import-Module MicrosoftTeams -ErrorAction Stop
    $command = Get-Command MicrosoftTeams\Connect-MicrosoftTeams -ErrorAction Stop | Select-Object -First 1
    $login = Get-LoginOptions -Authentication $Authentication -Windows $IsWindows -Supported $command.Parameters -TenantId $TenantId
    $connectionAttempted = $false
    try {
        Write-SessionLog -Ui $ui -Message "Trying to log in ($Authentication)."
        if ($Authentication -eq 'DeviceCode') {
            if (-not $NoBrowser -and -not $NonInteractive) { Open-LoginPage }
        }
        else { Write-SessionLog -Ui $ui -Mark '>' -Message 'Complete the Microsoft sign-in prompt.' }
        $connectionAttempted = $true
        # WhatIf applies to membership changes, never to authentication or reads.
        Write-SessionLog -Ui $ui -Message "Complete sign-in within $LoginTimeoutSeconds seconds."
        Set-LoginStage 'login'
        $session = @(Invoke-BoundedLogin -Options $login -TimeoutSeconds $LoginTimeoutSeconds)
        Set-LoginStage 'ready'
        $accounts = @($session | ForEach-Object { $_.Account } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique)
        if ($accounts.Count -ne 1) { throw 'Sign-in did not return exactly one account; no memberships were changed.' }
        $account = [string] $accounts[0]
        Write-SessionLog -Ui $ui -Message "Signed in as: $account"
        $teams = @(Invoke-UiActivity -Ui $ui -Title 'Finding your teams…' -Action ({
            MicrosoftTeams\Get-Team -User $account -ErrorAction Stop | Sort-Object DisplayName, GroupId
        }.GetNewClosure()))
        if ($ListOnly) {
            return $teams | Select-Object @{ Name = 'DisplayName'; Expression = { ConvertTo-SafeLabel $_.DisplayName } }, GroupId
        }
        if ($GroupId) {
            $selected = @(
                foreach ($id in ($GroupId | Select-Object -Unique)) {
                    $match = @($teams | Where-Object { $_.GroupId -eq $id.ToString() })
                    if ($match.Count -ne 1) { throw "Team $id is not uniquely present in this account's memberships. No changes made." }
                    $match[0]
                }
            )
        }
        else {
            if ($teams.Count -eq 0) { Write-Host 'No teams found for this account.'; return }
            $selected = @(if ($ui.Rich) { Read-RichTeamSelection -Teams $teams -Ui $ui } else { Read-TeamSelection -Teams $teams })
        }
        if ($selected.Count -eq 0) { Write-Host 'No teams selected.'; return }
        Write-TeamReview -Ui $ui -Teams $selected -Account $account
        $completed = 0
        foreach ($team in $selected) {
            $status = 'Skipped'
            $message = 'Not confirmed.'
            $target = '{0} / {1} [{2}]' -f (ConvertTo-SafeLabel $account), (ConvertTo-SafeLabel $team.DisplayName), $team.GroupId
            if ($PSCmdlet.ShouldProcess($target, 'Remove your team and Microsoft 365 group membership')) {
                try {
                    $null = Invoke-UiActivity -Ui $ui -Title "Leaving $($completed + 1)/$($selected.Count): $($team.DisplayName)" -Action ({
                        MicrosoftTeams\Remove-TeamUser -GroupId $team.GroupId -User $account -ErrorAction Stop
                    }.GetNewClosure())
                    $status = 'Submitted'
                    $message = 'Removal request accepted. Teams may take up to an hour to reflect the change.'
                }
                catch [OperationCanceledException] { throw }
                catch [System.Management.Automation.PipelineStoppedException] { throw }
                catch {
                    $status = 'Failed'
                    $message = ConvertTo-SafeLabel $_.Exception.Message
                }
            }
            elseif ($WhatIfPreference) { $status = 'Preview'; $message = 'No change made.' }
            $completed++
            [pscustomobject]@{
                Team = ConvertTo-SafeLabel $team.DisplayName
                GroupId = [string] $team.GroupId
                Status = $status
                Message = $message
            }
        }
    }
    finally {
        if ($connectionAttempted) {
            try { $null = MicrosoftTeams\Disconnect-MicrosoftTeams -ErrorAction Stop -WhatIf:$false -Confirm:$false }
            catch { Write-Warning ('Could not disconnect: {0}' -f (ConvertTo-SafeLabel $_.Exception.Message)) }
        }
    }
}

function Invoke-LetMeRemoveDemo {
    [CmdletBinding()]
    param(
        [ValidateSet('Auto', 'Rich', 'Plain')][string] $Interface = 'Auto',
        [switch] $NoAnimation
    )
    $ui = New-TerminalUi -Interface $Interface -NoAnimation:$NoAnimation
    Write-ToolBanner -Ui $ui -Demo
    Write-Host 'Demo data only. No Microsoft account, connection or membership changes.'
    $names = @('Design Studio', 'Engineering', 'Company Announcements', 'Product Launch',
        'Research & Development', 'Community', 'Operations', 'Design Studio',
        'Learning Lab', 'Events', 'Customer Success', 'Platform', 'Finance',
        'Marketing', 'Archive 2024', 'Archive 2025', 'People', 'Volunteers')
    $teams = @(for ($i = 0; $i -lt $names.Count; $i++) {
        [pscustomobject]@{ DisplayName = $names[$i]; GroupId = ('00000000-0000-0000-0000-{0:000000000000}' -f ($i + 1)) }
    })
    $selected = @(if ($ui.Rich) { Read-RichTeamSelection -Teams $teams -Ui $ui } else { Read-TeamSelection -Teams $teams })
    if (-not $selected.Count) { Write-Host 'Demo closed. No teams selected.'; return }
    Write-TeamReview -Ui $ui -Teams $selected -Account 'you@example.test'
    $results = @($selected | ForEach-Object {
        [pscustomobject]@{ Team = $_.DisplayName; GroupId = $_.GroupId; Status = 'Preview'; Message = 'Demo only. No change made.' }
    })
    Show-LetMeRemoveResult -Results $results -Interface $Interface
}

Export-ModuleMember -Function Invoke-LetMeRemove, Invoke-LetMeRemoveDemo, Show-LetMeRemoveResult
