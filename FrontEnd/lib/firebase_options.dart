// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDdGpKs-t8Ee4tr4GsaEavhureueb2O4zM',
    appId: '1:783534429855:web:cc78ab29a1b67306e6f4aa',
    messagingSenderId: '783534429855',
    projectId: 'dbnus-df986',
    authDomain: 'dbnus-df986.firebaseapp.com',
    databaseURL: 'https://dbnus-df986-default-rtdb.firebaseio.com',
    storageBucket: 'dbnus-df986.firebasestorage.app',
    measurementId: 'G-8YSKF8B4G1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDrLI6sP4HuEqJgGlul9NzE7XyfVl7Es9w',
    appId: '1:783534429855:android:3cef16b71551f7a6e6f4aa',
    messagingSenderId: '783534429855',
    projectId: 'dbnus-df986',
    storageBucket: 'dbnus-df986.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAxw1WbItbE1GEOJWiI8yCTLQ3sFQ93llA',
    appId: '1:783534429855:ios:7003b2b4c3048f9de6f4aa',
    messagingSenderId: '783534429855',
    projectId: 'dbnus-df986',
    databaseURL: 'https://dbnus-df986-default-rtdb.firebaseio.com',
    storageBucket: 'dbnus-df986.firebasestorage.app',
    iosBundleId: 'com.dbnus.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAxw1WbItbE1GEOJWiI8yCTLQ3sFQ93llA',
    appId: '1:783534429855:ios:7003b2b4c3048f9de6f4aa',
    messagingSenderId: '783534429855',
    projectId: 'dbnus-df986',
    databaseURL: 'https://dbnus-df986-default-rtdb.firebaseio.com',
    storageBucket: 'dbnus-df986.firebasestorage.app',
    iosBundleId: 'com.dbnus.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDWoA9iCdpB8hkSZW20KGXX4rzcLv21cLQ',
    appId: '1:783534429855:web:a259db0dd9a7b318e6f4aa',
    messagingSenderId: '783534429855',
    projectId: 'dbnus-df986',
    authDomain: 'dbnus-df986.firebaseapp.com',
    databaseURL: 'https://dbnus-df986-default-rtdb.firebaseio.com',
    storageBucket: 'dbnus-df986.firebasestorage.app',
    measurementId: 'G-K53JP17WSN',
  );

}