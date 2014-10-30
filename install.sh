#!/bin/bash

set -u
set -e
shopt -s extglob

# Copy files to DEST_DIR
DEST_DIR="${1:-$HOME}"
# Copy files from SOURCE_DIR
SOURCE_DIR="$(dirname "${0}")"
SOURCE_DIR="${2:-$SOURCE_DIR}"

# Just playin': don't actually do anything
PLAYIN="${PLAYIN:-false}"

# Paths that only need a top level message
SPECIAL_FILENAMES=('config/' 'vim/bundle/')

ERROR_COLOR=""
STATUS_COLOR=""
END_COLOR=""

if [ -t 1 ] && tput colors &> /dev/null
then
    STATUS_COLOR='\e[0;32m'
    ERROR_COLOR='\e[0;31m'
    END_COLOR='\e[0m'
fi

# Print formatted regular status message
#
# message: the message to be printed
format_status() {
    local message=$1
    printf "[${STATUS_COLOR}*${END_COLOR}] %s\n" "${message}"
}

# Print formatted error message
#
# message: the message to be printed
format_error() {
    local message=$1
    printf "[${ERROR_COLOR}!${END_COLOR}] ${ERROR_COLOR}%s${END_COLOR}\n" \
        "${message}"
}

# Remove prefixes and cruft from pathname
#
# clean_f: pathname to be cleaned
#
# stdout: cleaned pathname
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

# Is the dir_name prefixed with a special name
#
# dir_name: pathname to check
is_special_dir() {
    local dir_name="$1"
    [ "${dir_name}" ] || return 1

    for special in "${SPECIAL_FILENAMES[@]}"
    do
        local stripped="${dir_name#${special}}"
        if [ -z "${stripped##*([^/])}" ]
        then
            return 0
        fi
    done
    return 1
}

# Is the pathname special or a toplevel path name?
#
# dir_name: the pathname to be checked
should_print() {
    local path_name="$1"
    [ "${path_name}" ] || return 1

    if is_special_dir "${path_name}" || \
       ([ -n "${path_name}" ] && [ -z "${path_name##+([^/])}" ])
    then
        return 0
    fi
    return 1
}

# mkdir if the directory does not exist
#
# dest_dir: pathname of the destination directory
#
# returns: 0 on mkdir, 1 if nothing done or error
fixup_directory() {
    local dest_dir="$1"

    if ! [ -e "${dest_dir}" ]
    then
        if "${PLAYIN}"
        then
            format_status playin: mkdir "${dest_dir}"
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

# Copy file if it changed or doesn't exist
#
# src: copy file from src name
# dest: copy file to dest name
#
# returns: 0 on change, 1 on error/no change
copy_file() {
    local src="$1"
    local dest="$2"

    if [ ! -f "${dest}" ] || ! cmp "${src}" "${dest}" > /dev/null
    then
        local status=0
        if "${PLAYIN}"
        then
            format_status playin: cp "${src}" "${dest}"
            return 0
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

# Recursively copy changed/added files and directories
#
# source_dir: directory to copy files from
# dest_dir: directory to copy files to
#
# returns: 0 if change occured, 1 if unchanged
sync_files() {
    local source_dir="$1"
    local dest_dir="$2"

    local updated=false

    for f in "${source_dir}"/*
    do
        local clean_f="$(clean_filename "${f}")"

        if [ -d "${f}" ]
        then
            if fixup_directory "${dest_dir}/.${clean_f}"
            then
                if sync_files "${f}" "${dest_dir}" && ! "${updated}"
                then
                    updated=true
                fi
            fi
        elif [ -f "${f}" ]
        then
            if copy_file "${f}" "${dest_dir}/.${clean_f}" && \
               ! "${updated}"
            then
                updated=true
            fi
        fi

        if "${updated}" && should_print "${clean_f}"
        then
            format_status "${clean_f}" >&2
        fi
    done

    "${updated}" && return 0
    ! "${updated}" && return 1
}

pushd "${SOURCE_DIR}" > /dev/null
pushd "copydots" > /dev/null

sync_files "./" "${DEST_DIR}" || format_error "Error syncing dotfiles!"

popd > /dev/null # copydots
popd > /dev/null # dirname $0
