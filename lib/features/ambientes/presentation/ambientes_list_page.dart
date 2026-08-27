import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../shared/widgets/empty_state.dart';
import '../providers/ambientes_provider.dart';

class AmbientesListPage extends ConsumerWidget {
  const AmbientesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ambientesState = ref.watch(ambientesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambientes'),
      ),
      body: _buildBody(context, ref, ambientesState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/ambientes/novo'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AmbientesState state,
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
            Text(state.error ?? 'Erro ao carregar ambientes'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(ambientesProvider.notifier).load(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return EmptyState(
        icon: Icons.home_work,
        title: 'Nenhum ambiente',
        message: 'Adicione seu primeiro ambiente para começar.',
        actionLabel: 'Adicionar Ambiente',
        onAction: () => context.push('/ambientes/novo'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final ambiente = state.items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange[100],
              child: const Icon(Icons.home_work, color: Colors.orange),
            ),
            title: Text(ambiente.nome),
            subtitle: Text(
              ambiente.tipo,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/ambientes/${ambiente.id}'),
          ),
        );
      },
    );
  }
}
