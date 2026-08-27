import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/dado_ambiental.dart';
import '../data/dados_ambientais_repository.dart';

typedef DadosAmbientaisState = CrudState<DadoAmbiental>;

final dadosAmbientaisProvider =
    StateNotifierProvider<CrudNotifier<DadoAmbiental>, DadosAmbientaisState>(
        (ref) {
  final repository = ref.watch(dadosAmbientaisRepositoryProvider);
  return CrudNotifier<DadoAmbiental>(repository);
});
