import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/confirmation_dialog.dart';
import '../providers/insumos_provider.dart';

class InsumoDetailPage extends ConsumerStatefulWidget {
  final int id;

  const InsumoDetailPage({super.key, required this.id});

  @override
  ConsumerState<InsumoDetailPage> createState() => _InsumoDetailPageState();
}

class _InsumoDetailPageState extends ConsumerState<InsumoDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(insumosProvider.notifier).loadById(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final insumosState = ref.watch(insumosProvider);

    ref.listen<InsumosState>(insumosProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(insumosProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Insumo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/insumos/${widget.id}/editar'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      body: insumosState.selected == null
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                insumosState.selected!.nome,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                            if (insumosState.selected!.isEstoqueBaixo)
                              const Icon(Icons.warning, color: Colors.orange),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          context,
                          'Código',
                          insumosState.selected!.codigo,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Tipo',
                          insumosState.selected!.tipo,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Quantidade',
                          '${insumosState.selected!.quantidade} ${insumosState.selected!.unidadeMedida}',
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Estoque Mínimo',
                          '${insumosState.selected!.estoqueMinimo} ${insumosState.selected!.unidadeMedida}',
                        ),
                        if (insumosState.selected!.dataCadastro != null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Cadastrado em',
                            DateFormat('dd/MM/yyyy')
                                .format(insumosState.selected!.dataCadastro!),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (insumosState.selected!.isEstoqueBaixo) ...[
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.orange[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.orange),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Estoque abaixo do mínimo! Considere repor.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.orange[800],
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Excluir Insumo',
      message: 'Tem certeza que deseja excluir este insumo?',
      confirmText: 'Excluir',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      await ref.read(insumosProvider.notifier).delete(widget.id);
      if (context.mounted) {
        context.pop();
      }
    }
  }
}
