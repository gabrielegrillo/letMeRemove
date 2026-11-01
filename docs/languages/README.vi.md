# letMeRemove 🚪

**Bớt phiền nhiễu trong Teams. Tập trung hơn vào việc quan trọng.**

Tìm các nhóm không còn cần thiết, kiểm tra lựa chọn rồi rời nhóm ngay trong terminal trên Windows, macOS hoặc Linux.

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## Chuẩn bị terminal

Cần PowerShell 7.2 trở lên (`pwsh`, kể cả trên Windows). Tải kho mã, mở terminal trong thư mục đó rồi cài MicrosoftTeams cho người dùng hiện tại:

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## Dùng thử trước khi bắt đầu

Khám phá giao diện bằng dữ liệu mẫu, không cần tài khoản hay kết nối Microsoft:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

Đăng nhập và xem trước thao tác rời nhóm mà không thay đổi tư cách thành viên:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

Để thực sự rời nhóm, chạy không có `-WhatIf`. Mỗi nhóm đều cần xác nhận:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

Mở liên kết do Microsoft hiển thị và nhập mã tạm thời. Công cụ không yêu cầu mật khẩu và không lưu mã này.

## Điều khiển bằng bàn phím

Gõ để lọc; ↑/↓ để di chuyển; Space để chọn; Enter để xem lại; Esc để hủy. Home/End và Page Up/Page Down giúp di chuyển nhanh. Backspace sửa nội dung tìm kiếm, Delete xóa tìm kiếm. Các lựa chọn được giữ lại khi đổi bộ lọc.

## Theo cách của bạn

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

Giao diện ANSI/.NET được tích hợp sẵn, không cần Spectre hay .NET SDK riêng. Cần terminal tương tác tối thiểu 64 × 24. Cửa sổ nhỏ, đầu ra chuyển hướng và `NO_COLOR` dùng chế độ đơn giản. Nếu thu nhỏ dưới giới hạn, việc chọn nhóm bắt đầu lại ở chế độ đơn giản.

## Trước khi xác nhận

Rời nhóm cũng xóa tư cách thành viên trong nhóm Microsoft 365 liên kết và có thể ảnh hưởng quyền truy cập tài nguyên chung. Công cụ rời toàn bộ nhóm, không phải từng kênh. Yêu cầu được chấp nhận có thể mất tới một giờ để hiển thị trong Teams; công cụ không hỗ trợ hoàn tác yêu cầu đã gửi. Không thể xóa chủ sở hữu cuối cùng. Chính sách tổ chức vẫn được áp dụng.

## Trợ giúp và người duy trì

Giao diện và hướng dẫn chi tiết bằng tiếng Anh. Dùng `-PassThru` để nhận các đối tượng kết quả có cấu trúc.

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**Tác giả và người duy trì:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
