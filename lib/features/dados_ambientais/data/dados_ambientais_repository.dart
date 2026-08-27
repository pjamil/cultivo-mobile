import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/endpoints.dart';
import '../../../core/crud/crud_repository.dart';
import '../../../core/models/dado_ambiental.dart';

final dadosAmbientaisRepositoryProvider =
    Provider<DadosAmbientaisRepository>((ref) {
  return DadosAmbientaisRepository(ref);
});

class DadosAmbientaisRepository extends CrudRepository<DadoAmbiental> {
  DadosAmbientaisRepository(super.ref);

  @override
  String get basePath => Endpoints.dadosAmbientais;

  @override
  String get resourceName => 'dados-ambientais';

  @override
  String get getAllError => 'Erro ao carregar dados ambientais';

  @override
  String get getByIdError => 'Erro ao carregar dado ambiental';

  @override
  String get createError => 'Erro ao criar dado ambiental';

  @override
  String get updateError => 'Erro ao atualizar dado ambiental';

  @override
  String get deleteError => 'Erro ao excluir dado ambiental';

  @override
  DadoAmbiental fromJson(Map<String, dynamic> json) =>
      DadoAmbiental.fromJson(json);
}
