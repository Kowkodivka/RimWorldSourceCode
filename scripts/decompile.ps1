<#
.NOTES
NOTICE: The decompiled RimWorld source code in this project is intended 
SOLELY for:
1) Educational purposes to learn how the game works
2) Development of mods for RimWorld

As written in the EULA:
"You're allowed to 'decompile' our game assets and look through our code, 
art, sound, and other resources for learning purposes, or to use our 
resources as basis or reference for a Mod. However, you're not allowed to 
rip these resources out and pass them around independently. This educational 
use must be done in compliance with the 'fair dealing' (for Canadians), 
'fair use' (for Americans), or other similar copyright principles that may 
be applicable to you in your jurisdiction."

By using this script, you agree to use the decompiled code responsibly and 
in accordance with these principles.
#>

$env:PATH = "$env:USERPROFILE\.dotnet\tools;$env:PATH"

$MANAGED_DIR = Get-ChildItem -Path $env:USERPROFILE -Recurse -Directory -Filter "*_Data\Managed" -ErrorAction SilentlyContinue | 
               Where-Object { $_.FullName -like "*RimWorld*" } | 
               Select-Object -First 1 -ExpandProperty FullName

if (-not $MANAGED_DIR) {
    Write-Host "* RimWorld managed directory not found" -ForegroundColor Red
    exit 1
}

Write-Host "* Found RimWorld managed directory: $MANAGED_DIR" -ForegroundColor Green

$OUTPUT_DIR = "source"
New-Item -ItemType Directory -Path $OUTPUT_DIR -Force | Out-Null

Get-ChildItem -Path $MANAGED_DIR -Filter "*.dll" | ForEach-Object {
    $base_name = $_.BaseName
    $nested_path = $base_name -replace '\.', '\'
    $output_path = Join-Path -Path $OUTPUT_DIR -ChildPath $nested_path
    
    Write-Host "* $($_.FullName) -> $output_path" -ForegroundColor Cyan
    
    $parentDir = Split-Path -Path $output_path -Parent
    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    
    ilspycmd --nested-directories -p -o $output_path $_.FullName
}