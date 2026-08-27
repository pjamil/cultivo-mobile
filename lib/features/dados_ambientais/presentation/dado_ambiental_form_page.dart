import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/dado_ambiental.dart';
import '../providers/dados_ambientais_provider.dart';

class DadoAmbientalFormPage extends ConsumerStatefulWidget {
  final int? id;

  const DadoAmbientalFormPage({super.key, this.id});

  @override
  ConsumerState<DadoAmbientalFormPage> createState() =>
      _DadoAmbientalFormPageState();
}

class _DadoAmbientalFormPageState extends ConsumerState<DadoAmbientalFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _valorController;
  late TextEditingController _unidadeController;
  late TextEditingController _cultivoIdController;
  String _tipoMedicao = 'TEMPERATURA';
  DateTime _data = DateTime.now();
  bool _fieldsPopulated = false;

  static const _unidadesPorTipo = {
    'TEMPERATURA': '°C',
    'UMIDADE': '%',
    'LUMINOSIDADE': 'lux',
    'UMIDADE_SOLO': '%',
    'PH': 'pH',
    'NIVEL_AGUA': 'L',
  };

  static const _tipos = [
    'TEMPERATURA',
    'UMIDADE',
    'LUMINOSIDADE',
    'UMIDADE_SOLO',
    'PH',
    'NIVEL_AGUA',
  ];

  @override
  void initState() {
    super.initState();
    _valorController = TextEditingController();
    _unidadeController = TextEditingController();
    _cultivoIdController = TextEditingController();

    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(dadosAmbientaisProvider.notifier).loadById(widget.id!);
      });
    }
  }

  void _populateFields(DadoAmbiental dado) {
    if (_fieldsPopulated) return;
    _fieldsPopulated = true;

    setState(() {
      _tipoMedicao = dado.tipoMedicao;
      _valorController.text = dado.valor.toString();
      _unidadeController.text = dado.unidade;
      _cultivoIdController.text = dado.cultivoId?.toString() ?? '';
      _data = dado.dataHora ?? DateTime.now();
    });
  }

  @override
  void dispose() {
    _valorController.dispose();
    _unidadeController.dispose();
    _cultivoIdController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final dado = DadoAmbiental(
        id: widget.id ?? 0,
        cultivoId: int.tryParse(_cultivoIdController.text.trim()),
        tipoMedicao: _tipoMedicao,
        valor: double.tryParse(_valorController.text) ?? 0,
        unidade: _unidadeController.text.trim().isEmpty
            ? _unidadesPorTipo[_tipoMedicao]!
            : _unidadeController.text.trim(),
        dataHora: _data,
      );

      if (widget.id != null) {
        ref.read(dadosAmbientaisProvider.notifier).update(dado);
      } else {
        ref.read(dadosAmbientaisProvider.notifier).create(dado);
      }

      if (mounted) {
        context.pop();
      }
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (!mounted || date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_data),
    );
    if (!mounted) return;
    setState(() {
      _data = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? _data.hour,
        time?.minute ?? _data.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dadosAmbientaisProvider);

    if (widget.id != null && state.selected != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateFields(state.selected!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id != null ? 'Editar Leitura' : 'Nova Leitura',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                key: ValueKey(_tipoMedicao),
                initialValue: _tipoMedicao,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Medição *',
                  prefixIcon: Icon(Icons.thermostat),
                ),
                items: _tipos.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(_labelFor(tipo)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoMedicao = value!;
                    _unidadeController.text = _unidadesPorTipo[value]!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(
                  labelText: 'Valor *',
                  prefixIcon: Icon(Icons.pin),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unidadeController,
                decoration: const InputDecoration(
                  labelText: 'Unidade *',
                  prefixIcon: Icon(Icons.straighten),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a unidade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cultivoIdController,
                decoration: const InputDecoration(
                  labelText: 'ID do Cultivo',
                  prefixIcon: Icon(Icons.spa),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(DateFormat('dd/MM/yyyy HH:mm').format(_data)),
                subtitle: const Text('Data e hora'),
                onTap: _pickDateTime,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: state.status == CrudStatus.loading ? null : _submit,
                child: state.status == CrudStatus.loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.id != null ? 'Salvar' : 'Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _labelFor(String tipo) {
    switch (tipo) {
      case 'TEMPERATURA':
        return 'Temperatura';
      case 'UMIDADE':
        return 'Umidade';
      case 'LUMINOSIDADE':
        return 'Luminosidade';
      case 'UMIDADE_SOLO':
        return 'Umidade do Solo';
      case 'PH':
        return 'pH';
      case 'NIVEL_AGUA':
        return 'Nível de Água';
      default:
        return tipo;
    }
  }
}
