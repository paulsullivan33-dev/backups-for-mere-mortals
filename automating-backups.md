# Automating It

**Scope:** the nightly script that makes the backup happen
without you, including the password problem it creates —
and a check at the end so a broken backup complains
instead of failing silently for six months.

## The password problem, automated edition

Interactively, you type the password. A scheduled job
can't. The standard answers:

- **`RESTIC_PASSWORD_FILE`** — a file containing only the
  password, readable only by you (`chmod 600`). This is
  what the example script uses. The honest trade-off: the
  password now sits on the machine being backed up. If the
  machine is stolen, the thief has machine + password +
  (maybe) the backup drive. For most home setups this is
  acceptable; for higher stakes, put the repository on a
  server that only accepts appends, or keep the drive
  physically separate. (See the
  [encryption chapter](encryption-and-passwords.md).)
- **A password manager's CLI or a secrets tool** —
  better, more moving parts. (Documented; not run here.)

## The script

This guide's example — [`examples/nightly-backup.sh`](examples/nightly-backup.sh) —
does three things: back up, prune by policy, and *check*
the repository, exiting nonzero if anything is wrong:

```bash
#!/bin/bash
set -euo pipefail

export RESTIC_REPOSITORY=/mnt/backup-drive/laptop-restic
export RESTIC_PASSWORD_FILE="$HOME/.restic-password"

restic backup "$HOME/Documents" "$HOME/Pictures" \
    --exclude '*.tmp' --exclude 'Cache'

restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune

restic check
echo "Backup OK: $(date)"
```

The script was test-run against a real repository: backup,
forget/prune, and check all completed, ending in
`Backup OK: ...` and `no errors were found` from the check.

Two details that matter:

- `set -euo pipefail` means *any* failed step stops the
  script with a nonzero exit. That's what makes the next
  section work.
- `restic check` at the end is the smoke alarm. Skipping
  it is how people discover a corrupt six-month-old backup
  on the day they need it.

## Scheduling it

**cron** (every Linux and macOS):

```
0 2 * * *  /home/you/bin/nightly-backup.sh >> /home/you/backup.log 2>&1
```

**systemd timer** — a `.service` running the script plus a
`.timer` with `OnCalendar=daily`; nicer logs via
`journalctl`. Either is fine. What matters is not the
scheduler but the next paragraph.

## Silent failure is the enemy

A scheduled backup that fails quietly is worse than no
backup: it manufactures confidence. Pick at least one:

- Watch the log's end: the script only prints
  `Backup OK` after a successful check. No recent
  `Backup OK`, no working backup.
- Let cron mail you failures (works if local mail is set
  up).
- Use a **dead man's switch** service (healthchecks.io
  and friends): the script pings a URL on success; the
  service alerts *you* when a ping goes missing. This is
  the only option that catches "the machine was off /
  the drive was unplugged / cron died" — failures where
  nothing is around to complain. (Documented; pick your
  provider.)

## On laptops that sleep

A 2 AM cron job doesn't run on a laptop that's asleep or
closed. Options, honestly assessed: schedule for an hour
the machine is usually awake (lunch), use systemd timers
with `Persistent=true` (runs missed jobs at next boot),
or accept "runs when I'm using it in the evening." A
backup that runs most days beats a perfect schedule that
never fires.
