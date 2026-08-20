import 'package:flutter/material.dart';

class TarefaCard extends StatelessWidget {
  final dynamic tarefa;
  final VoidCallback? onTap;

  const TarefaCard({
    super.key,
    required this.tarefa,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getPrioridadeColor(tarefa.prioridade),
          child: Icon(
            _getStatusIcon(tarefa.status),
            color: Colors.white,
          ),
        ),
        title: Text(tarefa.titulo),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tarefa.descricao != null)
              Text(
                tarefa.descricao!.length > 50
                    ? '${tarefa.descricao!.substring(0, 50)}...'
                    : tarefa.descricao!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (tarefa.dataVencimento != null)
              Text(
                'Vence: ${_formatDate(tarefa.dataVencimento!)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _isVencida(tarefa.dataVencimento!)
                          ? Colors.red
                          : Colors.grey[600],
                    ),
              ),
          ],
        ),
        trailing: _buildStatusBadge(context),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(tarefa.status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(tarefa.status),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getStatusColor(tarefa.status),
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Color _getPrioridadeColor(String prioridade) {
    switch (prioridade) {
      case 'ALTA':
        return Colors.red;
      case 'MEDIA':
        return Colors.orange;
      case 'BAIXA':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDENTE':
        return Colors.grey;
      case 'EM_ANDAMENTO':
        return Colors.blue;
      case 'CONCLUIDA':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'PENDENTE':
        return Icons.radio_button_unchecked;
      case 'EM_ANDAMENTO':
        return Icons.play_circle;
      case 'CONCLUIDA':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  bool _isVencida(DateTime data) {
    return data.isBefore(DateTime.now());
  }
}
