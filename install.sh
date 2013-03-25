#!/bin/bash

set -u
set -e
shopt -s extglob

DEST_DIR="${1:-$HOME}"
SOURCE_DIR="$(dirname "${0}")"
SOURCE_DIR="${2:-$SOURCE_DIR}"

ERROR_COLOR=""
STATUS_COLOR=""
END_COLOR=""
if [ -t 1 ] && tput colors &> /dev/null
then
	STATUS_COLOR='\e[0;32m'
	ERROR_COLOR='\e[0;31m'
	END_COLOR='\e[0m'
fi

copy_files() {
	local source_dir="${1}"
	local dest_dir="${2}"

	for f in "${source_dir}"/*
	do
		local clean_f="${f}"
		if [ "${clean_f:0:2}" = "./" ]
		then
			while [ "${clean_f:0:2}" = "./" \
				-o "${clean_f:0:1}" = "/" ]
			do
				clean_f="${clean_f#./}"
				clean_f="${clean_f#/}"
			done
		fi

		if [ -d "${f}" ]
		then
			if [ "${clean_f}" ] && [ -z "${clean_f##+([^/])}" ]
			then
				print_status "${clean_f}/" >&2
			fi

			if [ ! -e "${dest_dir}/.${clean_f}" ]
			then
				#cp -rvi "${f}" "${dest_dir}/.${clean_f}"
				mkdir "${dest_dir}/.${clean_f}"
				copy_files "${f}" "${dest_dir}"

			elif [ -e "${dest_dir}/.${clean_f}" \
				-a ! -d "${dest_dir}/.${clean_f}" ]
			then
				print_error "What's where directory should be? ${dest_dir}/.${clean_f}" >&2
				continue
			elif [ -d "${dest_dir}/.${clean_f}" ]
			then
				copy_files "${f}" "${dest_dir}"  
			fi

		elif [ -f "${f}" ]
		then
			if [ "${clean_f}" ] && [ -z "${clean_f##+([^/])}" ]
			then
				print_status "${clean_f}" >&2
			fi

			cp -u "${f}" "${dest_dir}/.${clean_f}"  
		fi
	done
}

print_status() {
	printf "[${STATUS_COLOR}*${END_COLOR}] %s\n" "${1}"
}

print_error() {
	printf "[${ERROR_COLOR}!${END_COLOR}] ${ERROR_COLOR}%s${END_COLOR}\n" "${1}"
}

pushd "${SOURCE_DIR}" > /dev/null
pushd "home_dots" > /dev/null

copy_files "./" "${DEST_DIR}" 

popd > /dev/null # home_dots
popd > /dev/null # dirname $0
