DESTDIR ?=
PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
DATADIR ?= $(PREFIX)/share
# Can be overridden to use e.g. /usr/share/games
GAMEDATADIR ?= $(DATADIR)
EXE ?=

CFLAGS ?= -Wall -O2 -ffast-math -funroll-loops -fno-common
SDL_CFLAGS = `sdl2-config --cflags`
DEFINES = -Dstricmp=strcasecmp -Dstrnicmp=strncasecmp -DNDEBUG -DUSE_SDL -DUSE_NET -DZLIB_SUPPORT -DBZLIB_SUPPORT
INCLUDES = -I.
CFLAGS += $(DEFINES) $(SDL_CFLAGS) $(INCLUDES)
export SDL_CFLAGS
export DEFINES
export INCLUDES

LDFLAGS ?=
SDL_LIBS = `sdl2-config --libs`
LIBS = $(SDL_LIBS) -lSDL2_mixer -lSDL2_net -lbz2 -lz -lm

TARGET = jumpnbump$(EXE)
SDL_TARGET = sdl.a
MODIFY_TARGET = gobpack$(EXE) jnbpack$(EXE) jnbunpack$(EXE)
OBJS = main.o menu.o filter.o network.o
BINARIES = $(TARGET) $(MODIFY_TARGET)

.PHONY: data modify

all: $(BINARIES)

$(SDL_TARGET): globals.h
	$(MAKE) -C sdl

$(MODIFY_TARGET): modify

modify: globals.h
	$(MAKE) -C modify

$(TARGET): $(OBJS) $(SDL_TARGET) data globals.h
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS) $(SDL_TARGET) $(LIBS)

$(OBJS): globals.h

globals.h: globals.pre
	sed -e "s#%%DATADIR%%#$(GAMEDATADIR)#g" < globals.pre > globals.h

data: $(MODIFY_TARGET)
	$(MAKE) -C data

jnbmenu:
	$(MAKE) -C menu

clean:
	for dir in data modify sdl; do $(MAKE) clean -C $$dir; done
	$(RM) $(TARGET) *.exe *.o globals.h

	$(MAKE) -C menu clean

install:
	mkdir -p $(DESTDIR)$(BINDIR)
	mkdir -p $(DESTDIR)$(GAMEDATADIR)/jumpnbump/
	mkdir -p $(DESTDIR)$(DATADIR)/metainfo/
	mkdir -p $(DESTDIR)$(DATADIR)/applications/
	mkdir -p $(DESTDIR)$(DATADIR)/icons/hicolor/32x32/apps/
	mkdir -p $(DESTDIR)$(DATADIR)/icons/hicolor/64x64/apps/
	mkdir -p $(DESTDIR)$(DATADIR)/icons/hicolor/96x96/apps/
	mkdir -p $(DESTDIR)$(DATADIR)/icons/hicolor/128x128/apps/
	mkdir -p $(DESTDIR)$(DATADIR)/man/man6/
	install -m 755 $(BINARIES) $(DESTDIR)$(BINDIR)/
	install -m 644 data/jumpbump.dat \
		$(DESTDIR)$(GAMEDATADIR)/jumpnbump/jumpbump.dat
	install -m 644 dist/io.gitlab.LibreGames.jumpnbump.metainfo.xml \
		$(DESTDIR)$(DATADIR)/metainfo/io.gitlab.LibreGames.jumpnbump.metainfo.xml
	install -m 644 dist/io.gitlab.LibreGames.jumpnbump.desktop \
		$(DESTDIR)$(DATADIR)/applications/io.gitlab.LibreGames.jumpnbump.desktop
	install -m 644 dist/jumpnbump32.png \
		$(DESTDIR)$(DATADIR)/icons/hicolor/32x32/apps/io.gitlab.LibreGames.jumpnbump
	install -m 644 dist/jumpnbump64.png \
		$(DESTDIR)$(DATADIR)/icons/hicolor/64x64/apps/io.gitlab.LibreGames.jumpnbump
	install -m 644 dist/jumpnbump96.png \
		$(DESTDIR)$(DATADIR)/icons/hicolor/96x96/apps/io.gitlab.LibreGames.jumpnbump
	install -m 644 dist/jumpnbump128.png \
		$(DESTDIR)$(DATADIR)/icons/hicolor/128x128/apps/io.gitlab.LibreGames.jumpnbump
	install -m 644 dist/jumpnbump.6 $(DESTDIR)$(DATADIR)/man/man6/

#	$(MAKE) -C menu install

uninstall:
	for bin in $(BINARIES); do $(RM) $(DESTDIR)$(BINDIR)/$$bin; done
	$(RM) -r $(DESTDIR)$(GAMEDATADIR)/jumpnbump
	$(RM) $(DESTDIR)$(DATADIR)/metainfo/io.gitlab.LibreGames.jumpnbump.metainfo.xml
	$(RM) $(DESTDIR)$(DATADIR)/applications/io.gitlab.LibreGames.jumpnbump.desktop
	$(RM) $(DESTDIR)$(DATADIR)/icons/jumpnbump.png
	$(RM) $(DESTDIR)$(DATADIR)/man/man6/jumpnbump.6

	$(MAKE) -C menu uninstall

doc:
	rman dist/jumpnbump.6 -f HTML > docs/jumpnbump.html
