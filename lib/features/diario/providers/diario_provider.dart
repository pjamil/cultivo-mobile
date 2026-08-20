import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/diario.dart';
import '../data/diario_repository.dart';

typedef DiarioState = CrudState<DiarioCultivo>;

class DiarioNotifier extends CrudNotifier<DiarioCultivo> {
  DiarioNotifier(super.repository);

  Future<void> loadDiarios() => load();

  Future<void> loadDiario(int id) => loadById(id);

  Future<void> createDiario(DiarioCultivo diario) => create(diario);

  Future<void> updateDiario(DiarioCultivo diario) => update(diario);

  Future<void> deleteDiario(int id) => delete(id);
}

final diarioProvider =
    StateNotifierProvider<DiarioNotifier, DiarioState>((ref) {
  final repository = ref.watch(diarioRepositoryProvider);
  return DiarioNotifier(repository);
});
