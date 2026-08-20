import '../utils/date_utils.dart';
import 'package:hive/hive.dart';

part 'diario.g.dart';

@HiveType(typeId: 5)
class DiarioCultivo extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String titulo;

  @HiveField(2)
  final String conteudo;

  @HiveField(3)
  final DateTime? data;

  @HiveField(4)
  final int? userId;

  DiarioCultivo({
    required this.id,
    required this.titulo,
    required this.conteudo,
    this.data,
    this.userId,
  });

  factory DiarioCultivo.fromJson(Map<String, dynamic> json) {
    return DiarioCultivo(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      conteudo: json['conteudo'] ?? '',
      data: json['data'] != null ? parseDate(json['data']) : null,
      userId: json['userId'] ?? json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'conteudo': conteudo,
      'data': formatDateOnly(data),
    };
  }

  DiarioCultivo copyWith({
    int? id,
    String? titulo,
    String? conteudo,
    DateTime? data,
    int? userId,
  }) {
    return DiarioCultivo(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      conteudo: conteudo ?? this.conteudo,
      data: data ?? this.data,
      userId: userId ?? this.userId,
    );
  }
}
