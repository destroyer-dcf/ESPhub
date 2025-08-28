#!/bin/bash

if [ ! -f "$PWD/CMakeLists.txt" ]; then
    echo -e "\033[0;31mError: No se encontró CMakeLists.txt en $PWD\033[0m"
    exit 1
fi

export PICO_SDK_PATH=/home/destroyer/Projects/ESPhub/pico-sdk
echo "Me han ejecutado desde: $PWD"
echo "PICO_SDK_PATH ha sido configurado a $PICO_SDK_PATH"
PROJECT_DIR="."
BUILD_DIR="$PROJECT_DIR/build"
if [ -d "$BUILD_DIR" ]; then
    echo "Eliminando el directorio build..."
    rm -rf "$BUILD_DIR"
    echo "Directorio build eliminado."
else
    echo "El directorio build no existe."
fi

mkdir $BUILD_DIR
cd $BUILD_DIR

cmake -Wno-dev -DCMAKE_BUILD_TYPE=Debug ..
make
cd ..


#$PICO_SDK_PATH/openocd/0.12.0+dev/openocd.exe -s /Users/destroyer/.pico-sdk/openocd/0.12.0+dev/scripts -f /home/destroyer/Projects/ESPhub/pico-sdk/openocd/0.12.0+dev/scripts/interface/cmsis-dap.cfg -f /home/destroyer/Projects/ESPhub/pico-sdk/openocd/0.12.0+dev/scripts/target/rp2040.cfg -c "adapter speed 5000" -c "program build/esphub.elf verify reset exit"