# Changelog

All notable changes to this project will be documented in this file.

## [v2.3] - 2026-01-18

### Added
- Auto-detect certificate file (.0 format)
- User uploads their own certificate (no hardcoded cert)
- Better module status detection in WebUI

### Changed
- Changelog format now compatible with SukiSU inline display
- Improved WebUI reliability
- Better error handling

### Fixed
- Module "Active/Inactive" status detection in WebUI
- SukiSU changelog display (was showing HTML)
- Certificate detection logic

## [v2.2] - 2026-01-18

### Changed
- Updated CA certificates
- Improved compatibility with latest Android security patches
- Refined installation process

## [v2.1] - 2025-01-18

### Added
- Improved SukiSU detection and compatibility
- Enhanced Android 14+ APEX bypass with namespace injection
- Action script for WebUI integration
- Better logging with timestamps
- Per-process certificate mounting for Android 14+

### Changed
- Author updated to firdausmntp
- Repository moved to https://github.com/firdausmntp/reqable-cert-installer
- Improved root solution detection
- Better error messages and logging

### Fixed
- SukiSU installation issues
- APEX bypass reliability on Android 14+
- Certificate verification after boot

## [v2.0] - 2024-xx-xx

### Added
- Android 16 (API 36) support
- KernelSU support
- APatch support
- SukiSU-Ultra support
- WebUI for certificate management
- APEX bypass for Android 14+

### Changed
- Complete rewrite of installation scripts
- Improved SELinux handling

## [v1.0] - Initial Release

### Added
- Basic Magisk module
- System CA certificate installation
- Android 5.0+ support
