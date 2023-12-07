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
    apiKey: 'AIzaSyDtbdqB9vlsNbi2aHvY9zNA5Xkza3u0G8c',
    appId: '1:206733763218:web:48251078820a35c4ce7c4b',
    messagingSenderId: '206733763218',
    projectId: 'mobile-ii-c311e',
    authDomain: 'mobile-ii-c311e.firebaseapp.com',
    storageBucket: 'mobile-ii-c311e.appspot.com',
    measurementId: 'G-7M5JPW07S7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBr_xTQzHLbJIlAMymiukPa7IWwiknVQ7E',
    appId: '1:206733763218:android:a93312a8972340bace7c4b',
    messagingSenderId: '206733763218',
    projectId: 'mobile-ii-c311e',
    storageBucket: 'mobile-ii-c311e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGIRWM0z5RbpCwyTWFFg6rTKRYZ__luyY',
    appId: '1:206733763218:ios:4e7a0dc3f888b110ce7c4b',
    messagingSenderId: '206733763218',
    projectId: 'mobile-ii-c311e',
    storageBucket: 'mobile-ii-c311e.appspot.com',
    iosBundleId: 'com.example.teste',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBGIRWM0z5RbpCwyTWFFg6rTKRYZ__luyY',
    appId: '1:206733763218:ios:2377d7ca0889ae9fce7c4b',
    messagingSenderId: '206733763218',
    projectId: 'mobile-ii-c311e',
    storageBucket: 'mobile-ii-c311e.appspot.com',
    iosBundleId: 'com.example.teste.RunnerTests',
  );
}