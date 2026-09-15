import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:literaoctave/core/utils.dart';
import 'package:literaoctave/domain/entities/structured_class_entity.dart';

class UnityLauncher {
  static const MethodChannel channel = MethodChannel('unity_launcher_channel');

  static Future<void> openUnity(String contentCode, Module? module) async {
    UnityLauncher.channel.setMethodCallHandler((call) async {
      debugPrint("📱 Received method call from native: ${call.method}");
      if (call.method == "unityUnloaded") {
        debugPrint("📱 Received unityUnloaded from iOS");

        await UnityLauncher.unityUnloaded(); // your orientation change method
      }
    });
    try {
      if (Platform.isAndroid) {
        debugPrint("platform : android $contentCode");
        // Android-specific code
        await channel
            .invokeMethod('openUnityActivity', {"contentCode": contentCode});
      } else if (Platform.isIOS) {
        debugPrint("platform : iOS");
        // await SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.landscapeRight,
        // ]);
        await channel.invokeMethod(
            'openUnityViewController', {"contentCode": contentCode});
        debugPrint('📱 Invoked openUnityViewController on iOS');
      }
      Utils().updateProgress(module!.mid, module.ct!);
    } catch (e) {
      debugPrint("Failed to open Unity: $e");
    }
  }

  // Method to be called from native code to set portrait mode
  static Future<void> setPortraitMode() async {
    try {
      await channel.invokeMethod('setPortraitMode');
    } catch (e) {
      debugPrint("Failed to set portrait mode: $e");
    }
  }

  static Future<bool> checkDebuging() async {
    try {
      if (Platform.isAndroid) {
        debugPrint("platform : android");
        // Android-specific code
        return await channel.invokeMethod('checkDebug');
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Failed to open Unity: $e");
      return false;
    }
  }

  static Future<void> unityUnloaded() async {
    try {
      // Set Flutter app orientation to portrait up
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      debugPrint("Orientation set to portrait mode");
    } catch (e) {
      debugPrint("Failed to reset orientation: $e");
    }
  }

  static Future<int> getAvailableSpace() async {
    try {
      return await channel.invokeMethod('getAvailableStorage');
    } catch (e) {
      debugPrint("Failed to load available: $e");
      return 0;
    }
  }
}

// import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';

// class UnityLauncher {
//   static const MethodChannel channel = MethodChannel('unity_launcher_channel');

//   static Future<void> openUnity(String contentCode) async {
//     try {
//       if (Platform.isAndroid) {
//         debugPrint("platform : android ${contentCode}");
//         // Android-specific code
//         await channel.invokeMethod('openUnityActivity', {"contentCode": contentCode});
//       } else if (Platform.isIOS) {
//         debugPrint("platform : iOS");
//         await channel.invokeMethod(
//             'openUnityViewController', {"contentCode": contentCode});
//       }
//     } catch (e) {

//       debugPrint("Failed to open Unity: $e");
//     }
//   }

//   static Future<int> getAvailableSpace() async {
//     try {
//       return await channel.invokeMethod('getAvailableStorage');
//     } catch (e) {
//       debugPrint("Failed to load available: $e");
//       return 0;
//     }
//   }

//   static Future<bool> checkDebuging() async {
//     try {
//       if (Platform.isAndroid) {
//         debugPrint("platform : android");
//         // Android-specific code
//         return await channel.invokeMethod('checkDebug');
//       } else {
//         return false;
//       }
//     } catch (e) {
//       debugPrint("Failed to open Unity: $e");
//       return false;
//     }
//   }

//   static Future<void> unityUnloaded() async {
//     try {
//       // Set Flutter app orientation to portrait up
//       await SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//       ]);
//       debugPrint("Orientation set to portrait mode");
//     } catch (e) {
//       debugPrint("Failed to reset orientation: $e");
//     }
//   }

//   static Future<bool> checkIfTV() async {
//     try {
//       if (Platform.isAndroid) {
//         // Android-specific code
//         return await channel.invokeMethod('isAndroidTV');
//       } else {
//         return false;
//       }
//     } catch (e) {
//       debugPrint("Failed to open Unity: $e");
//       return false;
//     }
//   }

//   // Method to be called from native code to set portrait mode
//   static Future<void> setPortraitMode() async {
//     try {
//       await channel.invokeMethod('setPortraitMode');
//     } catch (e) {
//       debugPrint("Failed to set portrait mode: $e");
//     }
//   }
// }
