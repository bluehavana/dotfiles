#!/bin/bash

set -u
set -e
shopt -s extglob

DEST_DIR="${1:-$HOME}"
SOURCE_DIR="$(dirname "${0}")"
SOURCE_DIR="${2:-$SOURCE_DIR}"

# Just playin': don't actually do anything
PLAYIN="${PLAYIN:-false}"

ERROR_COLOR=""
STATUS_COLOR=""
END_COLOR=""

if [ -t 1 ] && tput colors &> /dev/null
then
    STATUS_COLOR='\e[0;32m'
    ERROR_COLOR='\e[0;31m'
    END_COLOR='\e[0m'
fi

SPECIAL_FILENAMES=('config/' 'vim/bundle/')

format_status() {
    printf "[${STATUS_COLOR}*${END_COLOR}] %s\n" "${1}"
}

format_error() {
    printf "[${ERROR_COLOR}!${END_COLOR}] ${ERROR_COLOR}%s${END_COLOR}\n" "${1}"
}

clean_filename() {
        local clean_f="$1"

        if [ "${clean_f:0:2}" = "./" ]
        then
            while [ "${clean_f:0:2}" = "./" \
                -o "${clean_f:0:1}" = "/" ]
            do
                clean_f="${clean_f#./}"
                clean_f="${clean_f#/}"
            done
        fi
        printf %s "${clean_f}"
}

is_special_dir() {
    local dir_name="$1"
    [ "${dir_name}" ] || return 1

    for special in "${SPECIAL_FILENAMES[@]}"
    do
        stripped="${dir_name#${special}}"
        if [ -z "${stripped##*([^/])}" ]
        then
            return 0
        fi
    done
    return 1
}

should_print() {
    local dir_name="$1"
    [ "${dir_name}" ] || return 1

    if is_special_dir "${dir_name}" || \
       ([ -n "${dir_name}" ] && [ -z "${dir_name##+([^/])}" ])
    then
        return 0
    fi
    return 1
}

fixup_directory() {
    local dest_dir="$1"

    if ! [ -e "${dest_dir}" ]
    then
        if "${PLAYIN}"
        then
            echo mkdir "${dest_dir}"
        else
            mkdir "${dest_dir}"
        fi
        return 0
    elif [ -e "${dest_dir}" ] && ! [ -d "${dest_dir}" ]
    then
        format_error "What's where directory should be? ${dest_dir}" >&2
        return 1
    elif [ -d "${dest_dir}" ]
    then
        return 0
    fi
    return 1
}

copy_file() {
    local clean="$1"
    local src="$2"
    local dest="$3"

    if [ ! -f "${dest}" ] || ! cmp "${src}" "${dest}" > /dev/null
    then
        local status=0
        if "${PLAYIN}"
        then
            echo cp "${src}" "${dest}"
        else
            cp "${src}" "${dest}"
            status=$?
        fi

        if [ "$?" -ne "0" ]
        then
            format_error "Could not copy into file ${dest}" >&2
            return 1
        fi
        return 0
    fi
    return 1
}

sync_files() {
    local source_dir="$1"
    local dest_dir="$2"

    local updated=1

    for f in "${source_dir}"/*
    do
        local clean_f="$(clean_filename "${f}")"

        if [ -d "${f}" ]
        then
            if fixup_directory "${dest_dir}/.${clean_f}"
            then
                if sync_files "${f}" "${dest_dir}" && [ "${updated}" -ne "0" ]
                then
                    updated=0
                fi
            fi
        elif [ -f "${f}" ]
        then
            if copy_file "${clean_f}" "${f}" "${dest_dir}/.${clean_f}" && \
               [ "${updated}" -ne "0" ]
            then
                updated=0
            fi
        fi

        if [ "${updated}" -eq "0" ] && should_print "${clean_f}"
        then
            format_status "${clean_f}" >&2
        fi
    done
}

pushd "${SOURCE_DIR}" > /dev/null
pushd "copydots" > /dev/null

sync_files "./" "${DEST_DIR}" || format_error "Error syncing dotfiles!"

popd > /dev/null # copydots
popd > /dev/null # dirname $0
