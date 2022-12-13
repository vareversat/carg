#!/bin/bash

if [ -s "$GITHUB_WORKSPACE"/android/app/keystore.jks ]; then
  echo "keystore.jks ✅"
else
  echo "keystore.jks is empty ❌"
  exit 1
fi

if [ -s "$GITHUB_WORKSPACE"/android/app/google-services.json ]; then
  echo "google-services.json ✅"
else
  echo "google-services.json is empty ❌"
  exit 1
fi

if [ -s "$GITHUB_WORKSPACE"/assets/config/google-play-api-key.json ]; then
  echo "google-play-api-key.json ✅"
else
  echo "google-play-api-key.json is empty ❌"
  exit 1
fi

if [ -f "$GITHUB_WORKSPACE"/ios/Runner/GoogleService-Info.plist ]; then
  echo "GoogleService-Info.plist ✅"
else
  echo "GoogleService-Info.plist is empty ❌"
  exit 1
fi

if [ -s "$GITHUB_WORKSPACE"/assets/config/algolia.json ]; then
  echo "algolia.json ✅"
else
  echo "algolia.json is empty ❌"
  exit 1
fi

if [ -s "$GITHUB_WORKSPACE"/firebase_functions/functions/src/assets/algolia-key.json ]; then
  echo "algolia-key.json ✅"
else
  echo "algolia-key.json is empty ❌"
  exit 1
fi

if [ -s "$GITHUB_WORKSPACE"/firebase_functions/functions/src/assets/backup-service-key.json ]; then
  echo "backup-service-key.json ✅"
else
  echo "backup-service-key.json is empty ❌"
  exit 1
fi

if [ -s "$GITHUB_WORKSPACE"/android/fastlane/fastlane-key.json ]; then
  echo "fastlane-key.json ✅"
else
  echo "fastlane-key.json is empty ❌"
  exit 1
fi

if [ -s "$GITHUB_WORKSPACE"/migration_scripts/key.json ]; then
  echo "key.json ✅"
else
  echo "key.json is empty ❌"
  exit 1
fi

exit 0
