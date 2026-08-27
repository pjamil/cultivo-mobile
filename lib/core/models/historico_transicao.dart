import '../utils/date_utils.dart';

class HistoricoTransicao {
  final int id;
  final int cultivoId;
  final String estadoAnterior;
  final String estadoAtual;
  final DateTime dataTransicao;
  final int? usuarioId;
  final String? observacoes;
  int diasNoEstado;

  HistoricoTransicao({
    required this.id,
    required this.cultivoId,
    required this.estadoAnterior,
    required this.estadoAtual,
    required this.dataTransicao,
    this.usuarioId,
    this.observacoes,
    this.diasNoEstado = 0,
  });

  factory HistoricoTransicao.fromJson(Map<String, dynamic> json) {
    return HistoricoTransicao(
      id: json['id'] ?? 0,
      cultivoId: json['cultivoId'] ?? json['cultivo_id'] ?? 0,
      estadoAnterior: json['estadoAnterior'] ?? json['estado_anterior'] ?? '',
      estadoAtual: json['estadoAtual'] ?? json['estado_atual'] ?? '',
      dataTransicao:
          parseDate(json['dataTransicao'] ?? json['data_transicao']) ??
              DateTime.now(),
      usuarioId: json['usuarioId'] ?? json['usuario_id'],
      observacoes: json['observacoes'],
    );
  }
}

/// Calcula quantos dias o cultivo ficou em cada estado.
///
/// Considera a diferença entre a data da transição atual e a próxima.
/// Para a última transição usa [dataFim] (se informado) ou a data de
/// referência ([agora], padrão: hoje).
List<HistoricoTransicao> calcularDiasNoEstado(
  List<HistoricoTransicao> transicoes, {
  DateTime? dataFim,
  DateTime? agora,
}) {
  if (transicoes.isEmpty) return [];

  final sorted = [...transicoes]..sort((a, b) {
      final porData = a.dataTransicao.compareTo(b.dataTransicao);
      return porData != 0 ? porData : a.id.compareTo(b.id);
    });

  final referencia = agora ?? DateTime.now();

  for (var i = 0; i < sorted.length; i++) {
    final inicio = DateTime(
      sorted[i].dataTransicao.year,
      sorted[i].dataTransicao.month,
      sorted[i].dataTransicao.day,
    );
    final fimBruto = i + 1 < sorted.length
        ? sorted[i + 1].dataTransicao
        : (dataFim ?? referencia);
    final fim = DateTime(fimBruto.year, fimBruto.month, fimBruto.day);
    final dias = fim.difference(inicio).inDays;
    sorted[i].diasNoEstado = dias < 0 ? 0 : dias;
  }

  return sorted;
}

/// Verifica se [novaData] respeita a ordem cronológica das transições,
/// ficando entre a transição [anterior] (inclusive) e a [proxima] (inclusive).
bool dataTransicaoValida(
  DateTime novaData, {
  DateTime? anterior,
  DateTime? proxima,
}) {
  if (anterior != null && novaData.isBefore(anterior)) return false;
  if (proxima != null && novaData.isAfter(proxima)) return false;
  return true;
}
