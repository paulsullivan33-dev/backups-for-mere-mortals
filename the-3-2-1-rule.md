# The 3-2-1 Rule

**Scope:** the classic shape of a backup setup that
survives real life. It's a rule of thumb, not a law —
understand the reasoning and you can bend it sensibly.

## The rule

Keep **3** copies of anything that matters, on **2**
different kinds of storage, with **1** copy somewhere
else entirely.

- **3 copies** — the original, plus two backups. Two
  backups sounds paranoid until the day you restore from
  backup #1 and find it corrupt; backup #2 is what makes
  that an annoyance instead of a funeral.
- **2 kinds of storage** — say, your computer's SSD and an
  external hard drive, or a home server and a cloud
  bucket. Two drives of the same batch, bought the same
  day, in the same enclosure, can share the same defect
  and the same bad week.
- **1 copy off-site** — fire and theft take the whole
  building. The off-site copy is the one that makes those
  recoverable.

## A concrete, ordinary setup

Nothing exotic is required. A setup a mortal can actually
maintain:

| Copy | Where | How |
|---|---|---|
| Original | Your laptop/desktop | — |
| Backup 1 | External drive or home server | Nightly restic backup (this guide) |
| Backup 2 (off-site) | Cloud storage, or a drive kept at a relative's house / office | restic to a cloud repository, or a second drive you swap weekly |

The "drive at a relative's house" version is real and
respectable: two external drives, one plugged in, one
off-site, swapped whenever you visit. The catch is the
swap cadence — the off-site copy is only as fresh as your
last visit. Cloud storage fixes the cadence and charges
rent; a relative's shelf is free and charges discipline.

## What counts as "different storage" in 2026

The rule dates from the tape era; the modern reading is
about *independent failure*, not exotic media:

- Laptop SSD + USB hard drive: different enough.
- Two partitions of the same drive: **not** two copies.
  One drive dies, both "copies" die.
- A NAS in the same house: counts as the second kind of
  storage, but not as off-site.
- Cloud object storage (S3, Backblaze B2): counts as both
  different storage *and* off-site — which is why a
  two-copy setup of "machine + cloud" is a defensible
  modern simplification of the rule.

## The honest simplification

Perfect 3-2-1, maintained for years, beats nothing. But a
2-copy setup you'll actually keep running — original plus
an automatic nightly backup, one of them off-site — beats
a perfect design you abandon in a month. Start with the
second copy. Add the third when the first is boring.
Boring is the goal: backups should be the least
interesting thing your computers do.
