# Dot-sourced by Run-Tests.ps1; all examples remain offline.
function Send-PickerKey {
    param($State, $Teams, [ConsoleKey] $Key, [char] $Character = [char]0, [int] $PageSize = 2)
    & $module {
        param($State, $Teams, $Key, $Character, $PageSize)
        $info = [ConsoleKeyInfo]::new($Character, $Key, $false, $false, $false)
        Update-PickerState -State $State -Teams $Teams -Key $info -PageSize $PageSize
    } $State $Teams $Key $Character $PageSize
}
Reset-Fixture
$teams = $global:LmrTest.Teams
$state = & $module { New-PickerState }
foreach ($i in 1..30) { Send-PickerKey $state $teams UpArrow }
Assert ($state.Cursor -eq 0) 'Rich picker clamps movement above the first item'
foreach ($i in 1..30) { Send-PickerKey $state $teams DownArrow }
Assert ($state.Cursor -eq 1) 'Rich picker clamps movement below the last item'
Send-PickerKey $state $teams Spacebar ' '
Assert ($state.Selected.Contains($two)) 'Rich picker selects by full ID'
Send-PickerKey $state $teams Home
Send-PickerKey $state $teams Spacebar ' '
Assert ($state.Selected.Count -eq 2) 'Equal names remain independently selectable'
Send-PickerKey $state $teams X 'x'
Assert ($state.Query -eq 'x' -and $state.Cursor -eq 0 -and $state.Selected.Count -eq 2) 'Search resets focus and retains hidden selections'
Send-PickerKey $state $teams Spacebar ' '
Assert ($state.Selected.Count -eq 2) 'Space on empty matches is safe'
Send-PickerKey $state $teams End
Send-PickerKey $state $teams PageDown
Assert ($state.Cursor -eq 0) 'Empty-match navigation is bounded'
Send-PickerKey $state $teams Backspace
Assert ($state.Query -eq '') 'Backspace edits live search'
Send-PickerKey $state $teams PageDown
Assert ($state.Cursor -eq 1) 'PageDown clamps to the last result'
Send-PickerKey $state $teams PageUp
Assert ($state.Cursor -eq 0) 'PageUp clamps to the first result'
Send-PickerKey $state $teams End
Send-PickerKey $state $teams Spacebar ' '
Assert ($state.Selected.Count -eq 1 -and -not $state.Selected.Contains($two)) 'Selection toggles off by ID'
Send-PickerKey $state $teams A 'a'
Send-PickerKey $state $teams Delete
Assert ($state.Query -eq '') 'Delete clears live search'
Send-PickerKey $state $teams Enter
Assert $state.Done 'Enter finishes selection'
$state = & $module { New-PickerState }
Send-PickerKey $state @() Escape
Assert $state.Cancelled 'Escape cancels empty rich selection'
$state = & $module { New-PickerState }
$state.Query = 'ab😀'
Send-PickerKey $state $teams Backspace
Assert ($state.Query -eq 'ab') 'Backspace removes a complete Unicode text element'
foreach ($i in 1..150) { Send-PickerKey $state $teams A 'a' }
Assert ($state.Query.Length -le 128) 'Search input is bounded'
$small = & $module { Get-PickerLayout 63 23 }
$minimum = & $module { Get-PickerLayout 64 24 }
$large = & $module { Get-PickerLayout 240 80 }
Assert (-not $small.Usable) 'Small terminals use fallback'
Assert ($minimum.Usable -and $minimum.PageSize -le 4) 'Minimum viewport reserves room for controls'
Assert ($large.Width -le 104 -and $large.PageSize -eq 10) 'Large terminals keep a readable layout'
$ui = & $module { New-TerminalUi -Interface Plain }
Assert (-not $ui.Rich -and -not $ui.Animated) 'Plain mode disables styling and animation'
$ui = & $module { New-TerminalUi -NonInteractive -Interface Rich } 3>$null
Assert (-not $ui.Rich) 'Noninteractive mode never opens a rich picker'

