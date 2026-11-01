# letMeRemove 🚪

**Less noise in Teams. More focus in your day.**

Choose the teams you no longer need, review your selection, and leave them from
your terminal. Made for PowerShell on **Windows, macOS and Linux**.

[🌐 18 languages](docs/languages.md) · [Italiano](docs/languages/README.it.md) · [Install](docs/install.md) · [Daily use](docs/usage.md) ·
[All commands](docs/commands.md) · [Get help](docs/troubleshooting.md)

## Get ready

Use [PowerShell 7.2 or newer](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell).
Download this repository, open a terminal in its folder, then run:

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

The helper installs MicrosoftTeams for your user. The ANSI/.NET interface is
bundled with the tool; no Spectre module or separate .NET SDK is needed. It does
not change repository trust or require a system-wide installation. Review any
PowerShell Gallery prompts. [Manual installation and updates →](docs/install.md)

## Take a look first

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

Explore the interface using example teams. No account, connection or changes.

## Make room for what matters

```powershell
# Sign in and preview your selection without leaving anything
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf

# When ready, review and confirm the teams you want to leave
pwsh -NoProfile -File ./letMeRemove.ps1
```

The Microsoft login page opens automatically; enter the temporary code shown in
the terminal. Use `-NoBrowser` to open the page yourself. The tool never asks for your
password. Login expires after **60 seconds** by default; press **Ctrl+C** to cancel
an unfinished login. In the selection screen, **type to search**, use **↑ / ↓** to move,
**Space** to select and **Enter** to review. **Esc** cancels. **Ctrl+A** selects all teams (press again to clear); Enter reviews
the selection before confirmation.

A large ASCII wordmark welcomes you, followed by concise `[+]` session logs.
You get live selection counts, adaptive pages, framed previews, an indeterminate
activity meter with elapsed time and color-coded result cards. Navigation updates
only changed rows, avoiding the full-screen flashes of earlier releases. Selections remain selected when you
filter; teams with the same name are distinguished by their IDs.

**Leaving a team also leaves its backing Microsoft 365 group**, which can affect
access to shared group resources. This tool leaves whole teams, not individual
channels. Normal use asks you to confirm each removal. Microsoft may take up to
an hour to reflect an accepted request.

## Fits your terminal

```powershell
# Keep the interface, disable activity animations
./letMeRemove.ps1 -NoAnimation

# Use the accessible numbered menu and plain summaries
./letMeRemove.ps1 -Interface Plain

# Just list your teams
./letMeRemove.ps1 -ListOnly
```

Rich mode activates automatically in an interactive ANSI terminal of at least
64 × 24, using the bundled renderer. Small terminals,
redirected output, `TERM=dumb`, `NO_COLOR` and environments that block renderer compilation
use the plain interface. Resizing below the minimum restarts selection in plain
mode; nothing is submitted by selecting alone.

For scripts and exports, use `-PassThru` or the module API.
[Examples and all options →](docs/commands.md)

## Need a hand?

- [Install or update on your OS](docs/install.md)
- [Keyboard controls and everyday tasks](docs/usage.md)
- [Login errors, terminal issues and failed removals](docs/troubleshooting.md)
- [What changed in 2.2](CHANGELOG.md)
- [Account privacy and security](SECURITY.md)

Your Microsoft account and organization must permit the operation. Tenant policies
may restrict login or departure, and the last team owner cannot be removed.
There is no rollback for a submitted departure request.

To help improve the tool, read [Contributing](CONTRIBUTING.md).
Licensed under the GNU GPL; see [COPYING](COPYING).

## Authors and maintainers

**[Matteo Marzano (pxxyco) (pxxyco)](https://github.com/pxxyco)** and **[Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo)**.
[Full credits](AUTHORS.md) · [All README languages](docs/languages.md)

The quick starts are translated; CLI messages and detailed reference guides remain
in English.
