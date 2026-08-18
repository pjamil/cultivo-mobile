import 'package:hive/hive.dart';

part 'variedade.g.dart';

@HiveType(typeId: 2)
class Variedade extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String nome;

  @HiveField(2)
  final String? descricao;

  @HiveField(3)
  final String tipoVariedade;

  @HiveField(4)
  final String tipoEspecie;

  @HiveField(5)
  final String? tempoFloracao;

  @HiveField(6)
  final String? origem;

  @HiveField(7)
  final String? caracteristicas;

  Variedade({
    required this.id,
    required this.nome,
    this.descricao,
    required this.tipoVariedade,
    required this.tipoEspecie,
    this.tempoFloracao,
    this.origem,
    this.caracteristicas,
  });

  factory Variedade.fromJson(Map<String, dynamic> json) {
    return Variedade(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      descricao: json['descricao'],
      tipoVariedade: json['tipoVariedade'] ?? json['tipoGenetica'] ?? 'INDICA',
      tipoEspecie: json['tipoEspecie'] ?? 'REGULAR',
      tempoFloracao: json['tempoFloracao']?.toString(),
      origem: json['origem'],
      caracteristicas: json['caracteristicas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'tipoVariedade': tipoVariedade,
      'tipoEspecie': tipoEspecie,
      'tempoFloracao': tempoFloracao,
      'origem': origem,
      'caracteristicas': caracteristicas,
    };
  }

  Variedade copyWith({
    int? id,
    String? nome,
    String? descricao,
    String? tipoVariedade,
    String? tipoEspecie,
    String? tempoFloracao,
    String? origem,
    String? caracteristicas,
  }) {
    return Variedade(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      tipoVariedade: tipoVariedade ?? this.tipoVariedade,
      tipoEspecie: tipoEspecie ?? this.tipoEspecie,
      tempoFloracao: tempoFloracao ?? this.tempoFloracao,
      origem: origem ?? this.origem,
      caracteristicas: caracteristicas ?? this.caracteristicas,
    );
  }
}
