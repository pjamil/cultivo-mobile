import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/confirmation_dialog.dart';
import '../providers/variedade_provider.dart';

class VariedadeDetailPage extends ConsumerStatefulWidget {
  final int id;

  const VariedadeDetailPage({super.key, required this.id});

  @override
  ConsumerState<VariedadeDetailPage> createState() => _VariedadeDetailPageState();
}

class _VariedadeDetailPageState extends ConsumerState<VariedadeDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(variedadeProvider.notifier).loadVariedade(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final variedadeState = ref.watch(variedadeProvider);

    ref.listen<VariedadeState>(variedadeProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(variedadeProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Variedade'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/variedades/${widget.id}/editar'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      body: variedadeState.selectedVariedade == null
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
                        _buildInfoRow(
                          context,
                          'Nome',
                          variedadeState.selectedVariedade!.nome,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Tipo',
                          variedadeState.selectedVariedade!.tipoVariedade,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Espécie',
                          variedadeState.selectedVariedade!.tipoEspecie,
                        ),
                        if (variedadeState.selectedVariedade!.descricao !=
                            null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Descrição',
                            variedadeState.selectedVariedade!.descricao!,
                          ),
                        ],
                        if (variedadeState.selectedVariedade!.tempoFloracao !=
                            null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Tempo de Floração',
                            variedadeState.selectedVariedade!.tempoFloracao!,
                          ),
                        ],
                        if (variedadeState.selectedVariedade!.origem !=
                            null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Origem',
                            variedadeState.selectedVariedade!.origem!,
                          ),
                        ],
                        if (variedadeState.selectedVariedade!.caracteristicas !=
                            null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Características',
                            variedadeState.selectedVariedade!.caracteristicas!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
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
      title: 'Excluir Variedade',
      message: 'Tem certeza que deseja excluir esta variedade?',
      confirmText: 'Excluir',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      await ref.read(variedadeProvider.notifier).deleteVariedade(widget.id);
      if (context.mounted) {
        context.pop();
      }
    }
  }
}
