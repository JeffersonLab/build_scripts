ifdef CCDB_VERSION
    CCDB_MAJOR_VERSION := $(shell echo $(CCDB_VERSION) | awk -F. '{print $$1}')
    CCDB_MINOR_VERSION := $(shell echo $(CCDB_VERSION) | awk -F. '{print $$2}' | bc)
    CCDB_SUBMINOR_VERSION := $(shell echo $(CCDB_VERSION) | awk -F'.p' '{print $$3}' | bc)
else
    CCDB_MAJOR_VERSION := 2
endif
