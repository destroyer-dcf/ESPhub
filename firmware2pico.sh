#!/bin/bash

export PICO_SDK_PATH=/home/destroyer/.pico-sdk/sdk/1.5.1
export PATH_OPENOCD_SCRIPTS=/home/destroyer/Projects/ESPhub/pico-sdk/openocd/0.12.0+dev/scripts

/home/destroyer/.pico-sdk/openocd/0.12.0+dev/openocd.exe -s $PATH_OPENOCD_SCRIPTS -f $PATH_OPENOCD_SCRIPTS/interface/cmsis-dap.cfg -f $PATH_OPENOCD_SCRIPTS/target/rp2040.cfg -c "adapter speed 5000" -c "program build/esphub.elf verify reset exit"