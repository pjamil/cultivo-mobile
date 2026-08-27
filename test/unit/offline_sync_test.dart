import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:cultivo_mobile/core/api/api_client.dart';
import 'package:cultivo_mobile/core/storage/local_storage.dart';
import 'package:cultivo_mobile/core/storage/offline_sync.dart';

class FakeApiClient extends ApiClient {
  final List<(String, String)> calls = [];

  FakeApiClient(super.ref);

  @override
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    calls.add(('POST', path));
    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 201,
      data: {'id': 99},
    );
  }

  @override
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    calls.add(('PUT', path));
    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: {'id': 1},
    );
  }

  @override
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    calls.add(('DELETE', path));
    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
    );
  }
}

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test');
    await LocalStorage.instance.init(path: tempDir.path);
  });

  tearDown(() async {
    Hive.resetAdapters();
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  ProviderContainer makeContainer() {
    return ProviderContainer(
      overrides: [
        apiClientProvider.overrideWith((ref) => FakeApiClient(ref)),
        localStorageProvider.overrideWith((ref) => LocalStorage.instance),
      ],
    );
  }

  test('enqueueOperation adds a pending operation', () async {
    final container = makeContainer();
    final sync = container.read(offlineSyncProvider);

    await sync.enqueueOperation(
      operation: 'POST',
      entity: 'plantas',
      url: '/v1/plantas',
      data: {'nome': 'Tomate'},
    );

    final pending = container.read(localStorageProvider).getPendingOperations();
    expect(pending.length, 1);
    expect(pending.first.operation, 'POST');
    expect(pending.first.entity, 'plantas');
    expect(pending.first.data, {'nome': 'Tomate'});
    container.dispose();
  });

  test('syncPendingOperations replays operations in order and marks synced',
      () async {
    final container = makeContainer();
    final sync = container.read(offlineSyncProvider);
    final api = container.read(apiClientProvider) as FakeApiClient;

    await sync.enqueueOperation(
      operation: 'POST',
      entity: 'plantas',
      url: '/v1/plantas',
      data: {'nome': 'Tomate'},
    );
    await sync.enqueueOperation(
      operation: 'DELETE',
      entity: 'tarefas',
      url: '/v1/tarefas/5',
      entityId: 5,
    );

    final synced = await sync.syncPendingOperations();

    expect(synced, 2);
    expect(api.calls, [
      ('POST', '/v1/plantas'),
      ('DELETE', '/v1/tarefas/5'),
    ]);
    final pending = container.read(localStorageProvider).getPendingOperations();
    expect(pending, isEmpty);
    container.dispose();
  });
}
