# Command reference

```powershell
./letMeRemove.ps1 [-Authentication DeviceCode|Browser] [-TenantId <guid>]
                 [-GroupId <guid[]>] [-ListOnly] [-NonInteractive]
                 [-Interface Auto|Rich|Plain] [-NoAnimation] [-NoBrowser]
                 [-LoginTimeoutSeconds <seconds>] [-PassThru]
                 [-WhatIf] [-Confirm]
./letMeRemove.ps1 -Demo [-Interface Auto|Rich|Plain] [-NoAnimation]
```

Run from PowerShell for array arguments, `-Confirm:$false`, pipelines and exports.
Use `pwsh -NoProfile -File ./letMeRemove.ps1` to launch from another shell.

| Option | Default | Purpose |
| --- | --- | --- |
| `Authentication` | `DeviceCode` | Microsoft login via code or browser |
| `TenantId` | None | Restrict authentication to the specified tenant GUID |
| `GroupId` | None | Select exact team IDs, bypassing the selection screen |
| `ListOnly` | Off | List names and IDs without removing membership |
| `NonInteractive` | Off | Require explicit selection and confirmation options; login still requires a user |
| `Interface` | `Auto` | Choose rich styling when supported, request it explicitly, or use plain mode |
| `NoAnimation` | Off | Disable activity spinners, retaining rich styling |
| `NoBrowser` | Off | Do not open the Microsoft login page automatically |
| `LoginTimeoutSeconds` | `60` | Maximum sign-in wait in seconds; accepted range 1–900 |
| `PassThru` | Off | Return structured objects instead of the CLI summary |
| `Demo` | Off | Explore local examples without MicrosoftTeams or a Microsoft connection |
| `WhatIf` | Off | Authenticate and read teams, but never submit removals |
| `Confirm` | On for removals | PowerShell confirmation; explicitly disable with `-Confirm:$false` |

`Rich` still falls back when the terminal cannot support it; it does not force ANSI
codes into a redirected stream or override `NO_COLOR`. `Demo` cannot be combined
with account, membership, list, noninteractive or structured-output options.

## Preview or list

```powershell
./letMeRemove.ps1 -WhatIf
./letMeRemove.ps1 -ListOnly
./letMeRemove.ps1 -TenantId '00000000-0000-0000-0000-000000000000' -ListOnly
```

## Select exact IDs

All IDs are validated against the authenticated account's fetched teams before
any removal. Duplicate IDs are deduplicated. An unknown ID rejects the whole batch.
There is no option to remove another user.

```powershell
./letMeRemove.ps1 -GroupId @(
    '00000000-0000-0000-0000-000000000001'
    '00000000-0000-0000-0000-000000000002'
) -WhatIf
```

## Export results

```powershell
./letMeRemove.ps1 -ListOnly -PassThru | Export-Csv ./my-teams.csv -NoTypeInformation
$results = ./letMeRemove.ps1 -GroupId '00000000-0000-0000-0000-000000000001' -WhatIf -PassThru
$results | ConvertTo-Json
```

`-PassThru` returns objects on the success stream; UI messages use the host stream.
List objects contain `DisplayName` and `GroupId`. Departure objects contain `Team`,
`GroupId`, `Status` and `Message`. Exports contain account-related membership data;
store and share them according to your organization's policy.

## Skip selection and confirmation prompts

```powershell
./letMeRemove.ps1 -GroupId '00000000-0000-0000-0000-000000000001' -NonInteractive -WhatIf
./letMeRemove.ps1 -GroupId '00000000-0000-0000-0000-000000000001' -NonInteractive -Confirm:$false
```

`NonInteractive` requires `ListOnly`, or `GroupId` plus `WhatIf` or explicit
`Confirm:$false`. **It does not provide unattended authentication**. Microsoft
sign-in still needs user participation. Use this option when redirecting input,
instead of expecting an interactive selection menu to work without a terminal.

## Module API

```powershell
Import-Module ./src/LetMeRemove.psd1
$results = Invoke-LetMeRemove -GroupId '00000000-0000-0000-0000-000000000001' -WhatIf
Show-LetMeRemoveResult -Results $results
Invoke-LetMeRemoveDemo -NoAnimation
```

`Invoke-LetMeRemove` accepts the workflow options above except `Demo` and `PassThru`;
it always returns objects, and fatal errors throw instead of exiting the shell.
Use a dedicated process: the MicrosoftTeams connection is shared within a process
and this tool attempts to disconnect it on completion.

## Exit status

| Code | Meaning |
| --- | --- |
| 0 | Completed, listed, previewed or cancelled |
| 1 | Setup, authentication, fetch or argument validation failed |
| 2 | At least one departure request failed |

For command-line exit status, launch through `pwsh -File`. Inside PowerShell,
check `$LASTEXITCODE` after invoking the script; the module API does not set a
process exit status. An exit code of zero does not mean every selected team was
left: check `Preview`, `Skipped` and `Submitted` in the returned results.

`-NoBrowser` disables automatic opening of the device login page. It is also
suppressed by `-NonInteractive`. Device-code instructions emitted on the module's
warning/information streams are displayed as `Login code: …`; unrecognized
messages remain visible so that sign-in problems are not hidden.

## Login deadline and cancellation

`-LoginTimeoutSeconds 60` sets the maximum authentication wait (default 60
seconds; accepted range 1–900). For example:

```powershell
./letMeRemove.ps1 -LoginTimeoutSeconds 60
```

The tool cannot observe whether a browser tab is closed or reopened on this or
another device. The deadline measures time until authentication completes, not
browser activity; reopening the page does not reset it. Start the tool again after
a timeout to obtain a fresh login. Timeout exits with code 1.

The authentication deadline requires PowerShell's in-memory `Add-Type` support,
including in plain mode. The ordinary CLI runs in a dedicated worker process. During login the launcher
handles Ctrl+C independently of MicrosoftTeams and can terminate a blocked worker
without terminating your existing PowerShell session. A 60-second authentication
deadline also terminates an unresponsive worker. The picker restores mouse mode, cursor and the previous screen. Ctrl+X
is not assigned. Native PowerShell confirmation prompts retain their host behavior. Cancelling or suspending a
process does not undo requests already sent to Microsoft.

`-PassThru` and the imported module API execute in the caller’s process to preserve
PowerShell objects and connection semantics. They use cooperative cancellation and
do not have the CLI launcher’s process-termination guarantee. The launcher’s
internal worker mode is not intended for user commands. Cancellation cannot undo
a request already accepted by Microsoft.
