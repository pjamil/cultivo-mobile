import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/registro_acao.dart';
import 'registro_acao_card.dart';

class RegistrosAcaoTimeline extends StatelessWidget {
  final List<RegistroAcao> registros;
  final ValueChanged<RegistroAcao>? onRegistroTap;

  const RegistrosAcaoTimeline({
    super.key,
    required this.registros,
    this.onRegistroTap,
  });

  @override
  Widget build(BuildContext context) {
    if (registros.isEmpty) {
      return const SizedBox.shrink();
    }

    final groupedByDate = _groupByDate(registros);
    final dates = groupedByDate.keys.toList()..sort((a, b) => b.compareTo(a));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dates.map((date) {
        final dayRegistros = groupedByDate[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _formatDateHeader(date),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
            ...dayRegistros.map(
              (registro) => RegistroAcaoCard(
                registro: registro,
                onTap: onRegistroTap != null
                    ? () => onRegistroTap!(registro)
                    : null,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Map<DateTime, List<RegistroAcao>> _groupByDate(List<RegistroAcao> registros) {
    final map = <DateTime, List<RegistroAcao>>{};
    for (final registro in registros) {
      final date = DateTime(
        registro.data.year,
        registro.data.month,
        registro.data.day,
      );
      map.putIfAbsent(date, () => []).add(registro);
    }
    return map;
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) {
      return 'Hoje';
    } else if (date == yesterday) {
      return 'Ontem';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}
