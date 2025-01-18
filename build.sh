#!/bin/bash

set -eu
shopt -s globstar

####################

depends=( resvg wget )
notfound=()

for app in "${depends[@]}"; do
	if ! type "$app" > /dev/null 2>&1; then
		notfound+=("$app")
	fi
done

if [[ ${#notfound[@]} -ne 0 ]]; then
	echo Failed to lookup dependency:


	for app in "${notfound[@]}"; do
		echo "- $app"
	done

	exit 1
fi

####################

DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$DIR"

rm -rf ".fonts"

mkdir .fonts

# depName=git@github.com:googlefonts/opensans.git
OPENSANS_COMMIT="bd7e37632246368c60fdcbd374dbf9bad11969b6"
OPENSANS_FILE="fonts/noto-set/ttf/OpenSans-Regular.ttf"

wget \
	"https://github.com/googlefonts/opensans/raw/$OPENSANS_COMMIT/$OPENSANS_FILE" \
	-O ".fonts/OpenSans-Regular.ttf"

for f in **/*.svg; do
	resvg \
		--use-fonts-dir .fonts/ \
		--sans-serif-family "Open Sans" \
		"$f" \
		"$(basename "$f" .svg).png"
done
