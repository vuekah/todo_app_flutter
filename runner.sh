#!/bin/bash

flutter doctor
flutter clean
flutter pub get
flutter gen-l10n
flutter run
