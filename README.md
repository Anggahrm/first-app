# Flutter Todo App

Simple Todo App built with Flutter - developed entirely without a PC using GitHub Codespaces and GitHub Actions.

## Features

- Add, edit, and delete todos
- Mark todos as complete/incomplete
- Persistent local storage
- Swipe to delete
- Stats bar showing total/active/done counts
- Dark mode support (follows system theme)

## Development Setup (Without PC)

### Prerequisites
- GitHub account
- Android phone to install and test the app

### Step 1: Create Repository

1. Go to GitHub and create a new repository
2. Upload all files from this folder to your repository

### Step 2: Open Codespaces

1. Go to your repository on GitHub
2. Click "Code" → "Codespaces" → "Create codespace"
3. Wait for the environment to load (1-2 minutes)
4. You now have VS Code running in your browser!

### Step 3: Make Changes

Edit any files in the Codespaces editor. The Flutter environment is pre-configured.

### Step 4: Build APK

Every time you push changes to `main` branch, GitHub Actions will automatically build the APK.

To trigger a build:
1. Commit your changes in Codespaces
2. Push to GitHub
3. Go to "Actions" tab in your repository
4. Wait for the build to complete (~5-10 minutes)
5. Download the APK artifact
6. Install on your Android phone

## Manual Build Commands

If you have a PC with Flutter installed:

```bash
# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Build release APK
flutter build apk --release
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/
│   └── todo.dart          # Todo data model
├── providers/
│   └── todo_provider.dart # State management with Provider
└── screens/
    ├── home_screen.dart   # Main todo list
    └── add_todo_screen.dart
```

## Technologies

- **Flutter 3.19** - UI framework
- **Provider** - State management
- **SharedPreferences** - Local storage
- **GitHub Actions** - CI/CD for building APK
- **GitHub Codespaces** - Cloud development environment

## Download APK

After pushing changes, download the APK from:
- Repository → Actions → Select the latest workflow → Scroll down to "Artifacts" → Download "todo-app-release"
