import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  ConsumerState<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends ConsumerState<NotificationSettingsPage> {
  bool _tarefaReminder = true;
  bool _estoqueAlert = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações de Notificação'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Lembretes de Tarefas'),
            subtitle: const Text('Receber notificações para tarefas agendadas'),
            value: _tarefaReminder,
            onChanged: (value) {
              setState(() {
                _tarefaReminder = value;
              });
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Alertas de Estoque'),
            subtitle: const Text('Receber notificações quando estoque estiver baixo'),
            value: _estoqueAlert,
            onChanged: (value) {
              setState(() {
                _estoqueAlert = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
