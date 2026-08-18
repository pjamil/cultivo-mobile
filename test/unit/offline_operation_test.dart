import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/offline_operation.dart';

void main() {
  group('OfflineOperation Model', () {
    test('should create OfflineOperation from JSON', () {
      final json = {
        'id': 'uuid-123',
        'operation': 'CREATE',
        'entity': 'PLANTA',
        'entityId': 10,
        'data': {'nome': 'Tomate'},
        'url': '/plantas',
        'timestamp': 1700000000000,
        'synced': false,
        'syncedAt': '2024-01-15T14:30:00.000',
        'error': null,
      };
      final op = OfflineOperation.fromJson(json);
      expect(op.id, 'uuid-123');
      expect(op.operation, 'CREATE');
      expect(op.entity, 'PLANTA');
      expect(op.entityId, 10);
      expect(op.data, {'nome': 'Tomate'});
      expect(op.url, '/plantas');
      expect(op.timestamp, 1700000000000);
      expect(op.synced, false);
      expect(op.syncedAt, isNotNull);
      expect(op.error, isNull);
    });

    test('should convert OfflineOperation to JSON', () {
      final op = OfflineOperation(
        id: 'uuid-456',
        operation: 'UPDATE',
        entity: 'CULTIVO',
        entityId: 5,
        url: '/cultivos/5',
        timestamp: 1700000000000,
        synced: true,
      );
      final json = op.toJson();
      expect(json['id'], 'uuid-456');
      expect(json['operation'], 'UPDATE');
      expect(json['entity'], 'CULTIVO');
      expect(json['entityId'], 5);
      expect(json['synced'], true);
    });

    test('should have mutable synced field', () {
      final op = OfflineOperation(
        id: 'uuid-789',
        operation: 'DELETE',
        entity: 'TAREFA',
        url: '/tarefas/3',
        timestamp: 1700000000000,
      );
      expect(op.synced, false);
      op.synced = true;
      expect(op.synced, true);
    });

    test('should handle null fields in JSON', () {
      final json = <String, dynamic>{
        'id': 'uuid-000',
        'operation': 'CREATE',
        'entity': 'DIARIO',
        'url': '/diario',
        'timestamp': 1700000000000,
      };
      final op = OfflineOperation.fromJson(json);
      expect(op.entityId, isNull);
      expect(op.data, isNull);
      expect(op.synced, false);
      expect(op.syncedAt, isNull);
      expect(op.error, isNull);
    });
  });
}
