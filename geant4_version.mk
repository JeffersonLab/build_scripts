ifdef GEANT4_VERSION
    GEANT4_MAJOR_VERSION := $(shell echo $(GEANT4_VERSION) | awk -F. '{print $$1}')
    GEANT4_MINOR_VERSION := $(shell echo $(GEANT4_VERSION) | awk -F. '{print $$2}' | bc)
    GEANT4_SUBMINOR_VERSION := $(shell echo $(GEANT4_VERSION) | awk -F'.p' '{print $$3}' | bc)
    GEANT4_EQ_10_04 := $(shell if [[ $(GEANT4_MAJOR_VERSION) -eq 10 && $(GEANT4_MINOR_VERSION) -eq 4 ]]; then echo true; else echo false; fi)
endif
