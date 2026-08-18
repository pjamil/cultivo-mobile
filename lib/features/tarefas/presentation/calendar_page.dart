import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/tarefas_provider.dart';
import 'widgets/calendar_view.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tarefasState = ref.watch(tarefasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário'),
      ),
      body: tarefasState.tarefas.isEmpty
          ? const Center(
              child: Text('Nenhuma tarefa para exibir no calendário'),
            )
          : CalendarView(
              tarefas: tarefasState.tarefas,
              onTarefaTap: (tarefa) => context.push('/tarefas/${tarefa.id}'),
            ),
    );
  }
}
