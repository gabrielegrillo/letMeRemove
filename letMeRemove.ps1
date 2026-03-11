# TODO:
# Paramaters 
# check if it works on windows
$moduleGet = Get-Module -ListAvailable -Name PowerShellGet
$moduleTeams = Get-Module -ListAvailable -Name MicrosoftTeams

if (-not $moduleGet -or -not $moduleTeams) {
    Write-Host "Trying to install the missing modules..."
    
    if (-not $moduleGet)   { Install-Module -Name PowerShellGet  -Force -AllowClobber }
    if (-not $moduleTeams) { Install-Module -Name MicrosoftTeams -Force -AllowClobber }

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
Write-Host "Log-in in your browser."
$acc = Connect-MicrosoftTeams | Select-Object -ExpandProperty "Account"

if (-not $acc) {
  Write-Host "Impossible to connect to the Microsoft Account"
  Exit
}

Write-Host "Logged in with:" $acc
$all_teams = Get-Team -User $acc

# List all the team enrolled
Write-Host "Enrolled teams:"
for ($i = 0; $i -lt $all_teams.Length; $i++) {
    Write-Output "$(($i+1))) $($all_teams[$i].DisplayName)"
}

# choice of 

do {
    $choiceMulti = Read-Host "`nRemove from one team or multiple teams?`n(0 = one team, 1 = multiple teams)"
    $choiceMulti = $choiceMulti -as [int]
    if ($choiceMulti -ne 0 -and $choiceMulti -ne 1) {
        Write-Host "Invalid input. Please enter 0 or 1."
    }
} while ($choiceMulti -ne 0 -and $choiceMulti -ne 1)


if ($choiceMulti -eq 0) {
    do {
        $choiceTeam = (Read-Host "Select a team (1-$($all_teams.Count))") -as [int]
        if ($choiceTeam -lt 1 -or $choiceTeam -gt $all_teams.Count) {
            Write-Host "Invalid selection. Please enter a number between 1 and $($all_teams.Count)."
        }
    } while ($choiceTeam -lt 1 -or $choiceTeam -gt $all_teams.Count)

    $groupId = $all_teams[$choiceTeam - 1].GroupId
    Remove-TeamUser -GroupId $groupId -User $acc
    Write-Host "Removed from: $($all_teams[$choiceTeam - 1].DisplayName)"
}
else {
     do {
        $choiceTeams = Read-Host "Select teams separated by ',' (e.g. 1,3,5)"
        $teams = $choiceTeams -split ',' | ForEach-Object { $_.Trim() -as [int] }
        $valid = $teams | Where-Object { $_ -lt 1 -or $_ -gt $all_teams.Count }
        if ($valid) {
            Write-Host "Invalid selection(s): $($valid -join ', '). Please use numbers between 1 and $($all_teams.Count)."
        }
    } while ($valid)

    foreach ($team in $teams) {
        $groupId = $all_teams[$team - 1].GroupId
        Remove-TeamUser -GroupId $groupId -User $acc
        Write-Host "Removed from: $($all_teams[$team - 1].DisplayName)"
    }
}

Write-Host "Disconnecting from Teams..."
Disconnect-MicrosoftTeams


