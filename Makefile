# Copyright 2019 Kis Imre

# Project settings
CFLAGS += -g2 -O2 -Wall -Werror -fno-strict-aliasing
CXXFLAGS += -g2 -O2 -Wall -Werror -fno-strict-aliasing -fno-exceptions -fno-rtti

INCLUDE_DIRS += .
INCLUDE_DIRS += config
INCLUDE_DIRS += CMSIS/Include
INCLUDE_DIRS += platform/$(PLATFORM)

SOURCES += main.c
SOURCES += platform/$(PLATFORM)/platform_$(PLATFORM).c
SOURCES += platform/$(PLATFORM)/Startup/startup_$(PLATFORM).S

BINARY ?= $(PLATFORM)
PREFIX ?= arm-none-eabi-
LDSCRIPT := platform/$(PLATFORM)/$(PLATFORM).ld
BUILDDIR ?= build

# Tools
HOSTCC := gcc
CC := $(PREFIX)gcc
CXX := $(PREFIX)g++
AS := $(PREFIX)g++
LD := $(PREFIX)g++
OBJDUMP := $(PREFIX)objdump
GDB := $(PREFIX)gdb
MKDIR := mkdir -p
ifneq ($(MAKECMDGOALS),clean)
ifeq ($(PLATFORM),stm32f4xx)
	# STM32F407IG
	TARGET += -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16
	
	DEFINES += STM32F40_41xxx
	DEFINES += HSE_VALUE=8000000
	
	LDFLAGS += -specs=/usr/arm-none-eabi/lib/thumb/v7e-m+fp/hard/nano.specs
	LDFLAGS += -specs=/usr/arm-none-eabi/lib/thumb/v7e-m+fp/hard/nosys.specs

	SOURCES += platform/$(PLATFORM)/Startup/system_$(PLATFORM).c
	
	INCLUDE_DIRS += CMSIS/Device/ST/STM32F4xx/Include 
else ifeq ($(PLATFORM),lpc8xx)
	# LPC810
	TARGET += -mcpu=cortex-m0 -mthumb -mfloat-abi=soft
	
	LDFLAGS += -specs=/usr/arm-none-eabi/lib/thumb/nofp/nano.specs
	LDFLAGS += -specs=/usr/arm-none-eabi/lib/thumb/nofp/nosys.specs

	INCLUDE_DIRS += CMSIS/Device/NXP/LPC8xx/Include
else
  $(error "Platform not exists. Valid platforms: stm32f4xx,lpc8xx")
endif
endif

# Targets
.PHONY: all clean distclean deploy debug gdb

all: $(BUILDDIR)/$(BINARY).elf $(BUILDDIR)/$(BINARY).dump
	@echo "Building finished"

clean:
	@echo "Cleaning build"
	@rm -rf $(BUILDDIR)

deploy: all
	@echo "Flashing   $(BINARY).elf"
	openocd -f platform/$(PLATFORM)/openocd.cfg -c "program $(BUILDDIR)/$(BINARY).elf reset exit"

debug: all
	@echo "Debuging   $(BINARY).elf"
	openocd -f platform/$(PLATFORM)/openocd.cfg -c "program $(BUILDDIR)/$(BINARY).elf"

gdb: $(BUILDDIR)/$(BINARY).elf
	@echo "Starting gdb"
	$(GDB) --symbols $(BUILDDIR)/$(BINARY).elf -x gdb.commands

# Files
OBJS := $(SOURCES:.c=.o)
OBJS := $(OBJS:.cpp=.o)
OBJS := $(OBJS:.S=.o)
OBJS := $(addprefix $(BUILDDIR)/,$(OBJS))
DEPS := $(OBJS:%.o=%.d)

# Compiler flags
CFLAGS += $(TARGET)
CFLAGS += -fdata-sections -ffunction-sections
CFLAGS += $(addprefix -D,$(DEFINES))
CFLAGS += $(addprefix -I,$(INCLUDE_DIRS))

CXXFLAGS += $(TARGET)
CXXFLAGS += -fdata-sections -ffunction-sections
CXXFLAGS += $(addprefix -D,$(DEFINES))
CXXFLAGS += $(addprefix -I,$(INCLUDE_DIRS))

ASFLAGS += $(TARGET)

LDFLAGS += $(TARGET)
LDFLAGS += -Wl,-M,--gc-sections,--start
LDFLAGS += $(addprefix -L,$(LIB_DIRS))
LDFLAGS += $(addprefix -l,$(LIBS))

# Common rules
%.dump: %.elf
	@echo "Exporting  $(@)"
	@$(OBJDUMP) -d $(<) > $(@)
	
$(BUILDDIR)/$(BINARY).elf: $(OBJS) $(STATIC_LIBS)
	@echo "Linking    $(@)"
	@$(LD) $(LDFLAGS) -T $(LDSCRIPT) $(OBJS) $(STATIC_LIBS) -o $@ > $(BUILDDIR)/$(BINARY).map

$(BUILDDIR)/%.o: %.cpp
	@echo "Compiling  $(<)"
	@$(MKDIR) $(dir $(@))
	@$(CXX) $(CXXFLAGS) -MMD -MP -MF$(@:%.o=%.d) -MT$(@) -c $(<) -o $(@)
	
$(BUILDDIR)/%.o: %.c
	@echo "Compiling  $(<)"
	@$(MKDIR) $(dir $(@))
	@$(CC) $(CFLAGS) -MMD -MP -MF$(@:%.o=%.d) -MT$(@) -c $(<) -o $(@)
	
$(BUILDDIR)/%.o: %.S
	@echo "Assembling $(<)"
	@$(MKDIR) $(dir $(@))
	@$(AS) $(ASFLAGS) -c $(<) -o $(@)
	
-include $(DEPS)
