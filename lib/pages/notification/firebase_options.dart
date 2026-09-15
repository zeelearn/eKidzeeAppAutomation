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
    apiKey: 'AIzaSyAO7hds0TPnnZ5vGRNTRAxRDuUs1eBbbyI',
    appId: '1:66383917412:android:cad5aa524168ec6f',
    messagingSenderId: '66383917412',
    projectId: 'kidzeeandroidapp-91faf',
    authDomain: 'react-native-firebase-testing.firebaseapp.com',
    measurementId: 'G-RF9GF9MQ1F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAO7hds0TPnnZ5vGRNTRAxRDuUs1eBbbyI',
    appId: '1:66383917412:android:cad5aa524168ec6f',
    messagingSenderId: '66383917412',
    projectId: 'kidzeeandroidapp-91faf',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHAsf51D0A407EklG1bs-5wA7EbyfNFg0',
    appId: '1:66383917412:ios:cad5aa524168ec6f',
    messagingSenderId: '66383917412',
    projectId: 'kidzeeandroidapp-91faf',
    androidClientId:
    '66383917412-b8235k1t8o9m2rsndo5tc9btlji34rh0.apps.googleusercontent.com',
    iosClientId:
    '66383917412-b8235k1t8o9m2rsndo5tc9btlji34rh0.apps.googleusercontent.com',
    iosBundleId: 'com.zeelearn.ekidzee',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAHAsf51D0A407EklG1bs-5wA7EbyfNFg0',
    appId: '1:448618578101:ios:0b11ed8263232715ac3efc',
    messagingSenderId: '448618578101',
    projectId: 'react-native-firebase-testing',
    databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
    storageBucket: 'react-native-firebase-testing.appspot.com',
    androidClientId:
    '448618578101-a9p7bj5jlakabp22fo3cbkj7nsmag24e.apps.googleusercontent.com',
    iosClientId:
    '448618578101-evbjdqq9co9v29pi8jcua8bm7kr4smuu.apps.googleusercontent.com',
    iosBundleId: 'com.zeelearn.ekidzee',
  );
}