import '../utils/date_utils.dart';
import 'package:hive/hive.dart';

import '../crud/entidade_serializavel.dart';

part 'tarefa.g.dart';

@HiveType(typeId: 8)
class Tarefa extends HiveObject with EntidadeSerializavel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String titulo;

  @HiveField(2)
  final String? descricao;

  @HiveField(3)
  final String status;

  @HiveField(4)
  final String prioridade;

  @HiveField(5)
  final DateTime? dataCriacao;

  @HiveField(6)
  final DateTime? dataVencimento;

  @HiveField(7)
  final int? usuarioId;

  @HiveField(8)
  final int? cultivoId;

  @HiveField(9)
  final String? recorrencia;

  @HiveField(10)
  final DateTime? dataFimRecorrencia;

  Tarefa({
    required this.id,
    required this.titulo,
    this.descricao,
    this.status = 'PENDENTE',
    this.prioridade = 'MEDIA',
    this.dataCriacao,
    this.dataVencimento,
    this.usuarioId,
    this.cultivoId,
    this.recorrencia,
    this.dataFimRecorrencia,
  });

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'],
      status: _normalizeStatus(json['status']),
      prioridade: _normalizePrioridade(json['prioridade']),
      dataCriacao: json['dataCriacao'] != null
          ? parseDate(json['dataCriacao'])
          : (json['data_criacao'] != null
              ? parseDate(json['data_criacao'])
              : null),
      dataVencimento: json['dataVencimento'] != null
          ? parseDate(json['dataVencimento'])
          : (json['data_vencimento'] != null
              ? parseDate(json['data_vencimento'])
              : null),
      usuarioId: json['usuarioId'] ?? json['usuario_id'],
      cultivoId: json['cultivoId'] ?? json['cultivo_id'],
      recorrencia: _normalizeRecorrencia(json['recorrencia']),
      dataFimRecorrencia: json['dataFimRecorrencia'] != null
          ? parseDate(json['dataFimRecorrencia'])
          : (json['data_fim_recorrencia'] != null
              ? parseDate(json['data_fim_recorrencia'])
              : null),
    );
  }

  static String _normalizeStatus(dynamic value) {
    if (value == null) return 'PENDENTE';
    switch (value.toString()) {
      case 'pendente':
        return 'PENDENTE';
      case 'em_andamento':
        return 'EM_ANDAMENTO';
      case 'concluida':
        return 'CONCLUIDA';
      default:
        return value.toString().toUpperCase();
    }
  }

  static String _normalizePrioridade(dynamic value) {
    if (value == null) return 'MEDIA';
    switch (value.toString()) {
      case 'baixa':
        return 'BAIXA';
      case 'media':
        return 'MEDIA';
      case 'alta':
        return 'ALTA';
      default:
        return value.toString().toUpperCase();
    }
  }

  static String _normalizeRecorrencia(dynamic value) {
    if (value == null) return 'NENHUMA';
    return value.toString().toUpperCase();
  }

  String _statusToApi() => switch (status) {
        'PENDENTE' => 'pendente',
        'EM_ANDAMENTO' => 'em_andamento',
        'CONCLUIDA' => 'concluida',
        _ => status.toLowerCase(),
      };

  String _prioridadeToApi() => switch (prioridade) {
        'BAIXA' => 'baixa',
        'MEDIA' => 'media',
        'ALTA' => 'alta',
        _ => prioridade.toLowerCase(),
      };

  @override
  Map<String, dynamic> toJson() => toCreateJson();

  @override
  Map<String, dynamic> toCreateJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'prioridade': _prioridadeToApi(),
      'data_vencimento': formatDateOnly(dataVencimento),
    };
  }

  @override
  Map<String, dynamic> toUpdateJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'status': _statusToApi(),
      'prioridade': _prioridadeToApi(),
      'data_vencimento': formatDateOnly(dataVencimento),
    };
  }

  Tarefa copyWith({
    int? id,
    String? titulo,
    String? descricao,
    String? status,
    String? prioridade,
    DateTime? dataCriacao,
    DateTime? dataVencimento,
    int? usuarioId,
    int? cultivoId,
    String? recorrencia,
    DateTime? dataFimRecorrencia,
  }) {
    return Tarefa(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      status: status ?? this.status,
      prioridade: prioridade ?? this.prioridade,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataVencimento: dataVencimento ?? this.dataVencimento,
      usuarioId: usuarioId ?? this.usuarioId,
      cultivoId: cultivoId ?? this.cultivoId,
      recorrencia: recorrencia ?? this.recorrencia,
      dataFimRecorrencia: dataFimRecorrencia ?? this.dataFimRecorrencia,
    );
  }

  bool get isConcluida => status == 'CONCLUIDA';
  bool get isPendente => status == 'PENDENTE';
  bool get isEmAndamento => status == 'EM_ANDAMENTO';
  bool get temRecorrencia => recorrencia != null && recorrencia != 'NENHUMA';
}
