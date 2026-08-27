import 'package:hive/hive.dart';

import '../crud/entidade_serializavel.dart';
import '../utils/date_utils.dart';

part 'dado_ambiental.g.dart';

@HiveType(typeId: 13)
class DadoAmbiental extends HiveObject with EntidadeSerializavel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int? cultivoId;

  @HiveField(2)
  final String tipoMedicao;

  @HiveField(3)
  final double valor;

  @HiveField(4)
  final String unidade;

  @HiveField(5)
  final DateTime? dataHora;

  DadoAmbiental({
    required this.id,
    this.cultivoId,
    this.tipoMedicao = 'TEMPERATURA',
    this.valor = 0,
    this.unidade = '°C',
    this.dataHora,
  });

  factory DadoAmbiental.fromJson(Map<String, dynamic> json) {
    return DadoAmbiental(
      id: json['id'] ?? 0,
      cultivoId: json['cultivo_id'],
      tipoMedicao: json['tipo_medicao'] ?? 'TEMPERATURA',
      valor: json['valor']?.toDouble() ?? 0,
      unidade: json['unidade'] ?? '',
      dataHora: parseDate(json['data_hora']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'cultivo_id': cultivoId,
      'tipo_medicao': tipoMedicao,
      'valor': valor,
      'unidade': unidade,
      'data_hora': formatDateTime(dataHora),
    };
  }

  DadoAmbiental copyWith({
    int? id,
    int? cultivoId,
    String? tipoMedicao,
    double? valor,
    String? unidade,
    DateTime? dataHora,
  }) {
    return DadoAmbiental(
      id: id ?? this.id,
      cultivoId: cultivoId ?? this.cultivoId,
      tipoMedicao: tipoMedicao ?? this.tipoMedicao,
      valor: valor ?? this.valor,
      unidade: unidade ?? this.unidade,
      dataHora: dataHora ?? this.dataHora,
    );
  }

  String get tipoLabel {
    switch (tipoMedicao) {
      case 'TEMPERATURA':
        return 'Temperatura';
      case 'UMIDADE':
        return 'Umidade';
      case 'LUMINOSIDADE':
        return 'Luminosidade';
      case 'UMIDADE_SOLO':
        return 'Umidade do Solo';
      case 'PH':
        return 'pH';
      case 'NIVEL_AGUA':
        return 'Nível de Água';
      default:
        return tipoMedicao;
    }
  }
}
