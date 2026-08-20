import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/endpoints.dart';
import '../../../core/crud/crud_repository.dart';
import '../../../core/models/meio_cultivo.dart';

final meioCultivoRepositoryProvider = Provider<MeioCultivoRepository>((ref) {
  return MeioCultivoRepository(ref);
});

class MeioCultivoRepository extends CrudRepository<MeioCultivo> {
  MeioCultivoRepository(super.ref);

  @override
  String get basePath => Endpoints.meiosCultivo;

  @override
  String get resourceName => 'meios-cultivo';

  @override
  String get getAllError => 'Erro ao carregar meios de cultivo';

  @override
  String get getByIdError => 'Erro ao carregar meio de cultivo';

  @override
  String get createError => 'Erro ao criar meio de cultivo';

  @override
  String get updateError => 'Erro ao atualizar meio de cultivo';

  @override
  String get deleteError => 'Erro ao excluir meio de cultivo';

  @override
  MeioCultivo fromJson(Map<String, dynamic> json) => MeioCultivo.fromJson(json);
}
