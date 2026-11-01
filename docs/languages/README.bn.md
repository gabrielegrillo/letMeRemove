# letMeRemove 🚪

**Teams-এ কম কোলাহল। গুরুত্বপূর্ণ কাজে বেশি মনোযোগ।**

যে টিমগুলো আর দরকার নেই সেগুলো খুঁজুন, নির্বাচন যাচাই করুন এবং Windows, macOS বা Linux-এর টার্মিনাল থেকে ছেড়ে দিন।

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## টার্মিনাল প্রস্তুত করুন

PowerShell 7.2 বা পরের সংস্করণ লাগবে। Windows-এও `pwsh` ব্যবহার করুন। রিপোজিটরি ডাউনলোড করে তার ফোল্ডারে টার্মিনাল খুলুন এবং নিজের ব্যবহারকারীর জন্য MicrosoftTeams ইনস্টল করুন:

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## আগে দেখুন, তারপর ব্যবহার করুন

অ্যাকাউন্ট বা Microsoft-এর সঙ্গে সংযোগ ছাড়াই ইন্টারফেস দেখুন:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

সাইন ইন করে সদস্যপদ না বদলে টিম ছাড়ার পূর্বরূপ দেখুন:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

সত্যিই ছাড়তে হলে `-WhatIf` ছাড়া চালান। প্রতিটি টিমের জন্য নিশ্চিত করতে হবে:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

Microsoft-এর দেখানো লিংক খুলে অস্থায়ী কোড লিখুন। টুলটি আপনার পাসওয়ার্ড চায় না এবং কোড সংরক্ষণ করে না।

## কিবোর্ডে নিয়ন্ত্রণ

লিখলে তালিকা ফিল্টার হয়; ↑/↓ দিয়ে সরুন; Space দিয়ে নির্বাচন করুন; Enter দিয়ে পর্যালোচনা করুন; Esc দিয়ে বাতিল করুন। Home/End ও Page Up/Page Down দিয়ে দ্রুত চলুন। Backspace অনুসন্ধান সম্পাদনা করে, Delete মুছে দেয়। ফিল্টার বদলালেও নির্বাচন বজায় থাকে।

## আপনার সুবিধামতো

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

ANSI/.NET ইন্টারফেস সঙ্গে দেওয়া আছে; Spectre বা আলাদা .NET SDK লাগে না। অন্তত 64 × 24 আকারের ইন্টারঅ্যাক্টিভ টার্মিনাল দরকার। ছোট উইন্ডো, রিডাইরেক্ট করা আউটপুট ও `NO_COLOR`-এ সাধারণ মোড ব্যবহৃত হয়। উইন্ডো ন্যূনতম আকারের নিচে নামলে সাধারণ মোডে নির্বাচন নতুন করে শুরু হয়।

## নিশ্চিত করার আগে

টিম ছাড়লে সংশ্লিষ্ট Microsoft 365 গ্রুপের সদস্যপদও সরবে এবং শেয়ার করা রিসোর্সে প্রবেশাধিকার প্রভাবিত হতে পারে। টুলটি পুরো টিম ছাড়ে, আলাদা চ্যানেল নয়। গৃহীত অনুরোধ Teams-এ দেখাতে এক ঘণ্টা লাগতে পারে; পাঠানো অনুরোধ ফিরিয়ে নেওয়ার সুবিধা নেই। শেষ মালিককে সরানো যায় না। প্রতিষ্ঠানের নীতি প্রযোজ্য থাকে।

## সাহায্য ও রক্ষণাবেক্ষণ

ইন্টারফেস ও বিস্তারিত নির্দেশিকা ইংরেজিতে। কাঠামোবদ্ধ ফলের জন্য `-PassThru` ব্যবহার করুন।

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**লেখক ও রক্ষণাবেক্ষণকারী:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
