import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class HidRepository {
  final WebSocketChannel _channel;

  HidRepository(this._channel);

  void sendMouseAbsolute(int x, int y, double width, double height) {
    if (width <= 0 || height <= 0) return;

    // Map coordinates to 0-32767 space
    final mappedX = (x * 32767 / width).round().clamp(0, 32767);
    final mappedY = (y * 32767 / height).round().clamp(0, 32767);

    final message = {
      'event': 'mouse_move',
      'data': {
        'x': mappedX,
        'y': mappedY,
      }
    };
    _channel.sink.add(jsonEncode(message));
  }

  void sendKey(String domCode, bool pressed) {
    final message = {
      'event': pressed ? 'key_down' : 'key_up',
      'data': {
        'code': domCode,
      }
    };
    _channel.sink.add(jsonEncode(message));
  }

  void sendPing() {
    _channel.sink.add(jsonEncode({'event': 'ping'}));
  }

  Stream get stream => _channel.stream;

  void close() {
    _channel.sink.close();
  }
}
