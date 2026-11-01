function Get-TerminalCapabilities {
    try {
        [pscustomobject]@{
            Interactive = $Host.Name -eq 'ConsoleHost' -and $Host.UI.SupportsVirtualTerminal -and
                -not [Console]::IsInputRedirected -and -not [Console]::IsOutputRedirected -and
                $env:TERM -ne 'dumb' -and -not (Test-Path Env:NO_COLOR)
            Width = [Console]::WindowWidth
            Height = [Console]::WindowHeight
        }
    }
    catch { [pscustomobject]@{ Interactive = $false; Width = 0; Height = 0 } }
}

function Initialize-TerminalRenderer {
    if (-not ('LetMeRemove.Terminal.Screen' -as [type])) {
        Add-Type -Path (Join-Path $script:ToolRoot 'src/Terminal/AnsiRenderer.cs') -ErrorAction Stop
    }
}

function New-TerminalUi {
    param([string] $Interface = 'Auto', [switch] $NoAnimation, [switch] $NonInteractive)
    $terminal = Get-TerminalCapabilities
    $rich = $Interface -ne 'Plain' -and -not $NonInteractive -and $terminal.Interactive -and
        $terminal.Width -ge 64 -and $terminal.Height -ge 24
    if ($rich) {
        try { Initialize-TerminalRenderer }
        catch {
            $rich = $false
            Write-Warning 'Native terminal renderer unavailable. Using the numbered menu.'
        }
    }
    elseif ($Interface -eq 'Rich') {
        Write-Warning 'Rich mode needs an interactive ANSI terminal of at least 64 columns by 24 rows, with NO_COLOR unset. Using plain mode.'
    }
    @{ Rich = $rich; Animated = $rich -and -not $NoAnimation }
}

function Get-ToolLogo {
    if (-not (Get-Variable ToolLogo -Scope Script -ErrorAction SilentlyContinue)) {
        $script:ToolLogo = [IO.File]::ReadAllLines((Join-Path $script:ToolRoot 'assets/logo.txt'))
    }
    $script:ToolLogo
}

function Write-SessionLog {
    param([hashtable] $Ui, [string] $Message, [ValidateSet('+', '>', '!')][string] $Mark = '+')
    $safe = ConvertTo-SafeLabel $Message
    if ($Ui.Rich) {
        $color = if ($Mark -eq '!') { "`e[93m" } else { "`e[96m" }
        Write-Host "$color[$Mark]`e[0m $safe"
    }
    else { Write-Host "[$Mark] $safe" }
}

function Write-ToolBanner {
    param([hashtable] $Ui, [switch] $Demo, [switch] $Preview)
    $mode = if ($Demo) { 'DEMO / OFFLINE' } elseif ($Preview) { 'PREVIEW / NO CHANGES' } else { 'YOUR TEAMS / YOUR CHOICE' }
    Write-Host ''
    $colors = @(81, 75, 69, 135, 171)
    $row = 0
    foreach ($line in (Get-ToolLogo)) {
        if ($Ui.Rich) { Write-Host "`e[38;5;$($colors[$row % $colors.Count])m $line`e[0m" }
        else { Write-Host " $line" }
        $row++
    }
    Write-SessionLog -Ui $Ui -Message "letMeRemove 2.2 / $mode"
    Write-Host ''
}

function Invoke-UiActivity {
    param([hashtable] $Ui, [string] $Title, [scriptblock] $Action)
    # Avoid a second progress renderer competing for the same console line.
    $ProgressPreference = 'SilentlyContinue'
    $activity = $null
    if ($Ui.Animated) {
        try {
            Initialize-TerminalRenderer
            $activity = [LetMeRemove.Terminal.Activity]::new((ConvertTo-SafeLabel $Title))
        }
        catch { Write-Verbose 'Animation unavailable; proceeding with the operation once.' }
    }
    if ($null -eq $activity) { Write-SessionLog -Ui $Ui -Message $Title }
    try {
        # Direct execution preserves PowerShell streams, scopes and array semantics.
        Invoke-InterruptibleOperation -Action $Action
        if ($null -ne $activity) { $activity.Finish($true) }
    }
    finally { if ($null -ne $activity) { $activity.Dispose() } }
}

