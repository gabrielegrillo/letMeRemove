# Help improve letMeRemove

For help using the tool, start with [troubleshooting](docs/troubleshooting.md).
For a reproducible bug, use the issue template and include your OS, terminal,
PowerShell and module versions. Redact account details and tenant/team IDs.
Never include sign-in codes, access tokens or credentials.

## Make a change

1. Use PowerShell 7.2 or newer and create a branch for your change.
2. Keep user-visible behavior documented in the relevant guide.
3. Run `pwsh -NoProfile -File ./tests/Run-Tests.ps1`.
4. For interface changes, try `./letMeRemove.ps1 -Demo` in a real terminal.
5. Open a pull request describing the changed behavior and checks performed.

The offline suite does not require MicrosoftTeams, credentials or a tenant.
The bundled C# terminal renderer is compiled and tested by PowerShell; no external
UI package, .NET SDK or tenant is needed for these checks.

## Structure

| Path | Responsibility |
| --- | --- |
| `letMeRemove.ps1` | CLI arguments, demo routing, summary and exit status |
| `src/LetMeRemove.psd1` | Public module metadata and exports |
| `src/LetMeRemove.psm1` | Authenticated workflow and offline demo |
| `src/Private/Authentication.ps1` | Platform-aware login options |
| `src/Private/Selection.ps1` | Plain menu and input validation |
| `src/Private/Terminal.ps1` | Terminal capabilities, rich UI, picker state and rendering |
| `src/Terminal/CliSupervisor.cs` | CLI worker lifecycle, hard login deadline and termination |
| `src/Invoke-Worker.ps1` | Internal isolated CLI entry point |
| `src/Private/Supervisor.ps1` | Launcher configuration and authentication phase markers |
| `src/Terminal/AnsiRenderer.cs` | Differential screen updates, Unicode cell sizing and background activity animation |
| `assets/logo.txt` | Shared ASCII wordmark |
| `src/Private/Text.ps1` | Untrusted text sanitization |
| `scripts/` | Explicit installation helpers |
| `tests/` | Offline tests, subprocess checks and fake service module |
| `docs/` | User-facing guides |

## Changes worth testing carefully

Preserve `ShouldProcess`, self-only targeting, complete ID validation before writes,
and cleanup in `finally`. Keep authentication outside spinners. Never retry an
operation merely because its animation failed. Rendering must not emit objects
into the service-results pipeline. Names are untrusted: sanitize terminal controls
and keep raw ANSI control sequences out of all labels.

The picker reducer can be tested without a console. Test first/last item movement,
empty results, resizing, duplicate names, retained selections and cancellation.
CI runs offline checks on Linux, Windows and macOS; real authentication still
requires a permitted Microsoft tenant and manual OS smoke tests.

Contributions use the GNU GPL terms in [COPYING](COPYING).

## Maintainers

Matteo Marzano (pxxyco) and [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
See [AUTHORS.md](AUTHORS.md) for credits and [docs/languages.md](docs/languages.md)
for translated README files. When user-facing behavior changes, update each
localized quick start as well as the English reference. The CLI stays in English.
