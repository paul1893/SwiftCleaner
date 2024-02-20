#!/bin/bash

set -e

GREEN='\033[1;32m'
NC='\033[0m' # No Color

green () {
  printf "${GREEN}${1}${NC}\n"
}

codesign () {
  /usr/bin/codesign --force --options=runtime --timestamp --sign "$SWIFT_CLEANER_CODE_SIGN" "$1"
}

notarize () {
  xcrun notarytool submit --keychain-profile "SwiftCleanerNotarize" --wait "$1"
}

cd SwiftCleaner
bin_path=$(make show_bin_path)
bundle_path=$(make show_bundle_path)
rm -rf "$bin_path"
make build_release
rm -rf .release
mkdir .release
cp "$bin_path" .release/
cp -R "$bundle_path" .release/
cp ../LICENSE.md .release/

## Codesign
green "Codesign"
cd .release
codesign SwiftCleaner

# Archive
green "Archive"
zip_filename="SwiftCleaner.zip"
zip -r "${zip_filename}" SwiftCleaner SwiftCleaner_SwiftCleaner.bundle ../LICENSE.md
green "Archive > Codesign"
codesign "${zip_filename}"

echo -e "\n${zip_filename} checksum:"
sha256=$( shasum -a 256 ${zip_filename} | awk '{print $1}' )
echo ${sha256}
open ./

# Notarize
# In case of issue
# xcrun notarytool log $submissionId --keychain-profile "SwiftCleanerNotarize"
green "Notarize"
notarize "${zip_filename}"