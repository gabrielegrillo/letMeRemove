# letMeRemove 🚪

**Teams’te daha az gürültü. Önemli işlere daha çok odak.**

Artık ihtiyaç duymadığınız ekipleri bulun, seçiminizi gözden geçirin ve Windows, macOS veya Linux terminalinden ayrılın.

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## Terminali hazırlayın

PowerShell 7.2 veya üzeri gerekir. Windows’ta da `pwsh` kullanın. Depoyu indirin, klasöründe bir terminal açın ve MicrosoftTeams’i kendi kullanıcınız için kurun:

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## Önce deneyin, sonra kullanın

Hesap veya Microsoft bağlantısı olmadan örnek verilerle arayüzü keşfedin:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

Oturum açıp üyeliği değiştirmeden ayrılma işlemlerini önizleyin:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

Gerçekten ayrılmak için `-WhatIf` olmadan çalıştırın. Her ekip için onay istenir:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

Microsoft’un gösterdiği bağlantıyı açıp geçici kodu girin. Araç parolanızı istemez ve kodu kaydetmez.

## Klavye ile kontrol

Yazarak filtreleyin; ↑/↓ ile ilerleyin; Space ile seçin; Enter ile gözden geçirin; Esc ile iptal edin. Home/End ve Page Up/Page Down hızlı gezinir. Backspace aramayı düzenler, Delete temizler. Filtre değişse de seçimler korunur.

## Size uygun şekilde

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

ANSI/.NET arayüzü dahildir; Spectre veya ayrı bir .NET SDK gerekmez. En az 64 × 24 boyutunda etkileşimli terminal gerekir. Küçük pencerelerde, yönlendirilmiş çıktıda veya `NO_COLOR` ile sade mod kullanılır. Pencere asgari boyutun altına düşerse seçim sade modda yeniden başlar.

## Onaylamadan önce

Bir ekipten ayrılmak, ilişkili Microsoft 365 grubu üyeliğini de kaldırır ve paylaşılan kaynaklara erişimi etkileyebilir. Tek tek kanallardan değil, ekiplerin tamamından ayrılırsınız. Kabul edilen isteğin Teams’e yansıması bir saati bulabilir; araç gönderilen istekleri geri alamaz. Son sahip kaldırılamaz. Kuruluşunuzun ilkeleri geçerliliğini korur.

## Yardım ve bakım

Arayüz ve ayrıntılı kılavuzlar İngilizcedir. Yapılandırılmış sonuçlar için `-PassThru` kullanın.

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**Yazarlar ve bakım sorumluları:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
