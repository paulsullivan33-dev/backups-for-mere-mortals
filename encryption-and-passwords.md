# Encryption and the Password Problem

**Scope:** the deal both tools make with you — real
encryption, no back door, no mercy — and where to put the
password so future-you can actually restore.

## The deal

restic encrypts everything in the repository: file
contents, file *names*, directory structure. Borg does the
same in its encrypted modes. Someone who walks off with
your backup drive gets noise. This is a genuine, major
advantage over a plain rsync copy sitting in the open.

The price of no back door is no back door:

```
Please note that knowledge of your password is required to access
the repository. Losing your password means that your data is
irrecoverably lost.
```

That's restic's own init message, and it is not legal
theater. There is no support ticket, no recovery key
service, no "forgot password." The mathematics does not
care about your circumstances.

## Borg's extra moving part

Borg splits trust in two: a **key** (a file) *and* a
**passphrase**. In `repokey` modes the key lives inside
the repository, encrypted by the passphrase — lose the
passphrase and the key is useless decoration. In
`keyfile` modes the key lives in your home directory —
reinstall your OS without exporting it first, and the
repository on the surviving drive is unopenable even
*with* the passphrase. Borg's init all but grabs you by
the collar about this:

```
borg key export  REPOSITORY  encrypted-key-backup
```

Export the key. Store the export and the passphrase in
different places. This is the single most-skipped step in
all of Borg, and the most regretted.

## Where mortals should keep the password

Ranked by "will future-you, mid-disaster, actually find
it":

1. **A password manager** — if you use one for everything
   else, the backup password belongs there too. (Your
   password manager's own database should be *in* the
   backup; keep its recovery story straight.)
2. **Written down, physically, somewhere sensible** — a
   sealed envelope with your important papers. A backup
   password is used rarely and desperately; paper suits it
   better than another digital note that itself needs
   backing up.
3. **The password file** (`chmod 600`) for the *automated
   job* — a working copy for the script, not the master
   record. See [Automating it](automating-backups.md) for
   the honest trade-off.

What doesn't work: memory ("I'll remember it" — you will
not, in eighteen months, mid-crisis), and a text file
inside the repository itself, which is a key taped to the
safe.

## Two smaller truths

- **Encryption protects the backup at rest, not in use.**
  While restic/Borg runs, files are readable as usual;
  malware on the live machine can still reach the live
  files — and an *always-mounted, always-writable* backup
  drive. Versioned snapshots blunt this (ransomware can't
  rewrite history inside a restic repo it can't decrypt,
  and older snapshots survive), but the off-site copy from
  the [3-2-1 chapter](the-3-2-1-rule.md) is the real answer.
- **A very strong password you lose is worse than a good
  password you keep.** A long, written-down passphrase of
  several words beats a short burst of symbols you trusted
  to memory. Length is strength; storage is survival.
