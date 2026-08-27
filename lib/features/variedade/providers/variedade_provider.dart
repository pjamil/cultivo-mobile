import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/crud/crud_provider.dart';
import '../../../core/models/variedade.dart';
import '../data/variedade_repository.dart';

typedef VariedadeState = CrudState<Variedade>;

final variedadeProvider =
    StateNotifierProvider<CrudNotifier<Variedade>, VariedadeState>((ref) {
  final repository = ref.watch(variedadeRepositoryProvider);
  return CrudNotifier<Variedade>(repository);
});
