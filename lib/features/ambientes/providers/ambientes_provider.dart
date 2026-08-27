import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/ambiente.dart';
import '../data/ambientes_repository.dart';

typedef AmbientesState = CrudState<Ambiente>;

final ambientesProvider =
    StateNotifierProvider<CrudNotifier<Ambiente>, AmbientesState>((ref) {
  final repository = ref.watch(ambientesRepositoryProvider);
  return CrudNotifier<Ambiente>(repository);
});
