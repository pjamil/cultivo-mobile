import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/models/foto.dart';
import '../../../core/models/historico_transicao.dart';
import '../../../core/models/registro_acao.dart';
import '../../../core/crud/crud_provider.dart';
import '../../../core/api/foto_service.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../../shared/widgets/full_screen_image_viewer.dart';
import '../../../shared/widgets/grouped_photo_timeline.dart';
import '../../../shared/widgets/photo_upload_button.dart';
import '../../registros_acao/presentation/widgets/registros_acao_timeline.dart';
import '../../registros_acao/providers/registros_acao_provider.dart';
import '../providers/cultivos_provider.dart';
import 'widgets/historico_estado_timeline.dart';
import 'widgets/state_badge.dart';

class CultivoDetailPage extends ConsumerStatefulWidget {
  final int id;

  const CultivoDetailPage({super.key, required this.id});

  @override
  ConsumerState<CultivoDetailPage> createState() => _CultivoDetailPageState();
}

class _CultivoDetailPageState extends ConsumerState<CultivoDetailPage> {
  List<Foto> _fotos = [];
  bool _isLoadingFotos = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cultivosProvider.notifier).loadCultivo(widget.id);
      ref
          .read(registrosAcaoProvider.notifier)
          .loadRegistrosPorCultivo(widget.id);
      _carregarFotos();
    });
  }

  void _carregarFotos() async {
    setState(() => _isLoadingFotos = true);
    try {
      final fotos = await ref
          .read(fotoServiceProvider)
          .listarPorEntidade('CULTIVO', widget.id);
      setState(() => _fotos = fotos);
    } catch (_) {
    } finally {
      setState(() => _isLoadingFotos = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cultivosState = ref.watch(cultivosProvider);
    final historicoAsync = ref.watch(cultivoHistoricoProvider(widget.id));
    final registrosState = ref.watch(registrosAcaoProvider);

    ref.listen<CultivosState>(cultivosProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(cultivosProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Cultivo'),
        actions: [
          PhotoUploadButton(
            onPhotoSelected: (file) => _uploadPhoto(context, ref, file),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/cultivos/${widget.id}/editar'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/registros-acao/novo?cultivoId=${widget.id}');
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar Ação'),
      ),
      body: cultivosState.selected == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                cultivosState.selected!.nome,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                            StateBadge(status: cultivosState.selected!.status),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (cultivosState.selected!.dataInicio != null) ...[
                          _buildInfoRow(
                            context,
                            'Data de Início',
                            DateFormat('dd/MM/yyyy')
                                .format(cultivosState.selected!.dataInicio!),
                          ),
                          const Divider(),
                        ],
                        if (cultivosState.selected!.dataFim != null) ...[
                          _buildInfoRow(
                            context,
                            'Data de Fim',
                            DateFormat('dd/MM/yyyy')
                                .format(cultivosState.selected!.dataFim!),
                          ),
                          const Divider(),
                        ],
                        if (cultivosState.selected!.notas != null &&
                            cultivosState.selected!.notas!.isNotEmpty) ...[
                          _buildInfoRow(
                            context,
                            'Notas',
                            cultivosState.selected!.notas!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (cultivosState.selected!.isActive) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAvancarEstadoDialog(context, ref),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Avançar Estado'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showCancelarDialog(context, ref),
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      label: const Text(
                        'Cancelar Cultivo',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  'Histórico de Estado',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                historicoAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => Text(
                    'Não foi possível carregar o histórico de estado.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  data: (historico) {
                    final comDias = calcularDiasNoEstado(
                      historico,
                      dataFim: cultivosState.selected!.dataFim,
                    );
                    if (comDias.isEmpty) {
                      return Text(
                        'Nenhuma transição registrada.',
                        style: TextStyle(color: Colors.grey[600]),
                      );
                    }
                    return HistoricoEstadoTimeline(
                      transicoes: comDias,
                      onEditar: (transicao) =>
                          _editarDataTransicao(transicao, comDias),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Registros de Ação',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () => context
                          .push('/registros-acao?cultivoId=${widget.id}'),
                      child: const Text('Ver todos'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (registrosState.status == CrudStatus.loading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (registrosState.status == CrudStatus.error)
                  Text(
                    'Não foi possível carregar os registros de ação.',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                else
                  _buildRegistrosSection(context, registrosState.items),
                const SizedBox(height: 16),
                Text(
                  'Fotos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (_isLoadingFotos)
                  const Center(child: CircularProgressIndicator())
                else
                  GroupedPhotoTimeline(
                    fotos: _fotos,
                    onFotoTap: (foto) => _showFotoFullScreen(context, foto),
                  ),
              ],
            ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrosSection(
    BuildContext context,
    List<RegistroAcao> registros,
  ) {
    final doCultivo = registros.where((r) => r.cultivoId == widget.id).toList();
    if (doCultivo.isEmpty) {
      return Text(
        'Nenhuma ação registrada. Toque no botão + para registrar.',
        style: TextStyle(color: Colors.grey[600]),
      );
    }
    return RegistrosAcaoTimeline(
      registros: doCultivo,
      onRegistroTap: (registro) =>
          context.push('/registros-acao/${registro.id}'),
    );
  }

  Future<void> _editarDataTransicao(
    HistoricoTransicao transicao,
    List<HistoricoTransicao> ordenadas,
  ) async {
    final novaData = await _pickDateTime(transicao.dataTransicao);
    if (novaData == null || !mounted) return;

    if (novaData.isAfter(DateTime.now())) {
      _mostrarSnack('A data não pode estar no futuro.', isError: true);
      return;
    }

    if (!_dataDentroDosVizinhos(ordenadas, transicao.id, novaData)) {
      _mostrarSnack(
        'Data fora da ordem cronológica. Escolha entre as transições vizinhas.',
        isError: true,
      );
      return;
    }

    try {
      await ref
          .read(cultivosProvider.notifier)
          .atualizarDataTransicao(widget.id, transicao.id, novaData);
      ref.invalidate(cultivoHistoricoProvider(widget.id));
      if (mounted) {
        _mostrarSnack('Data da transição atualizada.');
      }
    } catch (e) {
      if (mounted) {
        _mostrarSnack(_mensagemErro(e), isError: true);
      }
    }
  }

  bool _dataDentroDosVizinhos(
    List<HistoricoTransicao> ordenadas,
    int transicaoId,
    DateTime novaData,
  ) {
    final index = ordenadas.indexWhere((t) => t.id == transicaoId);
    if (index < 0) return false;
    final anterior = index > 0 ? ordenadas[index - 1].dataTransicao : null;
    final proxima = index < ordenadas.length - 1
        ? ordenadas[index + 1].dataTransicao
        : null;
    return dataTransicaoValida(
      novaData,
      anterior: anterior,
      proxima: proxima,
    );
  }

  String _mensagemErro(Object e) {
    final mensagem = e.toString().replaceFirst('Exception: ', '');
    return mensagem.isEmpty
        ? 'Erro ao atualizar a data da transição.'
        : mensagem;
  }

  Future<DateTime?> _pickDateTime(DateTime initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (!mounted || date == null) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (!mounted || time == null) return null;
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  void _mostrarSnack(String mensagem, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Excluir Cultivo',
      message: 'Tem certeza que deseja excluir este cultivo?',
      confirmText: 'Excluir',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      await ref.read(cultivosProvider.notifier).deleteCultivo(widget.id);
      if (context.mounted) {
        context.pop();
      }
    }
  }

  void _uploadPhoto(BuildContext context, WidgetRef ref, File file) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Upload de foto será implementado quando o backend estiver pronto'),
      ),
    );
  }

  void _showAvancarEstadoDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Avançar Estado',
      message: 'Deseja avançar para o próximo estado do cultivo?',
      confirmText: 'Avançar',
    );

    if (confirmed && context.mounted) {
      await ref.read(cultivosProvider.notifier).avancarEstado(widget.id);
    }
  }

  void _showCancelarDialog(BuildContext context, WidgetRef ref) async {
    final motivoController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Cultivo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Tem certeza que deseja cancelar este cultivo?'),
            const SizedBox(height: 16),
            TextField(
              controller: motivoController,
              decoration: const InputDecoration(
                labelText: 'Motivo *',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Voltar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (motivoController.text.isNotEmpty) {
                Navigator.of(context).pop(true);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancelar Cultivo'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref
          .read(cultivosProvider.notifier)
          .cancelar(widget.id, motivoController.text);
    }
  }

  void _showFotoFullScreen(BuildContext context, Foto foto) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(foto: foto),
      ),
    );
  }
}
