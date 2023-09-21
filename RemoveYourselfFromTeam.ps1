# $InputTeam = Read-Host "Write the name of the team that you want to remove yourself:"
$acc = Connect-MicrosoftTeams | Select-Object -ExpandProperty "Account"
Write-Host "Login effettuato con:" $acc
$all_teams = Get-Team -User $acc

for ($i = 0; $i -lt $all_teams.Length; $i++) {
    Write-Host $i")" $all_teams[$i].DisplayName
}

# $Group = Get-Team -DisplayName "$InputTeam" | Select-Object -ExpandProperty "GroupId"
# Remove-TeamUser -GroupId $Grodxup -User $Account
# Disconnect-MicrosoftTeams

$choice = Read-Host "Select the team where you want to remove yourself:"
$groupId = $all_teams[$choice].GroupId 
# $Group = Get-Team -DisplayName "$InputTeam" | Select-Object -ExpandProperty "GroupId"
Remove-TeamUser -GroupId $groupId -User $acc
Disconnect-MicrosoftTeams


