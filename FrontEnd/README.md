# Dbnus
Dbnus is a multi-platform Flutter application with web and native targets. The application contains dashboards, games, maps, media, payments, Firebase services, localization, and AI/LLM features.

## Contents

- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Application Entry Points](#application-entry-points)
- [Run the App](#run-the-app)
- [Flavors](#flavors)
- [Build Artifacts](#build-artifacts)
- [Firebase Hosting](#firebase-hosting)
- [Localization](#localization)
- [Testing](#testing)
- [Static Analysis and Formatting](#static-analysis-and-formatting)
- [Assets](#assets)
- [Platform Configuration](#platform-configuration)
- [Release Checklist](#release-checklist)
- [Troubleshooting](#troubleshooting)
- [Legacy References](#legacy-references)

## Requirements

Install the following tools before working on the project:

- Flutter with Dart SDK `^3.6.0`
- Android Studio and an Android SDK for Android development
- Java/JDK 17 for Android builds
- Xcode and CocoaPods for iOS/macOS development
- Firebase CLI for Firebase Hosting and deployment
- Chrome for web development and browser debugging
- A connected device or emulator for native development

Verify the Flutter installation:

```bash
flutter doctor
flutter --version
```

The repository does not define an application-level backend startup command. Network, Firebase, payment, and other external services must be available and configured for the feature being tested.

## Getting Started

Clone the repository, open the project root, and install Dart and Flutter dependencies:

```bash
flutter pub get
```

Check the project before making changes:

```bash
flutter analyze
flutter test
```

Firebase configuration is already represented by the platform configuration files in the repository, but each local environment still needs valid platform credentials and service access. Never commit API keys, device tokens, private keys, signing passwords, or service-account files.

## Project Structure

```text
lib/
	core/          Shared services, networking, storage, Firebase, and localization
	features/      Feature modules such as dashboard, maps, games, orders, and AI
	l10n/          ARB localization source files
	navigation/    Router and URL strategy
	shared/        Constants, extensions, utilities, and reusable UI support
	main.dart      Platform-selecting entry point
	main_app.dart  Native application entry point
	main_web.dart  Web application entry point
	main_dev.dart  Development flavor wrapper
	main_stg.dart  Staging flavor wrapper
	main_prod.dart Production flavor wrapper

assets/
	design/        Design resources
	icon/          Application and feature icons
	images/        Raster images
	js/            Web JavaScript bridges and helpers
	models/        3D and AI model assets
	sound/         Audio assets
	store/         Store and geographic data

integration_test/  End-to-end tests and shared test utilities
android/           Android application, flavors, Firebase, and signing setup
ios/               iOS application and platform configuration
macos/             macOS application and platform configuration
web/               Flutter web shell, SEO, styles, and browser assets
windows/           Windows runner
linux/             Linux runner
```

## Application Entry Points

`lib/main.dart` loads the web runner when compiled for web and the native runner when compiled for a native platform. Use an explicit entry point when running or building a particular target:

| Entry point | Purpose |
| --- | --- |
| `lib/main.dart` | Automatically selects web or native execution |
| `lib/main_app.dart` | Native Android, iOS, macOS, Windows, and Linux execution |
| `lib/main_web.dart` | Web execution, Firebase initialization, URL strategy, and web integrations |
| `lib/main_dev.dart` | Native development flavor wrapper |
| `lib/main_stg.dart` | Native staging flavor wrapper |
| `lib/main_prod.dart` | Native production flavor wrapper |

## Run the App

Run the default native application on a connected device or emulator:

```bash
flutter run -t lib/main_app.dart
```

Run the web application in Chrome:

```bash
flutter run -d chrome -t lib/main_web.dart
```

For local web development that requires cross-origin requests, use this only in a trusted local environment:

```bash
flutter run -d chrome -t lib/main_web.dart --web-browser-flag="--disable-web-security"
```

List available devices and check connected devices with:

```bash
flutter devices
adb devices
```

## Flavors

The available flavors are `dev`, `stg`, and `prod`. The wrapper files set `F.appFlavor`, which controls the application title and flavor-specific Android configuration.

### Run a Flavor

```bash
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor stg -t lib/main_stg.dart
flutter run --flavor prod -t lib/main_prod.dart
```

### Build a Flavor

```bash
flutter build apk --flavor dev -t lib/main_dev.dart
flutter build apk --flavor stg -t lib/main_stg.dart
flutter build apk --flavor prod -t lib/main_prod.dart
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

Use the same flavor when installing or testing an Android build. The development package is `com.dbnus.app.dev`; confirm the exact package for other flavors in the generated Android configuration before using ADB commands.

## Build Artifacts

### Android APK and App Bundle

```bash
flutter build apk --flavor prod -t lib/main_prod.dart
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

Android release signing reads `android/keystore.properties`. Keep that file private and provide the expected signing values locally. Release builds use Java/Kotlin 17 and require Android `minSdk 26` or newer.

### Web

Build a standard production web bundle:

```bash
flutter build web -t lib/main_prod.dart
```

Build the WASM version with tree-shaken icons:

```bash
flutter build web -t lib/main_prod.dart --wasm --tree-shake-icons
```

The output is written to `build/web`. The Firebase Hosting configuration rewrites application routes to `index.html` and sets the headers required by JavaScript, WASM, and the service worker.

### Other Platforms

Use the native production entry point for desktop and Apple builds after completing the platform-specific setup:

```bash
flutter build windows -t lib/main_prod.dart
flutter build linux -t lib/main_prod.dart
flutter build macos -t lib/main_prod.dart
flutter build ios -t lib/main_prod.dart
```

Some platform features, including camera, contacts, notifications, payments, location, and web views, require additional platform permissions or configuration.

## Firebase Hosting

Firebase Hosting serves the `build/web` directory. Deploy a freshly built web bundle from the project root:

```bash
flutter build web -t lib/main_prod.dart --wasm --tree-shake-icons
firebase deploy --only hosting
```

To deploy all configured Firebase resources instead:

```bash
firebase deploy
```

Before deploying, verify the active Firebase project and confirm that `build/web` contains the current build. Do not use a production Firebase project for experiments unless that is intentional.

## Localization

Localization source files are stored in `lib/l10n`. The configured template is `app_en.arb`, and generated Dart files are written to `lib/core/localization/app_localizations`.

After changing an ARB file, generate the localization output:

```bash
flutter gen-l10n
```

Do not edit generated localization Dart files directly. Update the ARB source and regenerate them instead.

## Testing

Run all unit and widget tests:

```bash
flutter test
```

Run the shared integration test with a selected flavor:

```bash
flutter test --flavor dev integration_test/end_to_end_test_dev.dart
flutter test --flavor stg integration_test/end_to_end_test_stg.dart
flutter test --flavor prod integration_test/end_to_end_test_prod.dart
```

The shared test flow is in `integration_test/end_to_end_test.dart`. It initializes the app, waits for the account route, and verifies the main menu route. The test requires a configured device or emulator and access to the services used during startup.

For Android permission-dependent tests, grant the required permissions on the development package when appropriate:

```bash
adb shell pm grant com.dbnus.app.dev android.permission.POST_NOTIFICATIONS
adb shell pm grant com.dbnus.app.dev android.permission.ACCESS_COARSE_LOCATION
adb shell pm grant com.dbnus.app.dev android.permission.ACCESS_FINE_LOCATION
```

## Static Analysis and Formatting

Run analysis and apply the standard Dart formatter to changed files:

```bash
flutter analyze
dart format lib test integration_test
```

Review analyzer output before submitting changes. Generated files and platform build output should not be manually reformatted unless they are part of the intended change.

## Assets

The Flutter asset manifest includes design files, images, icons, sound, JavaScript, store data, and 3D models. AI model assets are enabled only on Android, iOS, Windows, Linux, and macOS.

When adding an asset:

1. Place it in the appropriate `assets/` subdirectory.
2. Confirm that its directory is included in `pubspec.yaml`.
3. Use a package-relative asset path in Dart.
4. Run `flutter pub get` and verify the asset on the target platform.

Large model, video, and audio files can significantly increase build size. Check the target platform limits before adding them.

## Platform Configuration

The application uses Firebase Core, Messaging, Analytics, Crashlytics, and Performance. It also integrates platform-sensitive features such as camera, contacts, location, notifications, secure storage, file access, payments, audio, video, web views, and device information.

When changing a platform-sensitive feature:

- update the platform permission or entitlement configuration;
- test on the affected platform rather than relying only on web or unit tests;
- verify each flavor if the change affects application IDs or Firebase configuration;
- keep signing files and service credentials outside source control.

## Release Checklist

1. Run `flutter pub get`.
2. Run `flutter analyze` and `flutter test`.
3. Regenerate localization output if ARB files changed.
4. Test the intended flavor on its target device or browser.
5. Verify Firebase, notification, payment, and API configuration for the target environment.
6. Confirm Android signing configuration is available locally for release builds.
7. Build the release artifact.
8. For web, inspect `build/web` and deploy with `firebase deploy --only hosting`.
9. Confirm that no secrets or local configuration files were added to the commit.

## Troubleshooting

### Dependency or generated-file problems

```bash
flutter clean
flutter pub get
flutter gen-l10n
```

### Android build problems

Check `flutter doctor`, confirm Java 17 is active, and verify that the Android SDK and required licenses are installed:

```bash
flutter doctor --android-licenses
```

For release signing failures, check that `android/keystore.properties` exists locally and points to a valid keystore.

### Web routing or stale assets

Rebuild the web target and verify that Firebase Hosting is serving the new `build/web` directory. The hosting configuration deliberately disables caching for `index.html` and the Flutter service worker while caching immutable static assets.

## Legacy References

The following notes are retained from the original project documentation for reference.

### FVM on Windows

1. Download the latest Windows archive from the [FVM GitHub Releases page](https://github.com/leoafarias/fvm/releases).
2. Extract the FVM executable to a directory such as `C:\fvm`.
3. Add that directory to the system `Path` environment variable.
4. Open a new PowerShell window and verify the installation:

```powershell
fvm --version
```

### Firebase Cloud Messaging

The old project notes used the legacy FCM endpoint and Firebase Admin SDK. Use the current Firebase Admin SDK and keep all server credentials outside this repository.

Legacy payload shape:

```json
{
	"to": "<device-token>",
	"data": {
		"title": "Silent Notification",
		"message": "test",
		"body": "<p>This is<sub> subscript</sub> and <sup>superscript</sup></p>",
		"image": "https://example.com/notification-image.jpg",
		"ActionURL": "https://example.com/path"
	},
	"content_available": true,
	"priority": "high"
}
```

For the Firebase Admin SDK, Android messages should use high priority. Apple messages should set `contentAvailable` to `true`, use the background push type, and use APNS priority `5`.

### Legacy Links

- [Sales Dashboard design reference](https://www.figma.com/file/LSOW045UzL7VZtymWvrbzP/Sales-Dashboard-Design-(Community)?type=design&node-id=804-24216&mode=design)
- [Android ID package](https://pub.dev/packages/android_id)
# Dbnus

Dbnus is a Flutter application with web and native targets. The app includes dashboards, games, maps, media, payments, Firebase services, localization, and AI/LLM features.

## Requirements

- Flutter with Dart SDK `^3.6.0`
- Android Studio and an Android SDK for Android development
- Xcode and CocoaPods for iOS/macOS development
- Firebase CLI for web deployment and Firebase administration

Install dependencies from the project root:

```bash
flutter pub get
```

Firebase configuration files and platform credentials must be provided for the target environment. Do not commit API keys, device tokens, private keys, or other secrets to this repository.

## Project Structure

- `lib/main.dart` - shared entry point that selects the web or native runner
- `lib/main_web.dart` - web application entry point
- `lib/main_app.dart` - native application entry point
- `lib/main_dev.dart` - development flavor
- `lib/main_stg.dart` - staging flavor
- `lib/main_prod.dart` - production flavor
- `lib/core/` - shared services, networking, storage, localization, and platform integrations
- `lib/features/` - feature modules
- `lib/navigation/` - routing and URL strategy
- `lib/shared/` - shared constants, extensions, and utilities
- `assets/` - images, icons, sound, JavaScript, models, and store data
- `integration_test/` - end-to-end tests for the supported flavors

## Run Locally

Run the default native entry point on a connected device or emulator:

```bash
flutter run -t lib/main_app.dart
```

Run the web app in Chrome:

```bash
flutter run -d chrome -t lib/main_web.dart
```

For local web development that requires cross-origin requests, use the browser flag only on a trusted local environment:

```bash
flutter run -d chrome -t lib/main_web.dart --web-browser-flag="--disable-web-security"
```

## Flavors

The available flavors are `dev`, `stg`, and `prod`. Each flavor sets `F.appFlavor` through its corresponding entry point.

```bash
# Android
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor stg -t lib/main_stg.dart
flutter run --flavor prod -t lib/main_prod.dart

# Android builds
flutter build apk --flavor dev -t lib/main_dev.dart
flutter build apk --flavor prod -t lib/main_prod.dart
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

## Web Builds

```bash
flutter build web -t lib/main_prod.dart
flutter build web -t lib/main_prod.dart --wasm --tree-shake-icons
```

Deploy the generated web build with the Firebase CLI after selecting the correct Firebase project:

```bash
firebase deploy
```

## Tests and Analysis

Run unit and widget tests:

```bash
flutter test
```

Run the development integration test on an installed Android app:

```bash
flutter test --flavor dev integration_test/end_to_end_test_dev.dart
```

The production, staging, and shared integration test entry points are in `integration_test/`.

Run static analysis:

```bash
flutter analyze
```

## Maintenance

```bash
flutter clean
flutter pub get
```

When changing generated localization files or platform configuration, regenerate the relevant files and verify the affected flavor on its target platform before release.

## Legacy References

The following notes are retained from the original project documentation for reference.

### FVM on Windows

1. Download the latest Windows archive from the [FVM GitHub Releases page](https://github.com/leoafarias/fvm/releases).
2. Extract the FVM executable to a directory such as `C:\fvm`.
3. Add that directory to the system `Path` environment variable.
4. Open a new PowerShell window and verify the installation:

```powershell
fvm --version
```

### Firebase Cloud Messaging

The old project notes used the legacy FCM endpoint and Firebase Admin SDK. Use the current Firebase Admin SDK and keep all server credentials outside this repository.

Legacy payload shape:

```json
{
	"to": "<device-token>",
	"data": {
		"title": "Silent Notification",
		"message": "test",
		"body": "<p>This is<sub> subscript</sub> and <sup>superscript</sup></p>",
		"image": "https://example.com/notification-image.jpg",
		"ActionURL": "https://example.com/path"
	},
	"content_available": true,
	"priority": "high"
}
```

For the Firebase Admin SDK, Android messages should use high priority. Apple messages should set `contentAvailable` to `true`, use the background push type, and use APNS priority `5`.

### Device Permissions for Development

For the development Android application, permissions can be granted with ADB when required by a local test device:

```bash
adb shell pm grant com.dbnus.app.dev android.permission.POST_NOTIFICATIONS
adb shell pm grant com.dbnus.app.dev android.permission.ACCESS_COARSE_LOCATION
adb shell pm grant com.dbnus.app.dev android.permission.ACCESS_FINE_LOCATION
```

### Legacy Links

- [Sales Dashboard design reference](https://www.figma.com/file/LSOW045UzL7VZtymWvrbzP/Sales-Dashboard-Design-(Community)?type=design&node-id=804-24216&mode=design)
- [Android ID package](https://pub.dev/packages/android_id)