import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/dashboard_repository.dart';

class ActivityFeed extends StatelessWidget {
  final List<AtividadeRecente> atividades;

  const ActivityFeed({super.key, required this.atividades});

  @override
  Widget build(BuildContext context) {
    if (atividades.isEmpty) {
      return const Center(
        child: Text('Nenhuma atividade recente'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: atividades.length,
      itemBuilder: (context, index) {
        final atividade = atividades[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor:
                _getIconColor(atividade.tipo).withValues(alpha: 0.1),
            child: Icon(
              _getIcon(atividade.tipo),
              color: _getIconColor(atividade.tipo),
              size: 20,
            ),
          ),
          title: Text(
            atividade.titulo,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            DateFormat('dd/MM/yyyy HH:mm').format(atividade.data),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        );
      },
    );
  }

  IconData _getIcon(String tipo) {
    switch (tipo) {
      case 'PLANTA':
        return Icons.grass;
      case 'CULTIVO':
        return Icons.spa;
      case 'TAREFA':
        return Icons.task_alt;
      case 'DIARIO':
        return Icons.book;
      default:
        return Icons.circle;
    }
  }

  Color _getIconColor(String tipo) {
    switch (tipo) {
      case 'PLANTA':
        return Colors.green;
      case 'CULTIVO':
        return Colors.blue;
      case 'TAREFA':
        return Colors.orange;
      case 'DIARIO':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
