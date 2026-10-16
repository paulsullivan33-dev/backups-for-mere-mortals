# BorgBackup

**Scope:** the other great open-source backup tool — same
ideas as restic (encrypted, deduplicated, versioned),
different shape. Run for real with BorgBackup 1.4.5.

## How Borg differs, in one paragraph

restic treats the repository-location as a variable: the
same command backs up to a local disk, SSH server, or
S3 bucket. Borg is built around repositories on machines
you reach by SSH, stores each backup as a named **archive**
inside one repository, and is famously economical with
disk space and RAM. Borg runs on Linux and macOS
(Windows via WSL). If your backup target is "my home
server, over SSH," Borg is the traditional answer; if
it's "cloud storage, natively," that's restic's home turf.

## Create a repository

Encryption choices come first, and Borg makes you pick:

```
export BORG_REPO=/mnt/backup-drive/borg-repo
borg init --encryption=repokey-blake2
```

`repokey` means the encryption key lives *inside* the
repository, protected by your passphrase. Borg immediately
— and correctly — warns you:

```
IMPORTANT: you will need both KEY AND PASSPHRASE to access this repo!
...
1. Export the borg key and store the result at a safe place:
   borg key export           REPOSITORY encrypted-key-backup
...
2. Write down the borg key passphrase and store it at safe place.
```

Do step 1. Right now, not later:

```
borg key export $BORG_REPO ~/borg-key-backup.txt
```

produces a file starting `BORG_KEY ...` followed by the
encrypted key. Store that file and the passphrase in
*different* safe places. Key without passphrase, or
passphrase without key, is a repository you cannot open —
see the [encryption chapter](encryption-and-passwords.md).

## Back up

```
borg create ::laptop-2026-10-16-1 ~/Documents
```

`::` separates the repository (from `BORG_REPO`) from the
archive name. Names are yours — a machine name plus a date
is the convention, and `{now}` placeholders can generate
them. A second run, same data, creates a second archive:

```
borg list
```

```
laptop-2026-10-16-1   Fri, 2026-10-16 18:07:54 [8a8f50cf...]
laptop-2026-10-16-2   Fri, 2026-10-16 18:07:56 [d9ff72ef...]
```

## Watch deduplication work

```
borg info ::laptop-2026-10-16-2
```

```
                       Original size      Compressed size    Deduplicated size
This archive:              200.17 kB            200.33 kB                  0 B
All archives:              400.33 kB            400.67 kB            201.90 kB
```

Two archives representing 400 KiB of files; the second
one's deduplicated size is **0 B** — every chunk already
existed. This is why Borg users keep years of archives.

## Restore and compare

Extract restores into the *current directory*, recreating
the original paths beneath it:

```
mkdir /tmp/restore && cd /tmp/restore
borg extract ::laptop-2026-10-16-2
```

In the test lab, the extracted files passed the same
SHA-256 checksum comparison as the restic restores — all
`OK`.

What changed between two archives:

```
borg diff ::laptop-2026-10-16-2 laptop-2026-10-16-3
```

```
   +120 B     -89 B [ctime: ...] [mtime: ...] home/you/data/report.txt
```

(note the second archive name drops the `::` — a quirk
that bites everyone once).

## Pruning

Same shape as restic's forget/prune, one command:

```
borg prune --dry-run --list --keep-last 1
```

```
Keeping archive (rule: secondly #1):  laptop-2026-10-16-2 ...
Would prune:                          laptop-2026-10-16-1 ...
```

`--keep-daily`, `--keep-weekly`, `--keep-monthly` all
exist too, followed by `borg compact` to actually reclaim
space. Dry-run first, always.

## Restic or Borg?

| | restic | Borg |
|---|---|---|
| Cloud storage (S3, B2) built in | Yes | Not built in (SSH/local focus) |
| Windows | Native binary | Via WSL |
| Repository target | Disk, SSH, cloud — swappable | Disk or SSH server |
| Encryption key | Derived from password alone | Key file + passphrase (export the key!) |
| Vibe | One tool, many backends | Server-and-archive craftsman |

Both are honest tools with long track records. The worst
choice is the one you never get around to setting up.
