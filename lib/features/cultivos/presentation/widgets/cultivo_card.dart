import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/cultivo.dart';
import 'state_badge.dart';

class CultivoCard extends StatelessWidget {
  final Cultivo cultivo;
  final VoidCallback? onTap;

  const CultivoCard({
    super.key,
    required this.cultivo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[100],
          child: const Icon(Icons.spa, color: Colors.green),
        ),
        title: Text(cultivo.nome),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cultivo.dataInicio != null)
              Text(
                'Início: ${DateFormat('dd/MM/yyyy').format(cultivo.dataInicio!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        trailing: StateBadge(status: cultivo.status),
        onTap: onTap,
      ),
    );
  }
}
