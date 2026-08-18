import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/confirmation_dialog.dart';
import '../providers/usuario_provider.dart';
import '../../auth/providers/auth_provider.dart';

class MeusDadosPage extends ConsumerWidget {
  const MeusDadosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuarioState = ref.watch(usuarioProvider);

    ref.listen<UsuarioState>(usuarioProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(usuarioProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Dados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/meus-dados/editar'),
          ),
        ],
      ),
      body: usuarioState.usuario == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person, size: 40),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          context,
                          'Nome',
                          usuarioState.usuario!.nome,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Email',
                          usuarioState.usuario!.email,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Papel',
                          usuarioState.usuario!.papel,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Status',
                          usuarioState.usuario!.ativo ? 'Ativo' : 'Inativo',
                        ),
                        if (usuarioState.usuario!.dataCadastro != null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Membro desde',
                            usuarioState.usuario!.dataCadastro!
                                .toLocal()
                                .toString()
                                .split(' ')[0],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _showDeleteDialog(context, ref),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    'Excluir Conta',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Excluir Conta',
      message: 'Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.',
      confirmText: 'Excluir',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      await ref.read(usuarioProvider.notifier).deleteAccount();
      ref.read(authProvider.notifier).logout();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }
}
