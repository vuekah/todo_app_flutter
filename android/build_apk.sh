#!/bin/bash

flutter build apk --release
if [ $? -eq 0 ]; then
 echo "APK đã được build thành công!"
else
  echo "Build APK thất bại."
  exit 1
fi