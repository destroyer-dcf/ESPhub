#!/bin/bash

export PICO_SDK_PATH=/home/destroyer/Projects/ESPhub/pico-sdk
export PATH_OPENOCD_SCRIPTS=$PICO_SDK_PATH/openocd/0.12.0+dev/scripts

$PICO_SDK_PATH/openocd/0.12.0+dev/openocd.exe -s $PATH_OPENOCD_SCRIPTS -f $PATH_OPENOCD_SCRIPTS/interface/cmsis-dap.cfg -f $PATH_OPENOCD_SCRIPTS/target/rp2040.cfg -c "adapter speed 5000" -c "program build/esphub.elf verify reset exit"