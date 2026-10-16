# History Without Filling the Disk

**Scope:** how snapshots pile up, why they cost less than
you fear, and the retention policy that keeps a backup
drive from slowly filling to 100%.

## Why snapshots are cheap

restic (and Borg, next-door chapter) use
**deduplication**: files are split into chunks, each chunk
is stored once, and a snapshot is mostly a list of chunk
references. Real numbers from the test lab:

- Snapshot 1: 195.407 KiB of files → 197 KiB in the repo.
- Snapshot 2, after editing one file and adding another:
  the snapshot *represents* 195.475 KiB, but added only
  **2.576 KiB** of new chunks.
- Borg measured the same effect from the other side: two
  archives totaling 400 KiB of original data occupied
  **201.90 KiB** deduplicated.

Daily snapshots of a mostly-static documents folder grow
the repository by roughly "whatever actually changed."
History is nearly free. Deleting history to "save space"
is almost always a mistake.

## What actually fills disks

- Backing up re-downloadables (see
  [What to back up](what-to-back-up.md)) — big, churny,
  pointless.
- A few huge files that change completely every day
  (VM images, video projects). Deduplication can't help
  when every chunk is new.
- Never pruning. Which brings us to:

## Retention: forget + prune

Two separate operations, often run together:

- `forget` marks snapshots that fall outside your
  retention policy. They stop appearing, but their data
  isn't deleted yet.
- `prune` actually removes the now-unreferenced chunks
  and reclaims the space.

```
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
```

reads as: keep the last snapshot of each day for a week,
of each week for a month, of each month for half a year —
forget the rest, and prune their data now.

Real output, keeping only the last snapshot:

```
Applying Policy: keep 1 latest snapshots
keep 1 snapshots: ... 61986d36 ...
remove 1 snapshots: ... f08d32d7 ...
1 snapshots have been removed, running prune
...
total prune:           5 blobs / 1.223 KiB
...
done
```

Notice the shape: old snapshots vanish, but the space
recovered is small — because most of their chunks were
shared with the snapshot you kept. Pruning removes
*uniqueness*, not snapshots.

## Picking a policy

| You | Sensible retention |
|---|---|
| One laptop, nightly backups | `--keep-daily 7 --keep-weekly 4 --keep-monthly 6` |
| You edit documents for a living and notice mistakes slowly | add `--keep-monthly 12` — a year of month-ends |
| Backup drive is small | `--keep-daily 7 --keep-weekly 2` and fix the real problem (a bigger drive is cheaper than lost history) |

One caution: `forget` with the wrong policy forgets
*exactly what you told it to*. First run, add `--dry-run`
and read what *would* be removed:

```
restic forget --keep-last 1 --dry-run
```

Dry runs are how mortals stay mortal instead of becoming
cautionary tales.
