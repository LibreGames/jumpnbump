DESTDIR ?=
PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
DATADIR ?= $(PREFIX)/share
# Can be overridden to use e.g. /usr/share/games
GAMEDATADIR ?= $(DATADIR)
UNPACKBIN ?= $(BINDIR)/jnbunpack

all: jumpnbump_menu.py l10n

jumpnbump_menu.py:
	sed -e "s#%%BINDIR%%#$(BINDIR)#g" -e "s#%%DATADIR%%#$(GAMEDATADIR)#g" -e "s#%%UNPACKBIN%%#$(UNPACKBIN)#g" < jumpnbump_menu.py.pre > jumpnbump_menu.py

l10n:
	$(MAKE) -C po all

clean:
	$(RM) jumpnbump_menu.py

	$(MAKE) -C po clean

install:
	install -D -m 644 jumpnbump_menu.glade $(DESTDIR)$(GAMEDATADIR)/jumpnbump/jumpnbump_menu.glade
	install -D -m 755 jumpnbump_menu.py $(DESTDIR)$(BINDIR)/jumpnbump-menu
	install -D -m 644 ../dist/jumpnbump-menu.desktop $(DESTDIR)$(DATADIR)/applications/jumpnbump-menu.desktop

	$(MAKE) -C po install

uninstall:
	$(RM) $(DESTDIR)$(GAMEDATADIR)/jumpnbump/jumpnbump_menu.glade
	$(RM) $(DESTDIR)$(BINDIR)/jumpnbump-menu
	$(RM) $(DESTDIR)$(DATADIR)/applications/jumpnbump-menu.desktop

	$(MAKE) -C po uninstall
