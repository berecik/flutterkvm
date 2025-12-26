import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterkvm/features/hid/data/hid_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MockWebSocketChannel extends Mock implements WebSocketChannel {}
class MockWebSocketSink extends Mock implements WebSocketSink {}

void main() {
  late HidRepository repository;
  late MockWebSocketChannel mockChannel;
  late MockWebSocketSink mockSink;

  setUp(() {
    mockChannel = MockWebSocketChannel();
    mockSink = MockWebSocketSink();
    when(() => mockChannel.sink).thenReturn(mockSink);
    repository = HidRepository(mockChannel);
  });

  group('HidRepository', () {
    test('sendMouseAbsolute sends correct JSON for boundary values', () {
      // 0, 0
      repository.sendMouseAbsolute(0, 0, 1000, 1000);
      verify(() => mockSink.add(jsonEncode({
        'event': 'mouse_move',
        'data': {'x': 0, 'y': 0}
      }))).called(1);

      // max, max
      repository.sendMouseAbsolute(1000, 1000, 1000, 1000);
      verify(() => mockSink.add(jsonEncode({
        'event': 'mouse_move',
        'data': {'x': 32767, 'y': 32767}
      }))).called(1);

      // exceeding boundaries (should be clamped)
      repository.sendMouseAbsolute(2000, 2000, 1000, 1000);
      verify(() => mockSink.add(jsonEncode({
        'event': 'mouse_move',
        'data': {'x': 32767, 'y': 32767}
      }))).called(1);

      repository.sendMouseAbsolute(-100, -100, 1000, 1000);
      verify(() => mockSink.add(jsonEncode({
        'event': 'mouse_move',
        'data': {'x': 0, 'y': 0}
      }))).called(1);
    });

    test('sendMouseAbsolute does nothing for invalid dimensions', () {
      repository.sendMouseAbsolute(100, 100, 0, 1000);
      verifyNever(() => mockSink.add(any()));
    });

    test('sendKey sends correct JSON for key down', () {
      repository.sendKey('KeyA', true);

      final expectedMessage = jsonEncode({
        'event': 'key_down',
        'data': {
          'code': 'KeyA',
        }
      });

      verify(() => mockSink.add(expectedMessage)).called(1);
    });

    test('sendPing sends correct JSON', () {
      repository.sendPing();

      final expectedMessage = jsonEncode({'event': 'ping'});

      verify(() => mockSink.add(expectedMessage)).called(1);
    });
  });
}
