# ekidzee

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

flutter build apk --release --flavor kidzee -t .\lib\main.dart
flutter build appbundle --release --flavor kidzee -t .\lib\main.dart

flutter build appbundle --release --flavor mlzs -t .\lib\main.dart
flutter build apk --release --flavor mlzs -t .\lib\main.dart

flutter build web --web-renderer html
flutter build web --web-renderer html --no-tree-shake-icons

IOS
flutter clean
flutter build ios

pod install
pod update
pod repo update
pod install --repo-update


cd ios to get into the iOS directory of your flutter project.
Now deintegrate the pod via pod deintegrate
rm Flutter/Flutter.podspec
rm podfile.lock
flutter clean
flutter run



 ----FLUTTER Upgrade 
flutter pub cache clean

flutter channel stable

flutter pub upgrade win32

flutter pub get


git filter-branch --force --index-filter "git rm --cached --ignore-unmatch android/java_pid76631.hprof" --prune-empty --tag-name-filter cat -- --all

set PATH=%PATH:D:\flutter_new\flutter\bin\;=% for windows

flutter config --jdk-dir "C:\Program Files\Java\jdk-11" (after this command restart editor)


sudo xattr -rd com.apple.quarantine  /Users/sudhir.patil/Development/flutter/AppCode/ekIdzeeEarly/android/unityLibrary/src/main/jniLibs/arm64-v8a/libil2cpp.sym.so


sudo xattr -rd com.apple.quarantine /Users/sudhir.patil/Development/flutter/AppCode/eKidzeeApp/android/unityLibrary/src/main/Il2CppOutputProject/IL2CPP/build/


flutter run -d web-server --web-hostname=10.112.1.34 --web-port=8000


curl -L "https://cdn.jsdelivr.net/npm/pdfjs-dist@2.12.313/build/pdf.js" \
  -o /tmp/pdf.js

  openssl dgst -sha384 -binary /tmp/pdf.js | openssl base64 -A
