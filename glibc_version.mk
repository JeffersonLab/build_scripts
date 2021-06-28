GLIBC_VERSION := $(shell ldd --version | head -1 | awk '{print $$NF}')
GLIBC_MAJOR_VERSION := $(shell echo $(GLIBC_VERSION) | awk -F. '{print $$1}')
GLIBC_MINOR_VERSION := $(shell echo $(GLIBC_VERSION) | awk -F. '{print $$2}')
GLIBC_GE_2_32 := $(shell if [[ $(GLIBC_MAJOR_VERSION) -gt "2" || $(GLIBC_MAJOR_VERSION) -eq "2" && $(GLIBC_MINOR_VERSION) -ge "32" ]]; then echo true; else echo false; fi)
