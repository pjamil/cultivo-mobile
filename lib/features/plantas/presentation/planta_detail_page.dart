import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/models/foto.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../../shared/widgets/full_screen_image_viewer.dart';
import '../../../shared/widgets/photo_timeline.dart';
import '../../../shared/widgets/photo_upload_button.dart';
import '../../variedade/providers/variedade_provider.dart';
import '../providers/plantas_provider.dart';

class PlantaDetailPage extends ConsumerStatefulWidget {
  final int id;

  const PlantaDetailPage({super.key, required this.id});

  @override
  ConsumerState<PlantaDetailPage> createState() => _PlantaDetailPageState();
}

class _PlantaDetailPageState extends ConsumerState<PlantaDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(plantasProvider.notifier).loadPlanta(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final plantasState = ref.watch(plantasProvider);
    final variedadeState = ref.watch(variedadeProvider);

    ref.listen<PlantasState>(plantasProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(plantasProvider.notifier).clearError();
      }
    });

    // Get variety name from ID
    String getVariedadeName(int? variedadeId) {
      if (variedadeId == null) return 'Nenhuma';
      if (variedadeState.status != VariedadeStatus.loaded) return 'Carregando...';
      try {
        final variedade = variedadeState.variedades.firstWhere(
          (v) => v.id == variedadeId,
        );
        return variedade.nome;
      } catch (e) {
        return 'Variedade #$variedadeId';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Planta'),
        actions: [
          PhotoUploadButton(
            onPhotoSelected: (file) => _uploadPhoto(context, ref, file),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/plantas/${widget.id}/editar'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      body: plantasState.selectedPlanta == null
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
                        _buildInfoRow(
                          context,
                          'Nome',
                          plantasState.selectedPlanta!.nome,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Espécie',
                          plantasState.selectedPlanta!.especie,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Status',
                          plantasState.selectedPlanta!.status,
                        ),
                        if (plantasState.selectedPlanta!.dataPlantio !=
                            null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Data de Plantio',
                            DateFormat('dd/MM/yyyy')
                                .format(plantasState.selectedPlanta!.dataPlantio!),
                          ),
                        ],
                        if (plantasState.selectedPlanta!.dataColheita !=
                            null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Data de Colheita',
                            DateFormat('dd/MM/yyyy')
                                .format(plantasState.selectedPlanta!.dataColheita!),
                          ),
                        ],
                        if (plantasState.selectedPlanta!.notas != null &&
                            plantasState.selectedPlanta!.notas!.isNotEmpty) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Notas',
                            plantasState.selectedPlanta!.notas!,
                          ),
                        ],
                        const Divider(),
                        _buildInfoRow(
                          context,
                          'Variedade',
                          getVariedadeName(plantasState.selectedPlanta!.variedadeId),
                        ),
                        if (plantasState.selectedPlanta!.rendimentoGramas !=
                            null) ...[
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Rendimento',
                            '${plantasState.selectedPlanta!.rendimentoGramas!.toStringAsFixed(0)}g',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Fotos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                // TODO: Load photos from API
                PhotoTimeline(
                  fotos: [],
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

  void _uploadPhoto(BuildContext context, WidgetRef ref, File file) {
    // TODO: Implement photo upload via API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Upload de foto será implementado quando o backend estiver pronto'),
      ),
    );
  }

  void _showFotoFullScreen(BuildContext context, Foto foto) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(foto: foto),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Excluir Planta',
      message: 'Tem certeza que deseja excluir esta planta?',
      confirmText: 'Excluir',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      await ref.read(plantasProvider.notifier).deletePlanta(widget.id);
      if (context.mounted) {
        context.pop();
      }
    }
  }
}
