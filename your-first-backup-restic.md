# Your First Backup with Restic

**Scope:** install restic, create a **repository** (the
place backups live), and take your first **snapshot** (one
backed-up state of your files, frozen in time). Every
command below was run for real, with restic 0.19.1 on
Linux.

## Install

- **Linux:** your distribution's package manager
  (`apt install restic`, `dnf install restic`,
  `pacman -S restic`), or the single self-contained binary
  from restic's GitHub releases — restic is one file, no
  dependencies.
- **macOS:** `brew install restic`.
- **Windows:** `winget install restic.restic`, or the same
  single binary. (Documented — this guide's runs were on
  Linux.)

**Check:**

```
restic version
```

```
restic 0.19.1 compiled with go1.26.4 on linux/amd64
```

(Your exact version will differ; any recent version
behaves the same for everything in this guide.)

## The mental model

Three words run everything:

- A **repository** is a folder (on a backup drive,
  another machine, or cloud storage) where restic stores
  backups in its own encrypted, chopped-up format. You
  don't browse it by hand; restic reads it back for you.
- A **snapshot** is one backup run: the state of your
  folders at that moment. Every run adds a snapshot.
  Snapshots are cheap because they share unchanged data —
  more in [History and pruning](history-and-pruning.md).
- The **password** encrypts the repository. There is no
  reset and no recovery. The
  [encryption chapter](encryption-and-passwords.md) is
  short and worth reading twice.

## Step 1: create the repository

Point `RESTIC_REPOSITORY` at the backup location and
`RESTIC_PASSWORD` at your password (using environment
variables keeps them out of every command you type):

```
export RESTIC_REPOSITORY=/mnt/backup-drive/laptop-restic
export RESTIC_PASSWORD='a long password you have written down'
restic init
```

```
created restic repository 3d4bee6ff6 at /mnt/backup-drive/laptop-restic

Please note that knowledge of your password is required to access
the repository. Losing your password means that your data is
irrecoverably lost.
```

restic is not being dramatic. That warning is literal.

The repository can also live on another machine over SSH
(`sftp:user@server:/path`) or in cloud storage (S3,
Backblaze B2, and more) — same commands, different
`RESTIC_REPOSITORY` value. Cloud setup needs that
provider's credentials and is (documented), not run here.

## Step 2: back up

```
restic backup ~/Documents ~/Pictures
```

First run (real output, small test folder):

```
no parent snapshot found, will read all files

Files:           3 new,     0 changed,     0 unmodified
Dirs:            4 new,     0 changed,     0 unmodified
Added to the repository: 197.872 KiB (197.231 KiB stored)

processed 3 files, 195.407 KiB in 0:00
snapshot f08d32d7 saved
```

Read it as: everything was new, restic stored it, and the
result is snapshot `f08d32d7`. That short ID is how you
refer to this moment later.

## Step 3: back up again

Change a file, add one, run the identical command:

```
Files:           1 new,     1 changed,     2 unmodified
Dirs:            0 new,     3 changed,     1 unmodified
Added to the repository: 2.576 KiB (1.646 KiB stored)

processed 4 files, 195.475 KiB in 0:00
snapshot 61986d36 saved
```

The whole folder is 195 KiB, but the second backup added
only **2.6 KiB** to the repository: restic splits files
into chunks and stores each chunk once, so unchanged data
costs nothing the second time. This is why keeping months
of history is affordable — see
[History and pruning](history-and-pruning.md).

## Where you are

You have an encrypted repository with two snapshots, and
you can already survive "I deleted it yesterday." Next:
getting files back, which is the entire point.
