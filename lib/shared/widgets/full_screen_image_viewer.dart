import 'package:flutter/material.dart';

import '../../core/models/foto.dart';

class FullScreenImageViewer extends StatefulWidget {
  final Foto foto;
  final Function(String legenda)? onLegendaUpdated;

  const FullScreenImageViewer({
    super.key,
    required this.foto,
    this.onLegendaUpdated,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late String _legenda;

  @override
  void initState() {
    super.initState();
    _legenda = widget.foto.legenda ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_legenda.isNotEmpty ? _legenda : 'Foto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditLegendaDialog(context),
            tooltip: 'Editar legenda',
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            widget.foto.url,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, size: 48);
            },
          ),
        ),
      ),
    );
  }

  void _showEditLegendaDialog(BuildContext context) {
    final controller = TextEditingController(text: _legenda);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Legenda'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Legenda',
            hintText: 'Descreva a foto...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _legenda = controller.text.trim();
              });
              widget.onLegendaUpdated?.call(_legenda);
              Navigator.of(context).pop();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
