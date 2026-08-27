import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/confirmation_dialog.dart';
import '../providers/dados_ambientais_provider.dart';

class DadoAmbientalDetailPage extends ConsumerStatefulWidget {
  final int id;

  const DadoAmbientalDetailPage({super.key, required this.id});

  @override
  ConsumerState<DadoAmbientalDetailPage> createState() =>
      _DadoAmbientalDetailPageState();
}

class _DadoAmbientalDetailPageState
    extends ConsumerState<DadoAmbientalDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dadosAmbientaisProvider.notifier).loadById(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dadosAmbientaisProvider);

    ref.listen(dadosAmbientaisProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(dadosAmbientaisProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Leitura'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                context.push('/dados-ambientais/${widget.id}/editar'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: state.selected == null
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
                          'Tipo de Medição',
                          state.selected!.tipoLabel,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Valor',
                          '${state.selected!.valor} ${state.selected!.unidade}',
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Unidade',
                          state.selected!.unidade,
                        ),
                        if (state.selected!.cultivoId != null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'ID do Cultivo',
                            state.selected!.cultivoId.toString(),
                          ),
                        ],
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Data e Hora',
                          state.selected!.dataHora != null
                              ? DateFormat('dd/MM/yyyy HH:mm')
                                  .format(state.selected!.dataHora!)
                              : '-',
                        ),
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

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Excluir Leitura',
      message: 'Tem certeza que deseja excluir esta leitura?',
      confirmText: 'Excluir',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      await ref.read(dadosAmbientaisProvider.notifier).delete(widget.id);
      if (context.mounted) {
        context.pop();
      }
    }
  }
}
