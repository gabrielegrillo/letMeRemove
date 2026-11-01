# letMeRemove 🚪

**Menos ruido en Teams. Más tiempo para lo que importa.**

Busca los equipos que ya no necesitas, revisa tu selección y abandónalos desde el terminal en Windows, macOS o Linux.

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## Prepara el terminal

Necesitas PowerShell 7.2 o posterior (`pwsh`, también en Windows). Descarga el repositorio, abre un terminal en su carpeta e instala MicrosoftTeams para tu usuario:

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## Pruébalo y empieza

Explora la interfaz sin cuenta ni conexión a Microsoft:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

Inicia sesión y simula la salida sin cambiar ninguna pertenencia:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

Para salir de verdad, ejecútalo sin `-WhatIf`. Se pide confirmación para cada equipo:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

Sigue el enlace de Microsoft e introduce el código temporal que muestra. La herramienta no te pide la contraseña ni guarda el código.

## Todo desde el teclado

Escribe para filtrar; ↑/↓ mueve el cursor; Espacio selecciona; Intro revisa la selección; Esc cancela. Inicio/Fin y RePág/AvPág permiten saltar por la lista. Retroceso edita la búsqueda y Supr la borra. Las selecciones se conservan al cambiar el filtro.

## A tu ritmo

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

La interfaz ANSI/.NET viene incluida: no necesita Spectre ni un SDK de .NET aparte. Requiere un terminal interactivo de al menos 64 × 24. Los terminales pequeños, la salida redirigida y `NO_COLOR` activan el modo simple. Si la ventana se reduce por debajo del mínimo, la selección se reinicia en ese modo.

## Antes de confirmar

Salir de un equipo también elimina tu pertenencia a su grupo de Microsoft 365 y puede afectar al acceso a recursos compartidos. Se abandonan equipos completos, no canales individuales. Una solicitud aceptada puede tardar hasta una hora en reflejarse y no tiene una opción de deshacer en esta herramienta. No se puede eliminar al último propietario; se respetan las políticas de tu organización.

## Ayuda y responsables

La interfaz y las guías detalladas están en inglés. Usa `-PassThru` para obtener resultados estructurados.

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**Autores y mantenedores:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
