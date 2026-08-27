import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/models/registro_acao.dart';
import '../../../core/crud/crud_provider.dart';
import '../providers/registros_acao_provider.dart';
import 'widgets/registro_acao_tipo_selector.dart';
import 'widgets/registro_acao_detalhes_form.dart';

class RegistroAcaoFormPage extends ConsumerStatefulWidget {
  final int? id;
  final int cultivoId;
  final int? plantaId;

  const RegistroAcaoFormPage({
    super.key,
    this.id,
    required this.cultivoId,
    this.plantaId,
  });

  @override
  ConsumerState<RegistroAcaoFormPage> createState() =>
      _RegistroAcaoFormPageState();
}

class _RegistroAcaoFormPageState extends ConsumerState<RegistroAcaoFormPage> {
  final _formKey = GlobalKey<FormState>();
  TipoAcao _tipo = TipoAcao.rega;
  DateTime _data = DateTime.now();
  final _notasController = TextEditingController();
  Map<String, dynamic> _detalhes = {};
  bool _fieldsPopulated = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(registrosAcaoProvider.notifier).loadById(widget.id!);
      });
    }
  }

  void _populateFields(RegistroAcao registro) {
    if (_fieldsPopulated) return;
    _fieldsPopulated = true;

    setState(() {
      _tipo = registro.tipoAcao;
      _data = registro.data;
      _notasController.text = registro.notas ?? '';
      _detalhes = registro.detalhesMap() ?? {};
    });
  }

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final registro = RegistroAcao(
        id: widget.id ?? 0,
        tipo: _tipo.name,
        data: _data,
        cultivoId: widget.cultivoId,
        plantaId: widget.plantaId,
        detalhes: _detalhes.isNotEmpty ? jsonEncode(_detalhes) : null,
        notas: _notasController.text.trim().isNotEmpty
            ? _notasController.text.trim()
            : null,
      );

      if (widget.id != null) {
        ref.read(registrosAcaoProvider.notifier).update(registro);
      } else {
        ref.read(registrosAcaoProvider.notifier).create(registro);
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
    final registrosState = ref.watch(registrosAcaoProvider);

    if (widget.id != null && registrosState.selected != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateFields(registrosState.selected!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id != null ? 'Editar Registro' : 'Novo Registro',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              RegistroAcaoTipoSelector(
                selected: _tipo,
                onChanged: (tipo) => setState(() {
                  _tipo = tipo;
                  _detalhes = {};
                }),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(DateFormat('dd/MM/yyyy HH:mm').format(_data)),
                subtitle: const Text('Data e hora'),
                onTap: _pickDateTime,
              ),
              const SizedBox(height: 16),
              RegistroAcaoDetalhesForm(
                tipo: _tipo,
                initialDetalhes: _detalhes,
                onChanged: (detalhes) => _detalhes = detalhes,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notasController,
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: registrosState.status == CrudStatus.loading
                    ? null
                    : _submit,
                child: registrosState.status == CrudStatus.loading
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
}
