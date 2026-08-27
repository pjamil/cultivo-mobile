import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/confirmation_dialog.dart';
import '../providers/ambientes_provider.dart';

class AmbienteDetailPage extends ConsumerStatefulWidget {
  final int id;

  const AmbienteDetailPage({super.key, required this.id});

  @override
  ConsumerState<AmbienteDetailPage> createState() => _AmbienteDetailPageState();
}

class _AmbienteDetailPageState extends ConsumerState<AmbienteDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ambientesProvider.notifier).loadById(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ambientesState = ref.watch(ambientesProvider);

    ref.listen<AmbientesState>(ambientesProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(ambientesProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Ambiente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/ambientes/${widget.id}/editar'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      body: ambientesState.selected == null
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
                          ambientesState.selected!.nome,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Tipo',
                          ambientesState.selected!.tipo,
                        ),
                        if (ambientesState.selected!.descricao != null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Descrição',
                            ambientesState.selected!.descricao!,
                          ),
                        ],
                        if (ambientesState.selected!.comprimento != null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Comprimento',
                            '${ambientesState.selected!.comprimento}m',
                          ),
                        ],
                        if (ambientesState.selected!.largura != null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Largura',
                            '${ambientesState.selected!.largura}m',
                          ),
                        ],
                        if (ambientesState.selected!.altura != null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Altura',
                            '${ambientesState.selected!.altura}m',
                          ),
                        ],
                        if (ambientesState.selected!.tempoExposicao !=
                            null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Tempo de Exposição',
                            ambientesState.selected!.tempoExposicao!,
                          ),
                        ],
                        if (ambientesState.selected!.orientacao != null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Orientação',
                            ambientesState.selected!.orientacao!,
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
      title: 'Excluir Ambiente',
      message: 'Tem certeza que deseja excluir este ambiente?',
      confirmText: 'Excluir',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      await ref.read(ambientesProvider.notifier).delete(widget.id);
      if (context.mounted) {
        context.pop();
      }
    }
  }
}
