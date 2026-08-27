import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../shared/widgets/empty_state.dart';
import '../providers/dados_ambientais_provider.dart';

class DadosAmbientaisListPage extends ConsumerWidget {
  const DadosAmbientaisListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dadosAmbientaisProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados Ambientais'),
      ),
      body: _buildBody(context, ref, state),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/dados-ambientais/novo'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    DadosAmbientaisState state,
  ) {
    if (state.status == CrudStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == CrudStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error ?? 'Erro ao carregar dados ambientais'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(dadosAmbientaisProvider.notifier).load(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return EmptyState(
        icon: Icons.thermostat,
        title: 'Nenhum dado ambiental',
        message: 'Registre medições de temperatura, umidade e mais.',
        actionLabel: 'Adicionar Leitura',
        onAction: () => context.push('/dados-ambientais/novo'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final dado = state.items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal[100],
              child: Icon(
                _tipoIcon(dado.tipoMedicao),
                color: Colors.teal,
              ),
            ),
            title: Text(dado.tipoLabel),
            subtitle: Text(
              '${dado.valor} ${dado.unidade}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/dados-ambientais/${dado.id}'),
          ),
        );
      },
    );
  }

  IconData _tipoIcon(String tipoMedicao) {
    switch (tipoMedicao) {
      case 'TEMPERATURA':
        return Icons.thermostat;
      case 'UMIDADE':
      case 'UMIDADE_SOLO':
        return Icons.water_drop;
      case 'LUMINOSIDADE':
        return Icons.light_mode;
      case 'PH':
        return Icons.science;
      case 'NIVEL_AGUA':
        return Icons.opacity;
      default:
        return Icons.analytics;
    }
  }
}
