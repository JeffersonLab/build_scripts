ifdef DIRACXX_VERSION
    DIRACXX_VERSION_DEFINED = true
    DIRACXX_MAJOR_VERSION := $(shell echo $(DIRACXX_VERSION) | awk -F. '{print $$1}')
    DIRACXX_MINOR_VERSION := $(shell echo $(DIRACXX_VERSION) | awk -F. '{print $$2}')
    DIRACXX_SUBMINOR_VERSION := $(shell echo $(DIRACXX_VERSION) | awk -F. '{print $$3}')
else
    DIRACXX_VERSION_DEFINED = false
    DIRACXX_MAJOR_VERSION := 0
    DIRACXX_MINOR_VERSION := 0
    DIRACXX_SUBMINOR_VERSION := 0
endif

USE_CMAKE := $(shell if [[ $(DIRACXX_VERSION_DEFINED) == false || $(DIRACXX_MAJOR_VERSION) -ge "2" ]]; then echo true; else echo false; fi)
