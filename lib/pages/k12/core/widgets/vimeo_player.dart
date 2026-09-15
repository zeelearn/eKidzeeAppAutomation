import 'dart:convert';
import 'dart:io';

import 'package:ekidzee/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/utils.dart';
import 'handler/js_handler_stub.dart'
    if (dart.library.html) 'handler/web_js_handler.dart'
    if (dart.library.io) 'handler/mobile_js_handler.dart';

class VimeoPlayerLocal extends StatefulWidget {
  const VimeoPlayerLocal({
    super.key,
    required this.videoId,
    required this.mId,
    required this.isPip,
    this.position,
  });
  final String videoId;
  final int mId;
  final int? position;
  final bool isPip;
  @override
  _VimeoPlayerLocalState createState() => _VimeoPlayerLocalState();
}

class _VimeoPlayerLocalState extends State<VimeoPlayerLocal>
    with WidgetsBindingObserver, RouteAware {
  InAppWebViewController? _webViewController;
  // final floating = Floating();
  bool showThumbnail = true;
  double _currentProgress = 0.0;
  double _duration = 0.0;
  bool isRouteRegistered = false;
  BuildContext? mContext;
  bool isFullScreen = false; // Track fullscreen state

  String? progressKey;

  void seekToTime(double seconds) async {
    if (kIsWeb) {
      _webViewController?.evaluateJavascript(source: '''
      window.postMessage({ type: "message", message: seconds }, "*");
    ''');
    } else {
      var seektoResponse = await _webViewController?.evaluateJavascript(
          source: 'seekToTime($seconds);');
      debugPrint('Response from seektotime is - $seektoResponse');
    }
  }

  register(BuildContext context) {
    if (!isRouteRegistered) {
      mContext = context;
      try {
        final ModalRoute? modalRoute = ModalRoute.of(context);
        if (modalRoute != null) {
//           debugPrint(' 91 init didChangeDependencies subscribe');
          routeObserver.subscribe(this as RouteAware, modalRoute as PageRoute);
//           debugPrint('91 init  didChangeDependencies subscribe DONE');
          isRouteRegistered = true;
        } else {
          isRouteRegistered = false;
//           debugPrint('91 init didChangeDependencies subscribe NULL');
        }
      } catch (e) {
        isRouteRegistered = false;
//         debugPrint(' 91 init error in 104 ${e.toString()}');
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//     debugPrint('didChangeDependencies 124');
    //routeObserver.subscribe(this, ModalRoute.of(Get.context!)!);
    if (mContext != null) register(mContext!);
  }

  @override
  void didPushNext() {
//     debugPrint('didPushNext didPushNext didPushNext');
    // Called when navigating to the next screen
    if (isFullScreen) {
      if (isFullScreen) {
//         debugPrint('PLAY VIDEO');
        playVideo();
      } else {
        pauseVideo();
//         debugPrint('139  VIDEO');
      }
    } else
      pauseVideo();
  }

  @override
  void didPopNext() {
//     debugPrint('didPopNext didPopNext didPopNext');
    // Called when coming back to this screen
    playVideo();
  }

  @override
  void initState() {
    isRouteRegistered = false;

    super.initState();
    WidgetsBinding.instance.addObserver(this);
//     debugPrint('videmo didChangeAppLifecycleState addObserver');
    if (kIsWeb) {
      listenToJavaScriptMessages((message) async {
        // seekToTime((progress?.progress ?? 0) *
        //               (double.tryParse(arguments[0].toString()) ?? 0));
        debugPrint('Message from JavaScript: ${jsonDecode(message)} ');

        try {
          Map<String, dynamic> data = jsonDecode(message);
          if (data.containsKey('totalduration')) {
            _duration = data['totalduration'];
            debugPrint(
                'Seek to is getting called and _duration  $_duration $_webViewController');
            // seekToTime((progress?.progress ?? 0) *
            //     (double.tryParse(progress?.cduration.toString() ?? '0') ?? 0));
          } else if (data.containsKey('data')) {
            _currentProgress = data['data']['seconds'].runtimeType == int
                ? data['data']['seconds']
                : data['data']['seconds'];
            _duration = data['data']['duration'];

            //FirebaseUtils().updateProgress(progress.mid, uid, progress.progress);
          }
        } catch (e) {
          debugPrint('Error parsing message: $e');
        }
      });
    }
  }

  @override
  void dispose() {
//     debugPrint('videmo didChangeAppLifecycleState DISABLE');
    pauseVideo();
    // _webViewController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  pauseVideo() {
    try {
      if (mounted) {
        _webViewController?.evaluateJavascript(source: 'pauseVideo();');
      }
    } catch (e) {}
  }

  playVideo() {
    try {
      if (mounted) {
        _webViewController?.evaluateJavascript(source: 'playVideo();');
      }
    } catch (e) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      //  pauseVideo();
    }
  }

  @override
  void didUpdateWidget(covariant VimeoPlayerLocal oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.videoId != oldWidget.videoId) {
      _webViewController?.loadData(
          data:
              Utils.loadVimeoPlayer(widget.videoId, widget.isPip, seconds: 0));
    }
  }

  void _handleButtonClick(String button) async {
    if (button == 'play') {
      debugPrint('Play button clicked in Vimeo Player');
    } else if (button == 'pause') {
      debugPrint('Pause button clicked in Vimeo Player');
    } else if (button == 'pip') {
      debugPrint('Picture-in-Picture button clicked in Vimeo Player');
      if (!kIsWeb &&
          Platform.isAndroid &&
          !await Permission.systemAlertWindow.isGranted) {
        PermissionStatus permissionStatus =
            await Permission.systemAlertWindow.request();
        if (permissionStatus.isGranted) {
          // Utils.enterPiPMode();
        } else {
          // ToastUtility.showError('Please give permission to enter PIP mode');
        }
      } else if (!kIsWeb &&
          Platform.isAndroid &&
          await Permission.systemAlertWindow.isGranted) {
        // Utils.enterPiPMode();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;
    register(context);
    InAppWebView getInappWebView() => InAppWebView(
          initialData: InAppWebViewInitialData(
            data:
                Utils.loadVimeoPlayer(widget.videoId, widget.isPip, seconds: 0),
          ),
          initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              defaultFontSize: 25,
              allowBackgroundAudioPlaying: false,
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: true,
              allowsAirPlayForMediaPlayback: true,
              supportMultipleWindows: true,
              allowsPictureInPictureMediaPlayback: true,
              iframeAllowFullscreen: true,
              useWideViewPort: true,
              useHybridComposition: true,
              javaScriptCanOpenWindowsAutomatically: true,
              defaultFixedFontSize: 30),
          onConsoleMessage: (controller, consoleMessage) {
            //debugPrint('Console message is - $consoleMessage');
          },
          onLoadStop: (controller, url) async {
            // if (!kIsWeb) {
            // await controller.evaluateJavascript(source: '''
            //     player.getDuration().then(function(duration) {
            //       window.flutter_inappwebview.callHandler('getDuration', duration);
            //     });
            //   ''');
            // }

            // if(kIsWeb){
            //   debugPrint('Seek to is getting called - ${progress?.progress} and _duration 0 ${_duration}');
            //    seekToTime((progress?.progress ?? 0) *
            //     (double.tryParse(_duration.toString()) ?? 0));
            // }

            setState(() {
              showThumbnail = false;
            });
          },
          onWebViewCreated: (controller) async {
            _webViewController = controller;

            // if(kIsWeb){
            //    seekToTime((progress?.progress ?? 0) *
            //     (double.tryParse(_duration.toString()) ?? 0));
            // }

            if (!kIsWeb) {
              _webViewController?.addJavaScriptHandler(
                handlerName: 'getDuration',
                callback: (arguments) {
                  debugPrint(
                      'Duration is - ${double.tryParse(arguments[0].toString())}');
                  // seekToTime((progress?.progress ?? 0) *
                  //     (double.tryParse(arguments[0].toString()) ?? 0));
                },
              );
              _webViewController?.addJavaScriptHandler(
                handlerName: 'buttonClick',
                callback: (args) {
                  String button = args[0];
                  _handleButtonClick(button);
                },
              );

              _webViewController?.addJavaScriptHandler(
                handlerName: 'onProgress',
                callback: (args) async {
                  //debugPrint('On Progress is getting called - ${args.first}');
                  final data = jsonDecode(args.first);

                  _currentProgress = data['seconds'].runtimeType == int
                      ? data['seconds'].toDouble()
                      : data['seconds'].toDouble();
                  _duration = data['duration'];

                  //FirebaseUtils().updateProgress(progress.mid, uid, progress.progress);
                },
              );
            }
          },
        );

    Widget getVimeoPlayer() => Stack(children: [
          Container(
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: getInappWebView(),
              ),
            ),
          ),
          if (showThumbnail)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ]);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: getVimeoPlayer()),
    );
  }
}
