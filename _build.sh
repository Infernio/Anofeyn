#!/bin/bash

# Builds a full release of Anofeyn, compiling scripts, packing resources into a
# BSA and bundling the whole thing in a 7z archive.

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

# Delete and recreate a release folder to make sure we have a fresh setup
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
cp "AnofeynBSAManifest.txt" "release"
cp "AnofeynBSAScript.txt" "release"

# Move into the release folder to make the rest of this procedure simpler
cd "release"

# Compile all scripts and pack everything into an archive
# TODO Copying Archive.exe over is really ugly
cp "${SKYRIM_PATH}/Tools/Archive/Archive.exe" "Archive.exe"
"${COMPILER_PATH}" "Data/scripts/source" -a -op -o="Data/scripts" -i="Data/scripts/source;${SKYRIM_SOURCES}" -f="${FLAGS_PATH}"
./Archive.exe "AnofeynBSAScript.txt"

# Bundle everything into a 7z archive
7z a "Anofeyn_${VERSION}.7z" "Anofeyn.bsa" "Anofeyn.esp" "Anofeyn.modgroups"

# If we were launched in interactive mode (no parameter), wait for confirmation
if [ -z $1 ]
then
    echo ""
    echo "Release built as release/Anofeyn_${VERSION}.7z"
    echo "Press any key to continue"
    read -n 1
fi
