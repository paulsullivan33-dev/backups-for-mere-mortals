# What a Backup Is

**Scope:** the definition everything else builds on. Three
things get called "backup" that aren't, and the difference
only shows up on the worst day.

## The one-sentence test

A backup is a copy of your data that survives the loss of
the original — *including the losses you cause yourself*.

That last clause is where most setups fail. Walk through
the usual suspects:

| Thing | Protects against | Does NOT protect against |
|---|---|---|
| A second copy on the same disk | Nothing much | Disk failure, theft, ransomware |
| RAID / mirrored drives | One drive dying | Deletion, corruption, ransomware, fire — the mirror faithfully mirrors your mistake in real time |
| Cloud sync (Dropbox, iCloud, OneDrive) | A dead or lost device | Accidental deletion and ransomware, which sync to the cloud within seconds |
| A real backup | All of the above | — |

Sync deserves a closer look, because it feels like backup.
Sync's job is to make every device *the same*. Delete a
file on your laptop and sync does its job perfectly: the
file vanishes everywhere. Some sync services keep a few
weeks of deleted-file history, which helps — but that's a
grace period, not a backup strategy.

## What a real backup has

Four properties separate a backup from a copy:

1. **Separate.** Stored somewhere the original's disasters
   can't reach — a different device, ideally a different
   building (next chapter).
2. **Versioned.** Not just today's files, but last
   month's too. The document you mangled on Tuesday and
   only noticed on Friday is recoverable because the
   backup kept the older version.
3. **Automatic.** A backup that depends on you remembering
   is a backup you'll find was last run in March. Humans
   are the least reliable component; schedule it.
4. **Tested.** An unrestored backup is a hope, not a
   backup. The [checking chapter](checking-and-testing-restores.md)
   exists because drives fail silently and formats rot —
   you find out your backup works by restoring from it
   *before* the emergency.

## The failures you're actually defending against

Ranked by how often they really happen, not by drama:

- **You.** Accidental deletes, overwriting the good
  version, a cleanup command in the wrong folder. This is
  the most common data loss by a wide margin, and the one
  RAID and sync are worst at.
- **Hardware death.** Drives and SSDs fail without
  negotiation, sometimes without warning.
- **Malware and ransomware.** Encrypts what it can reach —
  including any backup drive that's always plugged in and
  writable. (A reason backups should be append-only or
  regularly disconnected; both tools in this guide make
  overwriting old backups hard by design.)
- **Theft, fire, flood.** The whole machine, gone. This is
  what the off-site copy is for.

## What this guide's setup gives you

By the end of the restic chapters you'll have: encrypted,
versioned snapshots on a separate drive or server, taken
nightly without you, pruned so the disk doesn't fill, and
checked regularly so silent damage gets caught. That's
all four properties. Everything after that — Borg, rsync,
cloud copies — is variations on the same four ideas.
