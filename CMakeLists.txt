# == DO NOT EDIT THE FOLLOWING LINES for the Raspberry Pi Pico VS Code Extension to work ==
if(WIN32)
    set(USERHOME $ENV{USERPROFILE})
else()
    set(USERHOME $ENV{HOME})
endif()
set(sdkVersion 2.2.0)
set(toolchainVersion 13_2_Rel1)
set(picotoolVersion 2.2.0)
set(picoVscode ${CMAKE_SOURCE_DIR}/pico-sdk/cmake/pico-vscode.cmake)
if (EXISTS ${picoVscode})
    include(${picoVscode})
endif()
# ====================================================================================
cmake_minimum_required(VERSION 3.13)
# Incluye el pico-sdk desde el submódulo
set(PICO_SDK_PATH "${CMAKE_SOURCE_DIR}/pico-sdk")

# Inicializa pico-sdk
include(${PICO_SDK_PATH}/pico_sdk_init.cmake)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

set(PICO_BOARD pico CACHE STRING "Board type")

set(MS_RATE_DEFAULT 100 CACHE STRING "Default mouse sample rate")
set(MS_RATE_HOST_CONTROL ON CACHE BOOL "Allow the host to configure the mouse sample rate")

# Pull in Raspberry Pi Pico SDK
include(pico_sdk_import.cmake)

if (NOT PICO_SDK_VERSION_STRING VERSION_EQUAL "1.5.1")
  message(FATAL_ERROR "Raspberry Pi Pico SDK version 2.2.0 required. Your version is ${PICO_SDK_VERSION_STRING}")
endif()


project(esphub C CXX ASM)

# Initialise the Raspberry Pi Pico SDK
pico_sdk_init()

add_executable(esphub src/esphub.c src/usbin.c src/scancodes.c src/ps2kb.c src/ps2ms.c src/ps2out.c src/ps2in.c)

pico_generate_pio_header(esphub ${CMAKE_CURRENT_LIST_DIR}/src/ps2out.pio)
pico_generate_pio_header(esphub ${CMAKE_CURRENT_LIST_DIR}/src/ps2in.pio)

# print memory usage, enable all warnings
target_link_options(esphub PRIVATE -Xlinker --print-memory-usage)
target_compile_options(esphub PRIVATE -Wall -Wextra)

### PS/2 output
add_compile_definitions(LVOUT=13) # Level shifter pull-up voltage
add_compile_definitions(KBOUT=11) # Keyboard data GPIO11, clock is GPIO12
add_compile_definitions(MSOUT=11) # Mouse data GPIO14, clock is GPIO15

### PS/2 input
add_compile_definitions(LVIN=5) # Level shifter pull-up voltage
add_compile_definitions(KBIN=3) # Keyboard data GPIO3, clock pin is GPIO4
add_compile_definitions(MSIN=6) # Mouse data GPIO6, clock pin is GPIO7

add_compile_definitions(PICO_PANIC_FUNCTION=reset)

add_compile_definitions(MS_RATE_DEFAULT=${MS_RATE_DEFAULT})
if (MS_RATE_HOST_CONTROL)
    add_compile_definitions(MS_RATE_HOST_CONTROL)
endif()

pico_set_program_name(esphub "esphub")
pico_set_program_version(esphub "0.1")

pico_enable_stdio_uart(esphub 1)
pico_enable_stdio_usb(esphub 0)

target_include_directories(esphub PRIVATE ${CMAKE_CURRENT_LIST_DIR}/src)
target_link_libraries(esphub pico_stdlib hardware_pio tinyusb_host tinyusb_board)

pico_add_extra_outputs(esphub)
