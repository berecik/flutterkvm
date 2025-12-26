import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterkvm/features/auth/data/repositories/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late AuthRepository repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = AuthRepository(mockDio);
  });

  group('AuthRepository', () {
    test('getServerInfo returns data on success', () async {
      final mockData = {
        'result': {'version': '1.0'}
      };
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          data: mockData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/info'),
        ),
      );

      final result = await repository.getServerInfo();

      expect(result, mockData);
      verify(() => mockDio.get('/api/info')).called(1);
    });

    test('getServerInfo rethrows error on failure', () async {
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/info'),
          error: 'Connection failed',
        ),
      );

      expect(() => repository.getServerInfo(), throwsA(isA<DioException>()));
    });
  });
}
