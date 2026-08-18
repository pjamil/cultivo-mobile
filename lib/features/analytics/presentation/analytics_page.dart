import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/analytics_provider.dart';
import 'widgets/yield_chart.dart';
import 'widgets/cycle_chart.dart';
import 'widgets/cost_chart.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(analyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: _buildBody(context, ref, analyticsState),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AnalyticsState state,
  ) {
    if (state.status == AnalyticsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == AnalyticsStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error ?? 'Erro ao carregar analytics'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(analyticsProvider.notifier).loadAnalytics(),
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
      onRefresh: () => ref.read(analyticsProvider.notifier).loadAnalytics(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          YieldChart(data: data.rendimentoPorVariedade),
          const SizedBox(height: 16),
          CycleChart(data: data.duracaoCiclo),
          const SizedBox(height: 16),
          CostChart(data: data.custoPorCultivo),
        ],
      ),
    );
  }
}
