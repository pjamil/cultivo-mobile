import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'crud_repository.dart';

enum CrudStatus { initial, loading, loaded, error }

class CrudState<T> {
  final CrudStatus status;
  final List<T> items;
  final T? selected;
  final String? error;

  const CrudState({
    this.status = CrudStatus.initial,
    this.items = const [],
    this.selected,
    this.error,
  });

  CrudState<T> copyWith({
    CrudStatus? status,
    List<T>? items,
    T? selected,
    String? error,
    bool clearSelected = false,
  }) {
    return CrudState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      selected: clearSelected ? null : selected ?? this.selected,
      error: error,
    );
  }
}

class CrudNotifier<T> extends StateNotifier<CrudState<T>> {
  final CrudRepository<T> _repository;

  CrudRepository<T> get repository => _repository;

  CrudNotifier(this._repository) : super(CrudState<T>()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(status: CrudStatus.loading);
    try {
      final items = await _repository.getAll();
      state = state.copyWith(status: CrudStatus.loaded, items: items);
    } catch (e) {
      state = state.copyWith(status: CrudStatus.error, error: e.toString());
    }
  }

  Future<void> loadById(int id) async {
    state = state.copyWith(status: CrudStatus.loading);
    try {
      final item = await _repository.getById(id);
      state = state.copyWith(status: CrudStatus.loaded, selected: item);
    } catch (e) {
      state = state.copyWith(status: CrudStatus.error, error: e.toString());
    }
  }

  Future<void> create(T item) async {
    state = state.copyWith(status: CrudStatus.loading);
    try {
      final created = await _repository.create(item);
      state = state.copyWith(
        status: CrudStatus.loaded,
        items: [...state.items, created],
      );
    } catch (e) {
      state = state.copyWith(status: CrudStatus.error, error: e.toString());
    }
  }

  Future<void> update(T item) async {
    state = state.copyWith(status: CrudStatus.loading);
    try {
      final updated = await _repository.update(item);
      final id = _getId(item);
      state = state.copyWith(
        status: CrudStatus.loaded,
        items: state.items.map((i) => _getId(i) == id ? updated : i).toList(),
        selected: updated,
      );
    } catch (e) {
      state = state.copyWith(status: CrudStatus.error, error: e.toString());
    }
  }

  Future<void> delete(int id) async {
    state = state.copyWith(status: CrudStatus.loading);
    try {
      await _repository.delete(id);
      state = state.copyWith(
        status: CrudStatus.loaded,
        items: state.items.where((i) => _getId(i) != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(status: CrudStatus.error, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  int _getId(T item) => (item as dynamic).id as int;
}
