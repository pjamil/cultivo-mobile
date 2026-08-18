import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/meio_cultivo.dart';
import '../providers/meio_cultivo_provider.dart';

class MeioCultivoFormPage extends ConsumerStatefulWidget {
  final int? id;

  const MeioCultivoFormPage({super.key, this.id});

  @override
  ConsumerState<MeioCultivoFormPage> createState() => _MeioCultivoFormPageState();
}

class _MeioCultivoFormPageState extends ConsumerState<MeioCultivoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descricaoController;
  String _tipo = 'solo';
  bool _fieldsPopulated = false;

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController();

    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(meioCultivoProvider.notifier).loadMeio(widget.id!);
      });
    }
  }

  void _populateFields(MeioCultivo meio) {
    if (_fieldsPopulated) return;
    _fieldsPopulated = true;

    _descricaoController.text = meio.descricao ?? '';
    _tipo = meio.tipo;
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final meio = MeioCultivo(
        id: widget.id ?? 0,
        tipo: _tipo,
        descricao: _descricaoController.text.trim().isEmpty
            ? null
            : _descricaoController.text.trim(),
      );

      if (widget.id != null) {
        ref.read(meioCultivoProvider.notifier).updateMeio(meio);
      } else {
        ref.read(meioCultivoProvider.notifier).createMeio(meio);
      }

      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final meioCultivoState = ref.watch(meioCultivoProvider);

    // Populate fields when editing
    if (widget.id != null && meioCultivoState.selectedMeio != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateFields(meioCultivoState.selectedMeio!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? 'Editar Meio' : 'Novo Meio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _tipo,
                decoration: const InputDecoration(
                  labelText: 'Tipo *',
                  prefixIcon: Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(value: 'solo', child: Text('Solo')),
                  DropdownMenuItem(value: 'hidroponia', child: Text('Hidroponia')),
                  DropdownMenuItem(value: 'aeroponia', child: Text('Aeroponia')),
                  DropdownMenuItem(value: 'substrato', child: Text('Substrato')),
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: meioCultivoState.status == MeioCultivoStatus.loading
                    ? null
                    : _submit,
                child: meioCultivoState.status == MeioCultivoStatus.loading
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
