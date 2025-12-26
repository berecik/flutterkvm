import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterkvm/features/video/data/mjpeg_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}
class MockResponseBody extends Mock implements ResponseBody {}

void main() {
  late MjpegRepository repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = MjpegRepository(mockDio);
  });

  group('MjpegRepository', () {
    test('getVideoStream yields JPEG frames', () async {
      final mockResponse = MockResponseBody();
      final controller = StreamController<Uint8List>();

      when(() => mockResponse.stream).thenAnswer((_) => controller.stream);
      when(() => mockDio.get<ResponseBody>(
        any(),
        options: any(named: 'options'),
      )).thenAnswer((_) async => Response(
        data: mockResponse,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/stream'),
      ));

      final frame1 = Uint8List.fromList([0xFF, 0xD8, 0x01, 0x02, 0xFF, 0xD9]);
      final frame2 = Uint8List.fromList([0xFF, 0xD8, 0x03, 0x04, 0xFF, 0xD9]);

      final completer = Completer<void>();
      final frames = <Uint8List>[];
      final stream = repository.getVideoStream();
      final subscription = stream.listen((frame) {
        frames.add(frame);
        if (frames.length == 2) {
          completer.complete();
        }
      });

      controller.add(Uint8List.fromList([0x00, 0x00])); // Garbage
      controller.add(frame1);
      controller.add(Uint8List.fromList([0xAA, 0xBB])); // More garbage
      controller.add(frame2);

      await completer.future.timeout(const Duration(seconds: 2));

      expect(frames.length, equals(2));
      expect(frames[0], equals(frame1));
      expect(frames[1], equals(frame2));

      await subscription.cancel();
      await controller.close();
    }, timeout: const Timeout(Duration(seconds: 5)));
  });
}
