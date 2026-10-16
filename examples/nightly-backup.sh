#!/bin/bash
# nightly-backup.sh -- one restic backup run: back up, prune old
# snapshots, and verify the repository is healthy.
#
# Setup (once):
#   1. Put your repository password in ~/.restic-password
#      (chmod 600 it) -- see the Encryption chapter.
#   2. Run: restic init   (with the two exports below in your shell)
#   3. Adjust REPOSITORY and the folders on the backup line.
#   4. Schedule it -- see the Automating chapter.
#
# Safe to run by hand any time:  ./nightly-backup.sh
set -euo pipefail

export RESTIC_REPOSITORY=/mnt/backup-drive/laptop-restic
export RESTIC_PASSWORD_FILE="$HOME/.restic-password"
PATH=/usr/local/bin:/usr/bin:/bin:$PATH

restic backup "$HOME/Documents" "$HOME/Pictures" \
    --exclude '*.tmp' --exclude 'Cache'

# Keep a week of daily snapshots, a month of weekly ones,
# half a year of monthly ones; delete anything older.
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune

# Fail loudly (nonzero exit) if the repository is damaged.
restic check
echo "Backup OK: $(date)"
