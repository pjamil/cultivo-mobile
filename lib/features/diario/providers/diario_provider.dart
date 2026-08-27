import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/diario.dart';
import '../data/diario_repository.dart';

typedef DiarioState = CrudState<DiarioCultivo>;

final diarioProvider =
    StateNotifierProvider<CrudNotifier<DiarioCultivo>, DiarioState>((ref) {
  final repository = ref.watch(diarioRepositoryProvider);
  return CrudNotifier<DiarioCultivo>(repository);
});
