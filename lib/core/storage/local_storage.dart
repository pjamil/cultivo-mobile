import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/offline_operation.dart';

final localStorageProvider = Provider<LocalStorage>((ref) {
  return LocalStorage.instance;
});

class LocalStorage {
  LocalStorage._();

  static final LocalStorage instance = LocalStorage._();

  static const String _offlineQueueBox = 'offline_queue';
  late Box<OfflineOperation> _offlineQueue;

  Future<void> init({String? path}) async {
    if (path != null) {
      Hive.init(path);
    } else {
      await Hive.initFlutter();
    }
    Hive.registerAdapter(OfflineOperationAdapter());
    _offlineQueue = await Hive.openBox<OfflineOperation>(_offlineQueueBox);
  }

  Future<void> addToOfflineQueue(OfflineOperation operation) async {
    await _offlineQueue.add(operation);
  }

  List<OfflineOperation> getPendingOperations() {
    return _offlineQueue.values.where((op) => !op.synced).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Future<void> markAsSynced(int key) async {
    final operation = _offlineQueue.get(key);
    if (operation != null) {
      operation.synced = true;
      operation.syncedAt = DateTime.now().toIso8601String();
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
}
