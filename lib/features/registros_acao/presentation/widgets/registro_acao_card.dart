import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/registro_acao.dart';

class RegistroAcaoCard extends StatelessWidget {
  final RegistroAcao registro;
  final VoidCallback? onTap;

  const RegistroAcaoCard({
    super.key,
    required this.registro,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'Registro de ${registro.tipoAcao.label}, ${DateFormat('dd/MM/yyyy HH:mm').format(registro.data)}',
      button: true,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Semantics(
                  label: registro.tipoAcao.label,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                          _getColor(registro.tipoAcao).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIcon(registro.tipoAcao),
                      color: _getColor(registro.tipoAcao),
                    ),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (registro.notas != null &&
                          registro.notas!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          registro.notas!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('dd/MM').format(registro.data),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      DateFormat('HH:mm').format(registro.data),
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
      case TipoAcao.irrigacao:
        return Colors.lightBlue;
      case TipoAcao.colheita:
        return Colors.amber;
      case TipoAcao.plantio:
        return Colors.lightGreen;
      case TipoAcao.poda:
        return Colors.purple;
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
      case TipoAcao.irrigacao:
        return Icons.water_drop;
      case TipoAcao.colheita:
        return Icons.agriculture;
      case TipoAcao.plantio:
        return Icons.grass;
      case TipoAcao.poda:
        return Icons.content_cut;
      case TipoAcao.outro:
        return Icons.more_horiz;
    }
  }
}
