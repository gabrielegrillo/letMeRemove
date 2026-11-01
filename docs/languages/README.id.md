# letMeRemove 🚪

**Lebih sedikit gangguan di Teams. Lebih fokus pada hal penting.**

Cari tim yang tidak lagi Anda perlukan, periksa pilihan Anda, lalu keluar melalui terminal di Windows, macOS, atau Linux.

[🌐 Languages](../../docs/languages.md) · [English](../../README.md) · [Italiano](README.it.md)

## Siapkan terminal

Gunakan PowerShell 7.2 atau lebih baru (`pwsh`, termasuk di Windows). Unduh repositori, buka terminal di foldernya, lalu instal MicrosoftTeams untuk pengguna Anda:

```powershell
pwsh -NoProfile -File ./scripts/Install-Dependencies.ps1
```

## Coba terlebih dahulu

Jelajahi antarmuka dengan data contoh, tanpa akun atau koneksi ke Microsoft:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -Demo
```

Masuk dan pratinjau tindakan keluar tanpa mengubah keanggotaan:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1 -WhatIf
```

Untuk benar-benar keluar, jalankan tanpa `-WhatIf`. Setiap tim memerlukan konfirmasi:

```powershell
pwsh -NoProfile -File ./letMeRemove.ps1
```

Buka tautan yang ditampilkan Microsoft dan masukkan kode sementara. Alat ini tidak meminta kata sandi dan tidak menyimpan kode tersebut.

## Kendali dengan papan ketik

Ketik untuk memfilter; ↑/↓ memindahkan fokus; Space memilih; Enter meninjau; Esc membatalkan. Home/End dan Page Up/Page Down menavigasi lebih cepat. Backspace mengedit pencarian dan Delete menghapusnya. Pilihan tetap tersimpan saat filter berubah.

## Sesuai kebutuhan Anda

```powershell
./letMeRemove.ps1 -NoAnimation
./letMeRemove.ps1 -Interface Plain
./letMeRemove.ps1 -ListOnly
```

Antarmuka ANSI/.NET sudah disertakan, tanpa Spectre atau .NET SDK terpisah. Diperlukan terminal interaktif minimal 64 × 24. Jendela kecil, keluaran yang dialihkan, dan `NO_COLOR` memakai mode sederhana. Jika jendela lebih kecil dari batas minimum, pemilihan dimulai ulang dalam mode sederhana.

## Sebelum mengonfirmasi

Keluar dari tim juga menghapus keanggotaan grup Microsoft 365 terkait dan dapat memengaruhi akses ke sumber daya bersama. Alat ini keluar dari seluruh tim, bukan kanal tertentu. Permintaan yang diterima dapat memerlukan waktu hingga satu jam untuk terlihat di Teams; alat ini tidak menyediakan pembatalan permintaan yang sudah dikirim. Pemilik terakhir tidak dapat dihapus. Kebijakan organisasi tetap berlaku.

## Bantuan dan pengelola

Antarmuka dan panduan terperinci tersedia dalam bahasa Inggris. Gunakan `-PassThru` untuk mendapatkan objek hasil terstruktur.

[Install (EN)](../../docs/install.md) · [Usage (EN)](../../docs/usage.md) ·
[Commands (EN)](../../docs/commands.md) · [Troubleshooting (EN)](../../docs/troubleshooting.md)

**Penulis dan pengelola:** Matteo Marzano (pxxyco) · [Gabriele Grillo (gabrielegrillo)](https://github.com/gabrielegrillo).
[AUTHORS](../../AUTHORS.md) · [GNU GPL](../../COPYING) · [Security](../../SECURITY.md)
