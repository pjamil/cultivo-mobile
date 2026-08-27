import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/empty_state.dart';
import '../../../core/crud/crud_provider.dart';
import '../providers/meio_cultivo_provider.dart';

class MeioCultivoListPage extends ConsumerWidget {
  const MeioCultivoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meioCultivoState = ref.watch(meioCultivoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meios de Cultivo'),
      ),
      body: _buildBody(context, ref, meioCultivoState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/meios-cultivo/novo'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    MeioCultivoState state,
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
            Text(state.error ?? 'Erro ao carregar meios de cultivo'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(meioCultivoProvider.notifier).load(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return EmptyState(
        icon: Icons.water_drop,
        title: 'Nenhum meio de cultivo',
        message: 'Adicione seu primeiro meio de cultivo.',
        actionLabel: 'Adicionar Meio',
        onAction: () => context.push('/meios-cultivo/novo'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final meio = state.items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.water_drop, color: Colors.blue),
            ),
            title: Text(meio.tipo),
            subtitle: meio.descricao != null
                ? Text(
                    meio.descricao!,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                : null,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/meios-cultivo/${meio.id}'),
          ),
        );
      },
    );
  }
}
