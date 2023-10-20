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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyA2YM2d8vvd1Wc5IfZnKuflQTNxfYzeJJo',
    appId: '1:756048760312:web:c23f972c5d807704db1a0d',
    messagingSenderId: '756048760312',
    projectId: 'campus-store-amrita',
    authDomain: 'campus-store-amrita.firebaseapp.com',
    storageBucket: 'campus-store-amrita.appspot.com',
    measurementId: 'G-TW6MZGT7GF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAhlDOsso0R8U4cCtMW97vMvMd4xMfQ0sg',
    appId: '1:756048760312:android:1c54fcf83996d013db1a0d',
    messagingSenderId: '756048760312',
    projectId: 'campus-store-amrita',
    storageBucket: 'campus-store-amrita.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBieyokxWkXVIhTnOuhFYDqmBlmIEkCykw',
    appId: '1:756048760312:ios:a96bf6924e48b06edb1a0d',
    messagingSenderId: '756048760312',
    projectId: 'campus-store-amrita',
    storageBucket: 'campus-store-amrita.appspot.com',
    iosBundleId: 'com.example.project',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBieyokxWkXVIhTnOuhFYDqmBlmIEkCykw',
    appId: '1:756048760312:ios:9f567dd9b8edde16db1a0d',
    messagingSenderId: '756048760312',
    projectId: 'campus-store-amrita',
    storageBucket: 'campus-store-amrita.appspot.com',
    iosBundleId: 'com.example.project.RunnerTests',
  );
}