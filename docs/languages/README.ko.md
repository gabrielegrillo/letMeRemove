# letMeRemove 🚪

**Teams의 방해는 줄이고, 중요한 일에 집중하세요.**

더 이상 필요 없는 팀을 찾고 선택 내용을 확인한 뒤 Windows, macOS 또는 Linux 터미널에서 탈퇴하세요.

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## 터미널 준비

PowerShell 7.2 이상이 필요합니다. Windows에서도 `pwsh`를 사용하세요. 저장소를 내려받아 해당 폴더에서 터미널을 열고 현재 사용자용 MicrosoftTeams를 설치하세요.

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## 먼저 살펴보고 시작하기

계정이나 Microsoft 연결 없이 예제 데이터로 인터페이스를 사용해 보세요.

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

로그인한 뒤 멤버 자격을 변경하지 않고 탈퇴 작업을 미리 확인하세요.

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

실제로 탈퇴하려면 `-WhatIf` 없이 실행하세요. 팀마다 확인을 요청합니다.

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

Microsoft가 표시하는 링크를 열고 임시 코드를 입력하세요. 도구는 비밀번호를 요청하지 않으며 코드를 저장하지 않습니다.

## 키보드 조작

입력하면 목록이 필터링됩니다. ↑/↓는 이동, Space는 선택, Enter는 검토, Esc는 취소입니다. Home/End와 Page Up/Page Down으로 빠르게 이동할 수 있습니다. Backspace는 검색을 수정하고 Delete는 검색을 지웁니다. 필터를 바꿔도 선택 항목은 유지됩니다.

## 편한 방식으로 사용하기

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

ANSI/.NET 인터페이스가 포함되어 있어 Spectre나 별도 .NET SDK가 필요 없습니다. 최소 64 × 24 크기의 대화형 터미널이 필요합니다. 작은 창, 출력 리디렉션 또는 `NO_COLOR`에서는 단순 모드를 사용합니다. 창이 최소 크기보다 작아지면 단순 모드에서 선택을 다시 시작합니다.

## 확인하기 전에

팀을 탈퇴하면 연결된 Microsoft 365 그룹의 멤버 자격도 제거되어 공유 리소스 접근에 영향을 줄 수 있습니다. 개별 채널이 아니라 팀 전체를 탈퇴합니다. 수락된 요청이 Teams에 표시되기까지 최대 한 시간이 걸릴 수 있으며, 이 도구는 제출한 요청의 실행 취소를 지원하지 않습니다. 마지막 소유자는 제거할 수 없고 조직 정책은 계속 적용됩니다.

## 도움말 및 유지 관리

인터페이스와 상세 가이드는 영어로 제공됩니다. 구조화된 결과 객체를 받으려면 `-PassThru`를 사용하세요.

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**작성자 및 유지 관리자:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
