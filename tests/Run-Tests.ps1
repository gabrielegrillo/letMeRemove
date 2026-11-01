#Requires -Version 7.2
[CmdletBinding()]
param()
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$originalModulePath = $env:PSModulePath
$env:PSModulePath = (Join-Path $PSScriptRoot 'fixtures') + [IO.Path]::PathSeparator + $originalModulePath
$script:passed = 0
function Assert($Condition, [string] $Message) {
    if (-not $Condition) { throw "ASSERTION FAILED: $Message" }
    $script:passed++
}
function Assert-Throws([scriptblock] $Action, [string] $Pattern) {
    $caught = $false
    try { & $Action } catch { $caught = $_.Exception.Message -like $Pattern }
    Assert $caught "Expected error: $Pattern"
}
function Reset-Fixture {
    $global:LmrTest = @{
        Account = 'self@example.test'; Login = @{}; LoginFailure = $false
        FetchFailure = $false; DisconnectFailure = $false; Disconnected = 0
        Calls = [Collections.Generic.List[object]]::new(); FailId = ''
        Teams = @(
            [pscustomobject]@{ DisplayName = 'Same [name]'; GroupId = '00000000-0000-0000-0000-000000000001' }
            [pscustomobject]@{ DisplayName = 'Same [name]'; GroupId = '00000000-0000-0000-0000-000000000002' }
        )
    }
}
try {
    Import-Module (Join-Path $PSScriptRoot 'fixtures/MicrosoftTeams/MicrosoftTeams.psd1') -Force
    $module = Import-Module (Join-Path $PSScriptRoot '../src/LetMeRemove.psd1') -Force -PassThru
    $one = '00000000-0000-0000-0000-000000000001'
    $two = '00000000-0000-0000-0000-000000000002'
    & $module {
        function script:Read-Host {
            param($Prompt)
            if ($script:Answers.Count -eq 0) { throw 'Menu read past supplied input' }
            $script:Answers.Dequeue()
        }
    }
    function Test-Menu([string[]] $Answers, [object[]] $Teams, [int] $PageSize = 1) {
        & $module {
            param($Answers, $Teams, $PageSize)
            $script:Answers = [Collections.Generic.Queue[string]]::new()
            foreach ($answer in $Answers) { $script:Answers.Enqueue($answer) }
            Read-TeamSelection -Teams $Teams -PageSize $PageSize
        } $Answers $Teams $PageSize
    }

    Reset-Fixture
    $selection = @(& $module { ConvertTo-Selection '3,1-2,2' 3 })
    Assert (($selection -join ',') -eq '0,1,2') 'Ranges are validated and deduplicated'
    foreach ($invalid in @('0', '-1', '4', '3-1', '1-9999999999999', 'a', '1,', '1.2', '1-2147483647')) {
        Assert-Throws { & $module { param($text) ConvertTo-Selection $text 3 } $invalid } '*'
    }
    $supported = @{ UseDeviceAuthentication = $true; DisableWAM = $true }
    foreach ($windows in @($true, $false)) {
        $login = & $module { param($w, $s) Get-LoginOptions DeviceCode $w $s ([guid]::Empty) } $windows $supported
        Assert ($login.UseDeviceAuthentication -and -not $login.ContainsKey('DisableWAM')) 'Device login is platform independent'
    }
    $login = & $module { param($s) Get-LoginOptions Browser $false $s ([guid]::Empty) } $supported
    Assert $login.DisableWAM 'Browser login disables Windows broker off Windows'
    $login = & $module { param($s) Get-LoginOptions Browser $true $s ([guid]::Empty) } $supported
    Assert (-not $login.ContainsKey('DisableWAM')) 'Windows browser login retains native broker'
    Assert-Throws { & $module { Get-LoginOptions DeviceCode $false @{} ([guid]::Empty) } } '*Update MicrosoftTeams*'
    Assert-Throws { & $module { Get-LoginOptions Browser $false @{} ([guid]::Empty) } } '*requires DisableWAM*'
    $safe = & $module { ConvertTo-SafeLabel "x`e[31m`ny" }
    Assert ($safe -notmatch '[\p{Cc}\p{Cf}]') 'Remote text cannot inject terminal controls'

    $picked = @(Test-Menu @('p', 'p', 'n', 'n', 'n', '2') $global:LmrTest.Teams)
    Assert ($picked.Count -eq 1 -and $picked[0].GroupId -eq $two) 'Repeated navigation at both boundaries is safe'
    $picked = @(Test-Menu @('/missing', 'n', 'p', '1', '/', '0', '999999999999', '1,2') $global:LmrTest.Teams)
    Assert ($picked.Count -eq 2) 'Empty search, reset and invalid entries recover'
    $picked = @(Test-Menu @('q') @())
    Assert ($picked.Count -eq 0) 'Empty list can be cancelled'
    $picked = @(Test-Menu @('/SAME [NAME]', '2') $global:LmrTest.Teams)
    Assert ($picked[0].GroupId -eq $two) 'Search is literal, case insensitive and preserves IDs'

    Reset-Fixture
    $result = @(Invoke-LetMeRemove -NoBrowser -Interface Plain -GroupId $one,$two -WhatIf)
    Assert (($result.Status -join ',') -eq 'Preview,Preview') 'WhatIf produces structured previews'
    Assert ($global:LmrTest.Calls.Count -eq 0) 'WhatIf never removes membership'
    Assert ($global:LmrTest.Login.UseDeviceAuthentication -and -not $global:LmrTest.Login.WhatIf) 'WhatIf still authenticates using device code'
    Assert ($global:LmrTest.Disconnected -eq 1) 'Preview disconnects'

    Reset-Fixture
    $result = @(Invoke-LetMeRemove -NoBrowser -Interface Plain -GroupId $two,$two -Confirm:$false)
    Assert ($result.Count -eq 1 -and $result[0].Status -eq 'Submitted') 'Duplicate IDs are submitted once'
    Assert ($global:LmrTest.Calls[0].GroupId -eq $two) 'Duplicate team names cannot target the wrong team'
    Assert ($global:LmrTest.Calls[0].User -eq 'self@example.test') 'Only authenticated user can be removed'

    Reset-Fixture
    $global:LmrTest.FailId = $one
    $result = @(Invoke-LetMeRemove -NoBrowser -Interface Plain -GroupId $one,$two -Confirm:$false)
    Assert (($result.Status -join ',') -eq 'Failed,Submitted') 'A nonterminating service error is captured and batch continues'
    Assert ($global:LmrTest.Disconnected -eq 1) 'Partial failure disconnects'

    Reset-Fixture
    Assert-Throws { Invoke-LetMeRemove -NoBrowser -Interface Plain -GroupId $one,'00000000-0000-0000-0000-000000000099' -Confirm:$false } '*No changes made*'
    Assert ($global:LmrTest.Calls.Count -eq 0) 'All IDs are validated before any removal'
    Assert ($global:LmrTest.Disconnected -eq 1) 'Invalid ID disconnects'
    Reset-Fixture
    $result = @(Invoke-LetMeRemove -NoBrowser -Interface Plain -ListOnly)
    Assert ($result.Count -eq 2 -and $global:LmrTest.Calls.Count -eq 0) 'ListOnly has no membership side effects'
    Reset-Fixture
    $global:LmrTest.Teams = @()
    $result = @(Invoke-LetMeRemove -NoBrowser)
    Assert ($result.Count -eq 0 -and $global:LmrTest.Disconnected -eq 1) 'No teams exits cleanly'
    Reset-Fixture
    $global:LmrTest.Teams = @($global:LmrTest.Teams[0])
    $result = @(Invoke-LetMeRemove -NoBrowser -Interface Plain -GroupId $one -Confirm:$false)
    Assert ($result.Count -eq 1) 'Singleton results work under strict mode'
    Reset-Fixture
    $global:LmrTest.Account = ''
    Assert-Throws { Invoke-LetMeRemove -NoBrowser -Interface Plain -ListOnly } '*exactly one account*'
    Assert ($global:LmrTest.Calls.Count -eq 0 -and $global:LmrTest.Disconnected -eq 1) 'Missing account fails closed and disconnects'
    Reset-Fixture
    $global:LmrTest.LoginFailure = $true
    Assert-Throws { Invoke-LetMeRemove -NoBrowser -Interface Plain -ListOnly } '*Sign-in failed*'
    Assert ($global:LmrTest.Disconnected -eq 1) 'Failed authentication attempts cleanup'
    Reset-Fixture
    $global:LmrTest.FetchFailure = $true
    Assert-Throws { Invoke-LetMeRemove -NoBrowser -Interface Plain -ListOnly } '*Fetch failed*'
    Assert ($global:LmrTest.Disconnected -eq 1) 'Failed read disconnects'
    Reset-Fixture
    $global:LmrTest.DisconnectFailure = $true
    $result = @(Invoke-LetMeRemove -NoBrowser -Interface Plain -GroupId $one -Confirm:$false -WarningAction SilentlyContinue)
    Assert ($result[0].Status -eq 'Submitted') 'Cleanup failure does not overwrite successful submission'
    Reset-Fixture
    Assert-Throws { Invoke-LetMeRemove -NoBrowser -Interface Plain -NonInteractive } '*requires -GroupId*'
    Assert-Throws { Invoke-LetMeRemove -NoBrowser -Interface Plain -NonInteractive -GroupId $one } '*requires -Confirm*'
    Assert-Throws { Invoke-LetMeRemove -NoBrowser -Interface Plain -ListOnly -GroupId $one } '*either*'
    Assert ($global:LmrTest.Login.Count -eq 0) 'Invalid options fail before authentication'
    $result = @(Invoke-LetMeRemove -NoBrowser -Interface Plain -NonInteractive -GroupId $one -WhatIf)
    Assert ($result[0].Status -eq 'Preview') 'Noninteractive preview does not prompt'

    Reset-Fixture
    $global:LmrTest.LoginDelayMs = 10000
    $elapsed = [Diagnostics.Stopwatch]::StartNew()
    Assert-Throws { Invoke-LetMeRemove -NoBrowser -Interface Plain -ListOnly -LoginTimeoutSeconds 1 } '*within 1 seconds*'
    Assert ($elapsed.Elapsed.TotalSeconds -lt 5) 'Login deadline stops a waiting authentication call promptly'
    Assert ($global:LmrTest.Disconnected -eq 1 -and $global:LmrTest.Calls.Count -eq 0) 'Timed-out login disconnects without membership changes'

    . (Join-Path $PSScriptRoot 'Test-Terminal.ps1')

    $repository = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
    $child = Join-Path $PSScriptRoot 'Invoke-EntryPoint.ps1'
    $PSNativeCommandUseErrorActionPreference = $false
    foreach ($case in @(
        @{ Name = 'List'; Exit = 0 }, @{ Name = 'Preview'; Exit = 0 },
        @{ Name = 'Remove'; Exit = 0 }, @{ Name = 'PartialFailure'; Exit = 2 },
        @{ Name = 'Invalid'; Exit = 1 }, @{ Name = 'Decline'; Exit = 0 },
        @{ Name = 'PassThru'; Exit = 0 }, @{ Name = 'Demo'; Exit = 0 }
    )) {
        $inputText = switch ($case.Name) { 'Decline' { 'n' }; 'Demo' { 'q' }; default { '' } }
        $output = $inputText | & (Join-Path $PSHOME $(if ($IsWindows) { 'pwsh.exe' } else { 'pwsh' })) -NoProfile -File $child -Repository $repository -Scenario $case.Name 2>&1
        Assert ($LASTEXITCODE -eq $case.Exit) "Entry point $($case.Name): expected $($case.Exit), got $LASTEXITCODE. $output"
        if ($case.Name -eq 'Decline') { Assert (($output -join ' ') -match 'Skipped') 'Declined confirmation is reported as skipped' }
    }
    $nativeShell = Join-Path $PSHOME $(if ($IsWindows) { 'pwsh.exe' } else { 'pwsh' })
    $wait = [Diagnostics.Stopwatch]::StartNew()
    $timeoutOutput = & $nativeShell -NoProfile -File (Join-Path $PSScriptRoot 'Invoke-Supervisor.ps1') -TimeoutSeconds 1 2>&1
    Assert ($LASTEXITCODE -eq 1 -and $wait.Elapsed.TotalSeconds -lt 8) 'Supervisor deadline terminates an uncooperative native login'
    $pidMatch = [regex]::Match(($timeoutOutput -join ' '), 'PID=(\d+)')
    Assert ($pidMatch.Success) 'Blocked authentication ran in its own process'
    $remaining = Get-Process -Id ([int]$pidMatch.Groups[1].Value) -ErrorAction SilentlyContinue
    Assert ($null -eq $remaining) 'A timed-out authentication process is no longer running'
    $previewOutput = 'q' | & $nativeShell -NoProfile -File (Join-Path $repository 'letMeRemove.ps1') -Demo -WhatIf -Interface Plain 2>&1
    Assert ($LASTEXITCODE -eq 0 -and ($previewOutput -join ' ') -match 'Demo closed') 'Supervised preview serializes flags and cleans up even with WhatIf'
    Write-Host "PASS: $script:passed assertions (offline; no Microsoft requests)."
}
finally {
    $env:PSModulePath = $originalModulePath
    Remove-Module LetMeRemove, MicrosoftTeams -ErrorAction SilentlyContinue
    Remove-Variable LmrTest -Scope Global -ErrorAction SilentlyContinue
}
