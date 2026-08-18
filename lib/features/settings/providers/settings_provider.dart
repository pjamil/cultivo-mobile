import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final bool tarefaReminder;
  final bool estoqueAlert;

  SettingsState({
    this.tarefaReminder = true,
    this.estoqueAlert = true,
  });

  SettingsState copyWith({
    bool? tarefaReminder,
    bool? estoqueAlert,
  }) {
    return SettingsState(
      tarefaReminder: tarefaReminder ?? this.tarefaReminder,
      estoqueAlert: estoqueAlert ?? this.estoqueAlert,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState());

  void toggleTarefaReminder() {
    state = state.copyWith(tarefaReminder: !state.tarefaReminder);
  }

  void toggleEstoqueAlert() {
    state = state.copyWith(estoqueAlert: !state.estoqueAlert);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
