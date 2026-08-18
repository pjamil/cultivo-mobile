// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tarefa.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TarefaAdapter extends TypeAdapter<Tarefa> {
  @override
  final int typeId = 8;

  @override
  Tarefa read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tarefa(
      id: fields[0] as int,
      titulo: fields[1] as String,
      descricao: fields[2] as String?,
      status: fields[3] as String,
      prioridade: fields[4] as String,
      dataCriacao: fields[5] as DateTime?,
      dataVencimento: fields[6] as DateTime?,
      usuarioId: fields[7] as int?,
      cultivoId: fields[8] as int?,
      recorrencia: fields[9] as String?,
      dataFimRecorrencia: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Tarefa obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titulo)
      ..writeByte(2)
      ..write(obj.descricao)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.prioridade)
      ..writeByte(5)
      ..write(obj.dataCriacao)
      ..writeByte(6)
      ..write(obj.dataVencimento)
      ..writeByte(7)
      ..write(obj.usuarioId)
      ..writeByte(8)
      ..write(obj.cultivoId)
      ..writeByte(9)
      ..write(obj.recorrencia)
      ..writeByte(10)
      ..write(obj.dataFimRecorrencia);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TarefaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
