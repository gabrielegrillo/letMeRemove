# TODO:
# Paramaters 
# check if it works on windows
if (Get-Module -ListAvailable -Name PowerShellGet -and Get-Module -ListAvailable -Name MicrosoftTeams) {
    Write-Host "OK!"
}
else {
    Install-Module -Name PowerShellGet -Force -AllowClobber
    Install-Module -Name MicrosoftTeams -Force -AllowClobber
    Exit
}

# Connect and get the email.
$acc = Connect-MicrosoftTeams | Select-Object -ExpandProperty "Account"
Write-Host "Logged in with:" $acc
$all_teams = Get-Team -User $acc

for ($i = 0; $i -lt $all_teams.Length; $i++) {
    Write-Host $i")" $all_teams[$i].DisplayName
}

$choice = Read-Host "Select the team you want to remove yourself from: "
$groupId = $all_teams[$choice].GroupId 
Remove-TeamUser -GroupId $groupId -User $acc
Disconnect-MicrosoftTeams


