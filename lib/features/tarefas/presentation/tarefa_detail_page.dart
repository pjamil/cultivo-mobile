import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/confirmation_dialog.dart';
import '../providers/tarefas_provider.dart';

class TarefaDetailPage extends ConsumerStatefulWidget {
  final int id;

  const TarefaDetailPage({super.key, required this.id});

  @override
  ConsumerState<TarefaDetailPage> createState() => _TarefaDetailPageState();
}

class _TarefaDetailPageState extends ConsumerState<TarefaDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tarefasProvider.notifier).loadById(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tarefasState = ref.watch(tarefasProvider);

    ref.listen<TarefasState>(tarefasProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(tarefasProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Tarefa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/tarefas/${widget.id}/editar'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      body: tarefasState.selected == null
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
                        Text(
                          tarefasState.selected!.titulo,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          context,
                          'Status',
                          _getStatusText(tarefasState.selected!.status),
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Prioridade',
                          _getPrioridadeText(tarefasState.selected!.prioridade),
                        ),
                        if (tarefasState.selected!.dataVencimento != null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Vencimento',
                            DateFormat('dd/MM/yyyy')
                                .format(tarefasState.selected!.dataVencimento!),
                          ),
                        ],
                        if (tarefasState.selected!.descricao != null &&
                            tarefasState.selected!.descricao!.isNotEmpty) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Descrição',
                            tarefasState.selected!.descricao!,
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

  String _getStatusText(String status) {
    switch (status) {
      case 'PENDENTE':
        return 'Pendente';
      case 'EM_ANDAMENTO':
        return 'Em Andamento';
      case 'CONCLUIDA':
        return 'Concluída';
      default:
        return status;
    }
  }

  String _getPrioridadeText(String prioridade) {
    switch (prioridade) {
      case 'BAIXA':
        return 'Baixa';
      case 'MEDIA':
        return 'Média';
      case 'ALTA':
        return 'Alta';
      default:
        return prioridade;
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Excluir Tarefa',
      message: 'Tem certeza que deseja excluir esta tarefa?',
      confirmText: 'Excluir',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      await ref.read(tarefasProvider.notifier).delete(widget.id);
      if (context.mounted) {
        context.pop();
      }
    }
  }
}
