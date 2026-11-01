# letMeRemove 🚪

**ضوضاء أقل في Teams، وتركيز أكبر على ما يهمك.**

ابحث عن الفرق التي لم تعد تحتاج إليها، وراجع اختيارك، ثم غادرها من الطرفية على Windows أو macOS أو Linux.

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## تجهيز الطرفية

تحتاج إلى PowerShell 7.2 أو أحدث. استخدم `pwsh` حتى على Windows. نزّل المستودع، وافتح الطرفية في مجلده، ثم ثبّت MicrosoftTeams لحساب المستخدم المحلي:

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## جرّب الأداة ثم ابدأ

استكشف الواجهة دون حساب أو اتصال بخدمات Microsoft:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

سجّل الدخول وعاين عمليات المغادرة دون تغيير العضوية:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

للمغادرة الفعلية، شغّل الأداة دون `-WhatIf`. ستُطلب موافقتك لكل فريق:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

افتح رابط Microsoft وأدخل الرمز المؤقت الذي تعرضه. لا تطلب الأداة كلمة المرور ولا تحفظ الرمز.

## التحكم بلوحة المفاتيح

اكتب لتصفية القائمة؛ ↑ و↓ للتنقل؛ Space للتحديد؛ Enter للمراجعة؛ Esc للإلغاء. استخدم Home وEnd وPage Up وPage Down للتنقل السريع. يعدّل Backspace البحث ويمسحه Delete. تبقى العناصر محددة عند تغيير التصفية.

## اختر ما يناسبك

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

واجهة ANSI/.NET مرفقة؛ لا تحتاج إلى Spectre أو حزمة .NET SDK منفصلة. يلزم طرفية تفاعلية بحجم 64 × 24 على الأقل. تُستخدم الواجهة البسيطة في النوافذ الصغيرة أو عند إعادة توجيه المخرجات أو تفعيل `NO_COLOR`. إذا صغرت النافذة عن الحد الأدنى، يبدأ التحديد من جديد في الوضع البسيط.

## قبل التأكيد

تؤدي مغادرة الفريق أيضًا إلى إزالة عضويتك في مجموعة Microsoft 365 المرتبطة، وقد تؤثر في الوصول إلى الموارد المشتركة. تغادر الأداة فرقًا كاملة، لا قنوات منفردة. قد يستغرق ظهور الطلب المقبول في Teams ساعة، ولا توفر الأداة التراجع عن الطلبات المرسلة. لا يمكن إزالة آخر مالك للفريق، وتظل سياسات مؤسستك سارية.

## المساعدة والمسؤولون

الواجهة والأدلة التفصيلية باللغة الإنجليزية. استخدم `-PassThru` للحصول على نتائج منظمة.

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**المؤلفان والقائمان على الصيانة:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
