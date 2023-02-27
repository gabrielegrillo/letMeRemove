$InputTeam = Read-Host "Write the name of the team that you want to remove yourself:"
$Account = Connect-MicrosoftTeams | Select-Object -ExpandProperty "Account"
$Group = Get-Team -DisplayName "$InputTeam" | Select-Object -ExpandProperty "GroupId"
Remove-TeamUser -GroupId $Group -User $Account
Disconnect-MicrosoftTeams