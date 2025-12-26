import 'package:dio/dio.dart';
import 'package:flutterkvm/features/atx/domain/atx_status.dart';

class AtxRepository {
  final Dio _client;

  AtxRepository(this._client);

  Future<AtxStatus> getStatus() async {
    final response = await _client.get('/api/atx');
    return AtxStatus.fromJson(response.data['result']);
  }

  Future<void> powerOn() async {
    await _client.post('/api/atx/power?action=on');
  }

  Future<void> powerOff() async {
    await _client.post('/api/atx/power?action=off');
  }

  Future<void> powerReset() async {
    await _client.post('/api/atx/reset?action=on');
    await Future.delayed(const Duration(milliseconds: 500));
    await _client.post('/api/atx/reset?action=off');
  }
}
