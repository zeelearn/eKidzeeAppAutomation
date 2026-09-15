// This file is only used on Web
// import 'dart:html' as html;
import 'package:web/web.dart' as web;

void listenToJavaScriptMessages(Function(dynamic) callback) {
  web.window.onMessage.listen(
    (event) {
      callback(event.data);
    },
  );
  /* html.window.onMessage.listen((event) {
    callback(event.data);
  }); */
}

void sendMessageToJavaScript(String message) {
  // web.window.postMessage(message,optionsOrTargetOrigin "*");

  // html.window.dispatchEvent(html.CustomEvent('fluttercallseektotime',detail:  message));
}
