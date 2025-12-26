import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class MjpegRepository {
  final Dio _client;

  MjpegRepository(this._client);

  Stream<Uint8List> getVideoStream() async* {
    while (true) {
      try {
        final response = await _client.get<ResponseBody>(
          '/stream',
          options: Options(responseType: ResponseType.stream),
        );

        final stream = response.data!.stream;
        List<int> buffer = [];

        await for (final chunk in stream) {
          buffer.addAll(chunk);

          // Prevent memory leaks from unbounded buffer
          if (buffer.length > 10 * 1024 * 1024) {
            buffer.clear();
          }

          while (true) {
            int start = -1;
            for (int i = 0; i < buffer.length - 1; i++) {
              if (buffer[i] == 0xFF && buffer[i + 1] == 0xD8) {
                start = i;
                break;
              }
            }

            if (start == -1) {
              // No start marker found, but keep the last byte in case it's part of a marker
              if (buffer.isNotEmpty) {
                buffer = [buffer.last];
              }
              break;
            }

            int end = -1;
            for (int i = start + 2; i < buffer.length - 1; i++) {
              if (buffer[i] == 0xFF && buffer[i + 1] == 0xD9) {
                end = i + 2;
                break;
              }
            }

            if (end == -1) {
              // Start found but no end yet
              if (start > 0) {
                buffer.removeRange(0, start);
              }
              break;
            }

            // Extract the JPEG frame
            final frame = Uint8List.fromList(buffer.sublist(start, end));
            yield frame;

            // Remove processed frame from buffer
            buffer.removeRange(0, end);
          }
        }
      } catch (e) {
        // Log error and wait before reconnecting
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }
}
