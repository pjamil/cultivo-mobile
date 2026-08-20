import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/endpoints.dart';
import '../../../core/crud/crud_repository.dart';
import '../../../core/models/variedade.dart';

final variedadeRepositoryProvider = Provider<VariedadeRepository>((ref) {
  return VariedadeRepository(ref);
});

class VariedadeRepository extends CrudRepository<Variedade> {
  VariedadeRepository(super.ref);

  @override
  String get basePath => Endpoints.variedades;

  @override
  String get resourceName => 'variedades';

  @override
  String get getAllError => 'Erro ao carregar variedades';

  @override
  String get getByIdError => 'Erro ao carregar variedade';

  @override
  String get createError => 'Erro ao criar variedade';

  @override
  String get updateError => 'Erro ao atualizar variedade';

  @override
  String get deleteError => 'Erro ao excluir variedade';

  @override
  Variedade fromJson(Map<String, dynamic> json) => Variedade.fromJson(json);
}
