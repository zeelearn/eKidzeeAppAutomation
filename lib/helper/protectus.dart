import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';

class ProtectMyScreen {
  void proectScreen(BuildContext context) {
    if (!kIsWeb) {
      _protectDataLeakageOn(context);
      // For iOS only.
      _addListenerPreventScreenshot(context);

      // For iOS and Android
      _preventScreenshotOn();
      _checkScreenRecording(context);
    }
  }

  Future<void> removeProtection() async {
    if (!kIsWeb) {
      _removeListenerPreventScreenshot();
      // For iOS and Android
      _preventScreenshotOff();
      await ScreenProtector.protectDataLeakageOff();
    }
  }

  void _checkScreenRecording(BuildContext context) async {
    final isRecording = await ScreenProtector.isRecording();

    if (isRecording) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Screen Recording...')));
    }
    return null;
  }

  void _protectDataLeakageOn(BuildContext context) async {
    if (Platform.isIOS) {
      // await ScreenProtector.protectDataLeakageWithColor(Colors.white);
    } else if (Platform.isAndroid) {
      await ScreenProtector.protectDataLeakageOn();
    }
  }

  void _preventScreenshotOn() async =>
      await ScreenProtector.preventScreenshotOn();

  void _preventScreenshotOff() async =>
      await ScreenProtector.preventScreenshotOff();

  void _addListenerPreventScreenshot(BuildContext context) async {
    ScreenProtector.addListener(
      () {
        // Screenshot
        debugPrint('Screenshot:');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Screenshot!')));
      },
      (isCaptured) {
        // Screen Record
        debugPrint('Screen Record:');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Screen Record!')));
      },
    );
  }

  void _removeListenerPreventScreenshot() async {
    ScreenProtector.removeListener();
  }
}
