import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../api/api_client.dart';
import '../models/offline_operation.dart';
import 'local_storage.dart';

final offlineSyncProvider = Provider<OfflineSync>((ref) {
  return OfflineSync(ref);
});

class OfflineSync {
  final Ref _ref;

  OfflineSync(this._ref);

  static const Uuid _uuid = Uuid();

  LocalStorage get _storage => _ref.read(localStorageProvider);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<void> enqueueOperation({
    required String operation,
    required String entity,
    required String url,
    int? entityId,
    Map<String, dynamic>? data,
  }) async {
    await _storage.addToOfflineQueue(
      OfflineOperation(
        id: _uuid.v4(),
        operation: operation,
        entity: entity,
        entityId: entityId,
        data: data,
        url: url,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Future<int> syncPendingOperations() async {
    final pending = _storage.getPendingOperations();
    var synced = 0;

    for (final operation in pending) {
      try {
        await _replay(operation);
        await _storage.markAsSynced(operation.key);
        synced++;
      } catch (_) {
        break;
      }
    }

    if (synced > 0) {
      await _storage.clearSyncedOperations();
    }

    return synced;
  }

  Future<void> _replay(OfflineOperation operation) async {
    switch (operation.operation) {
      case 'POST':
        await _api.post(operation.url, data: operation.data);
        break;
      case 'PUT':
        await _api.put(operation.url, data: operation.data);
        break;
      case 'PATCH':
        await _api.patch(operation.url, data: operation.data);
        break;
      case 'DELETE':
        await _api.delete(operation.url);
        break;
    }
  }
}
