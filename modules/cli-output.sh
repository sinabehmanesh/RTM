#!/bin/bash
#this file contains configuration and variables required for a proper cli outpu
#variables for printing and grids
BOLD_TEXT=$(tput bold)
NORMAL=$(tput sgr0)
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[1;31m'
NC='\033[0m'

grid_header () {
    printf  "%s \t\t" "ID"  "NAME" "STATUS"
    printf "\n\n"
}

info () {
    echo -e "${BOLD_TEXT}${BLUE}$1${NC}"
}

error () {
    echo -e  "${BOLD_TEXT}${RED}$1${NC}"
}