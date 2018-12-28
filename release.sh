#!/bin/bash

# Builds a full release of Anofeyn, compiling scripts, packing resources into a
# BSA and bundling the whole thing in a 7z archive.

# Variable definitions
# The path to the Skyrim / Skyrim SE installation to use
SKYRIM_PATH="G:/steam/steamapps/common/Skyrim Special Edition"
# The version to release the mod with
VERSION="0.1.0"

# Delete and recreate a release folder to make sure we have a fresh setup
rm -rf release
mkdir release

# Copy MLib over
cp -r "../MLib/scripts" "release"

# Copy everything into the release folder
cp "Anofeyn.esp" "release"
cp "Anofeyn.modgroups" "release"
cp -r "interface" "release"
cp -r "meshes" "release"
cp -r "scripts" "release"
cp -r "textures" "release"

# Move into the release folder to make the rest of this procedure simpler
cd "release"

# Compile all scripts and pack everything into an archive
# TODO Copying Archive.exe over is really ugly
"${SKYRIM_PATH}/Papyrus Compiler/PapyrusCompiler.exe" "scripts/source" -a -op -o="scripts" -i="scripts/source;${SKYRIM_PATH}/Data/Scripts/Source" -f="${SKYRIM_PATH}/Papyrus Compiler/TESV_Papyrus_Flags.flg"
cp "${SKYRIM_PATH}/Tools/Archive/Archive.exe" "Archive.exe"
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
