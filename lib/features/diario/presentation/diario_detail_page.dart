import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/models/foto.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../../shared/widgets/photo_timeline.dart';
import '../../../shared/widgets/photo_upload_button.dart';
import '../providers/diario_provider.dart';

class DiarioDetailPage extends ConsumerStatefulWidget {
  final int id;

  const DiarioDetailPage({super.key, required this.id});

  @override
  ConsumerState<DiarioDetailPage> createState() => _DiarioDetailPageState();
}

class _DiarioDetailPageState extends ConsumerState<DiarioDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(diarioProvider.notifier).loadDiario(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final diarioState = ref.watch(diarioProvider);

    ref.listen<DiarioState>(diarioProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(diarioProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Diário'),
        actions: [
          PhotoUploadButton(
            onPhotoSelected: (file) => _uploadPhoto(context, ref, file),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/diario/${widget.id}/editar'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      body: diarioState.selectedDiario == null
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
                        Text(
                          diarioState.selectedDiario!.titulo,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        if (diarioState.selectedDiario!.data != null)
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(diarioState.selectedDiario!.data!),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        Text(
                          diarioState.selectedDiario!.conteudo,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
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
                PhotoTimeline(
                  fotos: const [],
                  onFotoTap: (foto) => _showFotoFullScreen(context, foto),
                ),
              ],
            ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Excluir Entrada',
      message: 'Tem certeza que deseja excluir esta entrada do diário?',
      confirmText: 'Excluir',
      isDestructive: true,
    );

    if (confirmed && context.mounted) {
      await ref.read(diarioProvider.notifier).deleteDiario(widget.id);
      if (context.mounted) {
        context.pop();
      }
    }
  }

  void _uploadPhoto(BuildContext context, WidgetRef ref, File file) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Upload de foto será implementado quando o backend estiver pronto'),
      ),
    );
  }

  void _showFotoFullScreen(BuildContext context, Foto foto) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(foto.legenda ?? 'Foto'),
          ),
          body: Center(
            child: Image.network(
              foto.url,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, size: 48);
              },
            ),
          ),
        ),
      ),
    );
  }
}
