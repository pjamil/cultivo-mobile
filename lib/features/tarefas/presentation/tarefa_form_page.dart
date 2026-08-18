import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/models/tarefa.dart';
import '../providers/tarefas_provider.dart';

class TarefaFormPage extends ConsumerStatefulWidget {
  final int? id;

  const TarefaFormPage({super.key, this.id});

  @override
  ConsumerState<TarefaFormPage> createState() => _TarefaFormPageState();
}

class _TarefaFormPageState extends ConsumerState<TarefaFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  DateTime? _dataVencimento;
  String _status = 'PENDENTE';
  String _prioridade = 'MEDIA';
  bool _fieldsPopulated = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _descricaoController = TextEditingController();

    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(tarefasProvider.notifier).loadTarefa(widget.id!);
      });
    }
  }

  void _populateFields(Tarefa tarefa) {
    if (_fieldsPopulated) return;
    _fieldsPopulated = true;

    _tituloController.text = tarefa.titulo;
    _descricaoController.text = tarefa.descricao ?? '';
    _dataVencimento = tarefa.dataVencimento;
    _status = tarefa.status;
    _prioridade = tarefa.prioridade;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final tarefa = Tarefa(
        id: widget.id ?? 0,
        titulo: _tituloController.text.trim(),
        descricao: _descricaoController.text.trim().isEmpty
            ? null
            : _descricaoController.text.trim(),
        status: _status,
        prioridade: _prioridade,
        dataVencimento: _dataVencimento,
      );

      if (widget.id != null) {
        ref.read(tarefasProvider.notifier).updateTarefa(tarefa);
      } else {
        ref.read(tarefasProvider.notifier).createTarefa(tarefa);
      }

      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tarefasState = ref.watch(tarefasProvider);

    // Populate fields when editing
    if (widget.id != null && tarefasState.selectedTarefa != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateFields(tarefasState.selectedTarefa!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? 'Editar Tarefa' : 'Nova Tarefa'),
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
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _dataVencimento != null
                      ? DateFormat('dd/MM/yyyy').format(_dataVencimento!)
                      : 'Selecionar data de vencimento',
                ),
                subtitle: const Text('Data de Vencimento'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dataVencimento ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _dataVencimento = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(Icons.flag),
                ),
                items: const [
                  DropdownMenuItem(value: 'PENDENTE', child: Text('Pendente')),
                  DropdownMenuItem(value: 'EM_ANDAMENTO', child: Text('Em Andamento')),
                  DropdownMenuItem(value: 'CONCLUIDA', child: Text('Concluída')),
                ],
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _prioridade,
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                  prefixIcon: Icon(Icons.priority_high),
                ),
                items: const [
                  DropdownMenuItem(value: 'BAIXA', child: Text('Baixa')),
                  DropdownMenuItem(value: 'MEDIA', child: Text('Média')),
                  DropdownMenuItem(value: 'ALTA', child: Text('Alta')),
                ],
                onChanged: (value) {
                  setState(() {
                    _prioridade = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: tarefasState.status == TarefasStatus.loading
                    ? null
                    : _submit,
                child: tarefasState.status == TarefasStatus.loading
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
