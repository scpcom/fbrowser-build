#!/bin/sh
make prepare
make clean
dpkg-buildpackage -ariscv64 -d
