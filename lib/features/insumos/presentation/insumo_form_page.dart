import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/insumo.dart';
import '../../../core/crud/crud_provider.dart';
import '../providers/insumos_provider.dart';

class InsumoFormPage extends ConsumerStatefulWidget {
  final int? id;

  const InsumoFormPage({super.key, this.id});

  @override
  ConsumerState<InsumoFormPage> createState() => _InsumoFormPageState();
}

class _InsumoFormPageState extends ConsumerState<InsumoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codigoController;
  late TextEditingController _nomeController;
  late TextEditingController _quantidadeController;
  late TextEditingController _unidadeMedidaController;
  late TextEditingController _estoqueMinimoController;
  String _tipo = 'OUTRO';
  bool _fieldsPopulated = false;

  @override
  void initState() {
    super.initState();
    _codigoController = TextEditingController();
    _nomeController = TextEditingController();
    _quantidadeController = TextEditingController(text: '0');
    _unidadeMedidaController = TextEditingController();
    _estoqueMinimoController = TextEditingController(text: '0');

    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(insumosProvider.notifier).loadInsumo(widget.id!);
      });
    }
  }

  void _populateFields(Insumo insumo) {
    if (_fieldsPopulated) return;
    _fieldsPopulated = true;

    _codigoController.text = insumo.codigo;
    _nomeController.text = insumo.nome;
    _quantidadeController.text = insumo.quantidade.toString();
    _unidadeMedidaController.text = insumo.unidadeMedida;
    _estoqueMinimoController.text = insumo.estoqueMinimo.toString();
    _tipo = insumo.tipo;
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _nomeController.dispose();
    _quantidadeController.dispose();
    _unidadeMedidaController.dispose();
    _estoqueMinimoController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final insumo = Insumo(
        id: widget.id ?? 0,
        codigo: _codigoController.text.trim(),
        nome: _nomeController.text.trim(),
        tipo: _tipo,
        quantidade: double.tryParse(_quantidadeController.text) ?? 0,
        unidadeMedida: _unidadeMedidaController.text.trim(),
        estoqueMinimo: double.tryParse(_estoqueMinimoController.text) ?? 0,
      );

      if (widget.id != null) {
        ref.read(insumosProvider.notifier).updateInsumo(insumo);
      } else {
        ref.read(insumosProvider.notifier).createInsumo(insumo);
      }

      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final insumosState = ref.watch(insumosProvider);

    // Populate fields when editing
    if (widget.id != null && insumosState.selected != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateFields(insumosState.selected!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? 'Editar Insumo' : 'Novo Insumo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(
                  labelText: 'Código *',
                  prefixIcon: Icon(Icons.qr_code),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o código';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome *',
                  prefixIcon: Icon(Icons.inventory),
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
                  DropdownMenuItem(value: 'ADUBO', child: Text('Adubo')),
                  DropdownMenuItem(value: 'SEMENTE', child: Text('Semente')),
                  DropdownMenuItem(
                      value: 'DEFENSIVO', child: Text('Defensivo')),
                  DropdownMenuItem(
                      value: 'SUBSTRATO', child: Text('Substrato')),
                  DropdownMenuItem(
                      value: 'FERRAMENTA', child: Text('Ferramenta')),
                  DropdownMenuItem(value: 'OUTRO', child: Text('Outro')),
                ],
                onChanged: (value) {
                  setState(() {
                    _tipo = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade *',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obrigatório';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _unidadeMedidaController,
                      decoration: const InputDecoration(
                        labelText: 'Unidade *',
                        hintText: 'kg, L, un',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obrigatório';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _estoqueMinimoController,
                decoration: const InputDecoration(
                  labelText: 'Estoque Mínimo',
                  prefixIcon: Icon(Icons.warning_amber),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    insumosState.status == CrudStatus.loading ? null : _submit,
                child: insumosState.status == CrudStatus.loading
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
