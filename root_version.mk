ifdef ROOT_VERSION
    ROOT_MAJOR_VERSION := $(shell echo $(ROOT_VERSION) | awk -F. '{print $$1}')
    ROOT_MINOR_VERSION := $(shell echo $(ROOT_VERSION) | awk -F. '{print $$2}')
    ROOT_SUBMINOR_VERSION := $(shell echo $(ROOT_VERSION) | awk -F. '{print $$3}')
    ROOT_LE_6_08 := $(shell if [[ $(ROOT_MAJOR_VERSION) -lt 6 || $(ROOT_MAJOR_VERSION) -eq 6 && $(ROOT_MINOR_VERSION) -le 8 ]]; then echo true; else echo false; fi)
endif
