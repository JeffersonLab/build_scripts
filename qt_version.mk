QT_VERSION := $(shell if [ -f  "/usr/lib64/libQt5Core.so" ]; then echo 5; else echo 4; fi)
