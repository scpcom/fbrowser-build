fbrowser
================

Build FBrowser for Debian.

Install prerequisites
---------------------

Cross toolchain (optional, better build on riscv64 chroot or target host)

    sudo dpkg --add-architecture riscv64
    sudo apt-get update
    sudo apt-get install crossbuild-essential-riscv64

Other dependencies

    sudo apt-get install build-essential cmake debhelper devscripts \
    git qtbase5-dev libqt5webkit5-dev libqt5websockets5-dev

Build
-----

    dpkg-buildpackage -ariscv64 -d
    sudo dpkg -i ../fbrowser_*.deb

Run
----------------

    cd /FB/
    ./autorun.sh


