import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterkvm/features/auth/data/server_config_repository.dart';
import 'package:flutterkvm/features/auth/domain/entities/server_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ServerConfigRepository', () {
    late ServerConfigRepository repository;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repository = ServerConfigRepository();
    });

    final testConfig = ServerConfig(
      host: 'localhost',
      username: 'admin',
      password: 'password',
    );

    test('getConfigs returns empty list initially', () async {
      final configs = await repository.getConfigs();
      expect(configs, isEmpty);
    });

    test('addConfig saves the config', () async {
      await repository.addConfig(testConfig);
      final configs = await repository.getConfigs();
      expect(configs.length, 1);
      expect(configs.first.host, 'localhost');
    });

    test('updateConfig modifies the config at index', () async {
      await repository.addConfig(testConfig);
      final updatedConfig = testConfig.copyWith(host: 'newhost');
      await repository.updateConfig(0, updatedConfig);

      final configs = await repository.getConfigs();
      expect(configs.length, 1);
      expect(configs.first.host, 'newhost');
    });

    test('deleteConfig removes the config at index', () async {
      await repository.addConfig(testConfig);
      await repository.deleteConfig(0);

      final configs = await repository.getConfigs();
      expect(configs, isEmpty);
    });

    test('saveConfigs persists multiple configs', () async {
      final configsToSave = [
        testConfig,
        testConfig.copyWith(host: 'host2'),
      ];
      await repository.saveConfigs(configsToSave);

      final loadedConfigs = await repository.getConfigs();
      expect(loadedConfigs.length, 2);
      expect(loadedConfigs[0].host, 'localhost');
      expect(loadedConfigs[1].host, 'host2');
    });
  });
}
