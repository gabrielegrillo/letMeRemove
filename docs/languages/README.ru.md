# letMeRemove 🚪

**Меньше шума в Teams. Больше внимания важному.**

Найдите ненужные команды, проверьте выбор и покиньте их прямо из терминала в Windows, macOS или Linux.

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## Подготовка терминала

Нужен PowerShell 7.2 или новее (`pwsh`, в том числе в Windows). Скачайте репозиторий, откройте терминал в его папке и установите MicrosoftTeams для своего пользователя:

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## Попробуйте и начните работу

Посмотрите интерфейс без учётной записи и подключения к Microsoft:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

Войдите и просмотрите запланированные выходы без изменения членства:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

Для реального выхода запустите без `-WhatIf`. Каждый выход требует подтверждения:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

Откройте адрес Microsoft и введите показанный одноразовый код. Утилита не запрашивает пароль и не сохраняет этот код.

## Управление с клавиатуры

Ввод текста фильтрует список; ↑/↓ перемещают курсор; Пробел выбирает; Enter открывает обзор; Esc отменяет. Home/End и Page Up/Page Down перемещают по списку. Backspace изменяет поиск, Delete очищает его. Выбор сохраняется при смене фильтра.

## Удобный вам режим

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

Интерфейс ANSI/.NET входит в комплект: Spectre и отдельный .NET SDK не нужны. Требуется интерактивный терминал размером не менее 64 × 24. В маленьком окне, при перенаправлении вывода или с `NO_COLOR` используется простой режим. При уменьшении окна ниже минимума выбор в этом режиме начинается заново.

## Перед подтверждением

Выход из команды также удаляет членство в связанной группе Microsoft 365 и может повлиять на доступ к общим ресурсам. Утилита работает с целыми командами, а не отдельными каналами. Принятый запрос может отобразиться в Teams в течение часа; отмены отправленных запросов в утилите нет. Последнего владельца удалить нельзя. Политики организации остаются в силе.

## Помощь и сопровождение

Интерфейс и подробные руководства — на английском. `-PassThru` возвращает структурированные объекты результатов.

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**Авторы и сопровождающие:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
