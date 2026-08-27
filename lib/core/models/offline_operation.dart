import 'package:hive/hive.dart';

part 'offline_operation.g.dart';

@HiveType(typeId: 11)
class OfflineOperation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String operation;

  @HiveField(2)
  final String entity;

  @HiveField(3)
  final int? entityId;

  @HiveField(4)
  final Map<String, dynamic>? data;

  @HiveField(5)
  final String url;

  @HiveField(6)
  final int timestamp;

  @HiveField(7)
  bool synced;

  @HiveField(8)
  String? syncedAt;

  @HiveField(9)
  String? error;

  OfflineOperation({
    required this.id,
    required this.operation,
    required this.entity,
    this.entityId,
    this.data,
    required this.url,
    required this.timestamp,
    this.synced = false,
    this.syncedAt,
    this.error,
  });

  factory OfflineOperation.fromJson(Map<String, dynamic> json) {
    return OfflineOperation(
      id: json['id'] ?? '',
      operation: json['operation'] ?? '',
      entity: json['entity'] ?? '',
      entityId: json['entityId'],
      data: json['data'],
      url: json['url'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      synced: json['synced'] ?? false,
      syncedAt: json['syncedAt'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operation': operation,
      'entity': entity,
      'entityId': entityId,
      'data': data,
      'url': url,
      'timestamp': timestamp,
      'synced': synced,
      'syncedAt': syncedAt,
      'error': error,
    };
  }
}
