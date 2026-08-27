import '../utils/date_utils.dart';
import 'package:hive/hive.dart';

import '../crud/entidade_serializavel.dart';

part 'insumo.g.dart';

@HiveType(typeId: 9)
class Insumo extends HiveObject with EntidadeSerializavel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String codigo;

  @HiveField(2)
  final String nome;

  @HiveField(3)
  final String tipo;

  @HiveField(4)
  final double quantidade;

  @HiveField(5)
  final String unidadeMedida;

  @HiveField(6)
  final double estoqueMinimo;

  @HiveField(7)
  final DateTime? dataCadastro;

  Insumo({
    required this.id,
    required this.codigo,
    required this.nome,
    required this.tipo,
    required this.quantidade,
    required this.unidadeMedida,
    required this.estoqueMinimo,
    this.dataCadastro,
  });

  factory Insumo.fromJson(Map<String, dynamic> json) {
    return Insumo(
      id: json['id'] ?? 0,
      codigo: json['codigo'] ?? '',
      nome: json['nome'] ?? '',
      tipo: json['tipo'] ?? 'OUTRO',
      quantidade: json['quantidade']?.toDouble() ?? 0,
      unidadeMedida: json['unidadeMedida'] ?? json['unidade_medida'] ?? '',
      estoqueMinimo:
          (json['estoqueMinimo'] ?? json['estoque_minimo'])?.toDouble() ?? 0,
      dataCadastro: json['dataCadastro'] != null
          ? parseDate(json['dataCadastro'])
          : (json['data_cadastro'] != null
              ? parseDate(json['data_cadastro'])
              : null),
    );
  }

  @override
  Map<String, dynamic> toJson() => toCreateJson();

  @override
  Map<String, dynamic> toCreateJson() {
    return {
      'codigo': codigo,
      'nome': nome,
      'tipo': tipo,
      'quantidade': quantidade,
      'unidade_medida': unidadeMedida,
      'estoque_minimo': estoqueMinimo,
    };
  }

  @override
  Map<String, dynamic> toUpdateJson() {
    return {
      'nome': nome,
      'quantidade': quantidade,
      'estoqueMinimo': estoqueMinimo,
    };
  }

  Insumo copyWith({
    int? id,
    String? codigo,
    String? nome,
    String? tipo,
    double? quantidade,
    String? unidadeMedida,
    double? estoqueMinimo,
    DateTime? dataCadastro,
  }) {
    return Insumo(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
      quantidade: quantidade ?? this.quantidade,
      unidadeMedida: unidadeMedida ?? this.unidadeMedida,
      estoqueMinimo: estoqueMinimo ?? this.estoqueMinimo,
      dataCadastro: dataCadastro ?? this.dataCadastro,
    );
  }

  bool get isEstoqueBaixo => quantidade <= estoqueMinimo;
}
