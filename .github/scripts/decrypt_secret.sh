#!/bin/bash

# Decrypt google-services.json.gpg
gpg --batch --yes --decrypt --pinentry-mode loopback --passphrase="$PASSPHRASE" --output "$GITHUB_WORKSPACE"/android/app/google-services.json "$GITHUB_WORKSPACE"/encrypted_config/google-services.json.gpg
# Decrypt google-play-api-key.json.gpg
gpg --batch --yes --decrypt --pinentry-mode loopback --passphrase="$PASSPHRASE" --output "$GITHUB_WORKSPACE"/assets/config/google-play-api-key.json "$GITHUB_WORKSPACE"/encrypted_config/google-play-api-key.json.gpg
# Decrypt GoogleService-Info.plist.gpg
gpg --batch --yes --decrypt --pinentry-mode loopback --passphrase="$PASSPHRASE" --output "$GITHUB_WORKSPACE"/ios/Runner/GoogleService-Info.plist "$GITHUB_WORKSPACE"/encrypted_config/GoogleService-Info.plist.gpg
# Decrypt key.json.gpg
gpg --batch --yes --decrypt --pinentry-mode loopback --passphrase="$PASSPHRASE" --output "$GITHUB_WORKSPACE"/migration_scripts/key.json "$GITHUB_WORKSPACE"/encrypted_config/key.json.gpg
# Decrypt algolia.json.gpg
gpg --batch --yes --decrypt --pinentry-mode loopback --passphrase="$PASSPHRASE" --output "$GITHUB_WORKSPACE"/assets/config/algolia.json "$GITHUB_WORKSPACE"/encrypted_config/algolia.json.gpg
cp "$GITHUB_WORKSPACE"/assets/config/algolia.json "$GITHUB_WORKSPACE"/firebase_functions/functions/src/assets/algolia-key.json
# Decrypt keystore.jks.gpg
gpg --batch --yes --decrypt --pinentry-mode loopback --passphrase="$PASSPHRASE" --output "$GITHUB_WORKSPACE"/android/app/keystore.jks "$GITHUB_WORKSPACE"/encrypted_config/keystore.jks.gpg
# Decrypt backup-service-key.json.gpg
gpg --batch --yes --decrypt --pinentry-mode loopback --passphrase="$PASSPHRASE" --output "$GITHUB_WORKSPACE"/firebase_functions/functions/src/assets/backup-service-key.json "$GITHUB_WORKSPACE"/encrypted_config/backup-service-key.json.gpg
# Decrypt fastlane-key.json.gpg
gpg --batch --yes --decrypt --pinentry-mode loopback --passphrase="$PASSPHRASE" --output "$GITHUB_WORKSPACE"/android/fastlane/fastlane-key.json "$GITHUB_WORKSPACE"/encrypted_config/fastlane-key.json.gpg
# Decrypt key_password.txt.gpg
tmp_key_password=$(gpg --quiet --batch --yes --decrypt --passphrase="$PASSPHRASE" "$GITHUB_WORKSPACE"/encrypted_config/key_password.txt.gpg)

# Inject
echo "storePassword=$tmp_key_password" >"$GITHUB_WORKSPACE"/android/key.properties
echo "keyPassword=$tmp_key_password" >>"$GITHUB_WORKSPACE"/android/key.properties
echo "keyAlias=key" >>"$GITHUB_WORKSPACE"/android/key.properties
echo "storeFile=./keystore.jks" >>"$GITHUB_WORKSPACE"/android/key.properties
