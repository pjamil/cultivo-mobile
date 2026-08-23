import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/empty_state.dart';
import '../providers/tarefas_provider.dart';
import 'widgets/tarefa_card.dart';

class TarefasListPage extends ConsumerWidget {
  const TarefasListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tarefasState = ref.watch(tarefasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => context.push('/tarefas/calendario'),
          ),
        ],
      ),
      body: _buildBody(context, ref, tarefasState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tarefas/nova'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    TarefasState state,
  ) {
    if (state.status == TarefasStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == TarefasStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error ?? 'Erro ao carregar tarefas'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(tarefasProvider.notifier).loadTarefas(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return EmptyState(
        icon: Icons.task_alt,
        title: 'Nenhuma tarefa',
        message: 'Adicione sua primeira tarefa.',
        actionLabel: 'Adicionar Tarefa',
        onAction: () => context.push('/tarefas/nova'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final tarefa = state.items[index];
        return TarefaCard(
          tarefa: tarefa,
          onTap: () => context.push('/tarefas/${tarefa.id}'),
        );
      },
    );
  }
}