function New-PickerState {
    @{
        Query = ''; Cursor = 0; Selected = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
        Done = $false; Cancelled = $false
        MatchQuery = $null; MatchTeams = $null; MatchItems = @()
    }
}

function Get-PickerMatches {
    param([object[]] $Teams, [hashtable] $State)
    if ($State.MatchQuery -ne $State.Query -or -not [object]::ReferenceEquals($State.MatchTeams, $Teams)) {
        $State.MatchItems = @(foreach ($team in $Teams) {
            if ($team.DisplayName.IndexOf($State.Query, [StringComparison]::OrdinalIgnoreCase) -ge 0) { $team }
        })
        $State.MatchQuery = $State.Query
        $State.MatchTeams = $Teams
    }
    # Return the cached array as one value rather than re-enumerating every team
    # through the PowerShell pipeline on every arrow key.
    return ,$State.MatchItems
}

function Update-PickerState {
    param([hashtable] $State, [object[]] $Teams, [ConsoleKeyInfo] $Key, [int] $PageSize)
    if ($Key.KeyChar -eq [char]3 -or ($Key.Key -eq [ConsoleKey]::C -and ($Key.Modifiers -band [ConsoleModifiers]::Control))) {
        throw [OperationCanceledException]::new('Cancelled by Ctrl+C.')
    }
    $matches = Get-PickerMatches $Teams $State
    $last = [Math]::Max(0, $matches.Count - 1)
    if ($Key.Key -eq [ConsoleKey]::A -and ($Key.Modifiers -band [ConsoleModifiers]::Control)) {
        $allSelected = $Teams.Count -gt 0 -and $State.Selected.Count -eq $Teams.Count
        $State.Selected.Clear()
        if (-not $allSelected) { foreach ($team in $Teams) { [void] $State.Selected.Add([string]$team.GroupId) } }
        return
    }
    switch ($Key.Key) {
        'UpArrow' { $State.Cursor = [Math]::Max(0, $State.Cursor - 1) }
        'DownArrow' { $State.Cursor = [Math]::Min($last, $State.Cursor + 1) }
        'Home' { $State.Cursor = 0 }
        'End' { $State.Cursor = $last }
        'PageUp' { $State.Cursor = [Math]::Max(0, $State.Cursor - $PageSize) }
        'PageDown' { $State.Cursor = [Math]::Min($last, $State.Cursor + $PageSize) }
        'Spacebar' {
            if ($matches.Count) {
                $id = [string] $matches[$State.Cursor].GroupId
                if (-not $State.Selected.Add($id)) { [void] $State.Selected.Remove($id) }
            }
        }
        'Enter' { $State.Done = $true }
        'Escape' { $State.Cancelled = $true }
        'Backspace' {
            if ($State.Query.Length) {
                $elements = [Globalization.StringInfo]::ParseCombiningCharacters($State.Query)
                $State.Query = $State.Query.Substring(0, $elements[-1])
            }
            $State.Cursor = 0
        }
        'Delete' { $State.Query = ''; $State.Cursor = 0 }
        default {
            if (-not [char]::IsControl($Key.KeyChar) -and
                ($Key.Modifiers -band ([ConsoleModifiers]::Control -bor [ConsoleModifiers]::Alt)) -eq 0) {
                if ($State.Query.Length -lt 128) { $State.Query += $Key.KeyChar }
                $State.Cursor = 0
            }
        }
    }
    # Clamp after every transition, including zero matches.
    $visible = Get-PickerMatches $Teams $State
    $State.Cursor = [Math]::Clamp($State.Cursor, 0, [Math]::Max(0, $visible.Count - 1))
}

function Get-PickerLayout {
    param([int] $Width, [int] $Height)
    @{
        Usable = $Width -ge 64 -and $Height -ge 24
        Width = [Math]::Max(40, [Math]::Min(104, $Width - 2))
        Height = [Math]::Max(1, $Height - 1)
        PageSize = [Math]::Max(1, [Math]::Min(10, $Height - 21))
    }
}

