import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/insumo.dart';
import '../data/insumos_repository.dart';

typedef InsumosState = CrudState<Insumo>;

final insumosProvider =
    StateNotifierProvider<CrudNotifier<Insumo>, InsumosState>((ref) {
  final repository = ref.watch(insumosRepositoryProvider);
  return CrudNotifier<Insumo>(repository);
});
