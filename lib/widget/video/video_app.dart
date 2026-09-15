import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyVideoApp extends StatefulWidget {
  final String videoPath;

  @override
  const MyVideoApp({
    super.key,
    required this.videoPath,
  });

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<MyVideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    try {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
            ..initialize().then((_) {
              setState(() {
                _controller.pause();
                _controller.play();
              });

              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            });
      _controller.setVolume(0.0);
//       debugPrint('initlise ${widget.videoPath}');
    } catch (e) {
      // debugPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
