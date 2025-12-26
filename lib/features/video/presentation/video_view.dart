import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutterkvm/features/video/data/mjpeg_repository.dart';
import 'dart:typed_data';

class VideoView extends HookWidget {
  final MjpegRepository repository;

  const VideoView({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final stream = useMemoized(() => repository.getVideoStream(), [repository]);
    final snapshot = useStream(stream);

    if (snapshot.hasError) {
      return Center(
        child: Text(
          'Error: ${snapshot.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    return Image.memory(
      snapshot.data as Uint8List,
      gaplessPlayback: true,
      fit: BoxFit.contain,
    );
  }
}