function Get-PickerFrame {
    param([object[]] $Teams, [hashtable] $State, [hashtable] $Layout)
    $matches = Get-PickerMatches $Teams $State
    $start = [int][Math]::Floor($State.Cursor / [double]$Layout.PageSize) * $Layout.PageSize
    $width = $Layout.Width
    $reset = "`e[0m"
    $cyan = "`e[96m"
    $muted = "`e[90m"
    $purple = "`e[95m"
    $lines = [Collections.Generic.List[string]]::new()
    $colors = @(81, 75, 69, 135, 171)
    $row = 0
    foreach ($line in (Get-ToolLogo)) {
        $lines.Add("`e[38;5;$($colors[$row % $colors.Count])m $line$reset")
        $row++
    }
    $lines.Add(" $muted" + 'v2.2 / A LITTLE LESS NOISE. A LITTLE MORE FOCUS.' + $reset)
    $lines.Add(" $muted" + ('─' * ($width - 2)) + $reset)
    $lines.Add(" $muted" + '01 SIGN IN   /   ' + $cyan + '02 CHOOSE TEAMS' + $muted + '   /   03 REVIEW' + $reset)
    $lines.Add('')
    $query = if ($State.Query) { $State.Query } else { 'Type a name to filter…' }
    $lines.Add(" ${purple}╭" + ('─' * ($width - 4)) + "╮$reset")
    $lines.Add(" ${purple}│ $cyan" + 'SEARCH  ' + $reset + [LetMeRemove.Terminal.Cells]::Fit($query, $width - 14) + " ${purple}│$reset")
    $lines.Add(" ${purple}╰" + ('─' * ($width - 4)) + "╯$reset")
    $lines.Add(" $muted" + [LetMeRemove.Terminal.Cells]::Fit('    TEAM', $width - 16) + "ID SUFFIX$reset")
    for ($slot = 0; $slot -lt $Layout.PageSize; $slot++) {
        $index = $start + $slot
        if ($index -ge $matches.Count) {
            $empty = if ($slot -eq 0) { '  No matches. Backspace to edit / Delete to reset.' } else { '' }
            $lines.Add("$muted$empty$reset")
            continue
        }
        $team = $matches[$index]
        $active = $index -eq $State.Cursor
        $picked = $State.Selected.Contains([string]$team.GroupId)
        $pointer = if ($active) { '›' } else { ' ' }
        $mark = if ($picked) { '[x]' } else { '[ ]' }
        $id = [string]$team.GroupId
        $suffix = $id.Substring([Math]::Max(0, $id.Length - 8))
        $name = [LetMeRemove.Terminal.Cells]::Fit((ConvertTo-SafeLabel $team.DisplayName), $width - 23)
        $style = if ($active) { "`e[48;5;24m`e[97m" } elseif ($picked) { "`e[92m" } else { "`e[37m" }
        $lines.Add(" $style $pointer $mark $name  …$suffix  $reset")
    }
    $pages = [Math]::Max(1, [int][Math]::Ceiling($matches.Count / [double]$Layout.PageSize))
    $page = [int][Math]::Floor($State.Cursor / [double]$Layout.PageSize) + 1
    $filled = if ($Teams.Count) { [int][Math]::Round(12 * $State.Selected.Count / $Teams.Count) } else { 0 }
    $bar = ('━' * $filled) + ('─' * (12 - $filled))
    $lines.Add('')
    $lines.Add(" $cyan$bar$reset  $($State.Selected.Count) selected / $($matches.Count) matches $muted / $page of $pages$reset")
    $lines.Add(" $cyan" + '↑ ↓ move   Space toggle   Enter review   Esc cancel' + $reset)
    $lines.Add(" $muted" + 'Ctrl+A all / none   Delete clears search' + $reset)
    $lines.Add(" $muted" + 'Selections stay selected across filters. Nothing is sent yet.' + $reset)
    # Clear unused viewport rows after a resize, keeping the terminal's final row
    # untouched so the emulator cannot scroll the alternate screen.
    while ($lines.Count -lt $Layout.Height) { $lines.Add('') }
    $lines.ToArray() | Select-Object -First $Layout.Height
}

