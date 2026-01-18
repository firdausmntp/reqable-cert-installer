#!/system/bin/sh
# Reqable Certificate Installer - Post-fs-data Script
# Author: firdausmntp
# GitHub: https://github.com/firdausmntp/reqable-cert-installer
#
# Android 14+ APEX Bypass - Aggressive Implementation

MODDIR=${0%/*}
LOG_FILE="/data/local/tmp/ReqableCert.log"
CERT_DIR="${MODDIR}/system/etc/security/cacerts"
TEMP_DIR="/data/local/tmp/reqable-apex-ca"

# Initialize logging
mkdir -p /data/local/tmp 2>/dev/null
echo "" > "$LOG_FILE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "╔══════════════════════════════════════════════════════╗"
log "║  Reqable Certificate Installer v2.1                  ║"
log "╚══════════════════════════════════════════════════════╝"
log ""
log "Post-fs-data started"
log "Module: $MODDIR"

API=$(getprop ro.build.version.sdk)
ANDROID_VERSION=$(getprop ro.build.version.release)
log "Android: $ANDROID_VERSION (API $API)"

# Detect root
if [ "$KSU" = "true" ]; then
    log "Root: KernelSU/SukiSU (v$KSU_VER_CODE)"
elif [ "$APATCH" = "true" ]; then
    log "Root: APatch (v$APATCH_VER_CODE)"
else
    log "Root: Magisk/Other"
fi

# Find our certificate
CERT_FILE=$(find "$CERT_DIR" -maxdepth 1 -type f -name "*.0" 2>/dev/null | head -1)
CERT_NAME=$(basename "$CERT_FILE" 2>/dev/null)

if [ -z "$CERT_FILE" ] || [ ! -f "$CERT_FILE" ]; then
    log "ERROR: No certificate file found in $CERT_DIR"
    log "Please add your Reqable .0 certificate!"
    exit 0
fi

log "Certificate: $CERT_NAME"

# For Android < 14, Magic Mount handles it
if [ "$API" -lt 34 ]; then
    log "Android < 14: Using Magic Mount"
    log "Done!"
    exit 0
fi

log ""
log "=== Android 14+ APEX Injection ==="

APEX_CACERTS="/apex/com.android.conscrypt/cacerts"

if [ ! -d "$APEX_CACERTS" ]; then
    log "ERROR: APEX cacerts not found"
    exit 1
fi

# Prepare temp directory with tmpfs
log "Preparing tmpfs..."
umount "$TEMP_DIR" 2>/dev/null
rm -rf "$TEMP_DIR" 2>/dev/null
mkdir -p "$TEMP_DIR"

if ! mount -t tmpfs tmpfs "$TEMP_DIR"; then
    log "ERROR: Failed to mount tmpfs"
    exit 1
fi

# Copy existing certs
log "Copying system certificates..."
cp -a "$APEX_CACERTS"/* "$TEMP_DIR/" 2>/dev/null
ORIG_COUNT=$(ls -1 "$TEMP_DIR"/*.0 2>/dev/null | wc -l)
log "System certs: $ORIG_COUNT"

# Add our certificate
log "Adding: $CERT_NAME"
cp -f "$CERT_FILE" "$TEMP_DIR/$CERT_NAME"

# Set permissions
chown -R 0:0 "$TEMP_DIR"
chmod 755 "$TEMP_DIR"
chmod 644 "$TEMP_DIR"/*

# Set SELinux context
APEX_CONTEXT=$(ls -Zd "$APEX_CACERTS" 2>/dev/null | awk '{print $1}')
if [ -n "$APEX_CONTEXT" ] && [ "$APEX_CONTEXT" != "?" ]; then
    chcon -R "$APEX_CONTEXT" "$TEMP_DIR" 2>/dev/null
    log "SELinux context: $APEX_CONTEXT"
fi

TOTAL_COUNT=$(ls -1 "$TEMP_DIR"/*.0 2>/dev/null | wc -l)
log "Total certs: $TOTAL_COUNT"

# Mount to APEX - try multiple approaches
log ""
log "Mounting to APEX..."

# 1. Global mount
mount --bind "$TEMP_DIR" "$APEX_CACERTS" && log "✓ Global mount"

# 2. Init namespace (PID 1)
nsenter --mount=/proc/1/ns/mnt -- mount --bind "$TEMP_DIR" "$APEX_CACERTS" 2>/dev/null && log "✓ Init (PID 1)"

# 3. Zygote namespaces - critical for apps
for zygote in zygote zygote64; do
    PID=$(pidof "$zygote" 2>/dev/null)
    if [ -n "$PID" ]; then
        nsenter --mount=/proc/$PID/ns/mnt -- mount --bind "$TEMP_DIR" "$APEX_CACERTS" 2>/dev/null && log "✓ $zygote (PID $PID)"
    fi
done

# 4. Try all running app processes (aggressive approach for Reqable)
log "Mounting for all app processes..."
for pid in $(ls /proc | grep -E '^[0-9]+$'); do
    if [ -d "/proc/$pid/ns" ] && [ -r "/proc/$pid/cmdline" ]; then
        cmdline=$(cat /proc/$pid/cmdline 2>/dev/null | tr '\0' ' ')
        # Only target app processes
        if echo "$cmdline" | grep -qE "^(com\.|android\.)" 2>/dev/null; then
            nsenter --mount=/proc/$pid/ns/mnt -- mount --bind "$TEMP_DIR" "$APEX_CACERTS" 2>/dev/null
        fi
    fi
done

# Verify
log ""
if [ -f "$APEX_CACERTS/$CERT_NAME" ]; then
    log "✓ SUCCESS: $CERT_NAME is in APEX!"
else
    log "✗ Certificate not visible in APEX (namespace isolation)"
fi

log ""
log "Post-fs-data completed"
log "══════════════════════════════════════════════════════"
