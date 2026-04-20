// File generated manually from Firebase Console config
// Project: tronongapp

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAu_g0AM715GM7tTwiZQqU3YKrw8uKuDmc',
    authDomain: 'tronongapp.firebaseapp.com',
    projectId: 'tronongapp',
    storageBucket: 'tronongapp.firebasestorage.app',
    messagingSenderId: '111413812987',
    appId: '1:111413812987:web:00e30f28cb3e6343e19a5e',
    measurementId: 'G-D8HWZKE6DV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAu_g0AM715GM7tTwiZQqU3YKrw8uKuDmc',
    appId: '1:111413812987:web:00e30f28cb3e6343e19a5e',
    messagingSenderId: '111413812987',
    projectId: 'tronongapp',
    storageBucket: 'tronongapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAu_g0AM715GM7tTwiZQqU3YKrw8uKuDmc',
    appId: '1:111413812987:web:00e30f28cb3e6343e19a5e',
    messagingSenderId: '111413812987',
    projectId: 'tronongapp',
    storageBucket: 'tronongapp.firebasestorage.app',
    iosBundleId: 'com.example.troNong',
  );
}
