import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class MockPiKvm {
  HttpServer? _server;
  int get port => _server?.port ?? 0;
  final List<WebSocket> _webSockets = [];

  Future<void> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server!.listen(_handleRequest);
    print('Mock PiKVM started on port $port');
  }

  Future<void> stop() async {
    for (var ws in _webSockets) {
      await ws.close();
    }
    await _server?.close(force: true);
  }

  void _handleRequest(HttpRequest request) async {
    final path = request.uri.path;

    if (path == '/api/info') {
      _handleInfo(request);
    } else if (path == '/api/atx') {
      _handleAtxStatus(request);
    } else if (path.startsWith('/api/atx/')) {
      _handleAtxAction(request);
    } else if (path == '/stream') {
      _handleStream(request);
    } else if (path == '/ws') {
      _handleWebSocket(request);
    } else {
      request.response.statusCode = HttpStatus.notFound;
      await request.response.close();
    }
  }

  void _handleInfo(HttpRequest request) async {
    final data = {
      'result': {
        'version': 'v3.250',
        'platform': 'v3-hdmi',
      }
    };
    request.response.headers.contentType = ContentType.json;
    request.response.write(jsonEncode(data));
    await request.response.close();
  }

  void _handleAtxStatus(HttpRequest request) async {
    final data = {
      'result': {
        'power': true,
        'hdd': false,
      }
    };
    request.response.headers.contentType = ContentType.json;
    request.response.write(jsonEncode(data));
    await request.response.close();
  }

  void _handleAtxAction(HttpRequest request) async {
    // Just return success for any ATX action
    final data = {'result': 'ok'};
    request.response.headers.contentType = ContentType.json;
    request.response.write(jsonEncode(data));
    await request.response.close();
  }

  void _handleStream(HttpRequest request) async {
    request.response.headers.set('Content-Type', 'multipart/x-mixed-replace; boundary=frame');

    // Send a few dummy JPEG frames
    final dummyJpeg = Uint8List.fromList([
      0xFF, 0xD8, // Start of Image
      0xFF, 0xEE, 0x00, 0x0E, 0x41, 0x64, 0x6F, 0x62, 0x65, 0x00, 0x64, 0x00, 0x00, 0x00, 0x00, 0x00,
      0xFF, 0xD9 // End of Image
    ]);

    for (int i = 0; i < 5; i++) {
      request.response.write('--frame\r\n');
      request.response.write('Content-Type: image/jpeg\r\n');
      request.response.write('Content-Length: ${dummyJpeg.length}\r\n\r\n');
      request.response.add(dummyJpeg);
      request.response.write('\r\n');
      await request.response.flush();
      await Future.delayed(const Duration(milliseconds: 100));
    }
    await request.response.close();
  }

  void _handleWebSocket(HttpRequest request) async {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      final socket = await WebSocketTransformer.upgrade(request);
      _webSockets.add(socket);

      socket.listen((message) {
        final data = jsonDecode(message as String);
        if (data['event'] == 'hello') {
          socket.add(jsonEncode({'event': 'hello', 'data': {'session': 'mock-session'}}));
        } else if (data['event'] == 'ping') {
          socket.add(jsonEncode({'event': 'pong'}));
        }
        // Echo back or handle other events if needed for verification
      });
    } else {
      request.response.statusCode = HttpStatus.badRequest;
      await request.response.close();
    }
  }
}
