#!/bin/bash

BUILD_NUMBER=$(git rev-list --all --count)
CHANGELOG_PATH="$GITHUB_WORKSPACE"/android/fastlane/metadata/android/fr-FR/changelogs/"$BUILD_NUMBER".txt
CHANGELOG=$(sed '/\*\*\*/q' "$GITHUB_WORKSPACE"/CHANGELOG.md | sed 's/\*//g' | sed 's/#//g' | sed '$d')

# Add path to the Github envs
echo "CHANGELOG_PATH=$CHANGELOG_PATH" >> $GITHUB_ENV
# Write changelog into the file
echo "$CHANGELOG" > "$CHANGELOG_PATH"

if [ -s "$CHANGELOG_PATH" ]; then
  echo "Changelog generated ✅"
  echo "New changelog (path : $CHANGELOG_PATH)"
  cat "$CHANGELOG_PATH"
  exit 0
else
  echo "Changelog is missing ❌"
  exit 1
fi
