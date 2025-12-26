import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../domain/entities/server_config.dart';
import '../data/server_config_repository.dart';
import 'server_config_edit_page.dart';

class ServerConfigListPage extends HookWidget {
  final ServerConfigRepository repository;
  final Function(ServerConfig) onSelect;

  const ServerConfigListPage({
    super.key,
    required this.repository,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final configs = useState<List<ServerConfig>>([]);
    final isLoading = useState(true);

    Future<void> loadConfigs() async {
      isLoading.value = true;
      configs.value = await repository.getConfigs();
      isLoading.value = false;
    }

    useEffect(() {
      loadConfigs();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Servers'),
      ),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : configs.value.isEmpty
              ? const Center(child: Text('No servers configured'))
              : ListView.builder(
                  itemCount: configs.value.length,
                  itemBuilder: (context, index) {
                    final config = configs.value[index];
                    return ListTile(
                      title: Text(config.host),
                      subtitle: Text('${config.username}@${config.host}:${config.port}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServerConfigEditPage(
                                    config: config,
                                    onSave: (newConfig) async {
                                      await repository.updateConfig(index, newConfig);
                                      await loadConfigs();
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await repository.deleteConfig(index);
                              await loadConfigs();
                            },
                          ),
                        ],
                      ),
                      onTap: () => onSelect(config),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServerConfigEditPage(
                onSave: (newConfig) async {
                  await repository.addConfig(newConfig);
                  await loadConfigs();
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
