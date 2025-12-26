import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterkvm/features/atx/data/atx_repository.dart';
import 'package:flutterkvm/features/atx/domain/atx_status.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late AtxRepository repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = AtxRepository(mockDio);
  });

  group('AtxRepository', () {
    test('getStatus returns AtxStatus', () async {
      final mockData = {
        'result': {'power': true, 'hdd': false}
      };
      when(() => mockDio.get('/api/atx')).thenAnswer(
        (_) async => Response(
          data: mockData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/atx'),
        ),
      );

      final status = await repository.getStatus();

      expect(status.power, isTrue);
      expect(status.hdd, isFalse);
    });

    test('powerOn calls correct endpoint', () async {
      when(() => mockDio.post(any())).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/atx/power?action=on'),
        ),
      );

      await repository.powerOn();

      verify(() => mockDio.post('/api/atx/power?action=on')).called(1);
    });

    test('powerReset calls correct endpoints and waits', () async {
      when(() => mockDio.post(any())).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/atx/reset?action=on'),
        ),
      );

      await repository.powerReset();

      verify(() => mockDio.post('/api/atx/reset?action=on')).called(1);
      verify(() => mockDio.post('/api/atx/reset?action=off')).called(1);
    });
  });
}
