import '../utils/date_utils.dart';
import 'package:hive/hive.dart';

part 'usuario.g.dart';

@HiveType(typeId: 0)
class Usuario extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String nome;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String papel;

  @HiveField(4)
  final bool ativo;

  @HiveField(5)
  final DateTime? dataCadastro;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.papel,
    this.ativo = true,
    this.dataCadastro,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      papel: json['papel'] ?? 'USUARIO',
      ativo: json['ativo'] ?? true,
      dataCadastro: json['dataCadastro'] != null
          ? parseDate(json['dataCadastro'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'papel': papel,
      'ativo': ativo,
      'dataCadastro': dataCadastro?.toIso8601String(),
    };
  }

  Usuario copyWith({
    int? id,
    String? nome,
    String? email,
    String? papel,
    bool? ativo,
    DateTime? dataCadastro,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      papel: papel ?? this.papel,
      ativo: ativo ?? this.ativo,
      dataCadastro: dataCadastro ?? this.dataCadastro,
    );
  }

  bool get isAdmin => papel == 'ADMINISTRADOR';
}
