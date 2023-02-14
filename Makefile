install: clam
	sudo install -Dm755 headers/*.sh $(DESTDIR)/usr/include/bash/
	sudo install -Dm755 clam $(DESTDIR)/usr/bin/
uninstall:
	sudo rm -v $(DESTDIR)/usr/include/bash/*.sh
	sudo rm -v $(DESTDIR)/usr/bin/clam
