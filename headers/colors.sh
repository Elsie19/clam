#!/bin/bash

# Colors
BOLD=$(tput bold)
export BOLD
NORMAL=$(tput sgr0)
export NORMAL
export NC='\033[0m'
# Courtesy of https://stackoverflow.com/a/28938235/13449010

# https://no-color.org/
if [[ -z ${NO_COLOR} ]]; then
    # Regular Colors
    export BLACK='\033[0;30m'  # Black
    export RED='\033[0;31m'    # Red
    export GREEN='\033[0;32m'  # Green
    export YELLOW='\033[0;33m' # Yellow
    export BLUE='\033[0;34m'   # Blue
    export PURPLE='\033[0;35m' # Purple
    export CYAN='\033[0;36m'   # Cyan
    export WHITE='\033[0;37m'  # White

    # Bold
    export BBlack='\033[1;30m'  # Black
    export BRed='\033[1;31m'    # Red
    export BGreen='\033[1;32m'  # Green
    export BYellow='\033[1;33m' # Yellow
    export BBlue='\033[1;34m'   # Blue
    export BPurple='\033[1;35m' # Purple
    export BCyan='\033[1;36m'   # Cyan
    export BWhite='\033[1;37m'  # White

    # Underline
    export UBlack='\033[4;30m'  # Black
    export URed='\033[4;31m'    # Red
    export UGreen='\033[4;32m'  # Green
    export UYellow='\033[4;33m' # Yellow
    export UBlue='\033[4;34m'   # Blue
    export UPurple='\033[4;35m' # Purple
    export UCyan='\033[4;36m'   # Cyan
    export UWhite='\033[4;37m'  # White

    # Background
    export On_Black='\033[40m'  # Black
    export On_Red='\033[41m'    # Red
    export On_Green='\033[42m'  # Green
    export On_Yellow='\033[43m' # Yellow
    export On_Blue='\033[44m'   # Blue
    export On_Purple='\033[45m' # Purple
    export On_Cyan='\033[46m'   # Cyan
    export On_White='\033[47m'  # White

    # High Intensity
    export IBlack='\033[0;90m'  # Black
    export IRed='\033[0;91m'    # Red
    export IGreen='\033[0;92m'  # Green
    export IYellow='\033[0;93m' # Yellow
    export IBlue='\033[0;94m'   # Blue
    export IPurple='\033[0;95m' # Purple
    export ICyan='\033[0;96m'   # Cyan
    export IWhite='\033[0;97m'  # White

    # Bold High Intensity
    export BIBlack='\033[1;90m'  # Black
    export BIRed='\033[1;91m'    # Red
    export BIGreen='\033[1;92m'  # Green
    export BIYellow='\033[1;93m' # Yellow
    export BIBlue='\033[1;94m'   # Blue
    export BIPurple='\033[1;95m' # Purple
    export BICyan='\033[1;96m'   # Cyan
    export BIWhite='\033[1;97m'  # White

    # High Intensity backgrounds
    export On_IBlack='\033[0;100m'  # Black
    export On_IRed='\033[0;101m'    # Red
    export On_IGreen='\033[0;102m'  # Green
    export On_IYellow='\033[0;103m' # Yellow
    export On_IBlue='\033[0;104m'   # Blue
    export On_IPurple='\033[0;105m' # Purple
    export On_ICyan='\033[0;106m'   # Cyan
    export On_IWhite='\033[0;107m'  # White
else
    export BLACK=''
    export RED=''
    export GREEN=''
    export YELLOW=''
    export BLUE=''
    export PURPLE=''
    export CYAN=''
    export WHITE=''
    export BBlack=''
    export BRed=''
    export BGreen=''
    export BYellow=''
    export BBlue=''
    export BPurple=''
    export BCyan=''
    export BWhite=''
    export UBlack=''
    export URed=''
    export UGreen=''
    export UYellow=''
    export UBlue=''
    export UPurple=''
    export UCyan=''
    export UWhite=''
    export On_Black=''
    export On_Red=''
    export On_Green=''
    export On_Yellow=''
    export On_Blue=''
    export On_Purple=''
    export On_Cyan=''
    export On_White=''
    export IBlack=''
    export IRed=''
    export IGreen=''
    export IYellow=''
    export IBlue=''
    export IPurple=''
    export ICyan=''
    export IWhite=''
    export BIBlack=''
    export BIRed=''
    export BIGreen=''
    export BIYellow=''
    export BIBlue=''
    export BIPurple=''
    export BICyan=''
    export BIWhite=''
    export On_IBlack=''
    export On_IRed=''
    export On_IGreen=''
    export On_IYellow=''
    export On_IBlue=''
    export On_IPurple=''
    export On_ICyan=''
    export On_IWhite=''
fi
