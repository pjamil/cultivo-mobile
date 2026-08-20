import 'package:hive/hive.dart';

part 'meio_cultivo.g.dart';

@HiveType(typeId: 7)
class MeioCultivo extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String tipo;

  @HiveField(2)
  final String? descricao;

  MeioCultivo({
    required this.id,
    required this.tipo,
    this.descricao,
  });

  factory MeioCultivo.fromJson(Map<String, dynamic> json) {
    return MeioCultivo(
      id: json['id'] ?? 0,
      tipo: json['tipo'] ?? '',
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() => toCreateJson();

  Map<String, dynamic> toCreateJson() {
    return {
      'tipo': tipo,
      'descricao': descricao,
    };
  }

  Map<String, dynamic> toUpdateJson() => toCreateJson();

  MeioCultivo copyWith({
    int? id,
    String? tipo,
    String? descricao,
  }) {
    return MeioCultivo(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      descricao: descricao ?? this.descricao,
    );
  }
}
