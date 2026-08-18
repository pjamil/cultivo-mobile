import '../utils/date_utils.dart';
import 'package:hive/hive.dart';

part 'insumo.g.dart';

@HiveType(typeId: 9)
class Insumo extends HiveObject {
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
      unidadeMedida: json['unidadeMedida'] ?? '',
      estoqueMinimo: json['estoqueMinimo']?.toDouble() ?? 0,
      dataCadastro: json['dataCadastro'] != null
          ? parseDate(json['dataCadastro'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'nome': nome,
      'tipo': tipo,
      'quantidade': quantidade,
      'unidadeMedida': unidadeMedida,
      'estoqueMinimo': estoqueMinimo,
      'dataCadastro': dataCadastro?.toIso8601String(),
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
