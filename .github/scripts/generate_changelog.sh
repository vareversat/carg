#!/bin/bash

BUILD_NUMBER=$(git rev-list --all --count)
CHANGELOG_PATH="$GITHUB_WORKSPACE"/android/fastlane/metada/android/fr-FR/changelogs/"$BUILD_NUMBER".txt
CHANGELOG=$(sed '/\*\*\*/q' "$GITHUB_WORKSPACE"/CHANGELOG.md | sed 's/\*//g' | sed 's/#//g' | sed '$d')
echo "$CHANGELOG" > "$CHANGELOG_PATH"
echo "New changelog (path : $CHANGELOG_PATH)"
echo "$CHANGELOG"