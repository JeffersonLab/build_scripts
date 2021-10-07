ifdef ROOT_VERSION
    ROOT_MAJOR_VERSION := $(shell echo $(ROOT_VERSION) | awk -F. '{print $$1}')
    ROOT_MINOR_VERSION := $(shell echo $(ROOT_VERSION) | awk -F. '{print $$2}' | bc)
    ROOT_SUBMINOR_VERSION := $(shell echo $(ROOT_VERSION) | awk -F. '{print $$3}' | bc)
    ROOT_LE_6_08 := $(shell if [[ $(ROOT_MAJOR_VERSION) -lt 6 || $(ROOT_MAJOR_VERSION) -eq 6 && $(ROOT_MINOR_VERSION) -le 8 ]]; then echo true; else echo false; fi)
    ROOT_EQ_6_24 := $(shell if [[ $(ROOT_MAJOR_VERSION) -eq 6 && $(ROOT_MINOR_VERSION) -eq 24 ]]; then echo true; else echo false; fi)
endif
