import 'package:flutter/material.dart';

import '../../core/models/foto.dart';

class FullScreenImageViewer extends StatelessWidget {
  final Foto foto;

  const FullScreenImageViewer({super.key, required this.foto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foto.legenda ?? 'Foto'),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            foto.url,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, size: 48);
            },
          ),
        ),
      ),
    );
  }
}
