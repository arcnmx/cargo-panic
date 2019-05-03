ifndef DESTDIR
install:
	$(error DESTDIR not set)
else
install:
	install -d "$(DESTDIR)"
	ln -s "$(CURDIR)/cargo-panic" "$(DESTDIR)/"
endif

.PHONY: install
