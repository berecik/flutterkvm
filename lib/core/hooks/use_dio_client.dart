import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutterkvm/features/auth/domain/entities/server_config.dart';
import 'package:otp/otp.dart';

Dio useDioClient(ServerConfig config) {
  return useMemoized(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://${config.host}:${config.port}',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['X-KVMD-User'] = config.username;

          String authPass = config.password;
          if (config.totpSecret != null && config.totpSecret!.isNotEmpty) {
            final code = OTP.generateTOTPCodeString(
              config.totpSecret!,
              DateTime.now().millisecondsSinceEpoch,
              isGoogle: true,
            );
            authPass = '${config.password}$code';
          }

          options.headers['X-KVMD-Passwd'] = authPass;
          return handler.next(options);
        },
      ),
    );

    if (config.isTrusted) {
      final adapter = dio.httpClientAdapter as IOHttpClientAdapter;
      adapter.createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    return dio;
  }, [config]);
}
