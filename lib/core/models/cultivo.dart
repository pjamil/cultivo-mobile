import '../utils/date_utils.dart';
import 'package:hive/hive.dart';

import '../crud/entidade_serializavel.dart';

part 'cultivo.g.dart';

@HiveType(typeId: 4)
class Cultivo extends HiveObject with EntidadeSerializavel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String nome;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final DateTime? dataInicio;

  @HiveField(4)
  final DateTime? dataFim;

  @HiveField(5)
  final String? notas;

  @HiveField(6)
  final int? plantaId;

  @HiveField(7)
  final int? ambienteId;

  @HiveField(8)
  final int? usuarioId;

  Cultivo({
    required this.id,
    required this.nome,
    this.status = 'PLANEJADO',
    this.dataInicio,
    this.dataFim,
    this.notas,
    this.plantaId,
    this.ambienteId,
    this.usuarioId,
  });

  factory Cultivo.fromJson(Map<String, dynamic> json) {
    return Cultivo(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      status: json['status'] ?? 'PLANEJADO',
      dataInicio: json['dataInicio'] != null
          ? parseDate(json['dataInicio'])
          : (json['data_inicio'] != null
              ? parseDate(json['data_inicio'])
              : null),
      dataFim: json['dataFim'] != null
          ? parseDate(json['dataFim'])
          : (json['data_fim'] != null ? parseDate(json['data_fim']) : null),
      notas: json['notas'] ?? json['observacoes'],
      plantaId: json['plantaId'] ?? json['planta_id'],
      ambienteId: json['ambienteId'] ?? json['ambiente_id'],
      usuarioId: json['usuarioId'] ?? json['usuario_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() => toCreateJson();

  @override
  Map<String, dynamic> toCreateJson() {
    return {
      'nome': nome,
      'planta_id': plantaId,
      'data_inicio': formatDateOnly(dataInicio),
      'data_fim': formatDateOnly(dataFim),
      'ambiente_id': ambienteId,
      'notas': notas,
    };
  }

  @override
  Map<String, dynamic> toUpdateJson() {
    return {
      'nome': nome,
      'data_inicio': formatDateOnly(dataInicio),
      'data_fim': formatDateOnly(dataFim),
      'ambiente_id': ambienteId,
      'notas': notas,
    };
  }

  Cultivo copyWith({
    int? id,
    String? nome,
    String? status,
    DateTime? dataInicio,
    DateTime? dataFim,
    String? notas,
    int? plantaId,
    int? ambienteId,
    int? usuarioId,
  }) {
    return Cultivo(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      status: status ?? this.status,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      notas: notas ?? this.notas,
      plantaId: plantaId ?? this.plantaId,
      ambienteId: ambienteId ?? this.ambienteId,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }

  bool get isActive => status != 'COLHIDO' && status != 'CANCELADO';
}
