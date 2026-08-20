import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';

abstract class CrudRepository<T> {
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
        data: _toJson(item)..remove('id'),
      );
      return fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(e.error ?? createError);
    }
  }

  Future<T> update(T item) async {
    try {
      final id = _getId(item);
      final response = await _api.put(
        byIdPath(id),
        data: _toJson(item),
      );
      return fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(e.error ?? updateError);
    }
  }

  Future<void> delete(int id) async {
    try {
      await _api.delete(byIdPath(id));
    } on DioException catch (e) {
      throw Exception(e.error ?? deleteError);
    }
  }

  Map<String, dynamic> _toJson(T item) => (item as dynamic).toJson();

  int _getId(T item) => (item as dynamic).id as int;
}
