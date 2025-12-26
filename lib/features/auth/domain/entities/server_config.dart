import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_config.freezed.dart';
part 'server_config.g.dart';

@freezed
class ServerConfig with _$ServerConfig {
  const factory ServerConfig({
    required String host,
    @Default(443) int port,
    required String username,
    required String password,
    String? totpSecret,
    @Default(false) bool isTrusted,
  }) = _ServerConfig;

  factory ServerConfig.fromJson(Map<String, dynamic> json) => _$ServerConfigFromJson(json);
}
