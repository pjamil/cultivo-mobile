import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/crud/crud_provider.dart';
import '../providers/dashboard_provider.dart';
import 'widgets/summary_card.dart';
import 'widgets/activity_feed.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: _buildBody(context, ref, dashboardState),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    DashboardState state,
  ) {
    if (state.status == LoadStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == LoadStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error ?? 'Erro ao carregar dashboard'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(dashboardProvider.notifier).loadDashboard(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final data = state.data;
    if (data == null) {
      return const Center(child: Text('Nenhum dado disponível'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardProvider.notifier).loadDashboard(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Visão Geral',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Cultivos Ativos',
                  value: '${data.cultivosAtivos}',
                  icon: Icons.spa,
                  color: Colors.green,
                  onTap: () => context.push('/cultivos'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SummaryCard(
                  title: 'Tarefas Pendentes',
                  value: '${data.tarefasPendentes}',
                  icon: Icons.task_alt,
                  color: Colors.orange,
                  onTap: () => context.push('/tarefas'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Alertas Estoque',
                  value: '${data.alertasEstoque}',
                  icon: Icons.warning,
                  color: data.alertasEstoque > 0 ? Colors.red : Colors.grey,
                  onTap: () => context.push('/insumos'),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Atividades Recentes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ActivityFeed(atividades: data.atividadesRecentes),
        ],
      ),
    );
  }
}
