# Backups for Mere Mortals

A **backup** is a copy of your files that still exists
after the original is gone — deleted, corrupted, encrypted
by ransomware, or at the bottom of a lake with your
laptop. This guide builds you a real one: automatic,
encrypted, versioned, and — the part everyone skips —
proven to restore.

The tool at the center is **restic**, a free, open-source
backup program that runs on Linux, macOS, and Windows.
BorgBackup and plain rsync copies get their own chapters,
because the best backup tool is the one that fits how you
already work.

This guide assumes you can use a terminal and create
folders. Everything backup-specific — snapshots,
deduplication, repositories — is explained from zero.

## What this guide covers

- [**What a backup is**](what-a-backup-is.md) — copies,
  sync, and backups are three different things
- [**The 3-2-1 rule**](the-3-2-1-rule.md) — the shape of a
  backup setup that survives real disasters
- [**What to back up**](what-to-back-up.md) — irreplaceable
  vs. re-downloadable, and the database trap
- [**Your first backup with restic**](your-first-backup-restic.md) —
  install, initialize, and back up, end to end
- [**Restoring with restic**](restoring-with-restic.md) —
  getting files back, including older versions
- [**History without filling the disk**](history-and-pruning.md) —
  snapshots, retention, and deduplication
- [**Automating it**](automating-backups.md) — a nightly
  script that backs up, prunes, and self-checks
- [**BorgBackup**](borgbackup.md) — the other great tool,
  and when to pick it instead
- [**Plain copies with rsync**](plain-copies-rsync.md) —
  when a simple mirror is the right answer
- [**Checking and testing restores**](checking-and-testing-restores.md) —
  proving the backup works before you need it
- [**Encryption and the password problem**](encryption-and-passwords.md) —
  why losing the password means losing the backup
- [**Troubleshooting**](troubleshooting.md) — symptom →
  fix, with the real error messages
- [**Glossary**](glossary.md) — the terms, collected in
  one place

## What it doesn't cover

Bare-metal disaster recovery (rebuilding a whole machine
from an image), enterprise backup suites, tape, and
backing up other people's fleets for a living. This guide
is for your machines and your files.

## How to use this guide

Every restic and BorgBackup command in this guide was run
for real — restic 0.19.1 and BorgBackup 1.4.5 on Linux —
including full backup/restore cycles verified with file
checksums, and a deliberately corrupted repository to show
what damage detection looks like. Steps that depend on a
cloud storage account (S3, Backblaze B2) are marked
**(documented)**: written from the tool's documentation,
not from a live run.
