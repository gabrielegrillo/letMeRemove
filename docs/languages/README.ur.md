# letMeRemove 🚪

**Teams میں کم شور، اہم کام پر زیادہ توجہ۔**

جن ٹیموں کی اب ضرورت نہیں انہیں تلاش کریں، انتخاب کا جائزہ لیں اور Windows، macOS یا Linux کے ٹرمینل سے چھوڑ دیں۔

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## ٹرمینل تیار کریں

PowerShell 7.2 یا جدید تر درکار ہے۔ Windows پر بھی `pwsh` استعمال کریں۔ ریپوزٹری ڈاؤن لوڈ کریں، اس کے فولڈر میں ٹرمینل کھولیں اور اپنے صارف کے لیے MicrosoftTeams نصب کریں:

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## پہلے آزمائیں، پھر استعمال کریں

اکاؤنٹ یا Microsoft سے رابطے کے بغیر نمونہ ڈیٹا سے انٹرفیس آزمائیں:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

سائن اِن کریں اور رکنیت بدلے بغیر ٹیم چھوڑنے کا پیش منظر دیکھیں:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

حقیقت میں چھوڑنے کے لیے `-WhatIf` کے بغیر چلائیں۔ ہر ٹیم کے لیے تصدیق مانگی جائے گی:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

Microsoft کا دکھایا ہوا ربط کھول کر عارضی کوڈ درج کریں۔ یہ ٹول آپ کا پاس ورڈ نہیں مانگتا اور کوڈ محفوظ نہیں کرتا۔

## کی بورڈ سے کنٹرول

لکھنے سے فہرست فلٹر ہوتی ہے؛ ↑/↓ سے حرکت کریں؛ Space سے منتخب کریں؛ Enter سے جائزہ لیں؛ Esc سے منسوخ کریں۔ Home/End اور Page Up/Page Down تیز حرکت کرتے ہیں۔ Backspace تلاش میں ترمیم اور Delete اسے صاف کرتا ہے۔ فلٹر بدلنے پر بھی انتخاب برقرار رہتا ہے۔

## اپنی سہولت کے مطابق

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

ANSI/.NET انٹرفیس ساتھ شامل ہے؛ Spectre یا الگ .NET SDK کی ضرورت نہیں۔ کم از کم 64 × 24 کا تعاملی ٹرمینل درکار ہے۔ چھوٹی ونڈو، ری ڈائریکٹ شدہ آؤٹ پٹ اور `NO_COLOR` میں سادہ موڈ استعمال ہوتا ہے۔ ونڈو کم از کم حجم سے چھوٹی ہو تو انتخاب سادہ موڈ میں دوبارہ شروع ہوتا ہے۔

## تصدیق سے پہلے

ٹیم چھوڑنے سے متعلقہ Microsoft 365 گروپ کی رکنیت بھی ختم ہوتی ہے اور مشترکہ وسائل تک رسائی متاثر ہو سکتی ہے۔ ٹول پوری ٹیم چھوڑتا ہے، الگ چینل نہیں۔ قبول شدہ درخواست Teams میں ظاہر ہونے میں ایک گھنٹہ لے سکتی ہے؛ ٹول بھیجی گئی درخواست واپس نہیں لے سکتا۔ آخری مالک کو ہٹایا نہیں جا سکتا۔ ادارے کی پالیسیاں بدستور لاگو رہتی ہیں۔

## مدد اور دیکھ بھال

انٹرفیس اور تفصیلی رہنما انگریزی میں ہیں۔ منظم نتائج کے لیے `-PassThru` استعمال کریں۔

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**مصنفین اور دیکھ بھال کرنے والے:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
