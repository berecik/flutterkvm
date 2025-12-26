import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutterkvm/features/atx/data/atx_repository.dart';
import 'package:flutterkvm/features/atx/presentation/hooks/use_atx_status.dart';

class PowerControlPanel extends HookWidget {
  final AtxRepository repository;

  const PowerControlPanel({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final statusSnapshot = useAtxStatus(repository);
    final isLoading = useState(false);

    Future<void> handleAction(Future<void> Function() action) async {
      isLoading.value = true;
      try {
        await action();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Action successful')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      } finally {
        isLoading.value = false;
      }
    }

    return Column(
      children: [
        if (statusSnapshot.hasError)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Status Error: ${statusSnapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _LedIndicator(
              label: 'Power',
              isOn: statusSnapshot.data?.power ?? false,
              color: Colors.green,
            ),
            _LedIndicator(
              label: 'HDD',
              isOn: statusSnapshot.data?.hdd ?? false,
              color: Colors.amber,
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isLoading.value) const LinearProgressIndicator(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: isLoading.value ? null : () => handleAction(repository.powerOn),
              child: const Text('Power On'),
            ),
            ElevatedButton(
              onPressed: isLoading.value ? null : () => handleAction(repository.powerOff),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Power Off'),
            ),
            ElevatedButton(
              onPressed: isLoading.value ? null : () => handleAction(repository.powerReset),
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}

class _LedIndicator extends StatelessWidget {
  final String label;
  final bool isOn;
  final Color color;

  const _LedIndicator({
    required this.label,
    required this.isOn,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOn ? color : Colors.grey,
            boxShadow: isOn
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
