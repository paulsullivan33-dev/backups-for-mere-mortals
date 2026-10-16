# Plain Copies with Rsync

**Scope:** the simplest backup of all — copying files with
rsync — and an honest account of when it's enough and when
it quietly isn't.

## The tool

**rsync** copies files from A to B, transferring only what
changed. It's on every Linux and macOS system (Windows via
WSL or cwRsync). A backup-flavored invocation:

```
rsync -avh --dry-run ~/Documents/ /mnt/backup-drive/Documents-copy/
```

```
sending incremental file list
created directory /mnt/backup-drive/Documents-copy
./
newfile.txt
photo.bin
report.txt
notes/
notes/todo.txt
```

`--dry-run` lists what *would* happen and changes nothing
— run every new rsync command this way first. Drop it when
the list looks right. (Note the trailing slashes:
`~/Documents/` copies the *contents*; without the slash it
copies the folder itself into the target. Everyone learns
this once, the loud way.)

## When a plain copy is the right answer

- The second drive in a 3-2-1 setup, where a *different*
  tool (restic/Borg) provides the versioned copy.
- Huge media files that don't change and don't dedupe —
  copying is copying.
- A bootable-ish clone you want to browse with ordinary
  file tools, no restore step. This is rsync's genuine
  advantage: the "backup" is just files, readable by
  anything, forever, with no restic/Borg installed.

## When it quietly isn't

Read the failure list against
[What a backup is](what-a-backup-is.md):

- **No history by itself.** Tonight's copy overwrites
  last night's. The file you corrupted on Tuesday is
  corrupted in the copy by Wednesday — rsync's job is to
  make B match A, *including A's mistakes*. (Flags like
  `--backup --backup-dir=` can keep replaced files aside,
  at which point you're hand-building what restic gives
  you for free.)
- **Deletes are contagious.** Add `--delete` (needed to
  keep a true mirror) and deleting a file deletes the
  copy. Leave it off and the copy grows stale extras.
  Neither is versioning.
- **No encryption, no integrity checking.** Files sit in
  the open, and a silently corrupted copy is discovered
  on restore day. (`--checksum` verifies during transfer;
  it doesn't audit the copy later.)
- **Databases and open files** have the same mid-write
  trap described in [What to back up](what-to-back-up.md).

## The verdict

rsync is a superb *copying* tool and a partial backup.
If your whole strategy is "rsync to an external drive,"
you have protection against a dead disk — the most
dramatic failure — and weak protection against the most
common ones (your own deletions and mistakes). Pair it
with one versioned copy, or graduate the important
folders to restic, and the combination is genuinely solid.
