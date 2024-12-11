# todo_app_flutter

A new Flutter project using provider package to management state 
This project using flutter version 3.24.4

## Screens
<img src="./screenshots/auth.gif" alt="auth screen" width="50%"/>

<img src="./screenshots/home.gif"  alt="home screen" width="50%"/>

## How to dev
type this command in terminal
```sh
  - chmod +x build_apk.sh
  - ./runner.sh
```
or 
```sh
  flutter pub get
  flutter gen-l10n
  flutter run
```
using this command when you want to add some assets (image, font,, etc.)
```sh
  flutter pub run build_runner build --delete-conflicting-outputs
```


### Project Structure
```
$PROJECT_ROOT
├── lib                  # Main application code
│   ├── common/widgets   # Reusable UI components (widgets)
│   ├── gen              # Folder for generated code (e.g., from build_runner)
│   ├── l10n             # Localization files
│   ├── models           # Data models (e.g., User, Task, etc.)
│   ├── pages            # Screens and page layouts
│   ├── service          # API service and network calls
│   ├── theme            # Theme of app
│   └── utils            # Utility functions and helpers
├── assets               # Static resources (images, fonts, etc.)
└── pubspec.yaml         # Flutter project configuration file
```
