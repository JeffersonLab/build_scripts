ifdef SQLITE_VERSION
    SQLITE_MAJOR_VERSION := $(shell echo $(SQLITE_VERSION) | awk -F. '{print $$1}')
    SQLITE_MINOR_VERSION := $(shell echo $(SQLITE_VERSION) | awk -F. '{print $$2}')
    SQLITE_SUBMINOR_VERSION := $(shell echo $(SQLITE_VERSION) | awk -F. '{print $$3}')
    SQLITE_LT_3_19 := $(shell if [[ $(SQLITE_MAJOR_VERSION) -lt 3 || $(SQLITE_MAJOR_VERSION) -eq 3 && $(SQLITE_MINOR_VERSION) -lt 19 ]]; then echo true; else echo false; fi)
endif
