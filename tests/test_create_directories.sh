#!/bin/bash
# Test that the directories to make are created

RED='\033[0;31m'
RESET='\033[0m'

# get directories to create
source ./utils/directories_to_make.sh

for DIR in "${DIRECTORIES_TO_CREATE[@]}"; do
    test -d "$DIR" || (echo -e "${RED}Error: $DIR not found.${RESET}" && exit 1)
done
