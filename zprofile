#!/bin/zsh
echo
CYAN="\x1b[0;36m"
BLUE="\x1b[0;34m"
LIGHT_BLUE="\x1b[1;34m"
WHITE="\x1b[1;37m"
BLACK="\x1b[0;30m"
GREEN="\x1b[0;32m"
BROWN="\x1b[0;35m"
COLOR_RESET="\x1b[0m"

big_hostname() {
	local SED_CYAN="\\x1b[0;36m"
	local SED_WHITE="\\x1b[1;37m"
	local SED_RESET="\\x1b[0m"
	if [ -x "$(which toilet)" ]
	then
		toilet -f pagga "$(hostname -s)"\
		| sed "s/█/${SED_CYAN}█${SED_RESET}/g;\
			s/▀/${SED_CYAN}▀${SED_RESET}/g;\
			s/▄/${SED_CYAN}▄${SED_RESET}/g;\
			s/░/${SED_WHITE}░${SED_RESET}/g;"
	fi
}

my_uptime() {
	local SECS=$(cat /proc/uptime | sed 's/ [0-9.]*$//')
	SECS="${SECS/.*}"
	local MINUTES=0
	local HOURS=0
	local DAYS=0

	if [ "${SECS}" -gt 60 ]
	then
		MINUTES=$(( $SECS / 60 ))
	fi
	if [ "${MINUTES}" -gt 60 ]
	then
		HOURS=$(( $MINUTES / 60 ))
	fi
	if [ "${HOURS}" -gt 24 ]
	then
		DAYS=$(( $HOURS / 24 ))
	fi

	if [ "${DAYS}" -gt 0 ]
	then
		echo "${DAYS} days"
		return 0
	fi
	if [ "${HOURS}" -gt 0 ]
	then
		echo "${HOURS} hours"
		return 0
	fi
	if [ "${MINUTES}" -gt 0 ]
	then
		echo "${MINUTES} minutes"
		return 0
	fi

	echo "${SECS} seconds"
}

append_strings() {
	local TEMP_DIR="$(mktemp --directory)"
	local TEMP1="$(mktemp --dry-run --tmpdir=${TEMP_DIR})"
	local TEMP2="$(mktemp --dry-run --tmpdir=${TEMP_DIR})"
	trap "rm -rf \"$TEMP_DIR\"" EXIT INT TERM HUP
	mkfifo --mode=0600 "${TEMP1}"
	mkfifo --mode=0600 "${TEMP2}"
	printf %s\\n "${1}" > "${TEMP1}" &!
	printf %s\\n "${2}" > "${TEMP2}" &!
	paste -d "  " "${TEMP1}" "${TEMP2}"
}

stats() {
	echo "      ${CYAN}OS:${COLOR_RESET} $(lsb_release -d | sed 's/Description:\s*//')"
	echo "${CYAN}Hostname:${COLOR_RESET} $(hostname)"
	echo "  ${CYAN}Kernel:${COLOR_RESET} $(uname -ri)"
	echo "  ${CYAN}Uptime:${COLOR_RESET} $(my_uptime)" #needs reboot?
	# echo "${CYAN}RAM:${COLOR_RESET} "
	echo "${CYAN}Terminal:${COLOR_RESET} ${TERM}"
	echo "      ${CYAN}df:${COLOR_RESET} "
	echo "    ${CYAN}logs:${COLOR_RESET} "
}


