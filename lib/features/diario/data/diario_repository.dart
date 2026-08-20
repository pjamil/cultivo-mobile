import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/endpoints.dart';
import '../../../core/crud/crud_repository.dart';
import '../../../core/models/diario.dart';

final diarioRepositoryProvider = Provider<DiarioRepository>((ref) {
  return DiarioRepository(ref);
});

class DiarioRepository extends CrudRepository<DiarioCultivo> {
  DiarioRepository(super.ref);

  @override
  String get basePath => Endpoints.diario;

  @override
  String get resourceName => 'diarios';

  @override
  String get getAllError => 'Erro ao carregar diários';

  @override
  String get getByIdError => 'Erro ao carregar diário';

  @override
  String get createError => 'Erro ao criar diário';

  @override
  String get updateError => 'Erro ao atualizar diário';

  @override
  String get deleteError => 'Erro ao excluir diário';

  @override
  DiarioCultivo fromJson(Map<String, dynamic> json) =>
      DiarioCultivo.fromJson(json);
}
