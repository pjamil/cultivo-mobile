import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/analytics_repository.dart';
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
        actions: [
          if (analyticsState.data != null)
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () => _exportCsv(context, analyticsState.data!),
              tooltip: 'Exportar CSV',
            ),
        ],
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
              onPressed: () =>
                  ref.read(analyticsProvider.notifier).loadAnalytics(),
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

  Future<void> _exportCsv(BuildContext context, AnalyticsData data) async {
    final buffer = StringBuffer();
    buffer.writeln('Rendimento por Variedade');
    buffer.writeln('Variedade,Rendimento Médio (g)');
    for (final item in data.rendimentoPorVariedade) {
      buffer.writeln('${item.variedade},${item.rendimentoMedio}');
    }
    buffer.writeln('');
    buffer.writeln('Duração do Ciclo');
    buffer.writeln('Fase,Dias Médios');
    for (final item in data.duracaoCiclo) {
      buffer.writeln('${item.fase},${item.diasMedios}');
    }
    buffer.writeln('');
    buffer.writeln('Custo por Cultivo');
    buffer.writeln('Cultivo,Custo Total (R\$)');
    for (final item in data.custoPorCultivo) {
      buffer.writeln('${item.cultivo},${item.custoTotal}');
    }

    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${directory.path}/analytics_$timestamp.csv');
    await file.writeAsString(buffer.toString());

    if (context.mounted) {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'Relatório de Analytics'),
      );
    }
  }
}
