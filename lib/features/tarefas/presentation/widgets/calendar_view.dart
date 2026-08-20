import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/tarefa.dart';

class CalendarView extends StatelessWidget {
  final List<Tarefa> tarefas;
  final Function(Tarefa) onTarefaTap;

  const CalendarView({
    super.key,
    required this.tarefas,
    required this.onTarefaTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);

    return Column(
      children: [
        _buildHeader(context, now),
        Expanded(
          child: _buildCalendar(context, firstDay, lastDay),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, DateTime now) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMM yyyy', 'pt_BR').format(now),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            '${tarefas.length} tarefas',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(
    BuildContext context,
    DateTime firstDay,
    DateTime lastDay,
  ) {
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: daysInMonth + firstWeekday - 1,
      itemBuilder: (context, index) {
        if (index < firstWeekday - 1) {
          return const SizedBox();
        }

        final day = index - firstWeekday + 2;
        final date = DateTime(firstDay.year, firstDay.month, day);
        final dayTarefas = _getTarefasForDay(date);

        return _buildDayCell(context, date, dayTarefas);
      },
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime date,
    List<Tarefa> dayTarefas,
  ) {
    final isToday = _isSameDay(date, DateTime.now());
    final hasTarefas = dayTarefas.isNotEmpty;

    return GestureDetector(
      onTap: hasTarefas
          ? () => _showTarefasDialog(context, date, dayTarefas)
          : null,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isToday
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : hasTarefas
                  ? Colors.orange.withValues(alpha: 0.1)
                  : null,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isToday
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: isToday ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
            if (hasTarefas)
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Tarefa> _getTarefasForDay(DateTime date) {
    return tarefas.where((t) {
      if (t.dataVencimento == null) return false;
      return _isSameDay(t.dataVencimento!, date);
    }).toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _showTarefasDialog(
    BuildContext context,
    DateTime date,
    List<Tarefa> tarefas,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tarefas - ${DateFormat('dd/MM/yyyy').format(date)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tarefas.length,
                itemBuilder: (context, index) {
                  final tarefa = tarefas[index];
                  return ListTile(
                    leading: Icon(
                      tarefa.isConcluida
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: tarefa.isConcluida ? Colors.green : Colors.grey,
                    ),
                    title: Text(tarefa.titulo),
                    subtitle: Text(tarefa.prioridade),
                    onTap: () {
                      Navigator.pop(context);
                      onTarefaTap(tarefa);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
