# Jump 'n Bump Menu

Launcher GUI in Python/GTK+3 for Jump 'n Bump. It allows setting various
command line options graphically, including loading additional levels
packaged in the standard path (defined by `GAMEDATADIR` in the Makefile),
or in `~/.jumpnbump/levels/`.

## Installation

Jump 'n Bump Menu is best installed together with the main game, using its
Makefile to initialize some packaging-specific constants.

## Dependencies

- Jump 'n Bump
- Python 3
- PyGObject
- Pillow

## History

Jump 'n Bump Menu was written in 2002 by Martin Willemoes Hansen. This
version is derived from the upstream version 0.6, subsequently maintained
by the Debian jumpnbump packagers.

It was integrated in the main Jump 'n Bump repository in 2017 for the
version 1.60 of the game.

There exists a Mono/Gtk# version of Jump 'n Bump Menu by its original
author, though only available via archive.org. You can find the latest
tarball on this [GitLab issue](https://gitlab.com/LibreGames/jumpnbump/issues/23).
