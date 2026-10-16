# What to Back Up

**Scope:** deciding what goes in. The mistake is not
backing up *too little* — it's backing up everything,
filling the drive, and quietly giving up.

## The one question

For each folder, ask: **can I get this back another way?**

- **Irreplaceable** — photos, documents you wrote, code,
  save files, configuration you tuned for months, the
  database your app keeps its life in. If it's gone,
  it's gone. Back it up.
- **Re-downloadable** — installed programs, games, the OS
  itself, caches, anything with an installer or a store
  page. Skip it. Reinstalling is faster than restoring,
  and the space is better spent on history of the things
  that matter.
- **Bulky and replaceable-ish** — a media library you
  could re-rip or re-buy. Your call; many people back up
  the *catalog* (a list of what they had) rather than the
  terabytes.

A useful size sanity check: for most people, everything
truly irreplaceable fits in tens of gigabytes. If your
backup set is enormous, it's usually stuffed with
re-downloadables.

## The usual suspects, on a real machine

| Back up | Skip |
|---|---|
| Documents, Desktop, Pictures | Program installation folders |
| `~/.ssh`, `~/.config`, dotfiles you care about | Browser caches, `Downloads` (usually) |
| Code / project folders (even with git — your unpushed branches and uncommitted work aren't in the remote) | Node modules, build output, VM images you can recreate |
| Application data folders (notes, email archives, finance data) | The OS — reinstall it, restore your files onto it |

## The database trap

Programs that keep their data in a **database** (SQLite,
PostgreSQL, a photo manager's catalog, most self-hosted
apps) have a catch: copying the database file *while the
program is running* can capture it mid-write — a backup
that restores to a corrupt database.

Three ways to handle it, best first:

1. **Back up when the program is stopped.** For a nightly
   backup, most mortal workloads can tolerate this: the
   app is idle, or briefly stopped by the backup script.
2. **Use the database's own dump tool** (`sqlite3 app.db
   .dump`, `pg_dump`) into a plain file, and back up the
   dump. Dumps are consistent by construction. (Documented
   — the right command depends on your database.)
3. **Just copy the file and accept the small risk** — for
   low-stakes data on a mostly-idle machine, this is
   common practice and usually fine. Know that it's a
   gamble, not a method.

Both restic and Borg back up *files*. Neither reaches
inside a running database and makes it consistent. That
part is on you.

## What about the whole system?

Full-system images ("bare metal" backups) promise to
restore your entire machine, OS and all. For one personal
machine they usually disappoint: the image is huge,
restoring it onto different hardware is fiddly, and you'll
still reinstall the OS every few years anyway.

The mortal's version: **back up your files, keep a note of
what you installed** (a package list is one command on
most systems), and accept a reinstall as part of recovery.
You get back everything that mattered; the rest was
re-downloadable by definition.
