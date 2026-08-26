import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/cultivo.dart';
import '../../../core/models/historico_transicao.dart';
import '../data/cultivos_repository.dart';

typedef CultivosState = CrudState<Cultivo>;
typedef CultivosStatus = CrudStatus;

class CultivosNotifier extends CrudNotifier<Cultivo> {
  CultivosNotifier(super.repository);

  Future<void> loadCultivos() => load();

  Future<void> loadCultivo(int id) => loadById(id);

  Future<void> createCultivo(Cultivo cultivo) => create(cultivo);

  Future<void> updateCultivo(Cultivo cultivo) => update(cultivo);

  Future<void> deleteCultivo(int id) => delete(id);

  Future<void> avancarEstado(int id) async {
    final updated = await (repository as CultivosRepository).avancarEstado(id);
    _replaceInState(updated);
  }

  Future<void> cancelar(int id, String motivo) async {
    final updated =
        await (repository as CultivosRepository).cancelar(id, motivo);
    _replaceInState(updated);
  }

  Future<void> atualizarDataTransicao(
    int cultivoId,
    int historicoId,
    DateTime novaData,
  ) async {
    await (repository as CultivosRepository)
        .atualizarDataTransicao(cultivoId, historicoId, novaData);
  }

  void _replaceInState(Cultivo updated) {
    final id = updated.id;
    state = state.copyWith(
      status: CrudStatus.loaded,
      items: state.items.map((c) => c.id == id ? updated : c).toList(),
      selected: updated,
    );
  }
}

final cultivosProvider =
    StateNotifierProvider<CultivosNotifier, CultivosState>((ref) {
  final repository = ref.watch(cultivosRepositoryProvider);
  return CultivosNotifier(repository);
});

final cultivoHistoricoProvider = FutureProvider.autoDispose
    .family<List<HistoricoTransicao>, int>((ref, id) async {
  final repository = ref.watch(cultivosRepositoryProvider);
  return repository.listarHistorico(id);
});
