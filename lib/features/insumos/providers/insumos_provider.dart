import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/insumo.dart';
import '../data/insumos_repository.dart';

typedef InsumosState = CrudState<Insumo>;

class InsumosNotifier extends CrudNotifier<Insumo> {
  InsumosNotifier(super.repository);

  Future<void> loadInsumos() => load();

  Future<void> loadInsumo(int id) => loadById(id);

  Future<void> createInsumo(Insumo insumo) => create(insumo);

  Future<void> updateInsumo(Insumo insumo) => update(insumo);

  Future<void> deleteInsumo(int id) => delete(id);
}

final insumosProvider =
    StateNotifierProvider<InsumosNotifier, InsumosState>((ref) {
  final repository = ref.watch(insumosRepositoryProvider);
  return InsumosNotifier(repository);
});