# The bundled .NET renderer is tested without a terminal or external packages.
& $module { Initialize-TerminalRenderer; $script:ActivityCalls = 0 }
Assert-Throws {
    & $module {
        Invoke-UiActivity -Ui @{ Rich = $true; Animated = $true } -Title 'Test' -Action {
            $script:ActivityCalls++
            throw 'Operation failed'
        }
    }
} '*Operation failed*'
$calls = & $module { $script:ActivityCalls }
Assert ($calls -eq 1) 'An animated operation is never retried after failure'
$animated = @(& $module {
    Invoke-UiActivity -Ui @{ Rich = $true; Animated = $true } -Title 'Offline renderer test' -Action {
        [pscustomobject]@{ GroupId = 'first' }
        [pscustomobject]@{ GroupId = 'second' }
    }
})
Assert ($animated.Count -eq 2 -and $animated[0].GroupId -eq 'first') 'Animated output remains a flat sequence of teams'

$screen = [LetMeRemove.Terminal.Screen]::new()
$first = $screen.BuildPatch(@('Header', 'First', 'Second'), $false)
$unchanged = $screen.BuildPatch(@('Header', 'First', 'Second'), $false)
$changed = $screen.BuildPatch(@('Header', 'FOCUSED', 'Second'), $false)
Assert ($unchanged.Length -eq 0) 'Idle frames produce no terminal writes'
Assert (-not $changed.Contains("`e[2J") -and -not $changed.Contains('Header') -and -not $changed.Contains('Second')) 'Navigation patches never clear the screen or redraw unchanged lines'
Assert ($changed.Contains("`e[2;1H")) 'Only the changed row is addressed'
$removed = $screen.BuildPatch(@('Header'), $false)
Assert ($removed.Contains("`e[2;1H") -and $removed.Contains("`e[3;1H")) 'Removed rows are erased when the view gets shorter'

$state = & $module { New-PickerState }
$layout = & $module { Get-PickerLayout 80 30 }
$frame = [string[]]@(& $module { param($t, $s, $l) Get-PickerFrame $t $s $l } $teams $state $layout)
$screen.Reset()
$initial = $screen.BuildPatch($frame, $false)
Send-PickerKey $state $teams DownArrow
$nextFrame = [string[]]@(& $module { param($t, $s, $l) Get-PickerFrame $t $s $l } $teams $state $layout)
$patch = $screen.BuildPatch($nextFrame, $false)
$rowsChanged = [regex]::Matches($patch, '\x1b\[\d+;1H').Count
Assert ($rowsChanged -eq 2) 'Moving focus changes exactly two rows, not the whole interface'
Assert ($patch.Length -lt $initial.Length / 3) 'Focus updates send substantially less data than a full frame'
$minimumFrame = @(& $module { param($t, $s) Get-PickerFrame $t $s (Get-PickerLayout 64 24) } $teams $state)
Assert ($minimumFrame.Count -eq 23) 'The minimum viewport reserves the last terminal row'
foreach ($line in $minimumFrame) {
    $text = [regex]::Replace($line, '\x1b\[[0-9;]*m', '')
    $cellCount = 0
    $elements = [Globalization.StringInfo]::GetTextElementEnumerator($text)
    while ($elements.MoveNext()) { $cellCount += [LetMeRemove.Terminal.Cells]::ElementWidth($elements.GetTextElement()) }
    Assert ($cellCount -lt 64) 'Every row fits without terminal wrapping'
}
Assert ([LetMeRemove.Terminal.Cells]::Fit('中文abc', 5).TrimEnd() -eq '中文…') 'CJK labels are clipped by display cells'
Assert ([LetMeRemove.Terminal.Cells]::Fit('a😀bc', 3).TrimEnd() -eq 'a…') 'Clipping never splits a surrogate pair'
Assert ([LetMeRemove.Terminal.Cells]::ElementWidth('❤️') -eq 2) 'Emoji presentation consumes two terminal cells'
$wrapped = [LetMeRemove.Terminal.Cells]::Wrap('abcdefgh', 3)
Assert (($wrapped -join '|') -eq 'abc|def|gh ') 'Result details wrap without losing text'

