import 'dart:convert';

import '../utils/date_utils.dart';
import 'package:hive/hive.dart';

import '../crud/entidade_serializavel.dart';

part 'registro_acao.g.dart';

enum TipoAcao {
  rega,
  adubacao,
  transplante,
  irrigacao,
  colheita,
  plantio,
  poda,
  outro;

  String get label {
    switch (this) {
      case TipoAcao.rega:
        return 'Rega';
      case TipoAcao.adubacao:
        return 'Adubação';
      case TipoAcao.transplante:
        return 'Transplante';
      case TipoAcao.irrigacao:
        return 'Irrigação';
      case TipoAcao.colheita:
        return 'Colheita';
      case TipoAcao.plantio:
        return 'Plantio';
      case TipoAcao.poda:
        return 'Poda';
      case TipoAcao.outro:
        return 'Outro';
    }
  }

  static TipoAcao fromString(String value) {
    return TipoAcao.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => TipoAcao.outro,
    );
  }
}

@HiveType(typeId: 12)
class RegistroAcao extends HiveObject with EntidadeSerializavel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String tipo;

  @HiveField(2)
  final DateTime data;

  @HiveField(3)
  final int cultivoId;

  @HiveField(4)
  final int? plantaId;

  @HiveField(5)
  final String? detalhes;

  @HiveField(6)
  final String? notas;

  @HiveField(7)
  final int? usuarioId;

  @HiveField(8)
  final DateTime? dataCriacao;

  @HiveField(9)
  final DateTime? dataAtualizacao;

  RegistroAcao({
    required this.id,
    required this.tipo,
    required this.data,
    required this.cultivoId,
    this.plantaId,
    this.detalhes,
    this.notas,
    this.usuarioId,
    this.dataCriacao,
    this.dataAtualizacao,
  });

  TipoAcao get tipoAcao => TipoAcao.fromString(tipo);

  factory RegistroAcao.fromJson(Map<String, dynamic> json) {
    return RegistroAcao(
      id: json['id'] ?? 0,
      tipo: json['tipo'] ??
          json['tipo_atividade'] ??
          json['tipoAtividade'] ??
          'OUTRO',
      data: parseDate(json['data']) ?? DateTime.now(),
      cultivoId: json['cultivoId'] ?? json['cultivo_id'] ?? 0,
      plantaId: json['plantaId'] ?? json['planta_id'],
      detalhes: json['detalhes'],
      notas: json['notas'] ?? json['observacoes'],
      usuarioId:
          json['usuarioId'] ?? json['usuario_id'] ?? json['responsavel_id'],
      dataCriacao: json['dataCriacao'] != null
          ? parseDate(json['dataCriacao'])
          : (json['data_criacao'] != null
              ? parseDate(json['data_criacao'])
              : null),
      dataAtualizacao: json['dataAtualizacao'] != null
          ? parseDate(json['dataAtualizacao'])
          : (json['data_atualizacao'] != null
              ? parseDate(json['data_atualizacao'])
              : null),
    );
  }

  @override
  Map<String, dynamic> toJson() => toCreateJson();

  @override
  Map<String, dynamic> toCreateJson() {
    return {
      'tipo': _tipoToApi(),
      'data': formatDateTime(data),
      'cultivo_id': cultivoId,
      'planta_id': plantaId,
      'detalhes': detalhes,
      'notas': notas,
    };
  }

  @override
  Map<String, dynamic> toUpdateJson() {
    return {
      'tipo': _tipoToApi(),
      'data': formatDateTime(data),
      'detalhes': detalhes,
      'notas': notas,
    };
  }

  String _tipoToApi() => tipo.toUpperCase();

  Map<String, dynamic>? detalhesMap() {
    if (detalhes == null || detalhes!.isEmpty) return null;
    try {
      final decoded = jsonDecode(detalhes!);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  RegistroAcao copyWith({
    int? id,
    String? tipo,
    DateTime? data,
    int? cultivoId,
    int? plantaId,
    String? detalhes,
    String? notas,
    int? usuarioId,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
  }) {
    return RegistroAcao(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      data: data ?? this.data,
      cultivoId: cultivoId ?? this.cultivoId,
      plantaId: plantaId ?? this.plantaId,
      detalhes: detalhes ?? this.detalhes,
      notas: notas ?? this.notas,
      usuarioId: usuarioId ?? this.usuarioId,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}
