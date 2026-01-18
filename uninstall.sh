#!/system/bin/sh
# Reqable Certificate Installer - Uninstall Script
# Author: firdausmntp
# GitHub: https://github.com/firdausmntp/reqable-cert-installer

MODDIR=${0%/*}
LOG_FILE="/data/local/tmp/ReqableCert.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [uninstall] $1" >> "$LOG_FILE"
}

log "Uninstall script started"

# Unmount APEX certificates if mounted
unmount_apex() {
    local apex_dir="/apex/com.android.conscrypt/cacerts"
    local temp_dir="/data/local/tmp/reqable-apex-ca"
    
    # Unmount APEX directory
    if mountpoint -q "$apex_dir" 2>/dev/null; then
        umount "$apex_dir" 2>/dev/null
        log "Unmounted APEX CA directory"
    fi
    
    # Try to unmount in all namespaces
    for pid in 1 $(pidof zygote 2>/dev/null) $(pidof zygote64 2>/dev/null); do
        if [ -d "/proc/$pid/ns/mnt" ]; then
            nsenter --mount=/proc/$pid/ns/mnt -- \
                umount "$apex_dir" 2>/dev/null
        fi
    done
    
    # Unmount and remove temp directory
    if mountpoint -q "$temp_dir" 2>/dev/null; then
        umount "$temp_dir" 2>/dev/null
        log "Unmounted temp directory"
    fi
    rm -rf "$temp_dir" 2>/dev/null
}

# Cleanup temporary files
cleanup_temp() {
    rm -rf /data/local/tmp/apex-ca-copy 2>/dev/null
    rm -rf /data/local/tmp/apex-ca-reinject 2>/dev/null
    rm -rf /data/local/tmp/reqable-apex-ca 2>/dev/null
    rm -f "$MODDIR/.apex_bypass_needed" 2>/dev/null
    log "Cleaned up temporary files"
}

# Main
unmount_apex
cleanup_temp

log "Uninstall completed"
log "NOTE: Reboot recommended to fully remove certificate from system"
