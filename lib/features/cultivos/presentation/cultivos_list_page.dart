import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/empty_state.dart';
import '../providers/cultivos_provider.dart';
import 'widgets/cultivo_card.dart';

class CultivosListPage extends ConsumerWidget {
  const CultivosListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cultivosState = ref.watch(cultivosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cultivos'),
      ),
      body: _buildBody(context, ref, cultivosState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/cultivos/novo'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    CultivosState state,
  ) {
    if (state.status == CultivosStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == CultivosStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error ?? 'Erro ao carregar cultivos'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(cultivosProvider.notifier).load(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return EmptyState(
        icon: Icons.spa,
        title: 'Nenhum cultivo',
        message: 'Adicione seu primeiro cultivo para começar.',
        actionLabel: 'Adicionar Cultivo',
        onAction: () => context.push('/cultivos/novo'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final cultivo = state.items[index];
        return CultivoCard(
          cultivo: cultivo,
          onTap: () => context.push('/cultivos/${cultivo.id}'),
        );
      },
    );
  }
}
