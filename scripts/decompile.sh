#!/bin/bash

# ----------------------------------------------------------------------------
# NOTICE: The decompiled RimWorld source code in this project is intended 
# SOLELY for:
# 1) Educational purposes to learn how the game works
# 2) Development of mods for RimWorld
#
# As written in the EULA:
# "You're allowed to 'decompile' our game assets and look through our code, 
# art, sound, and other resources for learning purposes, or to use our 
# resources as basis or reference for a Mod. However, you're not allowed to 
# rip these resources out and pass them around independently. This educational 
# use must be done in compliance with the 'fair dealing' (for Canadians), 
# 'fair use' (for Americans), or other similar copyright principles that may 
# be applicable to you in your jurisdiction."
#
# By using this script, you agree to use the decompiled code responsibly and 
# in accordance with these principles.
# ----------------------------------------------------------------------------

PATH="$HOME/.dotnet/tools:$PATH"

MANAGED_DIR=$(find ~ -type d -path "*/RimWorld*_Data/Managed" -print -quit)
OUTPUT_DIR="source"

if [[ -z "$MANAGED_DIR" ]]; then
    echo "* RimWorld managed directory not found"
    exit 1
fi

echo "* Found RimWorld managed directory: $MANAGED_DIR"

mkdir -p "$OUTPUT_DIR"

find "$MANAGED_DIR" -type f -name "*.dll" | while read -r file; do
    base_name=$(basename "$file" .dll)
    nested_path="${base_name//./\/}"
    output_path="$OUTPUT_DIR/$nested_path"
    
    echo "* $file -> $output_path"
    mkdir -p "$(dirname "$output_path")"
    ilspycmd --nested-directories -p -o "$output_path" "$file"
done