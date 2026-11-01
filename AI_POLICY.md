# AI use policy

letMeRemove allows AI-assisted contributions. This policy explains what we expect
from contributors and maintainers. It applies to code, tests, documentation,
translations, issue reports, reviews and assets.

The tool itself does not call AI services or send data to them at runtime.

## Disclosure

- Say in the pull request or issue whether AI helped, and for what: code, tests,
  documentation, translation or review. A short note is enough.
- Routine editor completion and autocomplete do not need disclosure.
- A human must submit and own the contribution. Fully autonomous pull requests
  opened without a responsible human are not accepted.
- If AI helped prepare a security report, mention it only as needed. Follow
  [SECURITY.md](SECURITY.md) and never paste sensitive details into an AI tool.

## Human accountability

- You are responsible for every change you submit. You should understand it and
  be able to maintain it.
- Reviewers approve the actual diff, not the prompt or a claim that a model
  produced it.
- If you cannot explain a change, do not submit it.

## Licensing and provenance

- Only contribute content you can license under the project's GNU GPL terms; see
  [COPYING](COPYING).
- Do not submit code, text, images or tests copied from sources with incompatible
  licensing or unknown provenance.
- Check that AI output is not a verbatim copy of protected material before
  contributing it.
- You remain responsible for attribution and license compliance.

## Quality and testing

- AI-assisted changes meet the same bar as any other change: tests, documentation,
  style and manual checks.
- Do not claim a check passed unless you ran it.
- Tests generated with AI must assert real behavior. Avoid tests that merely mirror
  the implementation.
- Keep changes reviewable. Large, unexplained generated changes may be declined.

## Security and privacy

- Never paste credentials, access tokens, sign-in codes, tenant or team IDs,
  personal data, private vulnerability details or non-public organizational
  information into an AI tool.
- Follow your employer's and tenant's AI and data-handling policies.
- Do not let an AI tool authenticate to a real Microsoft tenant or perform
  destructive operations without a human reviewing and confirming each action.
- Redact logs and screenshots before sharing them with an AI tool or in a public
  issue.
- AI-assisted security reports follow [SECURITY.md](SECURITY.md). Do not disclose
  vulnerabilities publicly or to third-party tools without permission.

## Security-sensitive changes

Authentication, permissions, membership removal, process supervision, terminal
sanitization and CI or release changes need extra human review. AI may help draft
them, but a human must verify the behavior and the tests. Maintainers may require a
second reviewer for these areas.

## Translations

AI-assisted translations are welcome when a fluent human reviews them. Keep
commands, links, warnings and safety information equivalent to the English source.
English remains the source of truth. Machine-only translations may be declined.

## Maintainer use

Maintainers may use AI for triage, documentation, review assistance and routine
maintenance. Final decisions and merges remain human. Maintainers follow the same
privacy rules as contributors.

## Attribution

Contributors remain the authors of their work. If you use an AI tool, you may credit
it in the pull request or with a commit trailer when that is accurate and useful.
This is optional. Do not present an AI tool as the sole author or use attribution to
avoid human accountability.

## Enforcement

Maintainers may ask for disclosure, request changes or decline a contribution that
does not meet this policy. Repeated or serious violations may lead to blocked
contributions. This policy may be updated as tools and norms change.

Questions? Open an issue or ask a maintainer. For security concerns, follow
[SECURITY.md](SECURITY.md).
