import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/empty_state.dart';
import '../../../core/crud/crud_provider.dart';
import '../providers/insumos_provider.dart';

class InsumosListPage extends ConsumerWidget {
  const InsumosListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insumosState = ref.watch(insumosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insumos'),
      ),
      body: _buildBody(context, ref, insumosState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/insumos/novo'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    InsumosState state,
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
            Text(state.error ?? 'Erro ao carregar insumos'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(insumosProvider.notifier).loadInsumos(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return EmptyState(
        icon: Icons.inventory,
        title: 'Nenhum insumo',
        message: 'Adicione seu primeiro insumo.',
        actionLabel: 'Adicionar Insumo',
        onAction: () => context.push('/insumos/novo'),
      );
    }

    final estoqueBaixo = state.items.where((i) => i.isEstoqueBaixo).toList();

    return Column(
      children: [
        if (estoqueBaixo.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.orange[100],
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${estoqueBaixo.length} insumo(s) com estoque baixo',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final insumo = state.items[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: insumo.isEstoqueBaixo
                        ? Colors.red[100]
                        : Colors.green[100],
                    child: Icon(
                      Icons.inventory,
                      color: insumo.isEstoqueBaixo ? Colors.red : Colors.green,
                    ),
                  ),
                  title: Text(insumo.nome),
                  subtitle: Text(
                    '${insumo.quantidade} ${insumo.unidadeMedida} (mín: ${insumo.estoqueMinimo})',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (insumo.isEstoqueBaixo)
                        const Icon(Icons.warning,
                            color: Colors.orange, size: 20),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => context.push('/insumos/${insumo.id}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