function Write-PickerFrame {
    param([object[]] $Teams, [hashtable] $State, [hashtable] $Layout, [object] $Screen, [switch] $Invalidate)
    $lines = [string[]]@(Get-PickerFrame -Teams $Teams -State $State -Layout $Layout)
    $Screen.Render($lines, $Invalidate.IsPresent)
}

function Read-RichTeamSelection {
    param([object[]] $Teams, [hashtable] $Ui)
    $state = New-PickerState
    $previousSize = ''
    $redraw = $true
    $fallback = $false
    $screen = [LetMeRemove.Terminal.Screen]::new()
    $clock = [Diagnostics.Stopwatch]::StartNew()
    $lastFrame = -100L
    $previousControlMode = [Console]::TreatControlCAsInput
    try {
        [Console]::TreatControlCAsInput = $true
        $screen.Open()
        [Console]::Write("`e[?1000h`e[?1006h")
        while (-not $state.Done -and -not $state.Cancelled) {
            $terminal = Get-TerminalCapabilities
            $layout = Get-PickerLayout $terminal.Width $terminal.Height
            if (-not $layout.Usable) { $fallback = $true; break }
            $size = "$($terminal.Width)x$($terminal.Height)"
            $resized = $size -ne $previousSize
            # Drain buffered input first: held keys and pasted searches share one frame.
            $keys = 0
            while ([Console]::KeyAvailable -and $keys -lt 64 -and -not $state.Done -and -not $state.Cancelled) {
                $key = Read-PickerKey
                if ($null -ne $key) { Update-PickerState -State $state -Teams $Teams -Key $key -PageSize $layout.PageSize }
                $redraw = $true
                $keys++
            }
            if (($redraw -or $resized) -and $clock.ElapsedMilliseconds - $lastFrame -ge 33) {
                if ($resized) { $screen.Reset() }
                Write-PickerFrame -Teams $Teams -State $state -Layout $layout -Screen $screen -Invalidate:$resized
                $previousSize = $size
                $lastFrame = $clock.ElapsedMilliseconds
                $redraw = $false
            }
            if (-not $state.Done -and -not $state.Cancelled) { Start-Sleep -Milliseconds 8 }
        }
    }
    catch [OperationCanceledException] { throw }
    catch [System.Management.Automation.PipelineStoppedException] { throw }
    catch {
        $fallback = $true
        Write-Verbose "Interactive picker unavailable: $($_.Exception.Message)"
    }
    finally { [Console]::TreatControlCAsInput = $previousControlMode; [Console]::Write("`e[?1000l`e[?1006l"); $screen.Dispose() }
    if ($fallback) {
        if ($null -ne $Ui) { $Ui.Rich = $false; $Ui.Animated = $false }
        Write-Warning 'Terminal changed or rich selection became unavailable. Restarting selection with the numbered menu.'
        return Read-TeamSelection -Teams $Teams
    }
    if (-not $state.Cancelled) { $Teams | Where-Object { $state.Selected.Contains([string]$_.GroupId) } }
}

function Write-ConsoleCard {
    param([string] $Title, [string[]] $Lines, [string] $Color = "`e[96m")
    $terminal = Get-TerminalCapabilities
    $width = [Math]::Min(100, [Math]::Max(48, $terminal.Width - 4))
    $heading = [LetMeRemove.Terminal.Cells]::Fit((' ' + (ConvertTo-SafeLabel $Title)), $width - 2)
    Write-Host "${Color}╭$heading╮`e[0m"
    foreach ($line in $Lines) {
        foreach ($wrapped in [LetMeRemove.Terminal.Cells]::Wrap((ConvertTo-SafeLabel $line), $width - 4)) {
            Write-Host "${Color}│`e[0m $wrapped ${Color}│`e[0m"
        }
    }
    Write-Host "${Color}╰$('─' * ($width - 2))╯`e[0m"
}

