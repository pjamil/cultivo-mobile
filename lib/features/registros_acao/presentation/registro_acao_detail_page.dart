import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/registro_acao.dart';
import '../providers/registros_acao_provider.dart';

class RegistroAcaoDetailPage extends ConsumerStatefulWidget {
  final int id;

  const RegistroAcaoDetailPage({super.key, required this.id});

  @override
  ConsumerState<RegistroAcaoDetailPage> createState() =>
      _RegistroAcaoDetailPageState();
}

class _RegistroAcaoDetailPageState
    extends ConsumerState<RegistroAcaoDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registrosAcaoProvider.notifier).loadRegistro(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final registrosState = ref.watch(registrosAcaoProvider);

    if (registrosState.status == CrudStatus.loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Registro')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final registro = registrosState.selected ??
        registrosState.items.firstWhere(
          (r) => r.id == widget.id,
          orElse: () => RegistroAcao(
            id: 0,
            tipo: 'OUTRO',
            data: DateTime.now(),
            cultivoId: 0,
          ),
        );

    if (registro.id == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Registro')),
        body: const Center(child: Text('Registro não encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(registro.tipoAcao.label),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push(
                '/registros-acao/${registro.id}/editar?cultivoId=${registro.cultivoId}',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref, registro),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(registro),
            const SizedBox(height: 24),
            _buildDetails(registro),
            if (registro.notas != null && registro.notas!.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildNotas(registro),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(RegistroAcao registro) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _getColor(registro.tipoAcao).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            _getIcon(registro.tipoAcao),
            color: _getColor(registro.tipoAcao),
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                registro.tipoAcao.label,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(registro.data),
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(RegistroAcao registro) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalhes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Cultivo ID', registro.cultivoId.toString()),
            if (registro.plantaId != null)
              _buildDetailRow('Planta ID', registro.plantaId.toString()),
            if (registro.detalhes != null && registro.detalhes!.isNotEmpty)
              _buildDetailRow('Detalhes', registro.detalhes!),
          ],
        ),
      ),
    );
  }

  Widget _buildNotas(RegistroAcao registro) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              registro.notas!,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    RegistroAcao registro,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Registro'),
        content: Text(
          'Tem certeza que deseja excluir este registro de ${registro.tipoAcao.label}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(registrosAcaoProvider.notifier)
                  .deleteRegistro(registro.id);
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getColor(TipoAcao tipo) {
    switch (tipo) {
      case TipoAcao.rega:
        return Colors.blue;
      case TipoAcao.adubacao:
        return Colors.green;
      case TipoAcao.transplante:
        return Colors.orange;
      case TipoAcao.outro:
        return Colors.grey;
    }
  }

  IconData _getIcon(TipoAcao tipo) {
    switch (tipo) {
      case TipoAcao.rega:
        return Icons.water_drop;
      case TipoAcao.adubacao:
        return Icons.science;
      case TipoAcao.transplante:
        return Icons.swap_horiz;
      case TipoAcao.outro:
        return Icons.more_horiz;
    }
  }
}