Reset-Fixture
$savedUi = & $module { ${function:New-TerminalUi} }
try {
    & $module {
        function script:New-TerminalUi {
            param($Interface, [switch] $NoAnimation, [switch] $NonInteractive)
            @{ Rich = $true; Animated = -not $NoAnimation }
        }
    }
    $result = @(Invoke-LetMeRemove -NoBrowser -GroupId $two -Confirm:$false)
    Assert ($result.Count -eq 1 -and $global:LmrTest.Calls.Count -eq 1) 'Animated fetch cannot broaden an explicit single-team selection'
    Assert ($global:LmrTest.Calls[0].GroupId -eq $two -and $global:LmrTest.Calls[0].User -eq 'self@example.test') 'Animated removal retains the exact authenticated target'
    Reset-Fixture
    $global:LmrTest.FailId = $one
    $result = @(Invoke-LetMeRemove -NoBrowser -GroupId $one,$two -Confirm:$false)
    Assert (($result.Status -join ',') -eq 'Failed,Submitted') 'Animated batch captures errors and continues correctly'
    Assert ($global:LmrTest.Calls.Count -eq 2 -and $global:LmrTest.Disconnected -eq 1) 'Animated batch executes each request once and disconnects'
    $leaks = @(Show-LetMeRemoveResult -Results $result)
    Assert ($leaks.Count -eq 0) 'Native summary emits no success-stream objects'
}
finally {
    & $module { param($Original) Set-Item Function:script:New-TerminalUi -Value $Original } $savedUi
}
$leaks = @(& $module { param($t) Write-TeamReview -Ui @{ Rich = $true } -Teams $t -Account 'self[red]@example.test' } $teams)
Assert ($leaks.Count -eq 0) 'Native review emits no success-stream objects and treats markup literally'
$state = & $module { New-PickerState }
$state.Query = 'not found'
$allKey = [ConsoleKeyInfo]::new([char]1, [ConsoleKey]::A, $false, $false, $true)
& $module { param($s,$t,$k) Update-PickerState $s $t $k 2 } $state $teams $allKey
Assert ($state.Selected.Count -eq $teams.Count) 'Ctrl+A selects every team, including filtered-out teams'
& $module { param($s,$t,$k) Update-PickerState $s $t $k 2 } $state $teams $allKey
Assert ($state.Selected.Count -eq 0) 'Ctrl+A toggles the complete selection off'
$wheel = & $module { ConvertFrom-MousePacket '[<65;20;10M' }
Assert ($wheel.Key -eq [ConsoleKey]::DownArrow) 'Mouse wheel down maps to one item rather than a page'
$wheel = & $module { ConvertFrom-MousePacket '[<64;20;10M' }
Assert ($wheel.Key -eq [ConsoleKey]::UpArrow) 'Mouse wheel up maps to one item'
$wheel = & $module { ConvertFrom-MousePacket '[<0;20;10M' }
Assert ($null -eq $wheel) 'Mouse clicks cannot trigger selection or removal'
$loginOutput = & $module {
    Write-DeviceLoginMessage ([System.Management.Automation.WarningRecord]::new('To sign in, use a browser and enter the code ABC123XYZ to authenticate.'))
} 6>&1
Assert (([string]$loginOutput).Contains('Login code: ABC123XYZ') -and -not ([string]$loginOutput).Contains('browser')) 'Official device instruction is reduced to the real code'

$cancelKey = [ConsoleKeyInfo]::new([char]3, [ConsoleKey]::C, $false, $false, $true)
Assert-Throws { & $module { param($s,$t,$k) Update-PickerState $s $t $k 2 } $state $teams $cancelKey } '*Cancelled by Ctrl+C*'
