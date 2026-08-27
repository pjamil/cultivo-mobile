import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/confirmation_dialog.dart';
import '../providers/meio_cultivo_provider.dart';

class MeioCultivoDetailPage extends ConsumerStatefulWidget {
  final int id;

  const MeioCultivoDetailPage({super.key, required this.id});

  @override
  ConsumerState<MeioCultivoDetailPage> createState() =>
      _MeioCultivoDetailPageState();
}

class _MeioCultivoDetailPageState extends ConsumerState<MeioCultivoDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(meioCultivoProvider.notifier).loadById(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final meioCultivoState = ref.watch(meioCultivoProvider);

    ref.listen<MeioCultivoState>(meioCultivoProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(meioCultivoProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Meio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/meios-cultivo/${widget.id}/editar'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      body: meioCultivoState.selected == null
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
                          'Tipo',
                          meioCultivoState.selected!.tipo,
                        ),
                        if (meioCultivoState.selected!.descricao != null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Descrição',
                            meioCultivoState.selected!.descricao!,
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
      title: 'Excluir Meio',
      message: 'Tem certeza que deseja excluir este meio de cultivo?',
      confirmText: 'Excluir',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      await ref.read(meioCultivoProvider.notifier).delete(widget.id);
      if (context.mounted) {
        context.pop();
      }
    }
  }
}
