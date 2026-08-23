import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static Future<File> compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1920,
      minHeight: 1920,
      quality: 85,
    );

    if (result == null) {
      return file;
    }
    final directory = await getTemporaryDirectory();
    final String fileName =
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File compressedFile = File('${directory.path}/$fileName');
    await compressedFile.writeAsBytes(result);

    return compressedFile;
  }

  static String getFileExtension(String path) {
    return path.split('.').last.toLowerCase();
  }

  static bool isImageFile(String path) {
    final ext = getFileExtension(path);
    return ['jpg', 'jpeg', 'png', 'webp'].contains(ext);
  }
}
