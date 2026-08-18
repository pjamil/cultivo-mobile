import 'package:hive/hive.dart';

part 'ambiente.g.dart';

@HiveType(typeId: 6)
class Ambiente extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String nome;

  @HiveField(2)
  final String? descricao;

  @HiveField(3)
  final String tipo;

  @HiveField(4)
  final double? comprimento;

  @HiveField(5)
  final double? altura;

  @HiveField(6)
  final double? largura;

  @HiveField(7)
  final String? tempoExposicao;

  @HiveField(8)
  final String? orientacao;

  Ambiente({
    required this.id,
    required this.nome,
    this.descricao,
    required this.tipo,
    this.comprimento,
    this.altura,
    this.largura,
    this.tempoExposicao,
    this.orientacao,
  });

  factory Ambiente.fromJson(Map<String, dynamic> json) {
    return Ambiente(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      descricao: json['descricao'],
      tipo: json['tipo'] ?? 'OUTRO',
      comprimento: json['comprimento']?.toDouble(),
      altura: json['altura']?.toDouble(),
      largura: json['largura']?.toDouble(),
      tempoExposicao: json['tempoExposicao']?.toString(),
      orientacao: json['orientacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'tipo': tipo,
      'comprimento': comprimento,
      'altura': altura,
      'largura': largura,
      'tempoExposicao': tempoExposicao,
      'orientacao': orientacao,
    };
  }

  Ambiente copyWith({
    int? id,
    String? nome,
    String? descricao,
    String? tipo,
    double? comprimento,
    double? altura,
    double? largura,
    String? tempoExposicao,
    String? orientacao,
  }) {
    return Ambiente(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      tipo: tipo ?? this.tipo,
      comprimento: comprimento ?? this.comprimento,
      altura: altura ?? this.altura,
      largura: largura ?? this.largura,
      tempoExposicao: tempoExposicao ?? this.tempoExposicao,
      orientacao: orientacao ?? this.orientacao,
    );
  }
}
