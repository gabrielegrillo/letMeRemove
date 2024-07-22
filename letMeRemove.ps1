# TODO:
# Paramaters 
# check if it works on windows
$moduleGet = Get-Module -ListAvailable -Name PowerShellGet
$moduleTeams = Get-Module -ListAvailable -Name MicrosoftTeams

if ($moduleGet -and $moduleTeams) {
    Write-Host "Modules found."
}
else {
    Write-Host "Trying to install modules..."
    Install-Module -Name PowerShellGet -Force -AllowClobber
   Get-Module -ListAvailable -Name PowerShellGet
    
    # Recheck if the modules are installed correctly
    $moduleGet = Get-Module -ListAvailable -Name PowerShellGet
    $moduleTeams = Get-Module -ListAvailable -Name MicrosoftTeams
    
    if (-not ($moduleGet -and $moduleTeams)) {
      Write-Host "Failed to install module PowerShellGet and/or MicrosoftTeams.`nTry do it yourself by:`nInstall-Module -Name PowerShellGet -Force -AllowClobber`nInstall-Module -Name MicrosoftTeams -Force -AllowClobber"
      Exit
    }
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
for ($i = 0; $i -lt $all_teams.Length; $i++) {
    Write-Host ($i + 1)")" $all_teams[$i].DisplayName
}

# choice of 

$choiceMulti = Read-Host "Do you want to remove from one team or multiple teams?`n(0 one team, 1 mutiple teams): "
while ($true) {
    if ($choiceMulti -eq 0 -or $choiceMulti -eq 1) {
      break;
    }
    else {
      Write-Host "Input invalid."
      $choiceMulti = Read-Host "Do you want to remove from one team or multiple teams?`n(0 one team, 1 mutiple teams): "
    }
}

if ($choiceMulti -eq 0) {
    $choiceTeam = Read-Host "Select the team: "
    $groupId = $all_teams[($choiceTeam - 1)].GroupId 
    Remove-TeamUser -GroupId $groupId -User $acc
}
if ($choiceMulti -eq 1)  {
    $choiceTeams = Read-Host "Select the teams, separeted by ',': "
    $teams = $choiceTeams -split ','
    for ($i = 0; $i -lt $teams.Count; $i++) {
        $groupId = $all_teams[($i - 1)].GroupId 
        Remove-TeamUser -GroupId $groupId -User $acc
        Write-Host "Removed from: " $all_teams[($i - 1)].DisplayName
    }
}
Write-Host "Disconnecting from Teams..."
Disconnect-MicrosoftTeams


