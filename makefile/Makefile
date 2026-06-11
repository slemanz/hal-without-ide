CC = arm-none-eabi-gcc
LD = arm-none-eabi-gcc
SIZE = arm-none-eabi-size
OBJCOPY = arm-none-eabi-objcopy

JLINK = jlink

RM = rm -rf

TARGET = flash
DIR_BUILD = build

DIR_HAL = drivers/stm32f4xx-hal-driver

MCU = -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb
CFLAGS = -c $(MCU) -std=gnu11 -DSTM32F411xE -DUSE_HAL_DRIVER -Wall -O0 -g3 -ffunction-sections -fdata-sections
LDFLAGS = $(MCU) -Tdrivers/Device/STM32F411.ld --specs=nano.specs --specs=nosys.specs -Wl,--gc-sections

INCLUDES =	-Iapp/Inc \
			-Idrivers/Device/cmsis \
			-I$(DIR_HAL)/Inc

OBJS += $(DIR_BUILD)/main.o
OBJS += $(DIR_BUILD)/config.o
OBJS += $(DIR_BUILD)/syscalls.o
OBJS += $(DIR_BUILD)/startup.o
OBJS += $(DIR_BUILD)/system_stm32f4xx.o

# Apenas os modulos do HAL realmente usados
DRIVERS += $(DIR_BUILD)/stm32f4xx_hal.o
DRIVERS += $(DIR_BUILD)/stm32f4xx_hal_cortex.o
DRIVERS += $(DIR_BUILD)/stm32f4xx_hal_rcc.o
DRIVERS += $(DIR_BUILD)/stm32f4xx_hal_gpio.o
DRIVERS += $(DIR_BUILD)/stm32f4xx_hal_uart.o

PREREQ = $(DIR_BUILD)

all: $(PREREQ) $(DIR_BUILD)/$(TARGET).elf

$(PREREQ):
	mkdir $(PREREQ)

$(DIR_BUILD)/%.o: app/Src/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(DIR_BUILD)/$(*).o app/Src/$(*).c

$(DIR_BUILD)/%.o: drivers/Device/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(DIR_BUILD)/$(*).o drivers/Device/$(*).c

$(DIR_BUILD)/%.o: $(DIR_HAL)/Src/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(DIR_BUILD)/$(*).o $(DIR_HAL)/Src/$(*).c

$(DIR_BUILD)/$(TARGET).elf: $(OBJS) $(DRIVERS)
	$(CC) $(LDFLAGS) -o $@ $^
	$(OBJCOPY) -O binary $(DIR_BUILD)/$(TARGET).elf $(DIR_BUILD)/$(TARGET).bin
	$(SIZE) $(DIR_BUILD)/$(TARGET).elf

flash:
	@$(JLINK) -CommanderScript flash.jlink >/dev/null 2>&1 && echo "Flash Finished"

clean:
	$(RM) $(DIR_BUILD)

.PHONY: clean flash
