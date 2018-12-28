#!/bin/bash

# Builds a full release of Anofeyn, compiling scripts, packing resources into a
# BSA and bundling the whole thing in a 7z archive.

# Color constants
C_RED='\033[1;31m'
C_GREEN='\033[1;32m'
C_BLUE='\033[1;34m'
C_YELLOW='\033[1;33m'
C_NC='\033[0m'

# Variable definitions
# The path to the Skyrim / Skyrim SE installation to use
SKYRIM_PATH="G:/steam/steamapps/common/Skyrim Special Edition"
# The path to the vanilla skyrim, SKSE and SkyUI sources.
SKYRIM_SOURCES="${SKYRIM_PATH}/Data/Scripts/Source"
# The path to the papyrus compiler.
COMPILER_PATH="${SKYRIM_PATH}/Papyrus Compiler/PapyrusCompiler.exe"
# The path to the flags file for Skyrim.
FLAGS_PATH="${SKYRIM_SOURCES}/TESV_Papyrus_Flags.flg"
# The version to release the mod with
VERSION="0.1.0"

# Print a nice greeting
echo -e "Welcome to the ${C_RED}Anofeyn release builder${C_NC}!"
echo ""

# Find out if we should build a dev or a release file
release=-1
while [[ release -eq -1 ]]; do
    echo -e "Build a (${C_GREEN}d${C_NC})${C_YELLOW}evelopment${C_NC} or a (${C_GREEN}r${C_NC})${C_YELLOW}elease${C_NC} file?"
    read -s -n 1 key
    if [[ "${key}" == "d" ]]
    then
        release=0
    elif [[ "${key}" == "r" ]]
    then
        release=1
    else
        echo -e "${C_GREEN}${key}${C_NC} is not a valid file type."
    fi
done

# Delete and recreate a release folder to make sure we have a fresh setup
echo ""
echo -e "${C_RED}==>${C_NC} Creating new release folder..."

rm -rf "release"
mkdir -p "release/Data"

# Make sure MLib is here and up to date, then copy it into the release folder
git submodule update
cp -r "MLib/scripts" "release/Data"

# Copy everything else into the release folder
cp -r "interface" "release/Data"
cp -r "meshes" "release/Data"
cp -r "scripts" "release/Data"
cp -r "textures" "release/Data"
cp "Anofeyn.esp" "release"
cp "Anofeyn.modgroups" "release"

# These are only used in release mode
if [[ $release -eq 1 ]]
then
    cp "AnofeynBSAManifest.txt" "release"
    cp "AnofeynBSAScript.txt" "release"
fi

# Move into the release folder to make the rest of this procedure simpler
cd "release"

# Compile all scripts, adding the appropriate flags for each mode
echo ""
echo -e "${C_RED}==>${C_NC} Compiling scripts, this may take a while..."

if [[ $release -eq 0 ]]
then
    "${COMPILER_PATH}" "Data/scripts/source" -a -q -o="Data/scripts" -i="Data/scripts/source;${SKYRIM_SOURCES}" -f="${FLAGS_PATH}"
else
    "${COMPILER_PATH}" "Data/scripts/source" -a -q -op -o="Data/scripts" -i="Data/scripts/source;${SKYRIM_SOURCES}" -f="${FLAGS_PATH}"
fi

# If we're in development mode, use loose files
# In release mode, use a BSA
echo ""
echo -e "${C_RED}==>${C_NC} Packing files into an archive..."
if [[ $release -eq 0 ]]
then
    cd "Data"
    7z a "../Anofeyn_${VERSION}.7z" "../Anofeyn.esp" "../Anofeyn.modgroups" "*"
else
    cp "${SKYRIM_PATH}/Tools/Archive/Archive.exe" "Archive.exe" # TODO This is really ugly
    ./Archive.exe "AnofeynBSAScript.txt"
    7z a "Anofeyn_${VERSION}.7z" "Anofeyn.bsa" "Anofeyn.esp" "Anofeyn.modgroups"
fi

# If we were launched in interactive mode (no parameter), wait for confirmation
if [ -z $1 ]
then
    echo ""
    echo -e "${C_RED}==>${C_NC} File built as ${C_GREEN}release/Anofeyn_${VERSION}.7z${C_NC}!"
    echo "Press any key to continue"
    read -s -n 1
fi
