import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/dashboard_data.dart';

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
        final tipoLabel = _getTipoLabel(atividade.tipo);
        final hasDescricao = atividade.descricao.isNotEmpty;
        final subtitulo = hasDescricao
            ? '$tipoLabel • ${_formatData(atividade.data)}'
            : _formatData(atividade.data);
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
            hasDescricao ? atividade.descricao : tipoLabel,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            subtitulo,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        );
      },
    );
  }

  String _formatData(DateTime data) {
    if (data.hour == 0 && data.minute == 0 && data.second == 0) {
      return DateFormat('dd/MM/yyyy').format(data);
    }
    return DateFormat('dd/MM/yyyy HH:mm').format(data);
  }

  String _getTipoLabel(String tipo) {
    switch (tipo) {
      case 'IRRIGACAO':
        return 'Irrigação';
      case 'ADUBACAO':
        return 'Adubação';
      case 'COLHEITA':
        return 'Colheita';
      case 'PLANTIO':
        return 'Plantio';
      case 'PODA':
        return 'Poda';
      case 'PLANTA':
        return 'Planta';
      case 'CULTIVO':
        return 'Cultivo';
      case 'TAREFA':
        return 'Tarefa';
      case 'DIARIO':
        return 'Diário';
      default:
        return tipo;
    }
  }

  IconData _getIcon(String tipo) {
    switch (tipo) {
      case 'IRRIGACAO':
        return Icons.water_drop;
      case 'ADUBACAO':
        return Icons.eco;
      case 'COLHEITA':
        return Icons.agriculture;
      case 'PLANTIO':
        return Icons.grass;
      case 'PODA':
        return Icons.content_cut;
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
      case 'IRRIGACAO':
        return Colors.blue;
      case 'ADUBACAO':
        return Colors.green;
      case 'COLHEITA':
        return Colors.amber;
      case 'PLANTIO':
        return Colors.lightGreen;
      case 'PODA':
        return Colors.purple;
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
