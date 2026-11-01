function Get-LoginOptions {
    param([string] $Authentication, [bool] $Windows, [System.Collections.IDictionary] $Supported, [guid] $TenantId)
    $options = @{ ErrorAction = 'Stop' }
    if ($TenantId -ne [guid]::Empty) { $options.TenantId = $TenantId.ToString() }
    if ($Authentication -eq 'DeviceCode') {
        if (-not $Supported.ContainsKey('UseDeviceAuthentication')) {
            throw 'Update MicrosoftTeams: device-code authentication is unavailable in this version.'
        }
        $options.UseDeviceAuthentication = $true
    }
    elseif (-not $Windows) {
        if (-not $Supported.ContainsKey('DisableWAM')) {
            throw 'Browser authentication on this platform requires DisableWAM. Use -Authentication DeviceCode or update MicrosoftTeams.'
        }
        $options.DisableWAM = $true
    }
    return $options
}

function Open-LoginPage {
    $url = 'https://microsoft.com/devicelogin'
    try {
        if ($IsWindows) { $null = Start-Process -FilePath $url -ErrorAction Stop }
        else {
            $start = [Diagnostics.ProcessStartInfo]::new()
            $start.FileName = if ($IsMacOS) { '/usr/bin/open' } else { 'xdg-open' }
            $start.ArgumentList.Add($url)
            $start.UseShellExecute = $false
            $start.RedirectStandardError = $true
            $start.RedirectStandardOutput = $true
            $process = [Diagnostics.Process]::Start($start)
            $null = $process.StandardError.ReadToEndAsync()
            $null = $process.StandardOutput.ReadToEndAsync()
            if ($process.WaitForExit(1000) -and $process.ExitCode -ne 0) { throw 'Browser launch failed.' }
        }
    }
    catch { Write-Warning "Open $url in a browser to complete sign-in." }
}

function Write-DeviceLoginMessage {
    param([object] $Record)
    $text = [string] $Record
    # The module owns device-code authentication; do not invent or persist codes.
    if ($text -cmatch '\bcode\s+([A-Z0-9]{6,16})\b') {
        Write-Host "`nLogin code: $($Matches[1])`n"
    }
    elseif ($Record -is [System.Management.Automation.WarningRecord]) { Write-Warning $text }
    else { Write-Host (ConvertTo-SafeLabel $text) }
}

function Invoke-BoundedLogin {
    param([hashtable] $Options, [int] $TimeoutSeconds)
    if (-not ('LetMeRemove.Terminal.LoginGuard' -as [type])) {
        Add-Type -Path (Join-Path $script:ToolRoot 'src/Terminal/LoginGuard.cs') -ErrorAction Stop
    }
    $pipeline = [powershell]::Create([System.Management.Automation.RunspaceMode]::CurrentRunspace)
    $guard = $null
    try {
        $null = $pipeline.AddScript('param($options) MicrosoftTeams\Connect-MicrosoftTeams @options -WhatIf:$false -Confirm:$false').AddArgument($Options)
        $guard = [LetMeRemove.Terminal.LoginGuard]::new($pipeline, $TimeoutSeconds)
        try { $result = $pipeline.Invoke() }
        catch {
            if ($guard.Cancelled) { throw [OperationCanceledException]::new('Cancelled by Ctrl+C.') }
            if ($guard.TimedOut) { throw [TimeoutException]::new("Login was not completed within $TimeoutSeconds seconds. Run the tool again to request a new code.") }
            throw
        }
        if ($guard.Cancelled) { throw [OperationCanceledException]::new('Cancelled by Ctrl+C.') }
        if ($guard.TimedOut) { throw [TimeoutException]::new("Login was not completed within $TimeoutSeconds seconds.") }
        if ($pipeline.HadErrors) { throw $pipeline.Streams.Error[0].Exception }
        $result
    }
    finally {
        if ($null -ne $guard) { $guard.Dispose() }
        $pipeline.Dispose()
    }
}

function Invoke-InterruptibleOperation {
    param([scriptblock] $Action)
    if (-not ('LetMeRemove.Terminal.LoginGuard' -as [type])) {
        Add-Type -Path (Join-Path $script:ToolRoot 'src/Terminal/LoginGuard.cs') -ErrorAction Stop
    }
    $pipeline = [powershell]::Create([System.Management.Automation.RunspaceMode]::CurrentRunspace)
    $guard = $null
    try {
        $null = $pipeline.AddScript('param($action) & $action').AddArgument($Action)
        $guard = [LetMeRemove.Terminal.LoginGuard]::new($pipeline, 0)
        try { $result = $pipeline.Invoke() }
        catch {
            if ($guard.Cancelled) { throw [OperationCanceledException]::new('Cancelled. A request already sent to Microsoft may still complete.') }
            throw
        }
        if ($guard.Cancelled) { throw [OperationCanceledException]::new('Cancelled. A request already sent to Microsoft may still complete.') }
        if ($pipeline.HadErrors) { throw $pipeline.Streams.Error[0].Exception }
        $result
    }
    finally {
        if ($null -ne $guard) { $guard.Dispose() }
        $pipeline.Dispose()
    }
}