function Write-TeamReview {
    param([hashtable] $Ui, [object[]] $Teams, [string] $Account)
    Write-SessionLog -Ui $Ui -Message "Review $($Teams.Count) selected team(s) / $Account"
    if ($Ui.Rich) {
        Write-ConsoleCard -Title '03 / BEFORE YOU LEAVE' -Color "`e[93m" -Lines @(
            'Leaving also removes access to the backing Microsoft 365 group.'
            'Check the full team IDs before confirming.'
        )
        foreach ($team in $Teams) {
            Write-ConsoleCard -Title $team.DisplayName -Lines @("ID: $($team.GroupId)")
        }
    }
    else {
        Write-Host "`nSelected $($Teams.Count) team(s). Leaving also removes membership in the backing Microsoft 365 group."
        foreach ($team in $Teams) { Write-Host ('  {0} [{1}]' -f (ConvertTo-SafeLabel $team.DisplayName), $team.GroupId) }
    }
}

function Show-LetMeRemoveResult {
    [CmdletBinding()]
    param([object[]] $Results, [ValidateSet('Auto', 'Rich', 'Plain')][string] $Interface = 'Auto')
    if (-not $Results.Count) { return }
    $ui = New-TerminalUi -Interface $Interface -NoAnimation
    if (-not $ui.Rich) { $Results | Format-Table -AutoSize -Wrap | Out-Host; return }
    Write-SessionLog -Ui $ui -Message 'Your session / complete'
    $isResult = $null -ne $Results[0].PSObject.Properties['Status']
    foreach ($result in $Results) {
        if (-not $isResult) { Write-ConsoleCard -Title $result.DisplayName -Lines @("ID: $($result.GroupId)"); continue }
        $color = switch ($result.Status) { 'Submitted' { "`e[92m" }; 'Failed' { "`e[91m" }; 'Preview' { "`e[96m" }; default { "`e[90m" } }
        Write-ConsoleCard -Title "$($result.Status.ToUpperInvariant()) / $($result.Team)" -Color $color -Lines @(
            "ID: $($result.GroupId)"
            $result.Message
        )
    }
    if ($isResult) {
        $failed = @($Results | Where-Object Status -EQ Failed).Count
        $submitted = @($Results | Where-Object Status -EQ Submitted).Count
        Write-SessionLog -Ui $ui -Message "$submitted submitted / $failed failed / $($Results.Count) reviewed"
    }
}

function Read-PickerKey {
    $key = [Console]::ReadKey($true)
    if ($key.Key -ne [ConsoleKey]::Escape) { return $key }
    # A real Escape has no following packet. Give the terminal a short packet window.
    $deadline = [Diagnostics.Stopwatch]::StartNew()
    while (-not [Console]::KeyAvailable -and $deadline.ElapsedMilliseconds -lt 25) { [Threading.Thread]::Sleep(1) }
    if (-not [Console]::KeyAvailable) { return $key }
    $packet = ''
    while ($packet.Length -lt 40) {
        if (-not [Console]::KeyAvailable) { break }
        $part = [Console]::ReadKey($true)
        $packet += $part.KeyChar
        if ($packet -match '^\[<\d+;\d+;\d+[Mm]$') {
            $wheel = ConvertFrom-MousePacket $packet
            if ($null -eq $wheel) { return $null }
            $now = [Environment]::TickCount64
            if ((Get-Variable LastWheelTick -Scope Script -ErrorAction SilentlyContinue) -and
                $script:LastWheelKey -eq $wheel.Key -and $now - $script:LastWheelTick -lt 30) { return $null }
            $script:LastWheelTick = $now
            $script:LastWheelKey = $wheel.Key
            return $wheel
        }
        if ($packet -notmatch '^\[<?[0-9;]*$') { break }
    }
    return $null
}

function ConvertFrom-MousePacket {
    param([string] $Packet)
    if ($Packet -notmatch '^\[<(64|65);\d+;\d+M$') { return $null }
    $direction = if ($Matches[1] -eq '64') { [ConsoleKey]::UpArrow } else { [ConsoleKey]::DownArrow }
    [ConsoleKeyInfo]::new([char]0, $direction, $false, $false, $false)
}
