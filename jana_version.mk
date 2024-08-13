ifdef JANA_VERSION
    JANA_MAJOR_VERSION := $(shell echo $(JANA_VERSION) | awk -F. '{print $$1}')
    JANA_MINOR_VERSION := $(shell echo $(JANA_VERSION) | awk -F. '{print $$2}' | bc)
    JANA_SUBMINOR_VERSION := $(shell echo $(JANA_VERSION) | awk -F. '{print $$3}' | bc)
else
     JANA_MAJOR_VERSION := 2
endif
