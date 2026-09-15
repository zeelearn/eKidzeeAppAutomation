import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:ekidzee/pages/feedback/presentation/controller/feedback_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class FeedbackMediaWidget extends StatefulWidget {
  final String? url;
  final String? type;
  final bool isMandatory;
  final Function()? onVideoFinished;

  const FeedbackMediaWidget({
    super.key,
    this.url,
    this.type,
    this.isMandatory = false,
    this.onVideoFinished,
  });

  @override
  State<FeedbackMediaWidget> createState() => _FeedbackMediaWidgetState();
}

class _FeedbackMediaWidgetState extends State<FeedbackMediaWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVisible = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    Get.log(
        'FeedbackMediaWidget initState with url: ${widget.url}, type: ${widget.type} , isMandatory: ${widget.isMandatory}');

    final controller = Get.find<FeedbackController>();
    ever(controller.isOffline, (bool isOffline) {
      if (isOffline) {
        _videoPlayerController?.pause();
      } else {
        if (widget.type?.toLowerCase() == 'video' && widget.url != null) {
          if (_videoPlayerController == null || _hasError) {
            _initializePlayer();
          } else if (_videoPlayerController!.value.isInitialized) {
            _videoPlayerController!.play();
          }
        }
      }
    });

    if (!controller.isOffline.value &&
        widget.type?.toLowerCase() == 'video' &&
        widget.url != null) {
      _initializePlayer();
    }
  }

  bool _isInitializing = false;
  void _initializePlayer() async {
    if (_isInitializing || widget.url == null) return;

    // Clear previous error and state
    if (_hasError || _videoPlayerController != null) {
      await _videoPlayerController?.dispose();
      _chewieController?.dispose();
      _videoPlayerController = null;
      _chewieController = null;
    }

    try {
      if (mounted) {
        setState(() {
          _hasError = false;
          _isInitializing = true;
        });
      }
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.url!));
      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        showControls: true,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        draggableProgressBar: !widget.isMandatory,
        showControlsOnInitialize: !widget.isMandatory,
        allowMuting: true,
        allowPlaybackSpeedChanging: !widget.isMandatory,
        allowFullScreen: true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
        ],
        customControls: FeedbackVideoControls(
          isMandatory: widget.isMandatory,
        ),
      );

      _videoPlayerController!.addListener(() {
        if (mounted) {
          setState(() {});
        }
        if (_videoPlayerController!.value.position >=
            _videoPlayerController!.value.duration) {
          if (widget.onVideoFinished != null) {
            widget.onVideoFinished!();
          }
        }
      });
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      Get.log("Error initializing video: $e");
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible || widget.url == null || widget.url!.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget content;
    if (widget.type?.toLowerCase() == 'video') {
      final feedbackController = Get.find<FeedbackController>();
      content = _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized
          ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Chewie(
                    controller: _chewieController!,
                  ),
                ),
              ],
            )
          : SizedBox(
              height: 200,
              child: Center(
                child: Obx(() => feedbackController.isOffline.value
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off, size: 40),
                          const SizedBox(height: 8),
                          const Text("You are offline"),
                        ],
                      )
                    : _hasError
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.red, size: 40),
                              const SizedBox(height: 8),
                              const Text(
                                "Error loading video",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Tap to retry",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _initializePlayer,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text("Retry"),
                              ),
                            ],
                          )
                        : const CircularProgressIndicator()),
              ),
            );
    } else {
      // Default to image
      content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            widget.url!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
          ),
        ),
      );
    }

    return Stack(
      children: [
        content,
        if (!widget.isMandatory)
          Positioned(
            top: 10,
            right: 10,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.black54,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: () {
                  _videoPlayerController?.pause();
                  // _videoPlayerController?.dispose();
                  // _chewieController?.dispose();
                  setState(() {
                    _isVisible = false;
                  });
                },
              ),
            ),
          ),
      ],
    );
  }
}

class OfflineOverlay extends StatelessWidget {
  final VoidCallback onClose;
  const OfflineOverlay({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off_rounded,
                    color: Colors.white, size: 60),
                const SizedBox(height: 16),
                const Text(
                  "Connection Lost",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "You are currently offline. Please provide the survey when internet is available.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "Close Survey",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeedbackVideoControls extends StatefulWidget {
  final bool isMandatory;
  const FeedbackVideoControls({
    super.key,
    required this.isMandatory,
  });

  @override
  State<FeedbackVideoControls> createState() => _FeedbackVideoControlsState();
}

class _FeedbackVideoControlsState extends State<FeedbackVideoControls> {
  bool _showControls = true;
  Timer? _hideTimer;
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newController = ChewieController.of(context).videoPlayerController;
    if (_controller != newController) {
      _controller?.removeListener(_updateState);
      _controller = newController;
      _controller?.addListener(_updateState);
    }
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller?.removeListener(_updateState);
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chewieController = ChewieController.of(context);
    final feedbackController = Get.find<FeedbackController>();

    return Obx(() {
      if (feedbackController.isOffline.value && chewieController.isFullScreen) {
        return OfflineOverlay(
          onClose: () => Get.back(),
        );
      }

      if (_controller == null) return const SizedBox.shrink();

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleControls,
        child: AnimatedOpacity(
          opacity: _showControls ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: !_showControls,
            child: Container(
              color: Colors.black26,
              child: Stack(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!widget.isMandatory) ...[
                          IconButton(
                            iconSize: 32,
                            icon: const Icon(Icons.replay_10,
                                color: Colors.white70),
                            onPressed: () {
                              _controller!.seekTo(_controller!.value.position -
                                  const Duration(seconds: 10));
                              _startHideTimer();
                            },
                          ),
                          const SizedBox(width: 20),
                        ],
                        IconButton(
                          iconSize: 50,
                          icon: Icon(
                            _controller!.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _controller!.value.isPlaying
                                  ? _controller!.pause()
                                  : _controller!.play();
                            });
                            _startHideTimer();
                          },
                        ),
                        if (!widget.isMandatory) ...[
                          const SizedBox(width: 20),
                          IconButton(
                            iconSize: 32,
                            icon: const Icon(Icons.forward_10,
                                color: Colors.white70),
                            onPressed: () {
                              _controller!.seekTo(_controller!.value.position +
                                  const Duration(seconds: 10));
                              _startHideTimer();
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black54],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${_formatDuration(_controller!.value.position)} / ${_formatDuration(_controller!.value.duration)}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  chewieController.isFullScreen
                                      ? Icons.fullscreen_exit
                                      : Icons.fullscreen,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  chewieController.toggleFullScreen();
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                            child: VideoProgressIndicator(
                              _controller!,
                              allowScrubbing: !widget.isMandatory,
                              colors: const VideoProgressColors(
                                playedColor: Colors.red,
                                bufferedColor: Colors.grey,
                                backgroundColor: Colors.black26,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
