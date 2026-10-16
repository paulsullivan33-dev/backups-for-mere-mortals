# Restoring with Restic

**Scope:** getting files back — a whole snapshot, or one
file from last Tuesday. Restoring is the reason the backup
exists; learn it while nothing is on fire.

## See what you have

```
restic snapshots
```

```
ID        Time                 Host          Tags        Paths            Size
-------------------------------------------------------------------------------------
f08d32d7  2026-10-16 18:07:39  mylaptop                  /home/you/data   195.407 KiB
61986d36  2026-10-16 18:07:40  mylaptop                  /home/you/data   195.475 KiB
-------------------------------------------------------------------------------------
2 snapshots
```

And what's inside one snapshot, without restoring it:

```
restic ls latest
```

```
snapshot 61986d36 of [/home/you/data] at ...
/home/you/data
/home/you/data/newfile.txt
/home/you/data/notes/todo.txt
/home/you/data/photo.bin
/home/you/data/report.txt
```

`latest` means the newest snapshot. Any ID from the list
works anywhere `latest` does.

## Restore everything

```
restic restore latest --target /tmp/restore-here
```

```
restoring snapshot 61986d36 of [/home/you/data] ...
Summary: Restored 8 files/dirs (195.475 KiB) in 0:00
```

restic rebuilds the folder tree under the target, with
the original paths nested inside it (so restoring
`/home/you/data` into `/tmp/restore-here` produces
`/tmp/restore-here/home/you/data`). It never overwrites
your live files unless you aim it at them on purpose.

## Restore the past, not just the present

The scenario that actually happens: you saved over a
document, or deleted something, and the *current* version
is the problem. Restore the older snapshot instead:

```
restic restore f08d32d7 --target /tmp/restore-old
```

In the test run, that older snapshot's `report.txt` came
back with its original first draft — the line appended
later simply wasn't there yet. Yesterday's version is a
first-class citizen, not a compromise.

## Restore one file

Point `--include` at the path, or restore the whole
snapshot and pick the file out — for mortal-sized backups
the second is honestly simpler. For big ones:

```
restic restore latest --target /tmp/one-file \
    --include /home/you/data/report.txt
```

## Prove it worked

Trust, but checksum. After the test restore in this
guide's lab, the restored files were compared against
SHA-256 checksums taken before the backup:

```
sha256sum -c checksums.txt
```

```
report.txt: OK
notes/todo.txt: OK
photo.bin: OK
newfile.txt: OK
```

All four `OK` — bit-for-bit identical, not "looks about
right." You won't checksum every real restore, but do it
once, now, so you've *seen* your backup produce perfect
files. That memory is what keeps you calm later.

## The habit to build

Restoring a folder takes under a minute when you know the
two commands. Practice on something trivial today, and
the day it's your thesis / tax records / photo library,
it's a procedure instead of a panic.
