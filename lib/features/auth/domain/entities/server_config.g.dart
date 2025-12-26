// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServerConfigImpl _$$ServerConfigImplFromJson(Map<String, dynamic> json) =>
    _$ServerConfigImpl(
      host: json['host'] as String,
      port: (json['port'] as num?)?.toInt() ?? 443,
      username: json['username'] as String,
      password: json['password'] as String,
      totpSecret: json['totpSecret'] as String?,
      isTrusted: json['isTrusted'] as bool? ?? false,
    );

Map<String, dynamic> _$$ServerConfigImplToJson(_$ServerConfigImpl instance) =>
    <String, dynamic>{
      'host': instance.host,
      'port': instance.port,
      'username': instance.username,
      'password': instance.password,
      'totpSecret': instance.totpSecret,
      'isTrusted': instance.isTrusted,
    };
