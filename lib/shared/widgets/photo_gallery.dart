import 'package:cached_network_image/cached_network_image.dart';
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
            child: CachedNetworkImage(
              imageUrl: foto.thumbnailUrl ?? foto.url,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image),
              ),
            ),
          ),
        );
      },
    );
  }
}
