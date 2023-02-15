#!/bin/bash

# Colors
BOLD=$(tput bold)
declare -r BOLD
NORMAL=$(tput sgr0)
declare -r NORMAL
declare -r NC='\033[0m'

export BOLD NORMAL NC
# Courtesy of https://stackoverflow.com/a/28938235/13449010

# https://no-color.org/
# shellcheck disable=SC2236
if [[ -z ${NO_COLOR} ]]; then
    # Regular Colors
    declare -r BLACK='\033[0;30m'  # Black
    declare -r RED='\033[0;31m'    # Red
    declare -r GREEN='\033[0;32m'  # Green
    declare -r YELLOW='\033[0;33m' # Yellow
    declare -r BLUE='\033[0;34m'   # Blue
    declare -r PURPLE='\033[0;35m' # Purple
    declare -r CYAN='\033[0;36m'   # Cyan
    declare -r WHITE='\033[0;37m'  # White

    # Bold
    declare -r BBlack='\033[1;30m'  # Black
    declare -r BRed='\033[1;31m'    # Red
    declare -r BGreen='\033[1;32m'  # Green
    declare -r BYellow='\033[1;33m' # Yellow
    declare -r BBlue='\033[1;34m'   # Blue
    declare -r BPurple='\033[1;35m' # Purple
    declare -r BCyan='\033[1;36m'   # Cyan
    declare -r BWhite='\033[1;37m'  # White

    # Underline
    declare -r UBlack='\033[4;30m'  # Black
    declare -r URed='\033[4;31m'    # Red
    declare -r UGreen='\033[4;32m'  # Green
    declare -r UYellow='\033[4;33m' # Yellow
    declare -r UBlue='\033[4;34m'   # Blue
    declare -r UPurple='\033[4;35m' # Purple
    declare -r UCyan='\033[4;36m'   # Cyan
    declare -r UWhite='\033[4;37m'  # White

    # Background
    declare -r On_Black='\033[40m'  # Black
    declare -r On_Red='\033[41m'    # Red
    declare -r On_Green='\033[42m'  # Green
    declare -r On_Yellow='\033[43m' # Yellow
    declare -r On_Blue='\033[44m'   # Blue
    declare -r On_Purple='\033[45m' # Purple
    declare -r On_Cyan='\033[46m'   # Cyan
    declare -r On_White='\033[47m'  # White

    # High Intensity
    declare -r IBlack='\033[0;90m'  # Black
    declare -r IRed='\033[0;91m'    # Red
    declare -r IGreen='\033[0;92m'  # Green
    declare -r IYellow='\033[0;93m' # Yellow
    declare -r IBlue='\033[0;94m'   # Blue
    declare -r IPurple='\033[0;95m' # Purple
    declare -r ICyan='\033[0;96m'   # Cyan
    declare -r IWhite='\033[0;97m'  # White

    # Bold High Intensity
    declare -r BIBlack='\033[1;90m'  # Black
    declare -r BIRed='\033[1;91m'    # Red
    declare -r BIGreen='\033[1;92m'  # Green
    declare -r BIYellow='\033[1;93m' # Yellow
    declare -r BIBlue='\033[1;94m'   # Blue
    declare -r BIPurple='\033[1;95m' # Purple
    declare -r BICyan='\033[1;96m'   # Cyan
    declare -r BIWhite='\033[1;97m'  # White

    # High Intensity backgrounds
    declare -r On_IBlack='\033[0;100m'  # Black
    declare -r On_IRed='\033[0;101m'    # Red
    declare -r On_IGreen='\033[0;102m'  # Green
    declare -r On_IYellow='\033[0;103m' # Yellow
    declare -r On_IBlue='\033[0;104m'   # Blue
    declare -r On_IPurple='\033[0;105m' # Purple
    declare -r On_ICyan='\033[0;106m'   # Cyan
    declare -r On_IWhite='\033[0;107m'  # White
else
    declare -r BLACK RED GREEN YELLOW BLUE PURPLE CYAN WHITE \
        BBlack BRed BGreen BYellow BBlue BPurple BCyan BWhite \
        UBlack URed UGreen UYellow UBlue UPurple UCyan UWhite \
        On_Black On_Red On_Green On_Yellow On_Blue On_Purple On_Cyan On_White \
        IBlack IRed IGreen IYellow IBlue IPurple ICyan IWhite \
        BIBlack BIRed BIGreen BIYellow BIBlue BIPurple BICyan BIWhite \
        On_IBlack On_IRed On_IGreen On_IYellow On_IBlue On_IPurple On_ICyan On_IWhite
fi

export BLACK RED GREEN YELLOW BLUE PURPLE CYAN WHITE \
    BBlack BRed BGreen BYellow BBlue BPurple BCyan BWhite \
    UBlack URed UGreen UYellow UBlue UPurple UCyan UWhite \
    On_Black On_Red On_Green On_Yellow On_Blue On_Purple On_Cyan On_White \
    IBlack IRed IGreen IYellow IBlue IPurple ICyan IWhite \
    BIBlack BIRed BIGreen BIYellow BIBlue BIPurple BICyan BIWhite \
    On_IBlack On_IRed On_IGreen On_IYellow On_IBlue On_IPurple On_ICyan On_IWhite
