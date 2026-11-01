# letMeRemove 🚪

**شلوغی کمتر در Teams، تمرکز بیشتر بر کارهای مهم.**

تیم‌هایی را که دیگر نیاز ندارید پیدا کنید، انتخابتان را بررسی کنید و از ترمینال Windows، macOS یا Linux از آن‌ها خارج شوید.

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## آماده‌سازی ترمینال

به PowerShell 7.2 یا جدیدتر نیاز دارید. در Windows هم از `pwsh` استفاده کنید. مخزن را دانلود کنید، ترمینال را در پوشهٔ آن باز کنید و MicrosoftTeams را برای کاربر خود نصب کنید:

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## ابتدا امتحان کنید

رابط را با داده‌های نمونه، بدون حساب یا اتصال به Microsoft امتحان کنید:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

وارد حساب شوید و خروج از تیم‌ها را بدون تغییر عضویت پیش‌نمایش کنید:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

برای خروج واقعی، بدون `-WhatIf` اجرا کنید. برای هر تیم تأیید خواسته می‌شود:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

پیوندی را که Microsoft نشان می‌دهد باز کنید و کد موقت را وارد کنید. ابزار گذرواژهٔ شما را نمی‌خواهد و کد را ذخیره نمی‌کند.

## کنترل با صفحه‌کلید

با تایپ کردن فهرست را فیلتر کنید؛ ↑/↓ برای حرکت، Space برای انتخاب، Enter برای بررسی و Esc برای لغو است. Home/End و Page Up/Page Down حرکت سریع‌تری دارند. Backspace جست‌وجو را ویرایش و Delete آن را پاک می‌کند. انتخاب‌ها با تغییر فیلتر حفظ می‌شوند.

## مطابق نیاز شما

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

رابط ANSI/.NET همراه ابزار است؛ به Spectre یا .NET SDK جداگانه نیاز نیست. ترمینال تعاملی با اندازهٔ حداقل 64 × 24 لازم است. پنجرهٔ کوچک، خروجی هدایت‌شده و `NO_COLOR` از حالت ساده استفاده می‌کنند. اگر پنجره از حداقل کوچک‌تر شود، انتخاب در حالت ساده از نو آغاز می‌شود.

## پیش از تأیید

خروج از تیم، عضویت در گروه Microsoft 365 مرتبط را نیز حذف می‌کند و ممکن است بر دسترسی به منابع مشترک اثر بگذارد. ابزار از کل تیم خارج می‌شود، نه از کانال‌های جداگانه. نمایش درخواست پذیرفته‌شده در Teams ممکن است تا یک ساعت طول بکشد؛ ابزار امکان بازگرداندن درخواست ارسال‌شده را ندارد. آخرین مالک قابل حذف نیست و سیاست‌های سازمان همچنان برقرارند.

## راهنما و نگه‌داری

رابط و راهنماهای تفصیلی به زبان انگلیسی هستند. برای دریافت نتیجه‌های ساختاریافته از `-PassThru` استفاده کنید.

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**نویسندگان و نگه‌دارندگان:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
