import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/empty_state.dart';
import '../providers/diario_provider.dart';

class DiarioListPage extends ConsumerWidget {
  const DiarioListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diarioState = ref.watch(diarioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diário'),
      ),
      body: _buildBody(context, ref, diarioState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/diario/novo'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    DiarioState state,
  ) {
    if (state.status == DiarioStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == DiarioStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error ?? 'Erro ao carregar diários'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(diarioProvider.notifier).loadDiarios(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (state.diarios.isEmpty) {
      return EmptyState(
        icon: Icons.book,
        title: 'Nenhuma entrada',
        message: 'Adicione sua primeira entrada no diário.',
        actionLabel: 'Nova Entrada',
        onAction: () => context.push('/diario/novo'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: state.diarios.length,
      itemBuilder: (context, index) {
        final diario = state.diarios[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.book, color: Colors.blue),
            ),
            title: Text(diario.titulo),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  diario.conteudo.length > 50
                      ? '${diario.conteudo.substring(0, 50)}...'
                      : diario.conteudo,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (diario.data != null)
                  Text(
                    DateFormat('dd/MM/yyyy').format(diario.data!),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/diario/${diario.id}'),
          ),
        );
      },
    );
  }
}
