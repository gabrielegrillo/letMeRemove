# letMeRemove 🚪

**Teams の雑音を減らして、大切なことに集中。**

不要になったチームを探し、選択内容を確認して、Windows・macOS・Linux のターミナルから退出できます。

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## ターミナルの準備

PowerShell 7.2 以降が必要です。Windows でも `pwsh` を使用してください。リポジトリをダウンロードし、そのフォルダーでターミナルを開いて、現在のユーザー向けに MicrosoftTeams をインストールします。

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## まず試してから使う

アカウントや Microsoft への接続なしで、サンプルの操作画面を試せます。

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

サインインして退出操作をプレビューします。メンバーシップは変更されません。

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

実際に退出するには `-WhatIf` を付けずに実行します。チームごとに確認が求められます。

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

Microsoft が表示するリンクを開き、一時コードを入力してください。このツールはパスワードを求めず、コードも保存しません。

## キーボード操作

文字入力で絞り込み、↑/↓で移動、スペースで選択、Enter で確認画面、Esc でキャンセルします。Home/End、Page Up/Page Down で素早く移動できます。Backspace は検索の編集、Delete は検索の消去です。絞り込みを変えても選択は保持されます。

## 好みに合わせて

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

ANSI/.NET の画面機能を同梱しています。Spectre や別途の .NET SDK は不要です。64 × 24 以上の対話型ターミナルが必要です。小さい画面、出力のリダイレクト、`NO_COLOR` では簡易モードになります。画面が最小サイズを下回ると、簡易モードで選択をやり直します。

## 確認する前に

チームを退出すると、関連する Microsoft 365 グループからも削除され、共有リソースへのアクセスに影響する場合があります。対象はチーム全体であり、個別のチャネルではありません。受理された要求が Teams に反映されるまで最大 1 時間かかることがあり、このツールで送信済み要求を取り消すことはできません。最後の所有者は削除できず、組織のポリシーも引き続き適用されます。

## ヘルプとメンテナンス

画面と詳細ガイドは英語です。構造化された結果を取得するには `-PassThru` を指定します。

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**作者・メンテナー:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
