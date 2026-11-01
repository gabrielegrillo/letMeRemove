# Security and account privacy

letMeRemove uses the official MicrosoftTeams module to authenticate and remove only
the signed-in account from selected teams. It never asks for a password, accepts
another target user, or writes authentication tokens to repository files.
MicrosoftTeams manages its own authentication state. Use a dedicated PowerShell
process if you also administer Teams in other sessions.

Leaving also removes membership in the backing Microsoft 365 group. Review the
account and full team IDs before confirming. A preview still signs in and reads
membership data, but does not submit removals. Demo mode uses only local examples.

Modules are installed only when you run the installation helper or install commands.
Review PowerShell Gallery prompts and your organization's software policy. The tool
does not alter repository trust or bypass authentication or tenant restrictions.

## Report a security concern

Do not post exploitable security details, credentials, tokens or sign-in codes in a
public issue. If the repository provides GitHub private vulnerability reporting,
use its **Security → Report a vulnerability** option. Otherwise contact the
repository maintainer through an existing private channel before sharing details.
No private email address is designated in this repository.

The authors and maintainers are **Matteo Marzano (pxxyco)** and **Gabriele Grillo
(gabrielegrillo)**; see [AUTHORS.md](AUTHORS.md).

For ordinary crashes or UI problems, use the bug report template with redacted
output. See [troubleshooting](docs/troubleshooting.md) for useful version information.
