# Exam Prep Quiz App

A production-ready Flutter Quiz App designed for Sri Lankan A/L and Government Job Exam preparation.

## Features

- **Offline Mode:** Questions are stored locally in Dart models.
- **Categorized Quizzes:** Support for A/L GK, Government Jobs, and IQ categories.
- **Interactive UI:** Smooth transitions, progress bars, and feedback animations.
- **Timer System:** 30-second countdown for each question.
- **AdMob Ready:** Placeholders for Banner and Interstitial ads.
- **Localized Content:** Supports Sinhala Unicode and English text.

## Tech Stack

- **Framework:** Flutter
- **State Management:** StatefulWidgets
- **Design:** Modern Blue/White Educational Theme
- **CI/CD:** GitHub Actions integration for automatic APK builds.

## Setup Instructions

1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Run `flutter run` to launch the app on your emulator/device.

## GitHub Actions Build (No Local Flutter Needed)

Since you don't have Flutter installed locally, you can use GitHub to build your APK:

1. **Push this code** to a new GitHub repository.
2. The **Code Validation** workflow will run automatically to check for errors.
3. The **Flutter Build APK** workflow will generate a release APK.
4. Go to the **Actions** tab on your GitHub repo.
5. Click on the latest "Flutter Build APK" run.
6. Scroll down to **Artifacts** to download your `release-apk`.

## Folder Structure

- `.github/workflows/`: Automation scripts (`github_actions_build.yml` for APK, `validate_code.yml` for checks).
- `lib/data/`: Contains quiz question data.
- `lib/models/`: Data models for the app.
- `lib/screens/`: UI screens (Home, Quiz, Result).
- `.gitignore`: Ensures environment files aren't uploaded to GitHub.
