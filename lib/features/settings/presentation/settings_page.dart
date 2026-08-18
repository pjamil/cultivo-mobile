import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações'),
            subtitle: const Text('Gerenciar preferências de notificação'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/configuracoes/notificacoes'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Meus Dados'),
            subtitle: const Text('Editar perfil'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/meus-dados'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre'),
            subtitle: const Text('Cultivo v1.0.0'),
          ),
        ],
      ),
    );
  }
}
