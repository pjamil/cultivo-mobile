import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/usuario_provider.dart';

class UsuarioFormPage extends ConsumerStatefulWidget {
  const UsuarioFormPage({super.key});

  @override
  ConsumerState<UsuarioFormPage> createState() => _UsuarioFormPageState();
}

class _UsuarioFormPageState extends ConsumerState<UsuarioFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  bool _fieldsPopulated = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(
      text: ref.read(usuarioProvider).usuario?.nome ?? '',
    );
  }

  void _populateFields() {
    if (_fieldsPopulated) return;
    _fieldsPopulated = true;

    _nomeController.text = ref.read(usuarioProvider).usuario?.nome ?? '';
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(usuarioProvider.notifier).updateNome(_nomeController.text.trim());
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioState = ref.watch(usuarioProvider);

    // Populate fields when editing
    if (usuarioState.usuario != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateFields();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Nome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: usuarioState.status == UsuarioStatus.loading
                    ? null
                    : _submit,
                child: usuarioState.status == UsuarioStatus.loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
