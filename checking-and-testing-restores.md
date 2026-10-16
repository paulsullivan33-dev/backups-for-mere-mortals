# Checking and Testing Restores

**Scope:** proving the backup works — repository checks
that catch silent damage, and the restore drill that
catches everything else. This is the chapter that makes
the rest of the guide true.

## The two ways backups lie

1. **The repository is quietly damaged.** A failing drive
   flips bits; a copy is interrupted; a pack file rots.
   The backup *runs* fine — the rot is in what's already
   stored.
2. **The restore doesn't work the way you assumed.**
   Wrong password discipline, a missing key file, paths
   you didn't expect, a database captured mid-write. The
   repository is perfect; your *procedure* is broken.

One check hunts the first. Only a restore hunts the second.

## Checking the repository: restic

```
restic check
```

```
load indexes
check all packs
check snapshots, trees and blobs
no errors were found
```

`no errors were found` is the sentence you want. Plain
`check` verifies structure and that all referenced data
exists. The deeper version reads and decrypts *every*
byte — run it monthly, and whenever hardware acts
suspicious:

```
restic check --read-data
```

To show it's not theater, the test lab deliberately
corrupted one pack file in a copy of a repository, then
ran the deep check. It caught it, named the damaged blob,
and printed the repair commands:

```
pack dfd09119... contains 2 errors: [blob 96eb4bd3...:
decrypting blob ... failed: ciphertext verification failed ...]

restic repair packs dfd09119...
restic repair snapshots --forget
```

Damage found *by a check, on a Tuesday, with time to fix
it* is the system working. Damage found by a desperate
restore is the system failing. The difference between
those two days is whether you run the check.

Borg's equivalent is `borg check` (add `--verify-data` to
cryptographically verify every archive, the equivalent of
`--read-data`). In the lab: ran clean on a healthy
repository, no output and a zero exit code — quiet is good.

## The restore drill

Once, and then a couple of times a year:

1. Pick a file you use daily and a snapshot from a month
   ago.
2. Restore that one file to a scratch folder.
3. Open it. Not "it exists" — *open it*, read it, use it.
4. Time it. Knowing a restore takes four minutes is calm;
   guessing is not.

Then graduate: restore your single most important folder
in full. If your backup involves a database, restore the
app against the restored database and see it actually run.
That is the only test that covers the mid-write trap from
[What to back up](what-to-back-up.md).

## Cadence that works

| When | What |
|---|---|
| Every backup run | Script ends with `restic check` (fast, structural) |
| Monthly | `check --read-data` / `borg check --verify-data` — reads everything; schedule it, don't supervise it |
| A few times a year | One-file restore drill, timed |
| After any change (new drive, new machine, new tool version) | Full drill again — change is when procedures silently break |

## The sentence to remember

*Nobody has a backup until they've restored from it.*
Everything this guide built before this chapter was
preparation. This chapter is the backup.
