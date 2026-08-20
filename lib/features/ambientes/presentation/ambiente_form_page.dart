import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/ambiente.dart';
import '../providers/ambientes_provider.dart';
import '../../../core/crud/crud_provider.dart';

class AmbienteFormPage extends ConsumerStatefulWidget {
  final int? id;

  const AmbienteFormPage({super.key, this.id});

  @override
  ConsumerState<AmbienteFormPage> createState() => _AmbienteFormPageState();
}

class _AmbienteFormPageState extends ConsumerState<AmbienteFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _comprimentoController;
  late TextEditingController _alturaController;
  late TextEditingController _larguraController;
  late TextEditingController _tempoExposicaoController;
  late TextEditingController _orientacaoController;
  String _tipo = 'INDOOR';
  bool _fieldsPopulated = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _descricaoController = TextEditingController();
    _comprimentoController = TextEditingController();
    _alturaController = TextEditingController();
    _larguraController = TextEditingController();
    _tempoExposicaoController = TextEditingController();
    _orientacaoController = TextEditingController();

    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(ambientesProvider.notifier).loadAmbiente(widget.id!);
      });
    }
  }

  void _populateFields(Ambiente ambiente) {
    if (_fieldsPopulated) return;
    _fieldsPopulated = true;

    _nomeController.text = ambiente.nome;
    _descricaoController.text = ambiente.descricao ?? '';
    _comprimentoController.text = ambiente.comprimento?.toString() ?? '';
    _alturaController.text = ambiente.altura?.toString() ?? '';
    _larguraController.text = ambiente.largura?.toString() ?? '';
    _tempoExposicaoController.text = ambiente.tempoExposicao ?? '';
    _orientacaoController.text = ambiente.orientacao ?? '';
    _tipo = ambiente.tipo;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _comprimentoController.dispose();
    _alturaController.dispose();
    _larguraController.dispose();
    _tempoExposicaoController.dispose();
    _orientacaoController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final ambiente = Ambiente(
        id: widget.id ?? 0,
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim().isEmpty
            ? null
            : _descricaoController.text.trim(),
        tipo: _tipo,
        comprimento: double.tryParse(_comprimentoController.text),
        altura: double.tryParse(_alturaController.text),
        largura: double.tryParse(_larguraController.text),
        tempoExposicao: _tempoExposicaoController.text.trim().isEmpty
            ? null
            : _tempoExposicaoController.text.trim(),
        orientacao: _orientacaoController.text.trim().isEmpty
            ? null
            : _orientacaoController.text.trim(),
      );

      if (widget.id != null) {
        ref.read(ambientesProvider.notifier).updateAmbiente(ambiente);
      } else {
        ref.read(ambientesProvider.notifier).createAmbiente(ambiente);
      }

      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ambientesState = ref.watch(ambientesProvider);

    // Populate fields when editing
    if (widget.id != null && ambientesState.selected != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateFields(ambientesState.selected!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? 'Editar Ambiente' : 'Novo Ambiente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome *',
                  prefixIcon: Icon(Icons.home_work),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _tipo,
                decoration: const InputDecoration(
                  labelText: 'Tipo *',
                  prefixIcon: Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(value: 'INDOOR', child: Text('Indoor')),
                  DropdownMenuItem(value: 'OUTDOOR', child: Text('Outdoor')),
                  DropdownMenuItem(value: 'ESTUFA', child: Text('Estufa')),
                  DropdownMenuItem(
                      value: 'GROW_TENT', child: Text('Grow Tent')),
                  DropdownMenuItem(value: 'OUTRO', child: Text('Outro')),
                ],
                onChanged: (value) {
                  setState(() {
                    _tipo = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _comprimentoController,
                      decoration: const InputDecoration(
                        labelText: 'Comprimento (m)',
                        prefixIcon: Icon(Icons.straighten),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _larguraController,
                      decoration: const InputDecoration(
                        labelText: 'Largura (m)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _alturaController,
                decoration: const InputDecoration(
                  labelText: 'Altura (m)',
                  prefixIcon: Icon(Icons.height),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tempoExposicaoController,
                decoration: const InputDecoration(
                  labelText: 'Tempo de Exposição',
                  prefixIcon: Icon(Icons.wb_sunny),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _orientacaoController,
                decoration: const InputDecoration(
                  labelText: 'Orientação',
                  prefixIcon: Icon(Icons.navigation),
                  hintText: 'Ex: Norte, Sul, Leste, Oeste',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: ambientesState.status == CrudStatus.loading
                    ? null
                    : _submit,
                child: ambientesState.status == CrudStatus.loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.id != null ? 'Salvar' : 'Criar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
