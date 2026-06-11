# Thin wrapper around CMake so the day to day commands stay short:
#   make        -> configure (first time only) and build
#   make flash  -> build and flash via J-Link
#   make clean  -> remove the build folder

RM = rm -rf

DIR_BUILD = build
GENERATOR = Ninja
TOOLCHAIN = cmake/stm32f411.cmake

all: $(DIR_BUILD)
	cmake --build $(DIR_BUILD)

$(DIR_BUILD):
	cmake -G $(GENERATOR) -B $(DIR_BUILD) -DCMAKE_TOOLCHAIN_FILE=$(TOOLCHAIN)

flash: $(DIR_BUILD)
	cmake --build $(DIR_BUILD) --target flash

clean:
	$(RM) $(DIR_BUILD)

.PHONY: all flash clean
