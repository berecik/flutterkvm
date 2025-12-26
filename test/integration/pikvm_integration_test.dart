import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterkvm/features/atx/data/atx_repository.dart';
import 'package:flutterkvm/features/auth/data/repositories/auth_repository.dart';
import 'package:flutterkvm/features/hid/data/hid_repository.dart';
import 'package:flutterkvm/features/video/data/mjpeg_repository.dart';
import 'package:web_socket_channel/io.dart';
import '../helpers/mock_pikvm.dart';

void main() {
  late MockPiKvm mockServer;
  late Dio dio;
  late AuthRepository authRepository;
  late AtxRepository atxRepository;
  late MjpegRepository mjpegRepository;

  setUp(() async {
    mockServer = MockPiKvm();
    await mockServer.start();

    dio = Dio(BaseOptions(baseUrl: 'http://localhost:${mockServer.port}'));
    authRepository = AuthRepository(dio);
    atxRepository = AtxRepository(dio);
    mjpegRepository = MjpegRepository(dio);
  });

  tearDown(() async {
    await mockServer.stop();
  });

  group('PiKVM Integration', () {
    test('Fetch server info', () async {
      final info = await authRepository.getServerInfo();
      expect(info['result']['version'], equals('v3.250'));
    });

    test('ATX status and power on', () async {
      final status = await atxRepository.getStatus();
      expect(status.power, isTrue);

      await atxRepository.powerOn();
      // Mock just returns success, so if no exception, it's good
    });

    test('MJPEG stream consumption', () async {
      final stream = mjpegRepository.getVideoStream();
      final frames = await stream.take(3).toList();
      expect(frames.length, equals(3));
      for (var frame in frames) {
        expect(frame.length, greaterThan(0));
        expect(frame[0], equals(0xFF));
        expect(frame[1], equals(0xD8));
      }
    });

    test('HID WebSocket communication', () async {
      final channel = IOWebSocketChannel.connect('ws://localhost:${mockServer.port}/ws');
      final broadcastStream = channel.stream.asBroadcastStream();
      final hidRepository = HidRepository(channel);

      // Perform handshake (MockPiKvm handles it)
      channel.sink.add('{"event": "hello"}');

      final firstMessage = await broadcastStream.first;
      expect(firstMessage, contains('mock-session'));

      // Send a mouse move
      hidRepository.sendMouseAbsolute(100, 100, 1000, 1000);

      // Send a ping
      hidRepository.sendPing();

      // Pong should come back (MockPiKvm handles it)
      final nextMessage = await broadcastStream.where((m) => m.contains('pong')).first;
      expect(nextMessage, contains('pong'));

      hidRepository.close();
    });
  });
}
