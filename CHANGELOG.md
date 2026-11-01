# Release notes

## 2.2.0 — 2026-11-01

- Set the default authentication deadline to 60 seconds.
- Run the ordinary CLI in a supervised worker process so Ctrl+C and the login
  deadline can terminate an uncooperative authentication call without closing the
  user's existing shell. Preserve in-process structured-output and module modes.
- Add regression checks for blocked native login, timeout termination, worker
  cleanup, supervised preview and existing-shell interruption.
- Large ASCII wordmark with a cyan-to-magenta palette and `[+]` session logs.
- Replaced Spectre-driven redraws and status spinners with a bundled ANSI/.NET
  engine. Navigation paints only changed rows in one write; buffered keys share
  a frame and rendering is capped at 30 fps. Idle screens perform no writes.
- Single-line, 10 fps indeterminate activity meter with elapsed time; service
  actions execute directly, preserving PowerShell output and error semantics.
- Cached search matches, Unicode-aware label fitting, word-wrapped result cards
  and viewport cleanup on resize. No separate UI module or .NET SDK required.
- README quick starts in English and Italian, with a shared language index. The
  16 unmaintained translations were removed.
- Gabriele Grillo (gabrielegrillo) and Matteo Marzano (pxxyco) credited as authors and maintainers.

## 2.1.0 — 2026-11-01

### Your terminal, upgraded

- A cyan and magenta interface with framed search, live selection counts,
  highlighted focus, selection markers and a color-coded session summary.
- Arrow keys, Home/End and page keys; type to filter instantly. Selections stay
  selected while filtering and are always tied to full team IDs.
- Adaptive page sizes, boundary clamping and terminal cleanup on exit. Small,
  redirected and color-disabled terminals use the numbered menu automatically.
- Animated activity indicators while fetching teams and submitting requests.
  Login instructions and confirmation prompts remain visible outside animations.
- `-Demo` lets you explore with example teams and no Microsoft connection.
- `-Interface Plain` and `-NoAnimation` support quieter sessions.
- CLI summaries are intended for reading; `-PassThru` returns structured objects.
- Installation helper and focused guides for setup, daily use and troubleshooting.

## 2.0.0 — 2026-11-01

- Device-code sign-in by default on Windows, macOS and Linux.
- Explicit dependency installation, self-only membership changes and ID validation.
- Preview mode, confirmation before removal, partial failure reporting and cleanup.
- Offline regression tests and Windows/macOS/Linux CI configuration.

## Earlier script

The original script used MicrosoftTeams and PwshSpectreConsole for single or batch
team departure. Version 2 replaces its authentication and selection flow.
