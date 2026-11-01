@{
    RootModule = 'LetMeRemove.psm1'
    ModuleVersion = '2.2.0'
    GUID = '36076c66-6c11-4ea3-9ac8-9388cd4411a2'
    Author = 'Matteo Marzano (pxxyco); Gabriele Grillo (gabrielegrillo)'
    Description = 'Cross-platform, self-service Microsoft Teams departure tool.'
    PowerShellVersion = '7.2'
    FunctionsToExport = @('Invoke-LetMeRemove', 'Invoke-LetMeRemoveDemo', 'Show-LetMeRemoveResult')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        Maintainers = @('Matteo Marzano (pxxyco)', 'Gabriele Grillo (gabrielegrillo)')
        PSData = @{ LicenseUri = 'https://www.gnu.org/licenses/gpl-3.0.html' }
    }
}
