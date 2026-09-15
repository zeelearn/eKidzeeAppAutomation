import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../widget/file_list_button.dart';

class VideoApp1 extends StatefulWidget {
  @override
  final FileDetail fileDetails;

  const VideoApp1({Key? key, required this.fileDetails}) : super(key: key);
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp1> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // LoadingScreen().show(
    //   context: context,
    //   text: 'Please wait a moment',
    // );

    String url = widget.fileDetails.dyntubeWeb_url as String;
    //debugPrint("---------File Name " + url);
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(false);
        //LoadingScreen().hide();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);*/
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(''), // You can add title here
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor:
              Colors.blue.withOpacity(0.3), //You can make this transparent
          elevation: 0.0, //No shadow
        ),
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(
                  child: _PlayPauseOverlay(
                    controller: _controller,
                  ),
                ),

          //VideoProgressIndicator(_controller, allowScrubbing: true),
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
    _controller.dispose();
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key? key, required this.controller})
      : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.play();
          },
        ),
      ],
    );
  }
}
