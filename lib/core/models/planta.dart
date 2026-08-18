import 'package:hive/hive.dart';

part 'planta.g.dart';

@HiveType(typeId: 3)
class Planta extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String nome;

  @HiveField(2)
  final String especie;

  @HiveField(3)
  final String status;

  @HiveField(4)
  final DateTime? dataPlantio;

  @HiveField(5)
  final DateTime? dataColheita;

  @HiveField(6)
  final String? notas;

  @HiveField(7)
  final double? rendimentoGramas;

  @HiveField(8)
  final int? variedadeId;

  @HiveField(9)
  final int? meioCultivoId;

  @HiveField(10)
  final int? ambienteId;

  @HiveField(11)
  final int? usuarioId;

  Planta({
    required this.id,
    required this.nome,
    required this.especie,
    this.status = 'ATIVA',
    this.dataPlantio,
    this.dataColheita,
    this.notas,
    this.rendimentoGramas,
    this.variedadeId,
    this.meioCultivoId,
    this.ambienteId,
    this.usuarioId,
  });

  factory Planta.fromJson(Map<String, dynamic> json) {
    return Planta(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      especie: json['especie'] ?? '',
      status: json['status'] ?? 'ATIVA',
      dataPlantio: _parseDate(json['dataPlantio']),
      dataColheita: _parseDate(json['dataColheita']),
      notas: json['notas'],
      rendimentoGramas: (json['rendimentoGramas'] ?? json['rendimento_gramas'])?.toDouble(),
      variedadeId: json['variedadeId'] ?? json['geneticaId'] ?? json['genetica_id'],
      meioCultivoId: json['meioCultivoId'] ?? json['meio_cultivo_id'],
      ambienteId: json['ambienteId'] ?? json['ambiente_id'],
      usuarioId: json['usuarioId'] ?? json['usuario_id'],
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    try {
      final str = value.toString();
      // Handle both ISO format (2025-01-15T00:00:00) and simple format (2025-01-15)
      if (str.contains('T')) {
        return DateTime.parse(str);
      } else {
        return DateTime.parse('${str}T00:00:00');
      }
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'especie': especie,
      'status': status,
      'dataPlantio': dataPlantio?.toIso8601String(),
      'dataColheita': dataColheita?.toIso8601String(),
      'notas': notas,
      'rendimentoGramas': rendimentoGramas,
      'variedadeId': variedadeId,
      'meioCultivoId': meioCultivoId,
      'ambienteId': ambienteId,
      'usuarioId': usuarioId,
    };
  }

  Planta copyWith({
    int? id,
    String? nome,
    String? especie,
    String? status,
    DateTime? dataPlantio,
    DateTime? dataColheita,
    String? notas,
    double? rendimentoGramas,
    int? variedadeId,
    int? meioCultivoId,
    int? ambienteId,
    int? usuarioId,
  }) {
    return Planta(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      especie: especie ?? this.especie,
      status: status ?? this.status,
      dataPlantio: dataPlantio ?? this.dataPlantio,
      dataColheita: dataColheita ?? this.dataColheita,
      notas: notas ?? this.notas,
      rendimentoGramas: rendimentoGramas ?? this.rendimentoGramas,
      variedadeId: variedadeId ?? this.variedadeId,
      meioCultivoId: meioCultivoId ?? this.meioCultivoId,
      ambienteId: ambienteId ?? this.ambienteId,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }

  bool get isActive => status == 'ATIVA';
}
