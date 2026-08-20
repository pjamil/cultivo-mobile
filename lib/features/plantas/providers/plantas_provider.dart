import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/planta.dart';
import '../data/plantas_repository.dart';

typedef PlantasState = CrudState<Planta>;

class PlantasNotifier extends CrudNotifier<Planta> {
  PlantasNotifier(super.repository);

  Future<void> loadPlantas() => load();

  Future<void> loadPlanta(int id) => loadById(id);

  Future<void> createPlanta(Planta planta) => create(planta);

  Future<void> updatePlanta(Planta planta) => update(planta);

  Future<void> deletePlanta(int id) => delete(id);

  Future<void> colher(int id, DateTime dataColheita, String? notas) async {
    final updated =
        await (repository as PlantasRepository).colher(id, dataColheita, notas);
    _replaceInState(updated);
  }

  Future<void> perder(int id, String motivo) async {
    final updated = await (repository as PlantasRepository).perder(id, motivo);
    _replaceInState(updated);
  }

  void _replaceInState(Planta updated) {
    final id = updated.id;
    state = state.copyWith(
      status: CrudStatus.loaded,
      items: state.items.map((p) => p.id == id ? updated : p).toList(),
      selected: updated,
    );
  }
}

final plantasProvider =
    StateNotifierProvider<PlantasNotifier, PlantasState>((ref) {
  final repository = ref.watch(plantasRepositoryProvider);
  return PlantasNotifier(repository);
});
