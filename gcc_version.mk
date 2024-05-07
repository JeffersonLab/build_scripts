GCC_VERSION := $(shell gcc -v 2>&1 | tail -1 | awk '{print $$3}')
GCC_MAJOR_VERSION := $(shell echo $(GCC_VERSION) | awk -F. '{print $$1}')
GCC_MINOR_VERSION := $(shell echo $(GCC_VERSION) | awk -F. '{print $$2}')
GCC_SUBMINOR_VERSION := $(shell echo $(GCC_VERSION) | awk -F. '{print $$3}')
GCC_GE_9 := $(shell if [ $(GCC_MAJOR_VERSION) -ge "9" ]; then echo true; else echo false; fi)
GCC_GE_9 := $(shell if [ $(GCC_MAJOR_VERSION) -ge "9" ]; then echo true; else echo false; fi)
GCC_GE_10 := $(shell if [ $(GCC_MAJOR_VERSION) -ge "10" ]; then echo true; else echo false; fi)
GCC_CXX_STANDARD := "c++11"