sonic() {
	local SONIC
	SONIC="${BLUE}                          ${LIGHT_BLUE}__${BLUE}____                          ${COLOR_RESET}\n"
	SONIC+="${BLUE}                    ${LIGHT_BLUE}_.-*'\"${BLUE}      \"\`*-._                    ${COLOR_RESET}\n"
	SONIC+="${BLUE}                ${LIGHT_BLUE}_.-*'${BLUE}                  \`*-._              ${COLOR_RESET}\n"
	SONIC+="${BLUE}             ${LIGHT_BLUE}.-'${BLUE}                           \`-.           ${COLOR_RESET}\n"
	SONIC+="${BLUE}  ${LIGHT_BLUE}/${BLUE}\`-.    .-'                  ${LIGHT_BLUE}_${BLUE}.              \`-.        ${COLOR_RESET}\n"
	SONIC+="${BLUE} ${LIGHT_BLUE}:${BLUE}    \`..'                  ${LIGHT_BLUE}.-'${BLUE}_ .                \`.      ${COLOR_RESET}\n"
	SONIC+="${BLUE} |    .'                 .-'_.' \\ .                 \\     ${COLOR_RESET}\n"
	SONIC+="${BLUE} |   /                 .' .*     ;               .-'\"     ${COLOR_RESET}\n"
	SONIC+="${BLUE} :   L                    \`.     | ;          .-'         ${COLOR_RESET}\n"
	SONIC+="${BLUE}  \\\\${LIGHT_BLUE}.'${BLUE} \`*.          ${LIGHT_BLUE}.-*${BLUE}\"*-.  \`.   ; |        .'            ${COLOR_RESET}\n"
	SONIC+="${BLUE}  ${LIGHT_BLUE}/${BLUE}      \\        ${LIGHT_BLUE}'${BLUE}       \`.  \`-'  ;      .'              ${COLOR_RESET}\n"
	SONIC+="${BLUE} : ${WHITE}.'\"\`.${BLUE}  .       ${WHITE}.-*'*-.${BLUE}  \\     .      (_                ${COLOR_RESET}\n"
	SONIC+="${BLUE} |              ${WHITE}.'${BLUE}       ${WHITE}\\ ${BLUE} .             \`*-.            ${COLOR_RESET}\n"
	SONIC+="${BLUE} |${WHITE}.${BLUE}     ${WHITE}.${BLUE}      ${WHITE}/${BLUE}          ${WHITE};${BLUE}                   \`-.         ${COLOR_RESET}\n"
	SONIC+="${BLUE} ${WHITE}:${BLUE}    ${GREEN}db${BLUE}      ${WHITE}'${BLUE}      ${GREEN}d\$b${BLUE}  ${WHITE}|${BLUE}                      \`-.     ${COLOR_RESET}\n"
	SONIC+="${BLUE} ${WHITE}.${BLUE}   ${GREEN}:PT;${WHITE}.${BLUE}  ${WHITE}'${BLUE}       ${GREEN}:P\"T;${BLUE} ${WHITE}:${BLUE}                         \`.   ${COLOR_RESET}\n"
	SONIC+="${BLUE} ${WHITE}:${BLUE}   ${GREEN}:bd;   ${WHITE}'${BLUE}       ${GREEN}:b_d;${BLUE} ${WHITE}:${BLUE}                           \\  ${COLOR_RESET}\n"
	SONIC+="${BLUE} |   ${GREEN}:\$\$;${BLUE} ${WHITE}\`'${BLUE}        ${GREEN}:\$\$\$;${BLUE} ${WHITE}|${BLUE}                            \\ ${COLOR_RESET}\n"
	SONIC+="${BLUE} |    ${GREEN}TP${BLUE}             ${GREEN}T\$P${BLUE}  ${WHITE}'${BLUE}                             ;${COLOR_RESET}\n"
	SONIC+="${BLUE} :                        /.-*'\"\\\`.                      |${COLOR_RESET}\n"
	SONIC+="${BLUE}.s${LIGHT_BLUE}dP^${BLUE}T\$bs.               /'       \\                       ${COLOR_RESET}\n"
	SONIC+="${BLUE}\$\$${LIGHT_BLUE}\$.${BLUE}_.\$\$\$\$b.--._      _.'   .--.   ;                      ${COLOR_RESET}\n"
	SONIC+="${BLUE}\`*\$\$\$\$\$\$P*'     \`*--*'     '  / \\  :                      ${COLOR_RESET}\n"
	SONIC+="${BLUE}   \\                        .'   ; ;                      ${COLOR_RESET}\n"
	SONIC+="${BLUE}    \`.                  _.-'    ' /                       ${COLOR_RESET}\n"
	SONIC+="${BLUE}      \`*-.                      .'                        ${COLOR_RESET}\n"
	SONIC+="${BLUE}          \`*-._            _.-*'                          ${COLOR_RESET}\n"
	SONIC+="${BLUE}               \`*=--..--=*'                               ${COLOR_RESET}\n"
	echo "${SONIC}"
}

SIDE=$(echo "$(big_hostname)" && echo && echo && echo "$(stats)")
append_strings "$(sonic)" "${SIDE}"
if [ -x /usr/games/fortune ]
then
	/usr/games/fortune
elif [ -x /usr/bin/fortune ]
then
	/usr/bin/fortune
fi
echo

unset big_hostname sonic stats my_uptime append_strings
