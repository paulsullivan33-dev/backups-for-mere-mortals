# Glossary

**Archive** — Borg's word for one backup run stored in a
repository; a named, frozen state of your files.

**Backup** — a copy of your data that survives the loss
of the original, including losses you cause yourself:
separate, versioned, automatic, tested.

**Blob** — restic's word for one chunk of stored data
inside a pack file.

**Check** — a verification pass over a repository:
structural (`restic check`) or full read-and-decrypt
(`--read-data`). Finds damage while it's still fixable.

**Chunk** — the piece a file is split into before storage.
Deduplication works at chunk level: identical chunks are
stored once, however many files or snapshots use them.

**Deduplication** — storing each unique chunk exactly
once. The reason a month of daily snapshots costs barely
more than one.

**Dead man's switch** — a monitoring service that alerts
you when an expected success signal *stops arriving*.
Catches the failures where nothing is left running to
complain.

**Forget** — restic's command that marks snapshots outside
your retention policy. Their data is removed by `prune`.

**Key (Borg)** — the cryptographic key material for a
Borg repository, separate from the passphrase. Export it
(`borg key export`) and store it elsewhere, or a reinstall
can orphan a healthy repository.

**Pack** — a file inside a restic repository containing
many encrypted blobs, stored as one unit.

**Prune** — actually deleting data no surviving snapshot
references, reclaiming the space. In Borg, the reclaim
step is `compact`.

**Repository** — the place backups live: a folder on a
backup drive, a server, or cloud storage, holding the
encrypted, deduplicated data plus its index. Not meant to
be browsed by hand.

**Restore** — reading files back out of a snapshot or
archive into ordinary folders. The entire point.

**Retention policy** — the rule for how much history to
keep (`--keep-daily 7 --keep-weekly 4 ...`). Applied by
`forget`/`prune` (restic) or `prune` (Borg).

**Snapshot** — restic's word for one backup run: the state
of the backed-up folders at that moment.

**Sync** — keeping two places identical (Dropbox, iCloud).
Protects against a lost device; faithfully propagates
deletions and corruption. Not a backup.

**3-2-1 rule** — three copies of what matters, on two
different kinds of storage, one of them off-site.
