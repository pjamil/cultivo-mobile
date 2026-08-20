import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/ambiente.dart';
import '../data/ambientes_repository.dart';

typedef AmbientesState = CrudState<Ambiente>;

class AmbientesNotifier extends CrudNotifier<Ambiente> {
  AmbientesNotifier(super.repository);

  Future<void> loadAmbientes() => load();

  Future<void> loadAmbiente(int id) => loadById(id);

  Future<void> createAmbiente(Ambiente ambiente) => create(ambiente);

  Future<void> updateAmbiente(Ambiente ambiente) => update(ambiente);

  Future<void> deleteAmbiente(int id) => delete(id);
}

final ambientesProvider =
    StateNotifierProvider<AmbientesNotifier, AmbientesState>((ref) {
  final repository = ref.watch(ambientesRepositoryProvider);
  return AmbientesNotifier(repository);
});
