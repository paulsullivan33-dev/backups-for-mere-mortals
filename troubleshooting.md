# Troubleshooting

**Scope:** the failures you'll actually meet, symptom →
fix. Every error message below is verbatim from a real run
(restic 0.19.1, BorgBackup 1.4.5) — several were
reproduced on purpose so you can recognize them.

## "Fatal: wrong password or no key found"

**Symptom:** any restic command against the repository
stops immediately.

**Fix:** the password is wrong, mistyped, or — for the
automated job — the password file has a stray newline or
the wrong file entirely. Type it interactively once to
confirm which password the repository actually expects.
If it's simply forgotten: the repository is gone, exactly
as the init warning promised. There is no recovery step.
Rebuild from whatever other copy exists (see
[Encryption and the password problem](encryption-and-passwords.md)).

## "Fatal: repository does not exist: unable to open config file"

```
Fatal: repository does not exist: unable to open config file:
stat /path/to/repo/config: no such file or directory
Is there a repository at the following location?
```

**Symptom:** restic refuses every command.

**Fix:** the path in `RESTIC_REPOSITORY` doesn't contain
an initialized repository. Either it's a typo (pointing at
the drive instead of the repo folder on it), the drive
isn't mounted (an unmounted mount point looks exactly like
an empty folder — check `ls /mnt/backup-drive` shows the
drive, not nothing), or you never ran `restic init` there.
It does **not** mean an existing repository was erased;
restic is telling you it found nothing where you pointed.

## "Fatal: failed to find snapshot: no matching ID found"

**Symptom:** `restic restore deadbeef ...` fails with
`no matching ID found for prefix "deadbeef"`.

**Fix:** that snapshot ID doesn't exist in this
repository. Run `restic snapshots` and copy an ID from the
list — IDs only need the first few characters, but they
have to be the *right* characters. Common cause: you're
looking at a different repository than the one you backed
up to (home vs. off-site).

## Repository locked / "unable to create lock"

**Symptom:** a command reports the repository is already
locked, often after a backup was interrupted — laptop
closed, drive unplugged, process killed.

**Fix:** first make *sure* no restic process is actually
running (a lock from a live backup is restic protecting
you). If nothing is running, the lock is a leftover:

```
restic unlock
```

removes stale locks. Never `unlock` while another run is
in progress to "make it go faster" — concurrent writes to
one repository is how repositories get damaged.

## Check reports damaged packs

**Symptom:** `restic check --read-data` reports errors
like `ciphertext verification failed` for a pack and
prints repair commands:

```
restic repair packs <pack-id>
restic repair snapshots --forget
```

**Fix:** don't panic, and don't improvise — restic just
told you the procedure. The damage is usually one failing
drive sector, and the repair rebuilds from what's
readable. Run the printed commands, re-run `check`, and
restore the affected files from your *other* copy if any
blob is unrecoverable. This is the 3-2-1 rule earning its
keep. Borg's equivalent recovery is `borg check --repair`
— it will ask you to type `YES`, because it can discard
damaged data to save the rest; read its output before
agreeing.

## Borg: "Passphrase supplied in BORG_PASSPHRASE ... is incorrect"

**Symptom:** every Borg command fails the same way.

**Fix:** same disease as restic's wrong-password error:
wrong passphrase, or the environment variable points at a
stale value from an older shell. Unset it and let Borg
prompt interactively to test the passphrase you *think*
it is. If it truly is lost — and there's no exported key
+ passphrase pair elsewhere — the repository is
unrecoverable. (See the
[encryption chapter](encryption-and-passwords.md).)

## Borg: "Archive no-such-archive does not exist"

**Symptom:** extract/diff/info names an archive and Borg
says it isn't there.

**Fix:** list what's actually in the repository
(`borg list`) — names must match exactly, and archives
live in the repository `BORG_REPO` points at, which may
not be the one you think. Also remember `borg diff`'s
quirk: only the *first* archive takes the `::` prefix.

## The backup drive is full

**Symptom:** backups start failing with write errors; the
repository drive is at 100%.

**Fix, in order:**

1. Run your prune for real (people forget `--prune` on
   `forget`, so forgotten snapshots still occupy space):
   `restic forget --keep-... --prune`, or for Borg,
   `prune` followed by `borg compact`.
2. Check whether the backup *set* grew — usually a
   re-downloadable folder crept in
   ([What to back up](what-to-back-up.md)).
3. Accept the arithmetic: retention × change rate needs
   disk. A bigger backup drive is the cheapest component
   in this entire guide, and history is the first thing
   you'll wish you'd kept.

## The backup "runs" but nothing is protected

**Symptom:** no errors anywhere, but the restore drill
([Checking](checking-and-testing-restores.md)) finds the
repository is ancient, empty, or on the same disk as the
originals.

**Fix:** this is the silent-failure family: cron job
pointing at an old script, the drive silently unmounted
for months (backups "succeeding" into a folder on the
*same* disk), closed laptop at backup o'clock. The fixes
live in [Automating it](automating-backups.md): end the
script with a check, watch for the success line, use a
dead man's switch. No error message exists for this one,
which is exactly why it's the most dangerous entry in this
chapter.
