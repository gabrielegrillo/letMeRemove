# TODO:
# Paramaters 
# check if it works on windows
$moduleGet = Get-Module -ListAvailable -Name PowerShellGet
$moduleTeams = Get-Module -ListAvailable -Name MicrosoftTeams
$moduleSpectre = Get-Module -ListAvailable -Name PwshSpectreConsole

if (-not $moduleGet -or -not $moduleTeams) {
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

    Write-Host "All required modules are installed! :)"
}


# Connect and get the email.

Write-SpectreHost "[cyan]=== letMeRemove 🚪 ===[/]`n"
Write-SpectreHost "[yellow]Log-in in your browser...[/]"
$acc = Connect-MicrosoftTeams | Select-Object -ExpandProperty "Account"

if (-not $acc) {
  Write-SpectreHost "[red]Impossible to connect to the Microsoft Account.[/]"
  Exit
}

Write-SpectreHost "[green]Logged in with:[/] $acc`n"
$all_teams = Get-Team -User $acc

if (-not $all_teams) {
    Write-SpectreHost "[red]No teams found for this account. Exiting.[/]"
    Disconnect-MicrosoftTeams
    Exit
}

# Display enrolled teams as a table
$tableData = for ($i = 0; $i -lt $all_teams.Count; $i++) {
    [PSCustomObject]@{ "#" = $i + 1; Team = $all_teams[$i].DisplayName }
}
Format-SpectreTable -Data $tableData -Title "Enrolled Teams" -Color "cyan"

$teamNames = $all_teams | ForEach-Object { $_.DisplayName }

# choice of 

$modeChoice = Read-SpectreSelection `
    -Title "Remove from one team or multiple teams?" `
    -Choices @("One team", "Multiple teams") `
    -Color "cyan"


if ($modeChoice -eq "One team") {
    $selectedTeam = Read-SpectreSelection `
        -Title "Select a team to remove yourself from" `
        -Choices $teamNames `
        -Color "yellow"

    $team = $all_teams | Where-Object { $_.DisplayName -eq $selectedTeam }

    Invoke-SpectreCommandWithStatus -Spinner "Dots" -Title "Removing you from [yellow]$selectedTeam[/]..." -ScriptBlock {
        Remove-TeamUser -GroupId $team.GroupId -User $acc
    }

    Write-SpectreHost "[green]Removed from:[/] $selectedTeam`n"}
else {
     $selectedTeams = Read-SpectreMultiSelection `
        -Title "Select teams to remove yourself from [grey](SPACE to select, ENTER to confirm)[/]" `
        -Choices $teamNames `
        -Color "yellow"

    if (-not $selectedTeams) {
        Write-SpectreHost "[red]No teams selected. Exiting.[/]"
        Disconnect-MicrosoftTeams
        Exit
    }

    Invoke-SpectreCommandWithProgress -ScriptBlock {
        param($ctx)
        $task = $ctx.AddTask("[yellow]Removing from teams...[/]", $true, $selectedTeams.Count)

        foreach ($name in $selectedTeams) {
            $team = $all_teams | Where-Object { $_.DisplayName -eq $name }
            Remove-TeamUser -GroupId $team.GroupId -User $acc
            Write-SpectreHost "[green]Removed from:[/] $name"
            $task.Increment(1)
        }
    }

    # Summary table
    $summary = $selectedTeams | ForEach-Object {
        [PSCustomObject]@{ Team = $_; Status = "✓ Removed" }
    }
    Format-SpectreTable -Data $summary -Title "Summary" -Color "green"
}


Write-SpectreHost "`n[grey]Disconnecting from Teams...[/]"
Disconnect-MicrosoftTeams
