#!/bin/sh

BITS=32

if [[ $# -ge 1 ]]; then
  case "$1" in
    --help|-h)
    echo "Usage: <script> [options]"
    echo -e "\nAvailable options:"
    echo -e "\t--help, -h\tThis usage explanation."
    echo -e "\t--builddeps\tInstall build dependencies (dnf)."
    echo -e "\t--32\t\tBuild 32-bit binary with MinGW-w64."
    echo -e "\t--64\t\tBuild 64-bit binary with MinGW-w64."
    echo -e "\t--clean, -c\tClean build artifacts."
    echo ""
    exit 0
    ;;
    --builddeps)
    sudo dnf install -y mingw32-bzip2 mingw32-flac mingw32-gcc mingw32-libmodplug mingw32-libogg mingw32-libvorbis \
        mingw32-winpthreads mingw32-SDL2 mingw32-SDL2_mixer mingw32-SDL2_net mingw32-zlib
    sudo dnf install -y mingw64-bzip2 mingw64-flac mingw64-gcc mingw64-libmodplug mingw64-libogg mingw64-libvorbis \
        mingw64-winpthreads mingw64-SDL2 mingw64-SDL2_mixer mingw64-SDL2_net mingw64-zlib
    sudo dnf install -y --setopt=install_weak_deps=False /usr/bin/wine
    exit 0
    ;;
    --32)
    BITS=32
    ;;
    --64)
    BITS=64
    ;;
    --clean|-c)
    make clean
    rm -f *.dll
    exit 0
    ;;
    *)
    echo "Unknown option, use --help for usage instructions."
    ;;
  esac
  shift
fi

if [ "${BITS}" == "32" ]; then
    MINGW=i686-w64-mingw32
    LIBS="libgcc_s_dw2-1 "
else
    MINGW=x86_64-w64-mingw32
    LIBS="libgcc_s_seh-1 "
fi

MINGW_PATH=/usr/${MINGW}
PATH=${MINGW_PATH}/bin:${MINGW_PATH}/sys-root/mingw/bin:${PATH}; echo ${PATH}
CC=${MINGW}-gcc

# Clean previous build artifacts
make clean
rm -f *.dll

make CC=${CC} EXEC=wine EXE=.exe $@

LIBS+="libbz2-1 libFLAC-8 libmodplug-1 libogg-0 libssp-0 libstdc++-6 libvorbis-0 libvorbisfile-3 libwinpthread-1 SDL2 SDL2_mixer SDL2_net zlib1"
for lib in ${LIBS}; do
  cp -f ${MINGW_PATH}/sys-root/mingw/bin/${lib}.dll .
done
