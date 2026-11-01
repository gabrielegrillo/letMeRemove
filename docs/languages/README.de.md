# letMeRemove 🚪

**Weniger Ablenkung in Teams. Mehr Raum für das Wesentliche.**

Finde Teams, die du nicht mehr brauchst, prüfe deine Auswahl und verlasse sie im Terminal unter Windows, macOS oder Linux.

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## Terminal vorbereiten

Du brauchst PowerShell 7.2 oder neuer (`pwsh`, auch unter Windows). Lade das Repository herunter, öffne ein Terminal in dessen Ordner und installiere MicrosoftTeams für dein Benutzerkonto:

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## Ausprobieren und loslegen

Probiere die Oberfläche ohne Konto und ohne Verbindung zu Microsoft aus:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

Melde dich an und sieh dir die geplanten Austritte an, ohne Mitgliedschaften zu ändern:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

Für tatsächliche Austritte starte ohne `-WhatIf`. Jeder Austritt muss bestätigt werden:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

Öffne den von Microsoft angezeigten Link und gib den angezeigten Einmalcode ein. Das Tool fragt nicht nach deinem Passwort und speichert den Code nicht.

## Bedienung per Tastatur

Tippen filtert die Liste; ↑/↓ bewegt den Fokus; Leertaste wählt aus; Eingabe öffnet die Übersicht; Esc bricht ab. Pos1/Ende und Bild↑/Bild↓ springen durch die Liste. Rücktaste bearbeitet die Suche, Entf löscht sie. Die Auswahl bleibt beim Filtern erhalten.

## So, wie es für dich passt

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

Die ANSI/.NET-Oberfläche wird mitgeliefert. Weder Spectre noch ein separates .NET-SDK sind nötig. Sie benötigt ein interaktives Terminal mit mindestens 64 × 24 Zeichen. Kleine Fenster, umgeleitete Ausgaben und `NO_COLOR` verwenden den einfachen Modus. Wird das Fenster zu klein, beginnt die Auswahl dort neu.

## Vor dem Bestätigen

Beim Verlassen eines Teams verlässt du auch die zugehörige Microsoft-365-Gruppe. Dadurch kann der Zugriff auf gemeinsame Ressourcen entfallen. Es geht um ganze Teams, nicht einzelne Kanäle. Angenommene Anfragen können erst nach bis zu einer Stunde sichtbar werden; das Tool bietet kein Rückgängigmachen. Der letzte Besitzer kann nicht entfernt werden. Die Richtlinien deiner Organisation gelten weiterhin.

## Hilfe und Verantwortliche

Oberfläche und ausführliche Anleitungen sind auf Englisch. `-PassThru` liefert strukturierte Ergebnisobjekte.

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**Autoren und Maintainer:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
