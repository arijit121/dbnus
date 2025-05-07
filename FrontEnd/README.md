# dbnus

Dbnus App
`<img src="https://docs.flutter.dev/assets/images/flutter-logo-sharing.png"/>`

```
flutter build web -t lib/main_web.dart --web-renderer html --no-tree-shake-icons
flutter build apk -t lib/main_app.dart --no-tree-shake-icons
flutter build apk --flavor prod -t lib/main_prod.dart
flutter build appbundle --flavor prod -t lib/main_prod.dart
flutter run web -t lib/main_web.dart --web-renderer html -d chrome
flutter run web -t lib/main_web.dart --web-renderer html -d chrome --web-browser-flag="
--disable-web-security"
```
Manual Installation on Windows
Download the FVM Executable

Visit the [FVM GitHub Releases page](https://github.com/leoafarias/fvm/releases).
Download the latest .zip file for Windows under Assets.
Extract the FVM Executable

Extract the downloaded .zip file to a directory of your choice (e.g., C:\fvm).
Add FVM to the PATH

Open the Start Menu and search for "Environment Variables."
Click Edit the system environment variables.
In the System Properties window, click Environment Variables.
Under System variables, locate the Path variable and click Edit.
Click New and add the path where you extracted the FVM executable (e.g., C:\fvm).
Click OK to close all windows.
Verify Installation

Open a new Command Prompt or PowerShell.
Run:
```fvm --version```

https://www.figma.com/file/LSOW045UzL7VZtymWvrbzP/Sales-Dashboard-Design-(Community)?type=design&node-id=804-24216&mode=design&t=Nz3iax801ZaHTguw-0

https://pub.dev/packages/android_id

firebase deploy

Post Man Old

```
https://fcm.googleapis.com/fcm/send
Firebase Massage Key:- AAAAtm5Klp8:APA91bEC-03UJDXjuwmxmoQrrg5cQShLx3hruk35WU3984QnH9PQXBReUfbf9mlkgUy_KZGzo9AhZkdFtCh4txRY9N-7GZ7HgPEM_fF6ebLZXg0np70HA8XcQDObKmmks2lidbjwGvKw

{
"to": "di2wZMboSue4ktyaoDdGCS:APA91bGuLGlZfpqkyk9SDDUwYScebl2MnxZBLDDoZ3NRdrGCfFbI_ZyfP9VQCE1182KbXLMNJOwP5KohK7w48Ao9_r1lDzzWR2yRsc5iIDOotbTml6evRuLOkVbo38xODdfS2NAdV7h-",
"data": {
"title": "Silent Notification",
"message":"test",
"body": "<p>This is<sub> subscript</sub> and <sup>superscript</sup></p>",
"image": "https://res.genupathlabs.com/genu_path_lab/GenuPushImage/900X450_1695990869.jpg",
"ActionURL": "http://gplab.in/m04oLk"
},
"apns": {
"headers": {
"apns-priority": "5"
}
},
"content_available": true,
"priority": "high"
}
```

V1 admin sdk

```
Notification Sample Payload:

admin.messaging().send({
token: "device token",
data: {
"title": "Silent Notification",
"message":"test",
"body": "<p>This is<sub> subscript</sub> and <sup>superscript</sup></p>",
"image": "https://res.genupathlabs.com/genu_path_lab/GenuPushImage/900X450_1695990869.jpg",
"ActionURL": "http://gplab.in/m04oLk"
},
// Set Android priority to "high"
android: {
priority: "high",
},
// Add APNS (Apple) config
apns: {
payload: {
aps: {
contentAvailable: true,
},
},
headers: {
"apns-push-type": "background",
"apns-priority": "5", // Must be 5 when contentAvailable is set to true.
"apns-topic": "com.******.presence", // bundle identifier "apns-topic": "io.flutter.plugins.firebase.messaging",
},
},
});
```

On Android, set the priority field to high.
On Apple (iOS & macOS), set the content-available field to true.
