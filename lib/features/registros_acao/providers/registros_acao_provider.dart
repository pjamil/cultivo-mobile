import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/registro_acao.dart';
import '../data/registros_acao_repository.dart';

typedef RegistrosAcaoState = CrudState<RegistroAcao>;

class RegistrosAcaoNotifier extends CrudNotifier<RegistroAcao> {
  RegistrosAcaoNotifier(super.repository);

  Future<void> loadRegistros() => load();

  Future<void> loadRegistrosPorCultivo(int cultivoId) async {
    state = state.copyWith(status: CrudStatus.loading);
    try {
      final registros =
          await (repository as RegistrosAcaoRepository).listarPorCultivo(
        cultivoId,
      );
      state = state.copyWith(status: CrudStatus.loaded, items: registros);
    } catch (e) {
      state = state.copyWith(status: CrudStatus.error, error: e.toString());
    }
  }

  Future<void> loadRegistro(int id) => loadById(id);

  Future<void> createRegistro(RegistroAcao registro) => create(registro);

  Future<void> updateRegistro(RegistroAcao registro) => update(registro);

  Future<void> deleteRegistro(int id) => delete(id);
}

final registrosAcaoProvider =
    StateNotifierProvider<RegistrosAcaoNotifier, RegistrosAcaoState>((ref) {
  final repository = ref.watch(registrosAcaoRepositoryProvider);
  return RegistrosAcaoNotifier(repository);
});
