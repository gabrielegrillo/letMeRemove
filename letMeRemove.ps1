# TODO:
# Parameters 
$moduleGet = Get-Module -ListAvailable -Name PowerShellGet
$moduleTeams = Get-Module -ListAvailable -Name MicrosoftTeams

if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "PowerShell 7 or higher is required. Current version: $($PSVersionTable.PSVersion)"
    Exit 1
}

$moduleSpectre = Get-Module -ListAvailable -Name PwshSpectreConsole

if (-not $moduleGet -or -not $moduleTeams -or -not $moduleSpectre) {
    Write-Host "Trying to install the missing modules..."
    
    if (-not $moduleGet)   { Install-Module -Name PowerShellGet  -Force -AllowClobber }
    if (-not $moduleTeams) { Install-Module -Name MicrosoftTeams -Force -AllowClobber }
    if (-not $moduleSpectre) { Install-Module -Name PwshSpectreConsole -Force -AllowClobber }
    # Recheck if the modules are installed correctly
    $moduleGet = Get-Module -ListAvailable -Name PowerShellGet
    $moduleTeams = Get-Module -ListAvailable -Name MicrosoftTeams
    
    if (-not $moduleGet -or -not $moduleTeams) {
      Write-Host "Failed to install module PowerShellGet and/or MicrosoftTeams.`nTry do it yourself by:`nInstall-Module -Name PowerShellGet -Force -AllowClobber`nInstall-Module -Name MicrosoftTeams -Force -AllowClobber"
      Exit
    }

    if (-not $moduleSpectre) {
      Write-Host "Failed to install module PwshSpectreConsole`nTry do it yourself by:`nInstall-Module -Name PwshSpectreConsole -Force -AllowClobber"
      Exit
    }

    Write-Host "All required modules are installed! :)"
}


# Connect and get the email.

Write-SpectreHost "[cyan]=== letMeRemove 🚪 ===[/]`n"
Write-SpectreHost "[yellow]Log-in in your browser...[/]"
$script:acc = $null

Invoke-SpectreCommandWithStatus -Spinner "Dots" -Title "Connecting to Microsoft Teams..." -ScriptBlock {
    $script:acc = Connect-MicrosoftTeams | Select-Object -ExpandProperty "Account"
}

if (-not $script:acc) {
  Write-SpectreHost "[red]Impossible to connect to the Microsoft Account.[/]"
  Exit
}

Write-SpectreHost "[green]Logged in with:[/] $script:acc`n"

$script:all_teams = $null

Invoke-SpectreCommandWithStatus -Spinner "Dots" -Title "Fetching your teams..." -ScriptBlock {
    $script:all_teams = Get-Team -User $acc -ProgressAction SilentlyContinue
}


if (-not $script:all_teams) {
    Write-SpectreHost "[red]No teams found for this account. Exiting.[/]"
    Disconnect-MicrosoftTeams
    Exit
}

# Display enrolled teams as a table
$tableData = for ($i = 0; $i -lt $script:all_teams.Count; $i++) {
    [PSCustomObject]@{ "#" = $i + 1; Team = $script:all_teams[$i].DisplayName }
}
Format-SpectreTable -Data $tableData -Title "Enrolled Teams" -Color "cyan"

$script:teamNames = $script:all_teams | ForEach-Object { $_.DisplayName }

# Selection 
$selectedTeams = Read-SpectreMultiSelection `
    -Title "Select teams to remove yourself from [grey](SPACE to select, ENTER to confirm)[/]" `
    -Choices $script:teamNames `
    -Color "yellow"

if (-not $selectedTeams) {
    Write-SpectreHost "[red]No teams selected. Exiting.[/]"
    Disconnect-MicrosoftTeams
    Exit
}

# Confirmation
$confirmData = $selectedTeams | ForEach-Object { [PSCustomObject]@{ Team = $_ } }
Format-SpectreTable -Data $confirmData -Title "Teams to Leave" -Color "yellow"

$confirm = Read-SpectreText `
    -Prompt "Confirm leaving the above [yellow]$($selectedTeams.Count)[/] team(s)? [grey]\[y/N][/]" `
    -AnswerColor "yellow"

if ($confirm -notmatch '^[Yy]$') {
    Write-SpectreHost "[grey]Aborted. No changes made.[/]"
    Disconnect-MicrosoftTeams
    Exit
}

Invoke-SpectreCommandWithProgress -ScriptBlock {
    param($ctx)
    $task = $ctx.AddTask("[yellow]Removing from teams...[/]", $true, $selectedTeams.Count)
    foreach ($name in $selectedTeams) {
        $script:team = $script:all_teams | Where-Object { $_.DisplayName -eq $name }
        Remove-TeamUser -GroupId $script:team.GroupId -User $script:acc
        Write-SpectreHost "[green]Removed from:[/] $name"
        $task.Increment(1)
    }
}

$summary = $selectedTeams | ForEach-Object {
    [PSCustomObject]@{ Team = $_; Status = "[green]✓ Removed[/]" }
}
Format-SpectreTable -Data $summary -Title "Summary" -Color "green"

Write-SpectreHost "`n[grey]Disconnecting from Teams...[/]"
Disconnect-MicrosoftTeams
