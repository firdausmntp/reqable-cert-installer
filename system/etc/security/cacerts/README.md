# Reqable Certificate - Add your certificate here

## 📝 Instructions

### Cara Mudah (Reqable v2.0+):

1. Buka **Reqable** di perangkat Anda
2. Pergi ke **Settings** → **HTTPS Capture** → **Root Certificate**
3. Tap **Export Root CA**
4. Pilih **Save as System Format (.0)**
5. Copy file `.0` yang di-export ke directory ini
6. Rebuild/reinstall module

> ✅ Reqable sudah otomatis generate file dalam format `.0` yang benar!

Contoh nama file: `reqable-ca-a1b2c3d4.0` atau `2652b13d.0`

### Cara Manual (jika export .pem/.crt):

Jika Reqable export dalam format `.pem` atau `.crt`:

```bash
# 1. Get certificate hash
openssl x509 -inform PEM -subject_hash_old -in reqable-ca.crt | head -1
# Output example: 2652b13d

# 2. Rename dengan hash
mv reqable-ca.crt 2652b13d.0

# 3. Copy ke directory ini
cp 2652b13d.0 /path/to/module/system/etc/security/cacerts/
```

## ⚠️ Important Notes

- ✅ Setiap instalasi Reqable menghasilkan certificate yang **UNIK**
- ✅ Anda HARUS menggunakan certificate dari Reqable app Anda sendiri
- ✅ Jangan share certificate Anda dengan orang lain
- ✅ File harus berformat `.0` (bukan `.pem`, `.crt`, atau `.cer`)
- ✅ Permission file harus `644` (rw-r--r--)

## 📂 File Format

```
system/etc/security/cacerts/
├── reqable-ca-12345678.0  ← Your certificate here
├── .gitkeep               ← Placeholder (don't delete)
└── README.md              ← This file
```
