#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CLANG_FORMAT=${1:-clang-format}
CLANG_FORMAT_RESOLVED=`which "${CLANG_FORMAT}"`
if [ ! -f "${CLANG_FORMAT_RESOLVED}" ]; then
    >&2 echo "ERROR: the formatter is not a file."
    >&2 echo "Specified or default: ${CLANG_FORMAT}"
    >&2 echo "Resolves to: ${CLANG_FORMAT_RESOLVED}"
    >&2 echo "It needs to be an executable file. Specify the formatter as the first command line argument."
    exit 1
fi
if [ ! -x "${CLANG_FORMAT_RESOLVED}" ]; then
    >&2 echo "ERROR: the formatter is not executable."
    >&2 echo "Specified or default: ${CLANG_FORMAT}"
    >&2 echo "Resolves to: ${CLANG_FORMAT_RESOLVED}"
    >&2 echo "It needs to be an executable file. Specify the formatter as the first command line argument."
    exit 2
fi

echo "Formatting *.h, *.c, global.pre in directory ${SCRIPT_DIR}."
if ! cd "${SCRIPT_DIR}"; then
    >&2 echo "ERROR: cannot change to the target directory."
    >&2 echo "Target directory: ${SCRIPT_DIR}"
    >&2 echo "The script will change directory (cd) to the target directory and run the formatter on files there. The target directory is taken from the location of this Bash script."
    exit 3
fi

# 'find' on MacOS requires the directory argument to be present.  That's the
# first argument to 'find'.  Also skip over dotfile directories using ".?*"
# where the question mark prevents matching the root dir ".".
find . \
    -type d -name ".?*" -prune -o \
    -type f \( -name "*.h" -o -name "*.c" -o -name "globals.pre" \) \
    -print -exec "${CLANG_FORMAT_RESOLVED}" -i \{\} \;
