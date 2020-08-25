PYTHON_VERSION := $(shell python --version 2>&1 | head -1 | awk '{print $$2}')
PYTHON_MAJOR_VERSION := $(shell echo $(PYTHON_VERSION) | awk -F. '{print $$1}')
PYTHON_MINOR_VERSION := $(shell echo $(PYTHON_VERSION) | awk -F. '{print $$2}')
PYTHON_SUBMINOR_VERSION := $(shell echo $(PYTHON_VERSION) | awk -F. '{print $$3}')
#PYTHON_GE_3 := $(shell if [ $(PYTHON_MAJOR_VERSION) -ge 3 ]; then echo true; else echo false; fi)
PYTHON_GE_3 := true

