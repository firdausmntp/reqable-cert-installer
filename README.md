# 🔐 Reqable Certificate Installer

<p align="center">
  <img src="https://img.shields.io/badge/Version-v2.2-blue?style=for-the-badge" alt="Version"/>
  <img src="https://img.shields.io/badge/Android-5.0--15-green?style=for-the-badge&logo=android" alt="Android"/>
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Magisk-20.4%2B-00AF9C?style=flat-square&logo=magisk" alt="Magisk"/>
  <img src="https://img.shields.io/badge/KernelSU-Supported-orange?style=flat-square" alt="KernelSU"/>
  <img src="https://img.shields.io/badge/SukiSU-✓%20Tested-9333ea?style=flat-square" alt="SukiSU"/>
  <img src="https://img.shields.io/badge/APatch-Supported-blue?style=flat-square" alt="APatch"/>
</p>

<p align="center">
  <b>📱 Install Reqable CA Certificate to System CA Store</b><br>
  <sub>Tested on Android 15 with SukiSU v40201</sub>
</p>

---

## 📋 Description

This Magisk/KernelSU/APatch module installs the **Reqable CA Certificate** into the Android System CA Store, enabling HTTPS traffic interception with the [Reqable](https://reqable.com) app.

> ⚠️ **IMPORTANT**: You must export and add **YOUR OWN** Reqable certificate! Each Reqable installation generates a **UNIQUE** certificate.

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| 🔧 **Multi-Root Support** | Works with Magisk, KernelSU, SukiSU, APatch |
| 📱 **Wide Android Support** | Android 5.0 - 15 (API 21-35) |
| 🔓 **APEX Bypass** | Proper injection for Android 14+ conscrypt APEX |
| 🖥️ **WebUI Interface** | Upload and manage certificates visually |
| 🛡️ **SELinux Compatible** | Works with SELinux enforcing |
| 💾 **Systemless** | Does not modify /system partition |

---

## 📱 Tested Compatibility

### ✅ Verified Working

| Device | Android | Root | Status |
|--------|---------|------|--------|
| Redmi Note 8 Pro | 15 (API 35) | SukiSU v40201 | ✅ **Tested** |

### Root Solutions Support

| Solution | Status | Notes |
|----------|--------|-------|
| **SukiSU** | ✅ Tested | Fully working with WebUI |
| **KernelSU** | ✅ Supported | With WebUI support |
| **Magisk** | ✅ Supported | v20.4+ required |
| **APatch** | ✅ Supported | v10300+ required |

### Android Versions

| Version | API | Status |
|---------|-----|--------|
| Android 5.0 - 13 | 21-33 | ✅ Standard Magic Mount |
| Android 14 | 34 | ✅ APEX Bypass |
| Android 15 | 35 | ✅ APEX Bypass (Tested) |

---

## 🚀 Quick Start

### Step 1: Export Certificate from Reqable

1. Open **Reqable** app
2. Go to **Settings** → **HTTPS Capture** → **Root Certificate**
3. Tap **Export Root CA**
4. Select **System Format (.0)**
5. Save the file (e.g., `2652b13d.0`)

### Step 2: Install Module

1. Download `Reqable-Cert-Installer-v2.2.zip`
2. Install via **Magisk/KernelSU/SukiSU/APatch** Manager
3. **Reboot** device

### Step 3: Upload Certificate via WebUI

1. Open root manager → Find module → Tap **WebUI** button
2. Tap **Upload Certificate** area
3. Select your `.0` certificate file
4. Tap **Install Certificate**
5. **Reboot** to apply

> 💡 Alternatively, copy certificate directly to `/data/adb/modules/reqable-cert-installer/system/etc/security/cacerts/`

---

## 🖥️ WebUI Features

Access WebUI through your root manager's module settings:

| Feature | Description |
|---------|-------------|
| 📤 **Upload Certificate** | Upload .0, .pem, .crt, .cer files |
| 📊 **Status Monitor** | View module and APEX injection status |
| 💉 **Re-inject** | Manually trigger certificate injection |
| 📋 **View Logs** | Check module operation logs |
| 🔄 **Reboot** | Quick reboot to apply changes |

---

## 🔧 Android 14+ APEX Bypass

Starting Android 14, CA certificates moved to APEX module (`com.android.conscrypt`).

This module implements:
- **Namespace Injection** - Mounts into zygote namespaces
- **Dynamic Re-injection** - Service script reinjects after boot
- **Per-process Mount** - All app processes see the certificate

### Verify Injection
```bash
# Check if certificate is in APEX
ls /apex/com.android.conscrypt/cacerts/*.0 | head -5

# View module logs
cat /data/local/tmp/ReqableCert.log
```

---

## ⚠️ Troubleshooting

### "Certificate Not Installed" in Reqable

```bash
# 1. Check logs
cat /data/local/tmp/ReqableCert.log

# 2. Manual re-inject
su -c "sh /data/adb/modules/reqable-cert-installer/post-fs-data.sh"

# 3. Force stop and reopen Reqable
```

### "Unknown Publisher" Error

- **SukiSU/KernelSU**: Settings → Enable "Allow untrusted modules"
- **APatch**: Settings → Security → Enable "Allow unknown sources"

### WebUI Not Loading

1. Ensure `webroot/index.html` exists in module
2. Check if root manager supports WebUI
3. Try reinstalling module

---

## 📁 Module Structure

```
reqable-cert-installer/
├── META-INF/com/google/android/
│   ├── update-binary
│   └── updater-script
├── system/etc/security/cacerts/
│   └── [YOUR_CERTIFICATE.0]
├── webroot/
│   └── index.html          # WebUI
├── module.prop
├── customize.sh            # Installation script
├── post-fs-data.sh         # APEX injection
├── service.sh              # Post-boot injection
├── action.sh               # Action button handler
└── uninstall.sh            # Cleanup script
```

---

## 📝 Changelog

### v2.2 (Current)
- ✅ Fixed WebUI file picker for Android WebView
- ✅ Auto-close logs on action buttons
- ✅ Improved status badges and indicators
- ✅ Tested on SukiSU v40201 + Android 15
- ✅ Enhanced APEX namespace injection

### v2.1
- ✅ Added WebUI for certificate management
- ✅ Improved SukiSU compatibility
- ✅ Enhanced APEX bypass for Android 14+

### v2.0
- ✅ Added KernelSU/APatch/SukiSU support
- ✅ Added Android 15 support
- ✅ Improved APEX bypass

---

## 📄 License

MIT License - See [LICENSE](LICENSE) for details.

---

## 🙏 Credits

- [firdausmntp](https://github.com/firdausmntp) - Author & Maintainer
- [topjohnwu](https://github.com/topjohnwu) - Magisk
- [tiann](https://github.com/tiann) - KernelSU
- [pomelohan](https://github.com/pomelohan/SukiSU-Ultra) - SukiSU
- [bmax121](https://github.com/bmax121) - APatch

---

## 🔗 Links

[![GitHub](https://img.shields.io/badge/GitHub-Repository-181717?style=for-the-badge&logo=github)](https://github.com/firdausmntp/reqable-cert-installer)
[![Issues](https://img.shields.io/badge/Report-Issues-red?style=for-the-badge&logo=github)](https://github.com/firdausmntp/reqable-cert-installer/issues)
[![Reqable](https://img.shields.io/badge/Reqable-Website-blue?style=for-the-badge)](https://reqable.com)
