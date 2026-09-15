import 'package:chewie/chewie.dart';
import 'package:ekidzee/utils/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';

class KltChewieRhymesPlayer extends StatefulWidget {
  @override
  final String filePath;
  final String background;

  const KltChewieRhymesPlayer({
    super.key,
    required this.filePath,
    required this.background,
    required this.Title,
  });

  final String Title;
  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<KltChewieRhymesPlayer> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  //late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;
  int? bufferDelay;
  bool _isInitializing = true;
  String? _initError;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
//     debugPrint('background url is ${widget.background}');
    /*  try {
      WidgetsBinding.instance.addPostFrameCallback((_) => initializePlayer());
    } catch (e) {
      //debugPrint(e.toString());
    } */
    initializePlayer();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _chewieController?.dispose();
    _videoPlayerController1.dispose();
    //_videoPlayerController2.dispose();
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
            'Unable to Play Rhyme.' /* _videoPlayerController1.value.errorDescription */;
        return;
      }

      _createChewieController();

      _isInitializing = false;
      setState(() {});
    } catch (e) {
      _initError = 'Unable to Play Rhyme.' /* e.toString() */;
      _isInitializing = false;
      setState(() {});
    }
  }

  /* Future<void> initializePlayer() async {
    // String newfilePath = widget.filePath.replaceAll(' ', '');
    final File filePath = File(widget.filePath);
    debugPrint('Rhymes video path is ${filePath.path}');

    _videoPlayerController1 =
        VideoPlayerController.networkUrl(Uri.file(widget.filePath));
    // _videoPlayerController1 = VideoPlayerController.file(filePath);
    await _videoPlayerController1.initialize().then((_) {
      _createChewieController();

      //_videoPlayerController1.play();
      setState(() {});
      debugPrint('Video path is initialized');
    }).onError(
      (error, stackTrace) {
        debugPrint('Video path error is - $error');
      },
    );
    setState(() {});
    //debugPrint('initlised player');
  } */

  void _createChewieController() {
    var subtitles = [];

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      allowFullScreen: false,
      showControls: true,
      allowedScreenSleep: false,
      // errorBuilder: (context, errorMessage) => Center(
      //     child: Text(
      //   errorMessage,
      // )),
      cupertinoProgressColors:
          ChewieProgressColors(backgroundColor: Colors.red),
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,

      hideControlsTimer: const Duration(seconds: 1),

      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.background),
              fit: BoxFit.contain,
            ),
          ),
          child: Stack(
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
                          : Chewie(controller: _chewieController!),
                ),
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
          )),
    );
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
