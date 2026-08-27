import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../shared/widgets/empty_state.dart';
import '../providers/plantas_provider.dart';
import 'widgets/planta_card.dart';

class PlantasListPage extends ConsumerWidget {
  const PlantasListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantasState = ref.watch(plantasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantas'),
      ),
      body: _buildBody(context, ref, plantasState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/plantas/nova'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    PlantasState state,
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
            Text(state.error ?? 'Erro ao carregar plantas'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(plantasProvider.notifier).load(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return EmptyState(
        icon: Icons.grass,
        title: 'Nenhuma planta',
        message: 'Adicione sua primeira planta para começar.',
        actionLabel: 'Adicionar Planta',
        onAction: () => context.push('/plantas/nova'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final planta = state.items[index];
        return PlantaCard(
          planta: planta,
          onTap: () => context.push('/plantas/${planta.id}'),
        );
      },
    );
  }
}
