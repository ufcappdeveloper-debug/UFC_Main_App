import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool hidePadding;

  const CustomVideoPlayer({
    super.key,
    required this.videoUrl,
    this.hidePadding = false,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: false,
      looping: false,
      showControls: true,
      allowMuting: true,
      allowPlaybackSpeedChanging: true,
      placeholder: Center(
        child: Icon(Icons.videocam, size: 55, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();

    super.dispose();
  }

  double get _aspectRatio => _controller.value.isInitialized
      ? _controller.value.aspectRatio
      : 16 / 9; // Default aspect ratio

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.hidePadding ? EdgeInsets.zero : EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: _aspectRatio,
          child: Chewie(controller: _chewieController),
        ),
      ),
    );
  }
}
