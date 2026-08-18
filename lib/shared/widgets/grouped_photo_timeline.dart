import 'package:flutter/material.dart';

import '../../../core/models/foto.dart';
import 'photo_timeline.dart';

class GroupedPhotoTimeline extends StatelessWidget {
  final List<Foto> fotos;
  final Function(Foto)? onFotoTap;

  const GroupedPhotoTimeline({
    super.key,
    required this.fotos,
    this.onFotoTap,
  });

  @override
  Widget build(BuildContext context) {
    if (fotos.isEmpty) {
      return const Center(
        child: Text('Nenhuma foto'),
      );
    }

    final grouped = _groupByPhase(fotos);
    final phases = grouped.keys.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final phase in phases) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(_getPhaseIcon(phase), size: 20, color: _getPhaseColor(phase)),
                const SizedBox(width: 8),
                Text(
                  _getPhaseLabel(phase),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _getPhaseColor(phase),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${grouped[phase]!.length})',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          PhotoTimeline(
            fotos: grouped[phase]!,
            onFotoTap: onFotoTap,
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Map<String, List<Foto>> _groupByPhase(List<Foto> fotos) {
    final grouped = <String, List<Foto>>{};
    for (final foto in fotos) {
      final phase = foto.cultivoEstado ?? 'GERAL';
      grouped.putIfAbsent(phase, () => []).add(foto);
    }
    return grouped;
  }

  String _getPhaseLabel(String phase) {
    const labels = {
      'PLANEJADO': 'Planejado',
      'GERMINANDO': 'Germinando',
      'PLANTADO': 'Plantado',
      'VEGETATIVO': 'Vegetativo',
      'FLORACAO': 'Floração',
      'FRUTIFICACAO': 'Frutificação',
      'COLHIDO': 'Colhido',
      'CANCELADO': 'Cancelado',
      'GERAL': 'Geral',
    };
    return labels[phase] ?? phase;
  }

  IconData _getPhaseIcon(String phase) {
    const icons = {
      'PLANEJADO': Icons.edit_calendar,
      'GERMINANDO': Icons.spa,
      'PLANTADO': Icons.grass,
      'VEGETATIVO': Icons.park,
      'FLORACAO': Icons.local_florist,
      'FRUTIFICACAO': Icons.eco,
      'COLHIDO': Icons.agriculture,
      'CANCELADO': Icons.cancel,
      'GERAL': Icons.photo_library,
    };
    return icons[phase] ?? Icons.photo_library;
  }

  Color _getPhaseColor(String phase) {
    const colors = {
      'PLANEJADO': Colors.blue,
      'GERMINANDO': Colors.green,
      'PLANTADO': Colors.lightGreen,
      'VEGETATIVO': Colors.green,
      'FLORACAO': Colors.pink,
      'FRUTIFICACAO': Colors.orange,
      'COLHIDO': Colors.brown,
      'CANCELADO': Colors.red,
      'GERAL': Colors.grey,
    };
    return colors[phase] ?? Colors.grey;
  }
}
