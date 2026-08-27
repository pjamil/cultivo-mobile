import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../storage/offline_sync.dart';
import 'entidade_serializavel.dart';

abstract class CrudRepository<T extends EntidadeSerializavel> {
  final Ref _ref;

  CrudRepository(this._ref);

  ApiClient get api => _ref.read(apiClientProvider);

  ApiClient get _api => api;

  String get basePath;

  String byIdPath(int id) => '$basePath/$id';

  String get resourceName;

  T fromJson(Map<String, dynamic> json);

  String get getAllError;

  String get getByIdError;

  String get createError;

  String get updateError;

  String get deleteError;

  Future<List<T>> getAll() async {
    try {
      final response = await _api.get(basePath);
      final data = response.data;
      List<dynamic> rawList;
      if (data is List) {
        rawList = data;
      } else if (data is Map<String, dynamic> && data['content'] is List) {
        rawList = data['content'] as List;
      } else {
        rawList = [];
      }
      return rawList
          .map((json) => fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.error ?? getAllError);
    }
  }

  Future<T> getById(int id) async {
    try {
      final response = await _api.get(byIdPath(id));
      return fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(e.error ?? getByIdError);
    }
  }

  Future<T> create(T item) async {
    try {
      final response = await _api.post(
        basePath,
        data: createBody(item),
      );
      return fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (_isConnectionError(e)) {
        await _enqueueOffline('POST', basePath, item, null);
      }
      throw Exception(e.error ?? createError);
    }
  }

  Future<T> update(T item) async {
    try {
      final id = _getId(item);
      final response = await _api.put(
        byIdPath(id),
        data: updateBody(item),
      );
      return fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (_isConnectionError(e)) {
        await _enqueueOffline(
            'PUT', byIdPath(_getId(item)), item, _getId(item));
      }
      throw Exception(e.error ?? updateError);
    }
  }

  Future<void> delete(int id) async {
    try {
      await _api.delete(byIdPath(id));
    } on DioException catch (e) {
      if (_isConnectionError(e)) {
        await _ref.read(offlineSyncProvider).enqueueOperation(
              operation: 'DELETE',
              entity: resourceName,
              url: byIdPath(id),
              entityId: id,
            );
      }
      throw Exception(e.error ?? deleteError);
    }
  }

  bool _isConnectionError(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout;
  }

  Future<void> _enqueueOffline(
    String operation,
    String url,
    T item,
    int? entityId,
  ) async {
    await _ref.read(offlineSyncProvider).enqueueOperation(
          operation: operation,
          entity: resourceName,
          url: url,
          entityId: entityId,
          data: operation == 'POST' ? createBody(item) : updateBody(item),
        );
  }

  Map<String, dynamic> createBody(T item) => item.toCreateJson();

  Map<String, dynamic> updateBody(T item) => item.toUpdateJson();

  int _getId(T item) => (item as dynamic).id as int;
}
