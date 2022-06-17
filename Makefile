# Build FBrowser for Debian
.POSIX:

TAG=2022.01
TAGPREFIX=v
REVISION=002

MK_ARCH="${shell uname -m}"
ifneq ("rv64gc", $(MK_ARCH))
	export ARCH=riscv
	export CROSS_COMPILE=riscv64-linux-gnu-
endif
undefine MK_ARCH

export LOCALVERSION:=-R$(REVISION)

all:
	make prepare
	make build

prepare:
	test -d fbrowser || git clone -v \
	https://github.com/44670/FBrowser fbrowser
	cd fbrowser && git fetch
	test -f ~/.gitconfig || \
	  ( git config --global user.email "somebody@example.com"  && \
	  git config --global user.name "somebody" )

build:
	cd fbrowser && git fetch
	cd fbrowser && ( git am --abort || true )
	cd fbrowser && git reset --hard
	cd fbrowser && git checkout main
	cd fbrowser && ( git branch -D build || true )
	cd fbrowser && git checkout -b build
	test ! -f patch/patch-$(TAG) || ( cd fbrowser && ../patch/patch-$(TAG) )
	cd fbrowser && cmake .
	cd fbrowser && make

clean:
	test ! -d fbrowser        || ( cd fbrowser && make clean )
	rm -f FBrowser

install:
	mkdir -p $(DESTDIR)/FB/
	cp -a fbrowser/Rootfs/FB/. $(DESTDIR)/FB/
	cp fbrowser/FBrowser $(DESTDIR)/FB/
	sed -i s/'^wpa_supplicant'/'#wpa_supplicant'/g $(DESTDIR)/FB/board.sh
	sed -i s/'^insmod '/'#insmod '/g $(DESTDIR)/FB/board.sh
	sed -i s/'^killall '/'#killall '/g $(DESTDIR)/FB/board.sh
	sed -i s/'^udhcpc '/'#udhcpc '/g $(DESTDIR)/FB/board.sh
	mkdir -p $(DESTDIR)/etc/init.d/
	cp -a fbrowser/Rootfs/etc/init.d/. $(DESTDIR)/etc/init.d/
	mkdir -p $(DESTDIR)/etc/skel/Desktop
	cp -p patch/fbrowser.desktop $(DESTDIR)/etc/skel/Desktop/
	mkdir -p $(DESTDIR)/etc/systemd/system
	cp -p patch/fbrowser.service $(DESTDIR)/etc/systemd/system/
	mkdir -p $(DESTDIR)/usr/share/fonts/
	cp -a fbrowser/Rootfs/usr/share/fonts/. $(DESTDIR)/usr/share/fonts/

uninstall:
	rm -rf $(DESTDIR)/FB/
