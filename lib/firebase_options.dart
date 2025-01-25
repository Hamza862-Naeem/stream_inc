// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyAWmosCEcLRr4Akz9QgozvVJj1O84EYm40',
    appId: '1:719619879988:web:2b674457347f5ea6b00661',
    messagingSenderId: '719619879988',
    projectId: 'tik-tok-stream-inc',
    authDomain: 'tik-tok-stream-inc.firebaseapp.com',
    storageBucket: 'tik-tok-stream-inc.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCihjlIl5a2qDWr0owoQ66d6YDENvnSGc0',
    appId: '1:719619879988:android:a257e70e0db8f35cb00661',
    messagingSenderId: '719619879988',
    projectId: 'tik-tok-stream-inc',
    storageBucket: 'tik-tok-stream-inc.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCoCvVhC7KcxpCHZck5RqmKaKp_PfB3tK0',
    appId: '1:719619879988:ios:bb9daf08917fec3bb00661',
    messagingSenderId: '719619879988',
    projectId: 'tik-tok-stream-inc',
    storageBucket: 'tik-tok-stream-inc.firebasestorage.app',
    iosBundleId: 'com.example.streamInc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCoCvVhC7KcxpCHZck5RqmKaKp_PfB3tK0',
    appId: '1:719619879988:ios:bb9daf08917fec3bb00661',
    messagingSenderId: '719619879988',
    projectId: 'tik-tok-stream-inc',
    storageBucket: 'tik-tok-stream-inc.firebasestorage.app',
    iosBundleId: 'com.example.streamInc',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAWmosCEcLRr4Akz9QgozvVJj1O84EYm40',
    appId: '1:719619879988:web:5bba7e9b10f424fdb00661',
    messagingSenderId: '719619879988',
    projectId: 'tik-tok-stream-inc',
    authDomain: 'tik-tok-stream-inc.firebaseapp.com',
    storageBucket: 'tik-tok-stream-inc.firebasestorage.app',
  );
}
