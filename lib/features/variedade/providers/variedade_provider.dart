import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/variedade.dart';
import '../data/variedade_repository.dart';

typedef VariedadeState = CrudState<Variedade>;

class VariedadeNotifier extends CrudNotifier<Variedade> {
  VariedadeNotifier(super.repository);

  Future<void> loadVariedades() => load();

  Future<void> loadVariedade(int id) => loadById(id);

  Future<void> createVariedade(Variedade variedade) => create(variedade);

  Future<void> updateVariedade(Variedade variedade) => update(variedade);

  Future<void> deleteVariedade(int id) => delete(id);
}

final variedadeProvider =
    StateNotifierProvider<VariedadeNotifier, VariedadeState>((ref) {
  final repository = ref.watch(variedadeRepositoryProvider);
  return VariedadeNotifier(repository);
});
