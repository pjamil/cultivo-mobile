import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/models/planta.dart';
import '../../../core/models/variedade.dart';
import '../../variedade/providers/variedade_provider.dart';
import '../providers/plantas_provider.dart';

class PlantaFormPage extends ConsumerStatefulWidget {
  final int? id;

  const PlantaFormPage({super.key, this.id});

  @override
  ConsumerState<PlantaFormPage> createState() => _PlantaFormPageState();
}

class _PlantaFormPageState extends ConsumerState<PlantaFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _especieController;
  late TextEditingController _notasController;
  DateTime? _dataPlantio;
  int? _variedadeId;
  int? _ambienteId;
  int? _meioCultivoId;
  bool _fieldsPopulated = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _especieController = TextEditingController();
    _notasController = TextEditingController();

    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(plantasProvider.notifier).loadPlanta(widget.id!);
      });
    }
  }

  void _populateFields(Planta planta) {
    if (_fieldsPopulated) return;
    _fieldsPopulated = true;
    
    _nomeController.text = planta.nome;
    _especieController.text = planta.especie;
    _notasController.text = planta.notas ?? '';
    _dataPlantio = planta.dataPlantio;
    _variedadeId = planta.variedadeId;
    _ambienteId = planta.ambienteId;
    _meioCultivoId = planta.meioCultivoId;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _especieController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final planta = Planta(
        id: widget.id ?? 0,
        nome: _nomeController.text.trim(),
        especie: _especieController.text.trim(),
        status: 'ATIVA',
        dataPlantio: _dataPlantio,
        notas: _notasController.text.trim().isEmpty
            ? null
            : _notasController.text.trim(),
        variedadeId: _variedadeId,
        ambienteId: _ambienteId,
        meioCultivoId: _meioCultivoId,
      );

      if (widget.id != null) {
        ref.read(plantasProvider.notifier).updatePlanta(planta);
      } else {
        ref.read(plantasProvider.notifier).createPlanta(planta);
      }

      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final plantasState = ref.watch(plantasProvider);
    final variedadeState = ref.watch(variedadeProvider);

    // Populate fields when editing
    if (widget.id != null && plantasState.selectedPlanta != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateFields(plantasState.selectedPlanta!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? 'Editar Planta' : 'Nova Planta'),
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
                  prefixIcon: Icon(Icons.grass),
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
                controller: _especieController,
                decoration: const InputDecoration(
                  labelText: 'Espécie *',
                  prefixIcon: Icon(Icons.science),
                  hintText: 'Ex: Cannabis, Tomate, Pimentão',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a espécie';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _dataPlantio != null
                      ? DateFormat('dd/MM/yyyy').format(_dataPlantio!)
                      : 'Selecionar data de plantio',
                ),
                subtitle: const Text('Data de Plantio'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dataPlantio ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _dataPlantio = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: variedadeState.variedades.any((v) => v.id == _variedadeId)
                    ? _variedadeId
                    : null,
                decoration: const InputDecoration(
                  labelText: 'Variedade',
                  prefixIcon: Icon(Icons.local_florist),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Nenhuma'),
                  ),
                  ...variedadeState.variedades.map((v) => DropdownMenuItem(
                        value: v.id,
                        child: Text(v.nome),
                      )),
                ],
                onChanged: variedadeState.status == VariedadeStatus.loading
                    ? null
                    : (value) {
                        setState(() {
                          _variedadeId = value;
                        });
                      },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notasController,
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: plantasState.status == PlantasStatus.loading
                    ? null
                    : _submit,
                child: plantasState.status == PlantasStatus.loading
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
