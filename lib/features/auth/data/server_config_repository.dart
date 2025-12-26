import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/server_config.dart';

class ServerConfigRepository {
  static const String _key = 'server_configs';

  Future<List<ServerConfig>> getConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? configsJson = prefs.getString(_key);
    if (configsJson == null) {
      return [];
    }
    final List<dynamic> decoded = jsonDecode(configsJson);
    return decoded.map((item) => ServerConfig.fromJson(item)).toList();
  }

  Future<void> saveConfigs(List<ServerConfig> configs) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(configs.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  Future<void> addConfig(ServerConfig config) async {
    final configs = await getConfigs();
    configs.add(config);
    await saveConfigs(configs);
  }

  Future<void> updateConfig(int index, ServerConfig config) async {
    final configs = await getConfigs();
    if (index >= 0 && index < configs.length) {
      configs[index] = config;
      await saveConfigs(configs);
    }
  }

  Future<void> deleteConfig(int index) async {
    final configs = await getConfigs();
    if (index >= 0 && index < configs.length) {
      configs.removeAt(index);
      await saveConfigs(configs);
    }
  }
}
