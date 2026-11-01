# Install and keep up to date

## 1. Prepare PowerShell

Install a maintained [PowerShell release for your OS](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell).
letMeRemove requires version 7.2 or newer. Check with:

```powershell
pwsh -NoProfile -Command '$PSVersionTable.PSVersion'
```

Use `pwsh` on Windows as well. The built-in `powershell.exe` is version 5.1.
Windows Terminal, a normal macOS terminal or a Linux ANSI terminal can display the
rich interface. For the full screen, allow at least 64 columns and 24 rows.

## 2. Install dependencies

Download or clone the repository. In its folder, run:

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

The helper installs missing dependencies for **CurrentUser**, from **PSGallery**:

| Dependency | Helper minimum | Purpose |
| --- | --- | --- |
| MicrosoftTeams | 8.0.0 | Microsoft authentication and Teams membership operations |

Preview installation with `-WhatIf`:

```powershell
./scripts/Install-Dependencies.ps1 -WhatIf
```

Existing versions meeting the minimum are left alone. The helper does not force
installation, overwrite commands, change repository trust or elevate privileges.
Review the normal Gallery prompts. Follow your organization's installation policy.

To install manually, run these commands **inside PowerShell**:

```powershell
Install-Module MicrosoftTeams -MinimumVersion 8.0.0 -Scope CurrentUser -Repository PSGallery
```

The native ANSI/.NET interface ships with the tool: no Spectre module or separate
.NET SDK is required. PowerShell compiles the small bundled renderer in memory on
first use; no binaries are downloaded or written. If dynamic compilation is blocked
by your organization, the plain menu remains available. The installation helper
still accepts `-PlainOnly` for compatibility; it no longer changes dependencies.
There is no background download or dependency installation when launching the tool.

## 3. Try the interface

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

Demo mode uses local example teams and never connects to Microsoft. Once familiar,
try `-WhatIf` to sign in and preview real selections without submitting departures.

## Updates

Download the updated tool into its own folder, keeping the `src/` and `assets/` directories next
to `letMeRemove.ps1`. Read the [release notes](../CHANGELOG.md).

For modules installed with `Install-Module`, close sessions using them and open
a new PowerShell session before updating:

```powershell
Update-Module MicrosoftTeams
```

Use your original installation method if your organization supplies modules another
way. No administrator role in Microsoft 365 is granted by installing this tool.
Your account and tenant policies determine which operations are permitted.

If Windows blocks a downloaded script, review its contents and use the appropriate
`Unblock-File` procedure for files you trust. This tool does not change execution
policy. In managed environments, ask your IT team for the approved setup.

[Next: use letMeRemove →](usage.md)
