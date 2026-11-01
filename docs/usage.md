# A quieter Teams list, in a few steps

## Sign in

Start with a preview:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

Microsoft prints a URL and a temporary code. Open that URL in a browser, enter the
code and sign in to the account whose teams you want to manage. You can use a browser
on another device. Confirm the account shown by letMeRemove before proceeding.

The login page opens automatically. Use `-NoBrowser` on a remote host or if you prefer
opening `https://microsoft.com/devicelogin` yourself. An interactive CLI launch clears
the visible screen but leaves your shell history intact.

A `[+] Trying to log in` message introduces the official sign-in instructions,
including the real one-time code printed by Microsoft. The tool never fabricates
a code or saves it to a log file. The sign-in instructions stay visible. Animations
start only for team retrieval and confirmed departure requests, so the login code
is never hidden by a spinner.

## Find and select your teams

The rich picker opens in a temporary full-screen view with a large ASCII wordmark,
a workflow breadcrumb, a highlighted focus row and a live selection meter. Your
shell's previous screen returns when you finish or cancel.

| Key | Action |
| --- | --- |
| Type a name fragment | Filter results immediately, ignoring case |
| ↑ / ↓ | Move one team; the cursor stays within the result list |
| Space | Select/deselect the focused team |
| Home / End | Go to first/last matching team |
| Page Up / Page Down | Move one visible page |
| Backspace | Remove the last search character |
| Delete | Clear the search |
| Enter | Finish selection and review all selected teams |
| Esc | Cancel the whole selection |

Space is reserved for selection: search with a word or name fragment. Filters
are literal, so brackets and other symbols are not special patterns. Selections
persist across filters, including teams hidden by the current search. The live
counter shows the total selected. Use Delete to clear the filter; press Enter to
review the full selection.

The short ID suffix helps distinguish names; the review screen shows full IDs.
Only changed rows are painted when you move. Buffered keys are processed together
for smoother navigation. The visible page size adapts when the terminal is resized.
If it becomes smaller than 64 × 24, or rendering fails, selection restarts with the
plain menu. Previous rich selections are discarded in that fallback; no departure
is submitted.

## Review and confirm

Check the account, team names and full IDs. Leaving also removes your membership
in the backing Microsoft 365 group, affecting access to its shared resources.

In normal mode, PowerShell asks you to confirm each departure. You may answer Yes,
No, Yes to All or No to All using the options shown by the prompt. In preview mode,
`WhatIf` describes the changes without submitting anything.

To perform the operation after a preview, run again without `-WhatIf` and make your
selection. Selections are not saved between runs.

## Read the summary

| Result | What it means |
| --- | --- |
| Preview | No request was sent |
| Skipped | You declined confirmation |
| Submitted | Microsoft accepted the request; propagation is pending |
| Failed | The request returned an error; read its details |

One failure does not prevent the other selected requests. The tool does not retry
removals automatically. Submitted requests can take up to an hour to appear in
Teams, and there is no rollback command.

## A quieter or more accessible session

Use `-NoAnimation` to keep rich styling without activity spinners. Use
`-Interface Plain` for a line-based numbered menu, which works better with screen
readers and basic terminals. Defining `NO_COLOR` also selects plain mode.

In the plain menu, enter `2` or `1,3-5`; `n`/`p` change pages; `/finance` filters;
`/` resets; and `q` cancels. Numbers refer to the entire current filtered list.
The final ID list and confirmation step are the same as in rich mode.

## Select all and use the mouse

**Ctrl+A** toggles selection of every team, including teams hidden by the search.
Press **Enter** to review, then confirm the departures. Selecting all never submits
requests by itself. In the plain menu, enter a range such as `1-18` instead.

On terminals supporting SGR mouse reporting, each wheel event moves one item.
Repeated same-direction reports within 30 ms are grouped to avoid the common
three-row wheel jump. Mouse reporting is disabled when leaving the picker.

[All options and exports →](commands.md) · [Get help →](troubleshooting.md)
