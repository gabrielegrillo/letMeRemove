# Get back on track

## Login mentions `kernel32.dll` on Linux or macOS

Start with the default device-code flow:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Authentication DeviceCode -ListOnly
```

Some MicrosoftTeams interactive authentication paths attempt to call the Windows
broker. A Windows DLL cannot fix that on Linux/macOS. Device-code authentication
avoids that interactive path. Make sure you are using the updated tool and module.

If your organization blocks device-code login, try `-Authentication Browser`.
On Linux/macOS, this requests `DisableWAM` and requires a module version supporting
that option. Ask your administrator if both flows are restricted; letMeRemove does
not bypass Conditional Access, consent or other tenant controls.

## The rich interface does not appear

Run `./letMeRemove.ps1 -Demo -Interface Rich` in a normal terminal. Check:

- The bundled `src/Terminal/AnsiRenderer.cs` and `assets/logo.txt` files are present.
- Your PowerShell environment permits `Add-Type` for the native renderer.
- The window is at least 64 columns by 24 rows.
- Input and output are not redirected, and the host supports ANSI.
- `NO_COLOR` is unset and `TERM` is not `dumb`.

The tool deliberately uses plain mode when these requirements are not met.
`-Interface Rich` prints a reason when the terminal is unsuitable; it cannot
create capabilities missing from the terminal. Use `-Interface Plain` in editors'
output panes, screen-reader sessions and basic hosts.

## Navigation, resizing or search behaves unexpectedly

Try the same action with `-Demo`. Arrow keys are bounded at the first and last
matching item. Home/End jump to the boundaries. Delete clears the search; Space
selects rather than typing a space. Use a single name fragment when searching.
Selections hidden by a filter still count and will appear in the final review.

If you shrink the window below the minimum, selection restarts in the numbered
menu and rich selections are discarded. No changes are made by selecting alone.
If a terminal cannot restore its display after forced termination, open a new tab;
normal exit and cancellation restore the alternate screen and show the cursor.

## A team could not be left

Read the `Failed` message in the summary. Common causes include tenant policy,
insufficient permissions, an expired session or being the last owner. Arrange
another owner before leaving a team you solely own. Local administrator rights
do not grant Microsoft 365 permissions.

Other confirmed teams continue after a single failure. Review results before
rerunning; the tool does not automatically retry or roll back requests.

## A submitted team still appears in Teams

Microsoft's command can return before Teams reflects the membership change.
Allow up to an hour. `Submitted` means accepted, not independently verified.
See [Microsoft's removal documentation](https://learn.microsoft.com/en-us/powershell/module/microsoftteams/remove-teamuser).

## Missing modules or a downloaded script will not run

Use the [installation guide](install.md). The tool never installs dependencies in
the background, changes execution policy or changes repository trust. Use `pwsh`,
not `powershell.exe`. If your organization manages module installation or script
execution policy, use its approved route.

## Gather useful details

Run inside PowerShell:

```powershell
$PSVersionTable | Select-Object PSVersion, OS, Platform
Get-Module -ListAvailable MicrosoftTeams |
    Select-Object Name, Version
```

Include your terminal name, exact command, interface mode and redacted error when
reporting a problem. Mention whether `-Demo` and `-Interface Plain` reproduce it.
Do not share credentials, tokens, login codes or unredacted account/tenant/team IDs.
For security concerns, see [security reporting](../SECURITY.md).

[Microsoft's login options](https://learn.microsoft.com/en-us/powershell/module/microsoftteams/connect-microsoftteams) ·
[Supported PowerShell platforms](https://learn.microsoft.com/en-us/microsoftteams/teams-powershell-install)

## Fetching or navigation flickers

Version 2.2 uses a bundled differential renderer: movement updates only changed
rows, held keys are batched and rendering is capped at 30 frames per second. The
fetch indicator is an indeterminate single-line animation with elapsed time, not
a percentage or an estimate of how many teams remain. It runs at 10 updates per
second independently of the Microsoft request.

Keep your terminal emulator current. If it still flickers over a slow remote
connection, use `-NoAnimation`; `-Interface Plain` disables the rich screen too.
The renderer avoids global screen clearing during navigation and restores the
previous screen on normal exit. Terminal-specific behavior still needs testing
on the affected emulator. Report its name and version along with the tool version.

## The browser was closed or login never finishes

Login expires after **60 seconds** by default. Use `-LoginTimeoutSeconds 30` for
a shorter limit. The tool cannot inspect browser tabs or detect reopening on
another device, so this is a fixed authentication deadline. Use Ctrl+C to interrupt the tool. The normal CLI launcher can terminate its
worker during login even when a native Microsoft authentication call is stuck.
The existing PowerShell shell remains open. In the picker Ctrl+C is also handled
as an explicit cancellation. On macOS
use Control, not Command. Ctrl+Z on POSIX shells suspends rather than terminates.

Translated quick starts live in `docs/languages/`. The earlier name `i18n` was a
common abbreviation for “internationalization”; the folder now uses a plain name.

If Ctrl+C still produces no response, check whether your terminal is using it to
copy selected text instead of delivering it to the running application. Include
the terminal name and exact launch command in a bug report. Use the normal CLI
without `-PassThru` to benefit from isolated authentication supervision.
