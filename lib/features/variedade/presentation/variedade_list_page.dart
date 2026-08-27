import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/empty_state.dart';
import '../../../core/crud/crud_provider.dart';
import '../providers/variedade_provider.dart';

class VariedadeListPage extends ConsumerWidget {
  const VariedadeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variedadeState = ref.watch(variedadeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Variedades'),
      ),
      body: _buildBody(context, ref, variedadeState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/variedades/nova'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    VariedadeState state,
  ) {
    if (state.status == CrudStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == CrudStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error ?? 'Erro ao carregar variedades'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(variedadeProvider.notifier).load(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return EmptyState(
        icon: Icons.local_florist,
        title: 'Nenhuma variedade',
        message: 'Adicione sua primeira variedade para começar.',
        actionLabel: 'Adicionar Variedade',
        onAction: () => context.push('/variedades/nova'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final variedade = state.items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green[100],
              child: const Icon(Icons.local_florist, color: Colors.green),
            ),
            title: Text(variedade.nome),
            subtitle: Text(
              '${variedade.tipoVariedade} - ${variedade.tipoEspecie}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/variedades/${variedade.id}'),
          ),
        );
      },
    );
  }
}
