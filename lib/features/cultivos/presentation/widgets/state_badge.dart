import 'package:flutter/material.dart';

class StateBadge extends StatelessWidget {
  final String status;

  const StateBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(status).withOpacity(0.3),
        ),
      ),
      child: Text(
        _getStatusText(status),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getStatusColor(status),
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PLANEJADO':
        return Colors.grey;
      case 'GERMINANDO':
        return Colors.brown;
      case 'PLANTADO':
        return Colors.lightGreen;
      case 'VEGETATIVO':
        return Colors.green;
      case 'FLORACAO':
        return Colors.pink;
      case 'FRUTIFICACAO':
        return Colors.orange;
      case 'COLHIDO':
        return Colors.blue;
      case 'CANCELADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'PLANEJADO':
        return 'Planejado';
      case 'GERMINANDO':
        return 'Germinando';
      case 'PLANTADO':
        return 'Plantado';
      case 'VEGETATIVO':
        return 'Vegetativo';
      case 'FLORACAO':
        return 'Floração';
      case 'FRUTIFICACAO':
        return 'Frutificação';
      case 'COLHIDO':
        return 'Colhido';
      case 'CANCELADO':
        return 'Cancelado';
      default:
        return status;
    }
  }
}
