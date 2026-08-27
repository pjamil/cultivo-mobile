import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/meio_cultivo.dart';
import '../data/meio_cultivo_repository.dart';

typedef MeioCultivoState = CrudState<MeioCultivo>;

final meioCultivoProvider =
    StateNotifierProvider<CrudNotifier<MeioCultivo>, MeioCultivoState>((ref) {
  final repository = ref.watch(meioCultivoRepositoryProvider);
  return CrudNotifier<MeioCultivo>(repository);
});
