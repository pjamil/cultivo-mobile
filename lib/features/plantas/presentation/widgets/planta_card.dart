import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/planta.dart';

class PlantaCard extends StatelessWidget {
  final Planta planta;
  final VoidCallback? onTap;

  const PlantaCard({
    super.key,
    required this.planta,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(planta.status),
          child: Icon(
            _getStatusIcon(planta.status),
            color: Colors.white,
          ),
        ),
        title: Text(planta.nome),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              planta.especie,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (planta.dataPlantio != null)
              Text(
                'Plantio: ${DateFormat('dd/MM/yyyy').format(planta.dataPlantio!)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusBadge(context),
            if (planta.rendimentoGramas != null)
              Text(
                '${planta.rendimentoGramas!.toStringAsFixed(0)}g',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(planta.status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(planta.status),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getStatusColor(planta.status),
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ATIVA':
        return Colors.green;
      case 'COLHIDA':
        return Colors.orange;
      case 'PERDIDA':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'ATIVA':
        return Icons.eco;
      case 'COLHIDA':
        return Icons.check_circle;
      case 'PERDIDA':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'ATIVA':
        return 'Ativa';
      case 'COLHIDA':
        return 'Colhida';
      case 'PERDIDA':
        return 'Perdida';
      default:
        return status;
    }
  }
}
