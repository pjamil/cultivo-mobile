import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/registro_acao.dart';
import '../providers/registros_acao_provider.dart';
import 'widgets/registro_acao_card.dart';

enum _PeriodoFiltro {
  todos,
  hoje,
  semana,
  mes,
  trimestre;

  String get label {
    switch (this) {
      case _PeriodoFiltro.todos:
        return 'Todos';
      case _PeriodoFiltro.hoje:
        return 'Hoje';
      case _PeriodoFiltro.semana:
        return 'Última semana';
      case _PeriodoFiltro.mes:
        return 'Último mês';
      case _PeriodoFiltro.trimestre:
        return 'Último trimestre';
    }
  }
}

class RegistrosAcaoListPage extends ConsumerStatefulWidget {
  final int cultivoId;

  const RegistrosAcaoListPage({super.key, required this.cultivoId});

  @override
  ConsumerState<RegistrosAcaoListPage> createState() =>
      _RegistrosAcaoListPageState();
}

class _RegistrosAcaoListPageState extends ConsumerState<RegistrosAcaoListPage> {
  TipoAcao? _filtroTipo;
  _PeriodoFiltro _filtroPeriodo = _PeriodoFiltro.todos;
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 20;
  int _displayedCount = _pageSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(registrosAcaoProvider.notifier)
          .loadRegistrosPorCultivo(widget.cultivoId);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    final registros = ref.read(registrosAcaoProvider).items;
    final filtered = _filtroTipo != null
        ? registros.where((r) => r.tipoAcao == _filtroTipo).toList()
        : registros;
    if (_displayedCount < filtered.length) {
      setState(() {
        _displayedCount =
            (_displayedCount + _pageSize).clamp(0, filtered.length);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final registrosState = ref.watch(registrosAcaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros de Ação'),
        actions: [
          PopupMenuButton<_PeriodoFiltro>(
            icon: const Icon(Icons.calendar_today),
            onSelected: (periodo) {
              setState(() {
                _filtroPeriodo = periodo;
                _displayedCount = _pageSize;
              });
            },
            itemBuilder: (context) => _PeriodoFiltro.values
                .map((periodo) => PopupMenuItem(
                      value: periodo,
                      child: Text(periodo.label),
                    ))
                .toList(),
          ),
          PopupMenuButton<TipoAcao?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (tipo) {
              setState(() {
                _filtroTipo = tipo;
                _displayedCount = _pageSize;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('Todos'),
              ),
              ...TipoAcao.values.map((tipo) => PopupMenuItem(
                    value: tipo,
                    child: Text(tipo.label),
                  )),
            ],
          ),
        ],
      ),
      body: _buildBody(registrosState),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/registros-acao/novo?cultivoId=${widget.cultivoId}');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(RegistrosAcaoState state) {
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
            Text(state.error ?? 'Erro ao carregar registros'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(registrosAcaoProvider.notifier)
                    .loadRegistrosPorCultivo(widget.cultivoId);
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final registros = state.items;

    if (registros.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.water_drop_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum registro encontrado',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toque no botão + para registrar uma ação',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    final filteredRegistros = registros.where((r) {
      if (_filtroTipo != null && r.tipoAcao != _filtroTipo) {
        return false;
      }
      if (_filtroPeriodo != _PeriodoFiltro.todos) {
        final now = DateTime.now();
        final hoje = DateTime(now.year, now.month, now.day);
        final dataRegistro = DateTime(
          r.data.year,
          r.data.month,
          r.data.day,
        );
        switch (_filtroPeriodo) {
          case _PeriodoFiltro.hoje:
            if (dataRegistro != hoje) return false;
          case _PeriodoFiltro.semana:
            if (hoje.difference(dataRegistro).inDays > 7) return false;
          case _PeriodoFiltro.mes:
            if (hoje.difference(dataRegistro).inDays > 30) return false;
          case _PeriodoFiltro.trimestre:
            if (hoje.difference(dataRegistro).inDays > 90) return false;
          case _PeriodoFiltro.todos:
            break;
        }
      }
      return true;
    }).toList();

    final displayedRegistros = filteredRegistros.take(_displayedCount).toList();
    final hasMore = _displayedCount < filteredRegistros.length;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: displayedRegistros.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == displayedRegistros.length) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: hasMore
                  ? TextButton(
                      onPressed: _loadMore,
                      child: const Text('Carregar mais'),
                    )
                  : const Text(
                      'Todos os registros carregados',
                      style: TextStyle(color: Colors.grey),
                    ),
            ),
          );
        }
        final registro = displayedRegistros[index];
        return RegistroAcaoCard(
          registro: registro,
          onTap: () {
            context.push('/registros-acao/${registro.id}');
          },
        );
      },
    );
  }
}
