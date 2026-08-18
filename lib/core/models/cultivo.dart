import '../utils/date_utils.dart';
import 'package:hive/hive.dart';

part 'cultivo.g.dart';

@HiveType(typeId: 4)
class Cultivo extends HiveObject {
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
          : null,
      dataFim: json['dataFim'] != null
          ? parseDate(json['dataFim'])
          : null,
      notas: json['notas'],
      plantaId: json['plantaId'],
      ambienteId: json['ambienteId'],
      usuarioId: json['usuarioId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'status': status,
      'dataInicio': dataInicio?.toIso8601String(),
      'dataFim': dataFim?.toIso8601String(),
      'notas': notas,
      'plantaId': plantaId,
      'ambienteId': ambienteId,
      'usuarioId': usuarioId,
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
