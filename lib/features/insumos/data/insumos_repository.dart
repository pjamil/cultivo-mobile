import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/endpoints.dart';
import '../../../core/crud/crud_repository.dart';
import '../../../core/models/insumo.dart';

final insumosRepositoryProvider = Provider<InsumosRepository>((ref) {
  return InsumosRepository(ref);
});

class InsumosRepository extends CrudRepository<Insumo> {
  InsumosRepository(super.ref);

  @override
  String get basePath => Endpoints.insumos;

  @override
  String get resourceName => 'insumos';

  @override
  String get getAllError => 'Erro ao carregar insumos';

  @override
  String get getByIdError => 'Erro ao carregar insumo';

  @override
  String get createError => 'Erro ao criar insumo';

  @override
  String get updateError => 'Erro ao atualizar insumo';

  @override
  String get deleteError => 'Erro ao excluir insumo';

  @override
  Insumo fromJson(Map<String, dynamic> json) => Insumo.fromJson(json);
}
