import 'package:flutter/material.dart';

import '../../../../core/models/registro_acao.dart';

class RegistroAcaoTipoSelector extends StatelessWidget {
  final TipoAcao selected;
  final ValueChanged<TipoAcao> onChanged;

  const RegistroAcaoTipoSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Selecione o tipo de ação',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tipo de Ação *',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TipoAcao.values.map((tipo) {
              final isSelected = tipo == selected;
              return Semantics(
                label: '${tipo.label}${isSelected ? ', selecionado' : ''}',
                button: true,
                child: ChoiceChip(
                  label: Text(tipo.label),
                  selected: isSelected,
                  onSelected: (_) => onChanged(tipo),
                  selectedColor: _getColor(tipo).withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? _getColor(tipo) : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
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
      case TipoAcao.outro:
        return Colors.grey;
    }
  }
}
