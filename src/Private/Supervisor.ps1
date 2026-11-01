function Invoke-SupervisedCli {
    param([hashtable] $Options, [int] $LoginTimeoutSeconds)
    if (-not ('LetMeRemove.Terminal.CliSupervisor' -as [type])) {
        Add-Type -Path (Join-Path $script:ToolRoot 'src/Terminal/CliSupervisor.cs') -ErrorAction Stop
    }
    $configuration = [IO.Path]::GetTempFileName()
    $stage = [IO.Path]::GetTempFileName()
    try {
        @{ Options = $Options } | Export-Clixml -LiteralPath $configuration -WhatIf:$false -Confirm:$false
        $executable = Join-Path $PSHOME $(if ($IsWindows) { 'pwsh.exe' } else { 'pwsh' })
        [LetMeRemove.Terminal.CliSupervisor]::Run($executable, @(
            '-NoProfile', '-File', (Join-Path $script:ToolRoot 'src/Invoke-Worker.ps1'), $configuration
        ), $stage, $LoginTimeoutSeconds)
    }
    finally {
        Remove-Item -LiteralPath $configuration, $stage -Force -WhatIf:$false -Confirm:$false -ErrorAction SilentlyContinue
    }
}

function Set-LoginStage {
    param([string] $Stage)
    if ($env:LMR_LOGIN_STAGE_FILE) { [IO.File]::WriteAllText($env:LMR_LOGIN_STAGE_FILE, $Stage) }
}
