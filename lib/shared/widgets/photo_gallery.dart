import 'package:flutter/material.dart';

import '../../../core/models/foto.dart';

class PhotoGallery extends StatelessWidget {
  final List<Foto> fotos;
  final Function(Foto)? onFotoTap;

  const PhotoGallery({
    super.key,
    required this.fotos,
    this.onFotoTap,
  });

  @override
  Widget build(BuildContext context) {
    if (fotos.isEmpty) {
      return const Center(
        child: Text('Nenhuma foto'),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: fotos.length,
      itemBuilder: (context, index) {
        final foto = fotos[index];
        return GestureDetector(
          onTap: onFotoTap != null ? () => onFotoTap!(foto) : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              foto.thumbnailUrl ?? foto.url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
