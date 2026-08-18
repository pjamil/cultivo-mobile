import 'package:flutter_test/flutter_test.dart';
import 'package:cultivo_mobile/core/models/tarefa.dart';

void main() {
  group('Tarefa Model', () {
    test('should create Tarefa from JSON', () {
      final json = {
        'id': 1,
        'titulo': 'Podar plantas',
        'descricao': 'Realizar poda das folhas inferiores',
        'status': 'PENDENTE',
        'prioridade': 'ALTA',
        'dataCriacao': '2024-01-15T00:00:00.000',
        'dataVencimento': '2024-01-20T00:00:00.000',
        'usuarioId': 1,
        'cultivoId': 5,
      };
      final tarefa = Tarefa.fromJson(json);
      expect(tarefa.id, 1);
      expect(tarefa.titulo, 'Podar plantas');
      expect(tarefa.descricao, 'Realizar poda das folhas inferiores');
      expect(tarefa.status, 'PENDENTE');
      expect(tarefa.prioridade, 'ALTA');
      expect(tarefa.dataCriacao, isNotNull);
      expect(tarefa.dataVencimento, isNotNull);
      expect(tarefa.usuarioId, 1);
      expect(tarefa.cultivoId, 5);
    });

    test('should convert Tarefa to JSON', () {
      final tarefa = Tarefa(
        id: 1,
        titulo: 'Podar plantas',
        status: 'PENDENTE',
        prioridade: 'ALTA',
      );
      final json = tarefa.toJson();
      expect(json['id'], 1);
      expect(json['titulo'], 'Podar plantas');
      expect(json['status'], 'PENDENTE');
      expect(json['prioridade'], 'ALTA');
    });

    test('should check status getters', () {
      final concluida = Tarefa(id: 1, titulo: 'T', status: 'CONCLUIDA');
      final pendente = Tarefa(id: 2, titulo: 'T', status: 'PENDENTE');
      final emAndamento = Tarefa(id: 3, titulo: 'T', status: 'EM_ANDAMENTO');

      expect(concluida.isConcluida, true);
      expect(concluida.isPendente, false);
      expect(concluida.isEmAndamento, false);

      expect(pendente.isConcluida, false);
      expect(pendente.isPendente, true);
      expect(pendente.isEmAndamento, false);

      expect(emAndamento.isConcluida, false);
      expect(emAndamento.isPendente, false);
      expect(emAndamento.isEmAndamento, true);
    });

    test('should copyWith correctly', () {
      final original = Tarefa(id: 1, titulo: 'Original', status: 'PENDENTE');
      final copied = original.copyWith(titulo: 'Atualizado', status: 'CONCLUIDA');
      expect(copied.id, 1);
      expect(copied.titulo, 'Atualizado');
      expect(copied.status, 'CONCLUIDA');
    });

    test('should handle null fields in JSON', () {
      final json = <String, dynamic>{'id': 1, 'titulo': 'Teste'};
      final tarefa = Tarefa.fromJson(json);
      expect(tarefa.status, 'PENDENTE');
      expect(tarefa.prioridade, 'MEDIA');
      expect(tarefa.descricao, isNull);
      expect(tarefa.dataCriacao, isNull);
      expect(tarefa.dataVencimento, isNull);
      expect(tarefa.recorrencia, isNull);
      expect(tarefa.dataFimRecorrencia, isNull);
    });

    test('should handle recurrence fields', () {
      final tarefa = Tarefa(
        id: 1,
        titulo: 'Tarefa Recorrente',
        recorrencia: 'SEMANAL',
        dataVencimento: DateTime(2024, 1, 20),
        dataFimRecorrencia: DateTime(2024, 6, 30),
      );
      expect(tarefa.recorrencia, 'SEMANAL');
      expect(tarefa.temRecorrencia, true);
      expect(tarefa.dataFimRecorrencia, DateTime(2024, 6, 30));
    });

    test('should check temRecorrencia getter', () {
      final comRecorrencia = Tarefa(id: 1, titulo: 'T', recorrencia: 'DIARIA');
      final semRecorrencia = Tarefa(id: 2, titulo: 'T', recorrencia: 'NENHUMA');
      final nula = Tarefa(id: 3, titulo: 'T');

      expect(comRecorrencia.temRecorrencia, true);
      expect(semRecorrencia.temRecorrencia, false);
      expect(nula.temRecorrencia, false);
    });
  });
}
