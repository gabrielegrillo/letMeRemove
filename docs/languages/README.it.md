# letMeRemove 🚪

**Meno rumore in Teams. Più spazio per ciò che ti serve.**

Scegli i team da lasciare, controlla il riepilogo e conferma l'uscita direttamente
dal terminale. Per **Windows, macOS e Linux**, con PowerShell 7.2 o successivo.

[🌐 18 lingue](../../docs/languages.md) · [English](../../README.md) · [Installazione](../../docs/install.md) · [Guida ai tasti](../../docs/usage.md) ·
[Comandi](../../docs/commands.md) · [Problemi e soluzioni](../../docs/troubleshooting.md)

## Inizia qui

Scarica questa repository e apri il terminale nella sua cartella. Usa `pwsh` anche
su Windows: `powershell.exe` avvia la versione 5.1, che non è supportata.

```powershell
# Installa le dipendenze per il tuo utente
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1

# Prova l'interfaccia con dati di esempio: nessun accesso a Microsoft
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo

# Accedi e simula l'uscita dai team, senza modificare nulla
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf

# Usa il tool: ogni uscita richiede conferma
pwsh -NoProfile -File ./letMeRemove.ps1
```

La pagina Microsoft si apre automaticamente: inserisci il codice temporaneo
mostrato nel terminale. Usa `-NoBrowser` per aprire la pagina manualmente.
Il tool non ti chiede la password.

## Tutto dalla tastiera

| Tasto | Azione |
| --- | --- |
| Scrivi | Filtra i nomi in tempo reale |
| ↑ / ↓ | Sposta il cursore |
| Spazio | Seleziona o deseleziona un team |
| Ctrl+A | Seleziona tutti i team, anche fuori dal filtro; ripremi per azzerare |
| Invio | Mostra il riepilogo della selezione |
| Esc | Annulla la selezione |
| Home / Fine | Vai al primo o all'ultimo risultato |
| PagSu / PagGiù | Spostati di una pagina |
| Backspace | Modifica la ricerca |
| Canc | Azzera la ricerca |

Le selezioni restano attive anche quando cambi filtro. I team con lo stesso nome
sono identificati tramite il loro ID, mostrato per intero nel riepilogo.

## Come preferisci tu

```powershell
./letMeRemove.ps1 -NoAnimation       # Disattiva gli indicatori animati
./letMeRemove.ps1 -Interface Plain   # Menu numerato e riepiloghi semplici
./letMeRemove.ps1 -ListOnly          # Mostra soltanto i tuoi team
```

Il logo ASCII grande e i messaggi `[+]` accompagnano accesso e operazioni.
La selezione aggiorna solo le righe cambiate; l'indicatore di caricamento mostra
il tempo trascorso su una sola riga, senza ridisegnare tutta la schermata.

L'interfaccia ANSI/.NET è inclusa: non servono Spectre né un SDK .NET separato.
Richiede un terminale ANSI
interattivo di almeno 64 colonne per 24 righe. Se mancano questi requisiti,
il tool passa alla modalità semplice. Vale anche con `NO_COLOR`, output
reindirizzato e terminali ridotti sotto la dimensione minima durante la selezione.
In quest'ultimo caso la selezione riparte: nessuna uscita viene inviata.

**Lasciare un team rimuove anche l'appartenenza al relativo gruppo Microsoft 365**,
con possibili effetti sull'accesso alle risorse condivise. Il tool agisce su team
interi, non sui singoli canali. Una richiesta accettata può impiegare fino a un'ora
per comparire in Teams; il tool non offre un annullamento delle richieste inviate.
L'ultimo proprietario non può essere rimosso e le regole della tua organizzazione
restano valide.

Le guide di dettaglio sono in inglese. Consulta [problemi e soluzioni](../../docs/troubleshooting.md)
per errori di accesso o terminale e [comandi](../../docs/commands.md) per esportare risultati
con `-PassThru`. Licenza GNU GPL: [COPYING](../../COPYING).

## Autori e manutentori

**Matteo Marzano (pxxyco)** e **[Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo)**.
[Crediti](../../AUTHORS.md) · [README in tutte le lingue disponibili](../../docs/languages.md)

I README sono disponibili in 18 lingue. I messaggi dell'interfaccia e le guide
di dettaglio restano in inglese.
