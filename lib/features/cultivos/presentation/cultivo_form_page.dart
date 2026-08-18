import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/models/cultivo.dart';
import '../../plantas/providers/plantas_provider.dart';
import '../providers/cultivos_provider.dart';

class CultivoFormPage extends ConsumerStatefulWidget {
  final int? id;

  const CultivoFormPage({super.key, this.id});

  @override
  ConsumerState<CultivoFormPage> createState() => _CultivoFormPageState();
}

class _CultivoFormPageState extends ConsumerState<CultivoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _notasController;
  DateTime? _dataInicio;
  int? _plantaId;
  int? _ambienteId;
  bool _fieldsPopulated = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _notasController = TextEditingController();

    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(cultivosProvider.notifier).loadCultivo(widget.id!);
      });
    }
  }

  void _populateFields(Cultivo cultivo) {
    if (_fieldsPopulated) return;
    _fieldsPopulated = true;

    _nomeController.text = cultivo.nome;
    _notasController.text = cultivo.notas ?? '';
    _dataInicio = cultivo.dataInicio;
    _plantaId = cultivo.plantaId;
    _ambienteId = cultivo.ambienteId;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final cultivo = Cultivo(
        id: widget.id ?? 0,
        nome: _nomeController.text.trim(),
        status: 'PLANEJADO',
        dataInicio: _dataInicio,
        notas: _notasController.text.trim().isEmpty
            ? null
            : _notasController.text.trim(),
        plantaId: _plantaId,
        ambienteId: _ambienteId,
      );

      if (widget.id != null) {
        ref.read(cultivosProvider.notifier).updateCultivo(cultivo);
      } else {
        ref.read(cultivosProvider.notifier).createCultivo(cultivo);
      }

      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cultivosState = ref.watch(cultivosProvider);
    final plantasState = ref.watch(plantasProvider);

    // Populate fields when editing
    if (widget.id != null && cultivosState.selectedCultivo != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateFields(cultivosState.selectedCultivo!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? 'Editar Cultivo' : 'Novo Cultivo'),
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
                  prefixIcon: Icon(Icons.spa),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _dataInicio != null
                      ? DateFormat('dd/MM/yyyy').format(_dataInicio!)
                      : 'Selecionar data de início',
                ),
                subtitle: const Text('Data de Início'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dataInicio ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _dataInicio = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _plantaId,
                decoration: const InputDecoration(
                  labelText: 'Planta',
                  prefixIcon: Icon(Icons.grass),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Nenhuma'),
                  ),
                  ...plantasState.plantas.map((p) => DropdownMenuItem(
                        value: p.id,
                        child: Text(p.nome),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    _plantaId = value;
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
                onPressed: cultivosState.status == CultivosStatus.loading
                    ? null
                    : _submit,
                child: cultivosState.status == CultivosStatus.loading
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
