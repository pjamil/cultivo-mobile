import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/offline_operation.dart';

final localStorageProvider = Provider<LocalStorage>((ref) {
  return LocalStorage();
});

class LocalStorage {
  static const String _boxName = 'cultivo_db';
  static const String _offlineQueueBox = 'offline_queue';
  late Box _box;
  late Box<OfflineOperation> _offlineQueue;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(OfflineOperationAdapter());
    _box = await Hive.openBox(_boxName);
    _offlineQueue = await Hive.openBox<OfflineOperation>(_offlineQueueBox);
  }

  // Offline Queue
  Future<void> addToOfflineQueue(OfflineOperation operation) async {
    await _offlineQueue.add(operation);
  }

  List<OfflineOperation> getPendingOperations() {
    return _offlineQueue.values
        .where((op) => !op.synced)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Future<void> markAsSynced(int key) async {
    final operation = _offlineQueue.get(key);
    if (operation != null) {
      operation.synced = true;
      operation.syncedAt = DateTime.now();
      await _offlineQueue.put(key, operation);
    }
  }

  Future<void> removeFromQueue(int key) async {
    await _offlineQueue.delete(key);
  }

  Future<void> clearSyncedOperations() async {
    final keysToDelete = _offlineQueue.keys.where((key) {
      final op = _offlineQueue.get(key);
      return op?.synced == true;
    }).toList();
    await _offlineQueue.deleteAll(keysToDelete);
  }

  // Generic CRUD operations
  Future<void> put<T>(String boxName, dynamic key, T value) async {
    final box = await Hive.openBox(boxName);
    await box.put(key, value);
  }

  T? get<T>(String boxName, dynamic key) {
    final box = Hive.box(boxName);
    return box.get(key) as T?;
  }

  List<T> getAll<T>(String boxName) {
    final box = Hive.box(boxName);
    return box.values.toList().cast<T>();
  }

  Future<void> delete(String boxName, dynamic key) async {
    final box = await Hive.openBox(boxName);
    await box.delete(key);
  }

  Future<void> clear(String boxName) async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }

  // Box getters
  Box get plantasBox => _box;
  Box get cultivosBox => _box;
  Box get diariosBox => _box;
  Box get tarefasBox => _box;
  Box get ambientesBox => _box;
  Box get variedadesBox => _box;
  Box get meiosCultivoBox => _box;
  Box get insumosBox => _box;
}
