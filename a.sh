#!/bin/bash
for d in /sys/class/hwmon/hwmon*; do
  echo "--- $d ---"
  cat "$d/name" 2>/dev/null || echo "(no name file)"
done
