class DashboardData {
  final int cultivosAtivos;
  final int tarefasPendentes;
  final int alertasEstoque;
  final List<AtividadeRecente> atividadesRecentes;
  final Map<String, int> cultivosPorStatus;

  DashboardData({
    required this.cultivosAtivos,
    required this.tarefasPendentes,
    required this.alertasEstoque,
    required this.atividadesRecentes,
    required this.cultivosPorStatus,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      cultivosAtivos: json['cultivosAtivos'] ?? 0,
      tarefasPendentes: json['tarefasPendentes'] ?? 0,
      alertasEstoque: json['alertasEstoque'] ?? 0,
      atividadesRecentes: (json['atividadesRecentes'] as List?)
              ?.map((a) => AtividadeRecente.fromJson(a))
              .toList() ??
          [],
      cultivosPorStatus: Map<String, int>.from(json['cultivosPorStatus'] ?? {}),
    );
  }
}

class AtividadeRecente {
  final String tipo;
  final String titulo;
  final DateTime data;

  AtividadeRecente({
    required this.tipo,
    required this.titulo,
    required this.data,
  });

  factory AtividadeRecente.fromJson(Map<String, dynamic> json) {
    return AtividadeRecente(
      tipo: json['tipo'] ?? '',
      titulo: json['titulo'] ?? '',
      data: DateTime.parse(json['data'] ?? DateTime.now().toIso8601String()),
    );
  }
}
