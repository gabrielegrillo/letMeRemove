# letMeRemove 🚪

**Menos ruído no Teams. Mais foco no seu dia.**

Encontre as equipes de que você não precisa mais, confira a seleção e saia delas pelo terminal no Windows, macOS ou Linux.

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## Prepare o terminal

Use PowerShell 7.2 ou posterior (`pwsh`, inclusive no Windows). Baixe o repositório, abra um terminal na pasta e instale o MicrosoftTeams para o seu usuário:

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## Experimente e comece

Conheça a interface sem conta nem conexão com a Microsoft:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

Entre na sua conta e simule a saída sem alterar nenhuma associação:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

Para sair de verdade, execute sem `-WhatIf`. Cada saída pede confirmação:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

Acesse o endereço mostrado pela Microsoft e digite o código temporário exibido. A ferramenta não pede sua senha nem salva o código.

## Tudo pelo teclado

Digite para filtrar; ↑/↓ move o foco; Espaço seleciona; Enter mostra a revisão; Esc cancela. Home/End e Page Up/Page Down percorrem a lista. Backspace edita a busca e Delete limpa o filtro. As seleções são mantidas ao filtrar.

## Do seu jeito

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

A interface ANSI/.NET já vem incluída, sem precisar de Spectre ou de um SDK do .NET separado. Use um terminal interativo de pelo menos 64 × 24. Janelas pequenas, saída redirecionada e `NO_COLOR` usam o modo simples. Se a janela ficar abaixo do mínimo, a seleção recomeça nesse modo.

## Antes de confirmar

Sair de uma equipe também remove sua associação ao grupo do Microsoft 365 correspondente, podendo afetar o acesso a recursos compartilhados. A ferramenta sai de equipes inteiras, não de canais isolados. Uma solicitação aceita pode levar até uma hora para aparecer e não pode ser desfeita pela ferramenta. O último proprietário não pode ser removido. As políticas da sua organização continuam valendo.

## Ajuda e responsáveis

A interface e os guias detalhados estão em inglês. Use `-PassThru` para obter objetos de resultado estruturados.

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**Autores e mantenedores:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
