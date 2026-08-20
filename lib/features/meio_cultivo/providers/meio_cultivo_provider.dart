import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/meio_cultivo.dart';
import '../data/meio_cultivo_repository.dart';

typedef MeioCultivoState = CrudState<MeioCultivo>;

class MeioCultivoNotifier extends CrudNotifier<MeioCultivo> {
  MeioCultivoNotifier(super.repository);

  Future<void> loadMeiosCultivo() => load();

  Future<void> loadMeio(int id) => loadById(id);

  Future<void> createMeio(MeioCultivo meio) => create(meio);

  Future<void> updateMeio(MeioCultivo meio) => update(meio);

  Future<void> deleteMeio(int id) => delete(id);
}

final meioCultivoProvider =
    StateNotifierProvider<MeioCultivoNotifier, MeioCultivoState>((ref) {
  final repository = ref.watch(meioCultivoRepositoryProvider);
  return MeioCultivoNotifier(repository);
});
