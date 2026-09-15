import 'package:chewie/chewie.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class KltChewieDemo extends StatefulWidget {
  @override
  final String filePath;

  const KltChewieDemo({
    super.key,
    required this.filePath,
    required this.Title,
  });

  final String Title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<KltChewieDemo> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;

  //late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;
  int? bufferDelay;
  bool _isInitializing = true;
  String? _initError;

  @override
  void initState() {
    //debugPrint('================KltChewieDemo');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    //AutoOrientation.landscapeAutoMode();
    super.initState();
    initializePlayer();
    debugPrint('Video path is - ${widget.filePath}');
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //AutoOrientation.portraitAutoMode();
    _chewieController?.dispose();
    _videoPlayerController1.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _isInitializing = true;
    _initError = null;
    setState(() {});

    try {
      _videoPlayerController1 =
          VideoPlayerController.networkUrl(Uri.parse(widget.filePath));
      // _videoPlayerController1 =
      //     VideoPlayerController.file(File(widget.filePath));

      await _videoPlayerController1.initialize();

      if (_videoPlayerController1.value.hasError) {
        _initError =
            'Unable to Play Video.' /* _videoPlayerController1.value.errorDescription */;
        return;
      }

      _createChewieController();

      _isInitializing = false;
      setState(() {});
    } catch (e) {
      _initError = 'Unable to Play Video.' /* e.toString() */;
      _isInitializing = false;
      setState(() {});
    }
  }

  /* Future<void> initializePlayer() async {
    final File filePath = File(widget.filePath);

    debugPrint('Video path is - ${widget.filePath} - ${filePath.existsSync()}');

    _videoPlayerController1 =
        VideoPlayerController.networkUrl(Uri.file(widget.filePath));
    // _videoPlayerController1 = VideoPlayerController.file(filePath);
    await _videoPlayerController1.initialize().then((_) {
      _createChewieController();
      isLoading = false;
      //_videoPlayerController1.play();
      setState(() {});
      debugPrint('Video path is initialized');
    }).onError(
      (error, stackTrace) {
        debugPrint('Video path error is - $error');
      },
    );
    //_videoPlayerController2 = VideoPlayerController.file(filePath);
    if (filePath.toString().contains('m3u8')) {
      /*  _videoPlayerController1 = VideoPlayerController.network(widget.filePath)
        ..initialize().then((_) {
          isLoading = false;
          _videoPlayerController1.play();
          setState(() {});
        }); */
      /*_videoPlayerController2 = VideoPlayerController.network(
          'https://api.dyntube.com/v1/apps/hls/OpedRznmZkK3k5oHplXTEg.m3u8')
        ..initialize().then((_) {
          isLoading = false;
          _videoPlayerController2.play();
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });*/
    }
    _videoPlayerController1.addListener(() {
      if (_videoPlayerController1.value.hasError) {
//         debugPrint('_videoPlayerCont error---- ${_videoPlayerController1.value.errorDescription}');
      }
      if (_videoPlayerController1.value.isInitialized) {
        //_videoPlayerController1.play();
        setState(() {
          isLoading = false;
        });
      }
      if (_videoPlayerController1.value.isBuffering) {}
      //debugPrint('_videoPlayerCont buf ${_videoPlayerController1.value.isBuffering}');
      //debugPrint('_videoPlayerCont isInitialized ${_videoPlayerController1.value.isInitialized}');
      //debugPrint('_videoPlayerCont isPlaying ${_videoPlayerController1.value.isPlaying}');
    });
    //_createChewieController();
    //setState(() {});
  } */

  void _createChewieController() {
    var subtitles = [
      Subtitle(
        index: 0,
        start: Duration.zero,
        end: const Duration(seconds: 10),
        text: const TextSpan(
          children: [
            TextSpan(
              text: '',
              style: TextStyle(color: Colors.red, fontSize: 22),
            ),
          ],
        ),
      ),
      Subtitle(
        index: 0,
        start: const Duration(seconds: 10),
        end: const Duration(seconds: 20),
        text: '',
        // text: const TextSpan(
        //   text: 'Whats up? :)',
        //   style: TextStyle(color: Colors.amber, fontSize: 22, fontStyle: FontStyle.italic),
        // ),
      ),
    ];

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      allowedScreenSleep: false,
      autoPlay: true,
      looping: false,
      isLive: false,
      // errorBuilder: (context, errorMessage) => Center(
      //     child: Text(
      //   errorMessage,
      // )),
      showControlsOnInitialize: true,
      showControls: true,
      aspectRatio: 4 / 2,
      routePageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondAnimation, provider) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return VideoScaffold(
              key: widget.key,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                body: Container(
                  alignment: Alignment.center,
                  color: Colors.black,
                  child: provider,
                ),
              ),
            );
          },
        );
      },
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,

      subtitle: Subtitles(subtitles),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),

      hideControlsTimer: const Duration(seconds: 1),

      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.r    //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await _videoPlayerController1.pause();
    currPlayIndex = 0;
    await initializePlayer();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          child: Center(
              child: _isInitializing
                  ? const CircularProgressIndicator()
                  : _initError != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error,
                                color: Colors.red, size: 40),
                            const SizedBox(height: 10),
                            Text(
                              _initError!,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: initializePlayer,
                              child: Text(
                                'Retry',
                                style: LightColors.smallTextStyle
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      : Chewie(controller: _chewieController!)),
        ),
        Positioned(
            top: 40,
            left: 15,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                "assets/icons/ic_left_arrow.png",
                width: 30,
              ),
            )),
      ],
    ));
  }
}

class DelaySlider extends StatefulWidget {
  const DelaySlider({super.key, required this.delay, required this.onSave});

  final int? delay;
  final void Function(int?) onSave;

  @override
  State<DelaySlider> createState() => _DelaySliderState();
}

class _DelaySliderState extends State<DelaySlider> {
  int? delay;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    delay = widget.delay;
  }

  @override
  Widget build(BuildContext context) {
    const int max = 1000;
    return ListTile(
      title: Text(
        "Progress indicator delay ${delay != null ? "${delay.toString()} MS" : ""}",
      ),
      subtitle: Slider(
        value: delay != null ? (delay! / max) : 0,
        onChanged: (value) async {
          delay = (value * max).toInt();
          setState(() {
            saved = false;
          });
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.save),
        onPressed: saved
            ? null
            : () {
                widget.onSave(delay);
                setState(() {
                  saved = true;
                });
              },
      ),
    );
  }
}

class VideoScaffold extends StatefulWidget {
  const VideoScaffold({required super.key, required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() => _VideoScaffoldState();
}

class _VideoScaffoldState extends State<VideoScaffold> {
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
