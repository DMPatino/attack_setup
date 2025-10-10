

#!/bin/bash
# Broadcast random ASCII art from /opt/ascii_art every 2 minutes

ART_DIR="/opt/ascii_art"
TAG="[3ntity Broadcast]"

while true; do
  FILE=$(find "$ART_DIR" -type f -name "*.txt" | shuf -n 1)
  if [[ -f "$FILE" ]]; then
    wall "$TAG $(cat "$FILE")"
  fi
  sleep 120
done
