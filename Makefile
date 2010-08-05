# See COPYING file for copyright, license and warranty details.

NAME = spout
SRC = spout.c
TARGETS = $(NAME)

OBJ = $(SRC:.c=.o)
MAN = $(TARGETS:=.1)

HEADERS = spout.h config.def.h font.h sintable.h
WEB = web/index.html

include config.mk

all: $(TARGETS)

$(OBJ): config.mk config.h $(HEADERS)

.c.o:
	@echo CC $<
	@cc -c $(CFLAGS) $<

$(TARGETS): $(OBJ)
	@echo LD $@
	@cc -o $@ $(OBJ) $(LDFLAGS)

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

$(WEB): web/index.txt web/header.html web/footer.html web/doap.ttl
	@echo making webpage
	@cat web/header.html > $@
	@smu < web/index.txt >> $@
	@echo '<hr />' >> $@
	@sh web/summary.sh web/doap.ttl | smu >> $@
	@cat web/footer.html >> $@

clean:
	rm -f -- $(TARGETS) $(WEB) $(OBJ) $(NAME)-$(VERSION).tar.gz $(NAME)-$(VERSION).tar.gz.sig

dist: clean
	@mkdir -p $(NAME)-$(VERSION)
	@cp -R $(SRC) $(HEADERS) Makefile config.mk COPYING README $(NAME)-$(VERSION)
	@for i in $(MAN); do \
		sed "s/VERSION/$(VERSION)/g" < $$i > $(NAME)-$(VERSION)/$$i; done
	@tar -c $(NAME)-$(VERSION) | gzip -c > web/releases/$(NAME)-$(VERSION).tar.gz
	@gpg -b < web/releases/$(NAME)-$(VERSION).tar.gz > web/releases/$(NAME)-$(VERSION).tar.gz.sig
	@rm -rf $(NAME)-$(VERSION)
	@echo $(NAME)-$(VERSION).tar.gz $(NAME)-$(VERSION).tar.gz.sig

install: all
	@echo installing executables to $(DESTDIR)$(PREFIX)/bin
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@for i in $(TARGETS); do \
		cp -f $$i $(DESTDIR)$(PREFIX)/bin/$$i; \
		chmod 755 $(DESTDIR)$(PREFIX)/bin/$$i; done
	@echo installing manual pages to $(DESTDIR)$(MANPREFIX)/man1
	@mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	@for i in $(MAN); do \
		sed "s/VERSION/$(VERSION)/g" < $$i > $(DESTDIR)$(MANPREFIX)/man1/$$i; \
		chmod 644 $(DESTDIR)$(MANPREFIX)/man1/$$i; done

uninstall:
	@echo uninstalling executables from $(DESTDIR)$(PREFIX)/bin
	@for i in $(TARGETS); do rm -f $(DESTDIR)$(PREFIX)/bin/$$i; done
	@echo uninstalling manual pages from $(DESTDIR)$(MANPREFIX)/man1
	@for i in $(MAN); do rm -f $(DESTDIR)$(MANPREFIX)/man1/$$i; done

.PHONY: all clean dist install uninstall test
