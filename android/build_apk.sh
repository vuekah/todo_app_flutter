#!/bin/bash
sh "flutter clean"
sh flutter pub get
sh flutter gen-l10n

if flutter build apk --release; then
 echo "APK đã được build thành công!"
else
  echo "Build APK thất bại."
  exit 1
fi