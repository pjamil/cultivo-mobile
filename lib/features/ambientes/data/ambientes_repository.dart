import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/endpoints.dart';
import '../../../core/crud/crud_repository.dart';
import '../../../core/models/ambiente.dart';

final ambientesRepositoryProvider = Provider<AmbientesRepository>((ref) {
  return AmbientesRepository(ref);
});

class AmbientesRepository extends CrudRepository<Ambiente> {
  AmbientesRepository(super.ref);

  @override
  String get basePath => Endpoints.ambientes;

  @override
  String get resourceName => 'ambientes';

  @override
  String get getAllError => 'Erro ao carregar ambientes';

  @override
  String get getByIdError => 'Erro ao carregar ambiente';

  @override
  String get createError => 'Erro ao criar ambiente';

  @override
  String get updateError => 'Erro ao atualizar ambiente';

  @override
  String get deleteError => 'Erro ao excluir ambiente';

  @override
  Ambiente fromJson(Map<String, dynamic> json) => Ambiente.fromJson(json);
}
