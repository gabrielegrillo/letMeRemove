# letMeRemove 🚪

**Moins de bruit dans Teams. Plus de place pour l’essentiel.**

Recherchez les équipes dont vous n’avez plus besoin, vérifiez votre sélection et quittez-les depuis votre terminal sous Windows, macOS ou Linux.

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## Préparer le terminal

Utilisez PowerShell 7.2 ou une version ultérieure (`pwsh`, y compris sous Windows). Téléchargez le dépôt, ouvrez un terminal dans son dossier et installez MicrosoftTeams pour votre compte local :

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## Essayer, puis utiliser

Découvrez l’interface sans compte ni connexion à Microsoft :

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

Connectez-vous et simulez les départs sans modifier vos appartenances :

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

Pour quitter réellement des équipes, relancez sans `-WhatIf`. Chaque départ demande une confirmation :

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

Suivez le lien Microsoft et saisissez le code temporaire affiché. L’outil ne demande pas votre mot de passe et n’enregistre pas ce code.

## Tout au clavier

Saisissez du texte pour filtrer ; ↑/↓ déplace le curseur ; Espace sélectionne ; Entrée affiche le récapitulatif ; Échap annule. Début/Fin et Page précédente/suivante permettent de parcourir la liste. Retour arrière modifie la recherche, Suppr l’efface. Les sélections sont conservées entre les filtres.

## À votre rythme

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

L’interface ANSI/.NET est fournie : aucun module Spectre ni SDK .NET séparé n’est nécessaire. Elle demande un terminal interactif d’au moins 64 × 24. Les petites fenêtres, les sorties redirigées et `NO_COLOR` utilisent le mode simple. Si la fenêtre devient trop petite, la sélection redémarre dans ce mode.

## Avant de confirmer

Quitter une équipe retire aussi votre appartenance au groupe Microsoft 365 associé et peut affecter l’accès aux ressources partagées. L’outil quitte des équipes entières, pas des canaux individuels. Une demande acceptée peut mettre jusqu’à une heure à apparaître ; l’outil ne propose pas d’annulation. Le dernier propriétaire ne peut pas être retiré et les règles de votre organisation restent applicables.

## Aide et responsables

L’interface et les guides détaillés sont en anglais. Utilisez `-PassThru` pour récupérer des objets structurés.

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**Auteurs et mainteneurs:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
