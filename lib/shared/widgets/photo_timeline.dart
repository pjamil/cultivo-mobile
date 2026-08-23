import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/foto.dart';

class PhotoTimeline extends StatelessWidget {
  final List<Foto> fotos;
  final Function(Foto)? onFotoTap;

  const PhotoTimeline({
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

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: fotos.length,
      itemBuilder: (context, index) {
        final foto = fotos[index];
        return _buildFotoItem(context, foto);
      },
    );
  }

  Widget _buildFotoItem(BuildContext context, Foto foto) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onFotoTap != null ? () => onFotoTap!(foto) : null,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: foto.thumbnailUrl ?? foto.url,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 48),
                ),
              ),
            ),
          ),
          if (foto.legenda != null && foto.legenda!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                foto.legenda!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          if (foto.createdAt != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Text(
                DateFormat('dd/MM/yyyy HH:mm').format(foto.createdAt!),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
