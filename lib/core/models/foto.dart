import 'package:hive/hive.dart';

part 'foto.g.dart';

@HiveType(typeId: 10)
class Foto extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String? thumbnailUrl;

  @HiveField(3)
  final String? legenda;

  @HiveField(4)
  final String entityType;

  @HiveField(5)
  final int entityId;

  @HiveField(6)
  final String? cultivoEstado;

  @HiveField(7)
  final DateTime? createdAt;

  Foto({
    required this.id,
    required this.url,
    this.thumbnailUrl,
    this.legenda,
    required this.entityType,
    required this.entityId,
    this.cultivoEstado,
    this.createdAt,
  });

  factory Foto.fromJson(Map<String, dynamic> json) {
    return Foto(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      legenda: json['legenda'],
      entityType: json['entityType'] ?? '',
      entityId: json['entityId'] ?? 0,
      cultivoEstado: json['cultivoEstado'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'legenda': legenda,
      'entityType': entityType,
      'entityId': entityId,
      'cultivoEstado': cultivoEstado,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  Foto copyWith({
    int? id,
    String? url,
    String? thumbnailUrl,
    String? legenda,
    String? entityType,
    int? entityId,
    String? cultivoEstado,
    DateTime? createdAt,
  }) {
    return Foto(
      id: id ?? this.id,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      legenda: legenda ?? this.legenda,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      cultivoEstado: cultivoEstado ?? this.cultivoEstado,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
