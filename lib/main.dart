import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/storage/local_storage.dart';

void main() async {
  final stopwatch = Stopwatch()..start();

  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage().init();

  stopwatch.stop();
  if (kDebugMode) {
    debugPrint('Startup time: ${stopwatch.elapsedMilliseconds}ms');
  }

  runApp(
    const ProviderScope(
      child: CultivoApp(),
    ),
  );
}
