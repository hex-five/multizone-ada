# Copyright(C) 2019 Hex Five Security, Inc. - All Rights Reserved

BSP_BASE := ../bsp
PLATFORM_DIR := $(BSP_BASE)/$(BOARD)
RUNTIME_DIR := $(PLATFORM_DIR)/runtime
GPRBUILD := $(abspath $(GNAT))/bin/gprbuild
GPRINSTALL := $(abspath $(GNAT))/bin/gprinstall

.PHONY: all
all:
	$(GPRBUILD) -p -P $(RUNTIME_DIR)/zfp_hifive1.gpr
	$(GPRINSTALL) -f -p -P $(RUNTIME_DIR)/zfp_hifive1.gpr --prefix=$(RUNTIME_DIR)
	$(AR) cr $(RUNTIME_DIR)/lib/gnat/zfp-hifive1/adalib/libgnat.a $(RUNTIME_DIR)/hifive1/zfp/obj/*.o
	$(GPRBUILD) -f -p -P zone3.gpr
	$(OBJCOPY) -O ihex obj/main zone3.hex --gap-fill 0x00

clean:

