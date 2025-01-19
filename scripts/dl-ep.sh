#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash yt-dlp dos2unix

set -x

# download yt subtitle track
yt-dlp --skip-download --write-auto-subs --convert-subs srt "$1"

# rename it
mv *srt "$2"

# convert it to unix line endings
dos2unix "$2"

# remove duplicate lines
awk -i inplace '/^\s*?$/||!seen[$0]++' "$2"

# remove timestamps
sed -i -r '/^[0-9]+$/{N;d}' "$2"

# remove blank lines
sed -i '/^\s*$/d' "$2"
