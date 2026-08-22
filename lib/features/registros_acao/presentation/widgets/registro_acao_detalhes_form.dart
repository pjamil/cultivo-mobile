import 'package:flutter/material.dart';

import '../../../../core/models/registro_acao.dart';

class RegistroAcaoDetalhesForm extends StatefulWidget {
  final TipoAcao tipo;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const RegistroAcaoDetalhesForm({
    super.key,
    required this.tipo,
    required this.onChanged,
  });

  @override
  State<RegistroAcaoDetalhesForm> createState() =>
      _RegistroAcaoDetalhesFormState();
}

class _RegistroAcaoDetalhesFormState extends State<RegistroAcaoDetalhesForm> {
  final _quantidadeController = TextEditingController();
  final _unidadeController = TextEditingController();
  final _metodoController = TextEditingController();
  final _produtoController = TextEditingController();
  final _concentracaoController = TextEditingController();
  final _vasoAnteriorController = TextEditingController();
  final _vasoNovoController = TextEditingController();
  final _substratoController = TextEditingController();
  final _motivoController = TextEditingController();

  @override
  void dispose() {
    _quantidadeController.dispose();
    _unidadeController.dispose();
    _metodoController.dispose();
    _produtoController.dispose();
    _concentracaoController.dispose();
    _vasoAnteriorController.dispose();
    _vasoNovoController.dispose();
    _substratoController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  void _updateDetalhes() {
    final detalhes = <String, dynamic>{};

    switch (widget.tipo) {
      case TipoAcao.rega:
        if (_quantidadeController.text.isNotEmpty) {
          detalhes['quantidade'] = double.tryParse(_quantidadeController.text);
        }
        if (_unidadeController.text.isNotEmpty) {
          detalhes['unidadeMedida'] = _unidadeController.text;
        }
        if (_metodoController.text.isNotEmpty) {
          detalhes['metodo'] = _metodoController.text;
        }
        break;
      case TipoAcao.adubacao:
        if (_produtoController.text.isNotEmpty) {
          detalhes['produto'] = _produtoController.text;
        }
        if (_quantidadeController.text.isNotEmpty) {
          detalhes['quantidade'] = double.tryParse(_quantidadeController.text);
        }
        if (_unidadeController.text.isNotEmpty) {
          detalhes['unidadeMedida'] = _unidadeController.text;
        }
        if (_concentracaoController.text.isNotEmpty) {
          detalhes['concentracao'] = _concentracaoController.text;
        }
        break;
      case TipoAcao.transplante:
        if (_vasoAnteriorController.text.isNotEmpty) {
          detalhes['vasoAnterior'] =
              double.tryParse(_vasoAnteriorController.text);
        }
        if (_vasoNovoController.text.isNotEmpty) {
          detalhes['vasoNovo'] = double.tryParse(_vasoNovoController.text);
        }
        if (_substratoController.text.isNotEmpty) {
          detalhes['substrato'] = _substratoController.text;
        }
        if (_motivoController.text.isNotEmpty) {
          detalhes['motivo'] = _motivoController.text;
        }
        break;
      case TipoAcao.outro:
        break;
    }

    widget.onChanged(detalhes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detalhes - ${widget.tipo.label}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        ..._buildFieldsForType(),
      ],
    );
  }

  List<Widget> _buildFieldsForType() {
    switch (widget.tipo) {
      case TipoAcao.rega:
        return [
          TextFormField(
            controller: _quantidadeController,
            decoration: const InputDecoration(
              labelText: 'Quantidade',
              prefixIcon: Icon(Icons.water_drop),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => _updateDetalhes(),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _unidadeController,
            decoration: const InputDecoration(
              labelText: 'Unidade (mL, L)',
              prefixIcon: Icon(Icons.straighten),
            ),
            onChanged: (_) => _updateDetalhes(),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _metodoController,
            decoration: const InputDecoration(
              labelText: 'Método (manual, gotejamento...)',
              prefixIcon: Icon(Icons.settings),
            ),
            onChanged: (_) => _updateDetalhes(),
          ),
        ];
      case TipoAcao.adubacao:
        return [
          TextFormField(
            controller: _produtoController,
            decoration: const InputDecoration(
              labelText: 'Produto/Nutriente',
              prefixIcon: Icon(Icons.science),
            ),
            onChanged: (_) => _updateDetalhes(),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _quantidadeController,
            decoration: const InputDecoration(
              labelText: 'Quantidade',
              prefixIcon: Icon(Icons.scale),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => _updateDetalhes(),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _unidadeController,
            decoration: const InputDecoration(
              labelText: 'Unidade (g, mL, L)',
              prefixIcon: Icon(Icons.straighten),
            ),
            onChanged: (_) => _updateDetalhes(),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _concentracaoController,
            decoration: const InputDecoration(
              labelText: 'Concentração/Diluição',
              prefixIcon: Icon(Icons.water),
            ),
            onChanged: (_) => _updateDetalhes(),
          ),
        ];
      case TipoAcao.transplante:
        return [
          TextFormField(
            controller: _vasoAnteriorController,
            decoration: const InputDecoration(
              labelText: 'Vaso anterior (L)',
              prefixIcon: Icon(Icons.arrow_back),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => _updateDetalhes(),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _vasoNovoController,
            decoration: const InputDecoration(
              labelText: 'Vaso novo (L)',
              prefixIcon: Icon(Icons.arrow_forward),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => _updateDetalhes(),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _substratoController,
            decoration: const InputDecoration(
              labelText: 'Substrato',
              prefixIcon: Icon(Icons.terrain),
            ),
            onChanged: (_) => _updateDetalhes(),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _motivoController,
            decoration: const InputDecoration(
              labelText: 'Motivo',
              prefixIcon: Icon(Icons.help_outline),
            ),
            onChanged: (_) => _updateDetalhes(),
          ),
        ];
      case TipoAcao.outro:
        return [
          const Text(
            'Tipo de ação personalizado',
            style: TextStyle(color: Colors.grey),
          ),
        ];
    }
  }
}
