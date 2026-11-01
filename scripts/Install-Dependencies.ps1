#Requires -Version 7.2
<#
.SYNOPSIS
Install letMeRemove dependencies for the current user.
.EXAMPLE
./scripts/Install-Dependencies.ps1 -WhatIf
.EXAMPLE
./scripts/Install-Dependencies.ps1 -PlainOnly
.PARAMETER PlainOnly
Compatibility option. Both interfaces now use the bundled renderer, so only
MicrosoftTeams is installed regardless of this switch.
#>
[CmdletBinding(SupportsShouldProcess)]
param([switch] $PlainOnly)
$ErrorActionPreference = 'Stop'
$dependencies = @(@{ Name = 'MicrosoftTeams'; Minimum = [version]'8.0.0' })
foreach ($dependency in $dependencies) {
    $installed = @(Get-Module -ListAvailable -Name $dependency.Name | Where-Object Version -GE $dependency.Minimum)
    if ($installed.Count) {
        Write-Host "$($dependency.Name) $($installed[0].Version) is ready."
        continue
    }
    if ($PSCmdlet.ShouldProcess("$($dependency.Name) >= $($dependency.Minimum) / CurrentUser / PSGallery", 'Install module')) {
        Install-Module -Name $dependency.Name -MinimumVersion $dependency.Minimum -Scope CurrentUser -Repository PSGallery -ErrorAction Stop
    }
}
Write-Host 'Next: pwsh -NoProfile -File ./letMeRemove.ps1 -Demo'
