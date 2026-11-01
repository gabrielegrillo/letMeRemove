# letMeRemove 🚪

**减少 Teams 干扰，让重要的事更清晰。**

在 Windows、macOS 或 Linux 的终端中查找不再需要的团队，核对选择后退出。

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## 准备终端

需要 PowerShell 7.2 或更高版本，Windows 上也请使用 `pwsh`。下载仓库，在其目录中打开终端，为当前用户安装 MicrosoftTeams：

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## 先体验，再使用

使用示例数据体验界面，无需账户，也不会连接 Microsoft：

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

登录并预览退出操作，不更改任何成员身份：

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

准备好后，不带 `-WhatIf` 运行。退出每个团队前都会请求确认：

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

打开 Microsoft 显示的链接并输入临时代码。本工具不会索取密码，也不会保存该代码。

## 键盘操作

直接输入文字可筛选团队；↑/↓ 移动焦点；空格选择或取消选择；Enter 查看汇总；Esc 取消。Home/End 和 Page Up/Page Down 可快速移动。Backspace 编辑搜索，Delete 清空搜索。更改筛选条件不会丢失已有选择。

## 按你的习惯使用

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

内置 ANSI/.NET 界面，无需 Spectre 或单独的 .NET SDK。完整界面需要至少 64 × 24 的交互式终端。窗口过小、输出重定向或设置 `NO_COLOR` 时使用简单模式。窗口缩小到最低要求以下时，会在简单模式中重新开始选择。

## 确认前请注意

退出团队也会移除关联 Microsoft 365 组的成员身份，可能影响共享资源的访问权限。本工具退出整个团队，而不是单独频道。已接受的请求可能需要最多一小时才会在 Teams 中显示；本工具不提供撤销已提交请求的功能。无法移除最后一位所有者，组织策略仍然有效。

## 帮助与维护

界面和详细文档使用英语。通过 `-PassThru` 获取结构化结果对象。

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**作者与维护者:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
