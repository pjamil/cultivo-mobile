import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/models/foto.dart';
import '../../../core/api/foto_service.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../../shared/widgets/full_screen_image_viewer.dart';
import '../../../shared/widgets/grouped_photo_timeline.dart';
import '../../../shared/widgets/photo_upload_button.dart';
import '../providers/cultivos_provider.dart';
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
