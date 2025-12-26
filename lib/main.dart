import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutterkvm/features/auth/domain/entities/server_config.dart';
import 'package:flutterkvm/core/hooks/use_dio_client.dart';
import 'package:flutterkvm/features/video/data/mjpeg_repository.dart';
import 'package:flutterkvm/features/video/presentation/video_view.dart';
import 'package:flutterkvm/features/atx/data/atx_repository.dart';
import 'package:flutterkvm/features/atx/presentation/power_control_panel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PikvmControl',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends HookWidget {
  final MjpegRepository? mjpegRepository;
  final AtxRepository? atxRepository;

  const DashboardPage({
    super.key,
    this.mjpegRepository,
    this.atxRepository,
  });

  @override
  Widget build(BuildContext context) {
    final config = useMemoized(() => ServerConfig(
          host: '192.168.1.100', // Example host
          username: 'admin',
          password: 'admin',
          isTrusted: true,
        ));

    final dio = useDioClient(config);
    final MjpegRepository effectiveMjpegRepo = mjpegRepository ?? useMemoized(() => MjpegRepository(dio), [dio]);
    final AtxRepository effectiveAtxRepo = atxRepository ?? useMemoized(() => AtxRepository(dio), [dio]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PiKVM Control'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: VideoView(repository: effectiveMjpegRepo),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Power Management',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            PowerControlPanel(repository: effectiveAtxRepo),
          ],
        ),
      ),
    );
  }
}
