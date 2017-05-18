DESTDIR ?=
PREFIX ?= /usr/local
DATADIR ?= $(PREFIX)/share

LANGS = $(subst .po,,$(wildcard *.po))
MOS   = $(subst .po,.mo,$(wildcard *.po))

all: $(MOS)

clean:
	rm -f $(MOS)

install:
	for lang in $(LANGS) ; do \
	  install -D -m 0644 $$lang.mo $(DESTDIR)$(DATADIR)/locale/$$lang/LC_MESSAGES/jumpnbump-menu.mo ; \
	done

uninstall:
	for lang in $(LANGS) ; do \
	  rm $(DESTDIR)$(DATADIR)/locale/$$lang/LC_MESSAGES/jumpnbump-menu.mo ; \
	done

%.mo: %.po
	msgfmt -o $@ $<
