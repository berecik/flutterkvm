import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../domain/entities/server_config.dart';

class ServerConfigEditPage extends HookWidget {
  final ServerConfig? config;
  final Function(ServerConfig) onSave;

  const ServerConfigEditPage({
    super.key,
    this.config,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final hostController = useTextEditingController(text: config?.host ?? '');
    final portController = useTextEditingController(text: config?.port.toString() ?? '443');
    final usernameController = useTextEditingController(text: config?.username ?? '');
    final passwordController = useTextEditingController(text: config?.password ?? '');
    final totpSecretController = useTextEditingController(text: config?.totpSecret ?? '');
    final isTrusted = useState(config?.isTrusted ?? false);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Scaffold(
      appBar: AppBar(
        title: Text(config == null ? 'Add Server' : 'Edit Server'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: hostController,
                decoration: const InputDecoration(labelText: 'Host'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: portController,
                decoration: const InputDecoration(labelText: 'Port'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  if (int.tryParse(value!) == null) return 'Must be a number';
                  return null;
                },
              ),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: totpSecretController,
                decoration: const InputDecoration(labelText: 'TOTP Secret (Optional)'),
              ),
              SwitchListTile(
                title: const Text('Trusted'),
                value: isTrusted.value,
                onChanged: (value) => isTrusted.value = value,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    final newConfig = ServerConfig(
                      host: hostController.text,
                      port: int.parse(portController.text),
                      username: usernameController.text,
                      password: passwordController.text,
                      totpSecret: totpSecretController.text.isEmpty ? null : totpSecretController.text,
                      isTrusted: isTrusted.value,
                    );
                    onSave(newConfig);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
