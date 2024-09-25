all: build install

build: target/release/clam
	cargo build --release
install:
	sudo rm -rf $(DESTDIR)/usr/include/bash/*.sh
	sudo cp -r headers/* $(DESTDIR)/usr/include/bash/
	sudo install -Dm755 target/release/clam $(DESTDIR)/usr/bin/
uninstall:
	sudo rm -v $(DESTDIR)/usr/include/bash/*.sh
	sudo rm -v $(DESTDIR)/usr/bin/clam
