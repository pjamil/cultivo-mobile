import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/models/diario.dart';
import '../../../core/crud/crud_provider.dart';
import '../providers/diario_provider.dart';

class DiarioFormPage extends ConsumerStatefulWidget {
  final int? id;

  const DiarioFormPage({super.key, this.id});

  @override
  ConsumerState<DiarioFormPage> createState() => _DiarioFormPageState();
}

class _DiarioFormPageState extends ConsumerState<DiarioFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _conteudoController;
  DateTime? _data;
  bool _fieldsPopulated = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _conteudoController = TextEditingController();
    _data = DateTime.now();

    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(diarioProvider.notifier).loadById(widget.id!);
      });
    }
  }

  void _populateFields(DiarioCultivo diario) {
    if (_fieldsPopulated) return;
    _fieldsPopulated = true;

    _tituloController.text = diario.titulo;
    _conteudoController.text = diario.conteudo;
    _data = diario.data;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final diario = DiarioCultivo(
        id: widget.id ?? 0,
        titulo: _tituloController.text.trim(),
        conteudo: _conteudoController.text.trim(),
        data: _data,
      );

      if (widget.id != null) {
        ref.read(diarioProvider.notifier).update(diario);
      } else {
        ref.read(diarioProvider.notifier).create(diario);
      }

      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final diarioState = ref.watch(diarioProvider);
    if (widget.id != null && diarioState.selected != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateFields(diarioState.selected!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? 'Editar Entrada' : 'Nova Entrada'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título *',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _data != null
                      ? DateFormat('dd/MM/yyyy').format(_data!)
                      : 'Selecionar data',
                ),
                subtitle: const Text('Data'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _data ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _data = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _conteudoController,
                decoration: const InputDecoration(
                  labelText: 'Conteúdo *',
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
                ),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o conteúdo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    diarioState.status == CrudStatus.loading ? null : _submit,
                child: diarioState.status == CrudStatus.loading
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
