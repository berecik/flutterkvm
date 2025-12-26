import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _client;

  AuthRepository(this._client);

  Future<Map<String, dynamic>> getServerInfo() async {
    try {
      final response = await _client.get('/api/info');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}
