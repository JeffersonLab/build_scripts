QT_VERSION := $(shell if [ -f  "/usr/lib64/libQtCore.so" ]; then echo 4; else echo 5; fi)
