import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'ChewiePlayer.dart';

class AudioPlayer extends StatefulWidget {
  @override
  String path;
  final String background;

  AudioPlayer({
    super.key,
    required this.path,
    required this.background,
    required this.Title,
  });

  final String Title;
  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<AudioPlayer> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
    try {
      widget.path = widget.path.replaceAll(" ", "%20");
      WidgetsBinding.instance
          .addPostFrameCallback((_) async => await initializePlayer());
    } catch (e) {
      //debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _videoPlayerController1.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  initializePlayer() async {
    _videoPlayerController1 =
        VideoPlayerController.networkUrl(Uri.parse(widget.path))
          ..initialize().then((_) {
            _createChewieController();
            _videoPlayerController1.play();
            setState(() {});
          });
//     debugPrint('Path ${widget.path}');
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      allowFullScreen: false,
      showControls: true,
      allowedScreenSleep: false,
      cupertinoProgressColors:
          ChewieProgressColors(backgroundColor: Colors.red),
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      hideControlsTimer: const Duration(seconds: 1),
    );
  }

  int currPlayIndex = 0;
  bool _isVideoPlaying = false;
  Future<void> toggleVideo() async {
//     debugPrint('toggle video...');
    if (_isVideoPlaying) {
      await _videoPlayerController1.play();
    } else {
      await _videoPlayerController1.pause();
    }
    _isVideoPlaying = !_isVideoPlaying;
    //currPlayIndex = 0;
    //await initializePlayer();
  }

  bool isPlaying = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: widget.background.isEmpty
              ? BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/audio_bg.jpg'),
                    fit: BoxFit.fill,
                  ),
                )
              : BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.background),
                    fit: BoxFit.fill,
                  ),
                ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: _chewieController != null &&
                              _chewieController!
                                  .videoPlayerController.value.isInitialized
                          ? ChewiePlayer(
                              controller: _chewieController!,
                              backgroundImage: widget.background)
                          : Stack(
                              children: [
                                widget.background != null
                                    ? SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Image.network(
                                          widget.background,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                      )
                                    : SizedBox(
                                        height: 0,
                                        width: 0,
                                      ),
                                _chewieController != null
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: ClipOval(
                                          child: Material(
                                            color: Colors.white, // Button color
                                            child: InkWell(
                                              splashColor:
                                                  Colors.white, // Splash color
                                              onTap: () {
                                                if (isPlaying) {
//                                                   debugPrint('pause $isPlaying');
                                                  //_chewieController?.pause();
                                                  _videoPlayerController1
                                                      .pause();
                                                } else {
                                                  //_chewieController?.play();
                                                  _videoPlayerController1
                                                      .play();
//                                                   debugPrint('pause $isPlaying');
                                                }
                                                isPlaying = !isPlaying;
                                              },
                                              child: SizedBox(
                                                  width: 56,
                                                  height: 56,
                                                  child: Icon(Icons.home)),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Align(
                                        alignment: Alignment.center,
                                        child: FadeInImage(
                                          width: 25,
                                          height: 25,
                                          placeholder:
                                              NetworkImage(widget.background),
                                          image: AssetImage(
                                              'assets/icons/ic_video.png'),
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                                'assets/icons/ic_video.png',
                                                fit: BoxFit.fitWidth);
                                          },
                                          fit: BoxFit.cover,
                                        )) /*Image.network(widget.background,))*/
                              ],
                            ),
                    ),
                  ),
                ],
              ),
              Positioned(
                  top: 40,
                  left: 15,
                  child: InkWell(
                    child: Image.asset(
                      "assets/icons/ic_left_arrow.png",
                      width: 30,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
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
          /*setState(() {
            saved = false;
          });*/
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
