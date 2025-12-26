import 'dart:async';
import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutterkvm/features/auth/domain/entities/server_config.dart';
import 'package:flutterkvm/features/hid/data/hid_repository.dart';
import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:otp/otp.dart';

HidRepository? useHidConnection(ServerConfig config) {
  final repository = useState<HidRepository?>(null);

  useEffect(() {
    String authPass = config.password;
    if (config.totpSecret != null && config.totpSecret!.isNotEmpty) {
      final code = OTP.generateTOTPCodeString(
        config.totpSecret!,
        DateTime.now().millisecondsSinceEpoch,
        isGoogle: true,
      );
      authPass = '${config.password}$code';
    }

    // Note: web_socket_channel doesn't easily support custom headers in all platforms directly
    // but PiKVM often allows passing credentials in the URL for WebSockets or uses a cookie-based session
    // established by a prior REST call. However, the requirement is "web_socket_channel for HID".
    // PiKVM HID WS typically expects a handshake.

    final uri = Uri.parse('wss://${config.host}:${config.port}/api/ws');

    // PiKVM expects authentication headers for WebSockets
    final headers = {
      'X-KVMD-User': config.username,
      'X-KVMD-Passwd': authPass,
    };

    final channel = IOWebSocketChannel.connect(
      uri,
      headers: headers,
    );

    final repo = HidRepository(channel);

    Timer? heartbeatTimer;

    final subscription = repo.stream.listen((message) {
      final data = jsonDecode(message as String);
      if (data['event'] == 'hello') {
        // Handshake: send authentication if required by PiKVM protocol in the first message
        // Or just move to loop
        repo.sendPing(); // Example to initiate

        heartbeatTimer = Timer.periodic(const Duration(seconds: 5), (_) {
          repo.sendPing();
        });
      }
    }, onError: (e) {
      print('HID WebSocket Error: $e');
    });

    repository.value = repo;

    return () {
      heartbeatTimer?.cancel();
      subscription.cancel();
      repo.close();
    };
  }, [config]);

  return repository.value;
}
