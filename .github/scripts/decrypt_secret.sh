
# Decrypt google-services.json.gpg
gpg --quiet --batch --yes --decrypt --passphrase="$PASSPHRASE" --output "$GITHUB_WORKSPACE"/android/app/google-services.json "$GITHUB_WORKSPACE"/encrypted_config/google-services.json.gpg
# Decrypt GoogleService-Info.plist.gpg
gpg --quiet --batch --yes --decrypt --passphrase="$PASSPHRASE" --output "$GITHUB_WORKSPACE"/ios/Runner/GoogleService-Info.plist "$GITHUB_WORKSPACE"/encrypted_config/GoogleService-Info.plist.gpg
# Decrypt key.json.gpg
gpg --quiet --batch --yes --decrypt --passphrase="$PASSPHRASE" --output "$GITHUB_WORKSPACE"/migration_scripts/key.json "$GITHUB_WORKSPACE"/encrypted_config/key.json.gpg
# Decrypt algolia.json.gpg
tmp_algolia_config=$(gpg --quiet --batch --yes --decrypt --passphrase="$PASSPHRASE" "$GITHUB_WORKSPACE"/encrypted_config/algolia.json.gpg)
# Decrypt keystore.jks.gpg
tmp_keystore=$(gpg --quiet --batch --yes --decrypt --passphrase="$PASSPHRASE" "$GITHUB_WORKSPACE"/encrypted_config/keystore.jks.gpg)
# Decrypt store_password.txt.gpg
tmp_store_password=$(gpg --quiet --batch --yes --decrypt --passphrase="$PASSPHRASE" "$GITHUB_WORKSPACE"/encrypted_config/store_password.txt.gpg)
# Decrypt key_password.txt.gpg
tmp_key_password=$(gpg --quiet --batch --yes --decrypt --passphrase="$PASSPHRASE" "$GITHUB_WORKSPACE"/encrypted_config/key_password.txt.gpg)

# Inject
echo "$tmp_algolia_config" > $GITHUB_WORKSPACE/assets/config/algolia.json
echo "$tmp_keystore" | base64 --decode > "$GITHUB_WORKSPACE"/android/app/keystore.jks
echo "storePassword=$tmp_store_password" > "$GITHUB_WORKSPACE"/android/key.properties
echo "keyPassword=$tmp_key_password" >> "$GITHUB_WORKSPACE"/android/key.properties
echo "keyAlias=key" >> "$GITHUB_WORKSPACE"/android/key.properties
echo "storeFile=./keystore.jks" >> "$GITHUB_WORKSPACE"/android/key.properties


