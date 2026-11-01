# letMeRemove 🚪

**Teams में कम शोर। ज़रूरी काम पर ज़्यादा ध्यान।**

जिन टीमों की अब ज़रूरत नहीं है, उन्हें खोजें, चयन जाँचें और Windows, macOS या Linux के टर्मिनल से छोड़ें।

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## टर्मिनल तैयार करें

PowerShell 7.2 या नया संस्करण चाहिए। Windows पर भी `pwsh` इस्तेमाल करें। रिपॉज़िटरी डाउनलोड करें, उसके फ़ोल्डर में टर्मिनल खोलें और अपने उपयोगकर्ता के लिए MicrosoftTeams स्थापित करें:

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## पहले आज़माएँ, फिर इस्तेमाल करें

बिना खाते या Microsoft से कनेक्शन के इंटरफ़ेस देखें:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

साइन इन करके सदस्यता बदले बिना टीम छोड़ने का पूर्वावलोकन करें:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

वास्तव में टीम छोड़ने के लिए `-WhatIf` के बिना चलाएँ। हर टीम के लिए पुष्टि माँगी जाएगी:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

Microsoft का दिखाया लिंक खोलें और अस्थायी कोड दर्ज करें। यह टूल आपका पासवर्ड नहीं माँगता और कोड सहेजता नहीं है।

## कीबोर्ड से नियंत्रण

लिखने से सूची फ़िल्टर होती है; ↑/↓ से आगे बढ़ें; Space से चुनें; Enter से चयन की समीक्षा करें; Esc से रद्द करें। Home/End और Page Up/Page Down से तेज़ी से जाएँ। Backspace खोज संपादित करता है और Delete उसे साफ़ करता है। फ़िल्टर बदलने पर भी चयन बना रहता है।

## अपनी सुविधा के अनुसार

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

ANSI/.NET इंटरफ़ेस साथ आता है; Spectre या अलग .NET SDK की ज़रूरत नहीं है। कम से कम 64 × 24 का इंटरैक्टिव टर्मिनल चाहिए। छोटी विंडो, रीडायरेक्ट किए गए आउटपुट और `NO_COLOR` में सरल मोड चलता है। विंडो न्यूनतम आकार से छोटी होने पर सरल मोड में चयन फिर शुरू होता है।

## पुष्टि करने से पहले

टीम छोड़ने से संबंधित Microsoft 365 समूह की सदस्यता भी हटती है और साझा संसाधनों तक पहुँच प्रभावित हो सकती है। टूल पूरी टीम छोड़ता है, अलग चैनल नहीं। स्वीकृत अनुरोध Teams में दिखने में एक घंटा लग सकता है; भेजे गए अनुरोध वापस लेने की सुविधा नहीं है। अंतिम मालिक को हटाया नहीं जा सकता। संगठन की नीतियाँ लागू रहती हैं।

## मदद और रखरखाव

इंटरफ़ेस और विस्तृत गाइड अंग्रेज़ी में हैं। संरचित परिणाम पाने के लिए `-PassThru` इस्तेमाल करें।

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**लेखक और रखरखावकर्ता:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
