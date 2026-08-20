import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/variedade.dart';
import '../../../core/crud/crud_provider.dart';
import '../providers/variedade_provider.dart';

class VariedadeFormPage extends ConsumerStatefulWidget {
  final int? id;

  const VariedadeFormPage({super.key, this.id});

  @override
  ConsumerState<VariedadeFormPage> createState() => _VariedadeFormPageState();
}

class _VariedadeFormPageState extends ConsumerState<VariedadeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _tempoFloracaoController;
  late TextEditingController _origemController;
  late TextEditingController _caracteristicasController;
  String _tipoVariedade = 'INDICA';
  String _tipoEspecie = 'REGULAR';
  bool _fieldsPopulated = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _descricaoController = TextEditingController();
    _tempoFloracaoController = TextEditingController();
    _origemController = TextEditingController();
    _caracteristicasController = TextEditingController();

    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(variedadeProvider.notifier).loadVariedade(widget.id!);
      });
    }
  }

  void _populateFields(Variedade variedade) {
    if (_fieldsPopulated) return;
    _fieldsPopulated = true;

    _nomeController.text = variedade.nome;
    _descricaoController.text = variedade.descricao ?? '';
    _tempoFloracaoController.text = variedade.tempoFloracao ?? '';
    _origemController.text = variedade.origem ?? '';
    _caracteristicasController.text = variedade.caracteristicas ?? '';
    _tipoVariedade = variedade.tipoVariedade;
    _tipoEspecie = variedade.tipoEspecie;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _tempoFloracaoController.dispose();
    _origemController.dispose();
    _caracteristicasController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final variedade = Variedade(
        id: widget.id ?? 0,
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim().isEmpty
            ? null
            : _descricaoController.text.trim(),
        tipoVariedade: _tipoVariedade,
        tipoEspecie: _tipoEspecie,
        tempoFloracao: _tempoFloracaoController.text.trim().isEmpty
            ? null
            : _tempoFloracaoController.text.trim(),
        origem: _origemController.text.trim().isEmpty
            ? null
            : _origemController.text.trim(),
        caracteristicas: _caracteristicasController.text.trim().isEmpty
            ? null
            : _caracteristicasController.text.trim(),
      );

      if (widget.id != null) {
        ref.read(variedadeProvider.notifier).updateVariedade(variedade);
      } else {
        ref.read(variedadeProvider.notifier).createVariedade(variedade);
      }

      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final variedadeState = ref.watch(variedadeProvider);

    // Populate fields when editing
    if (widget.id != null && variedadeState.selected != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateFields(variedadeState.selected!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? 'Editar Variedade' : 'Nova Variedade'),
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
                  prefixIcon: Icon(Icons.local_florist),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
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
              DropdownButtonFormField<String>(
                initialValue: ['INDICA', 'SATIVA', 'HIBRIDA', 'RUDERALIS']
                        .contains(_tipoVariedade)
                    ? _tipoVariedade
                    : 'INDICA',
                decoration: const InputDecoration(
                  labelText: 'Tipo de Variedade *',
                  prefixIcon: Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(value: 'INDICA', child: Text('Indica')),
                  DropdownMenuItem(value: 'SATIVA', child: Text('Sativa')),
                  DropdownMenuItem(value: 'HIBRIDA', child: Text('Híbrida')),
                  DropdownMenuItem(
                      value: 'RUDERALIS', child: Text('Ruderalis')),
                ],
                onChanged: (value) {
                  setState(() {
                    _tipoVariedade = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue:
                    ['REGULAR', 'FEMININA', 'AUTOMATICA'].contains(_tipoEspecie)
                        ? _tipoEspecie
                        : 'REGULAR',
                decoration: const InputDecoration(
                  labelText: 'Tipo de Espécie *',
                  prefixIcon: Icon(Icons.science),
                ),
                items: const [
                  DropdownMenuItem(value: 'REGULAR', child: Text('Regular')),
                  DropdownMenuItem(value: 'FEMININA', child: Text('Feminina')),
                  DropdownMenuItem(
                      value: 'AUTOMATICA', child: Text('Automática')),
                ],
                onChanged: (value) {
                  setState(() {
                    _tipoEspecie = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tempoFloracaoController,
                decoration: const InputDecoration(
                  labelText: 'Tempo de Floração',
                  prefixIcon: Icon(Icons.timer),
                  hintText: 'Ex: 8-9 semanas',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _origemController,
                decoration: const InputDecoration(
                  labelText: 'Origem',
                  prefixIcon: Icon(Icons.public),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caracteristicasController,
                decoration: const InputDecoration(
                  labelText: 'Características',
                  prefixIcon: Icon(Icons.info),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: variedadeState.status == CrudStatus.loading
                    ? null
                    : _submit,
                child: variedadeState.status == CrudStatus.loading
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
