import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/endpoints.dart';
import '../../../core/crud/crud_repository.dart';
import '../../../core/models/planta.dart';

final plantasRepositoryProvider = Provider<PlantasRepository>((ref) {
  return PlantasRepository(ref);
});

class PlantasRepository extends CrudRepository<Planta> {
  PlantasRepository(super.ref);

  @override
  String get basePath => Endpoints.plantas;

  @override
  String get resourceName => 'plantas';

  @override
  String get getAllError => 'Erro ao carregar plantas';

  @override
  String get getByIdError => 'Erro ao carregar planta';

  @override
  String get createError => 'Erro ao criar planta';

  @override
  String get updateError => 'Erro ao atualizar planta';

  @override
  String get deleteError => 'Erro ao excluir planta';

  @override
  Planta fromJson(Map<String, dynamic> json) => Planta.fromJson(json);

  Future<Planta> colher(int id, DateTime dataColheita, String? notas) async {
    final response = await api.post(
      '/plantas/$id/colher',
      data: {
        'dataColheita': dataColheita.toIso8601String(),
        'notas': notas,
      },
    );
    return Planta.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Planta> perder(int id, String motivo) async {
    final response = await api.post(
      '/plantas/$id/perder',
      data: {'motivo': motivo},
    );
    return Planta.fromJson(response.data as Map<String, dynamic>);
  }
}
