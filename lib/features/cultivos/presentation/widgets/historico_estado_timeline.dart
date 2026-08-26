import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/historico_transicao.dart';

class HistoricoEstadoTimeline extends StatelessWidget {
  final List<HistoricoTransicao> transicoes;
  final ValueChanged<HistoricoTransicao>? onEditar;

  const HistoricoEstadoTimeline({
    super.key,
    required this.transicoes,
    this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    if (transicoes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        for (final transicao in transicoes)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.indigo.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.swap_horiz,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${transicao.estadoAnterior} → ${transicao.estadoAtual}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm')
                              .format(transicao.dataTransicao),
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        if (transicao.observacoes != null &&
                            transicao.observacoes!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            transicao.observacoes!,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      transicao.diasNoEstado == 1
                          ? '1 dia'
                          : '${transicao.diasNoEstado} dias',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (onEditar != null)
                    IconButton(
                      icon: const Icon(Icons.edit_calendar, size: 20),
                      tooltip: 'Alterar data',
                      visualDensity: VisualDensity.compact,
                      onPressed: () => onEditar!(transicao),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
