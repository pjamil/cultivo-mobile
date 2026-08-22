// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registro_acao.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RegistroAcaoAdapter extends TypeAdapter<RegistroAcao> {
  @override
  final int typeId = 12;

  @override
  RegistroAcao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegistroAcao(
      id: fields[0] as int,
      tipo: fields[1] as String,
      data: fields[2] as DateTime,
      cultivoId: fields[3] as int,
      plantaId: fields[4] as int?,
      detalhes: fields[5] as String?,
      notas: fields[6] as String?,
      usuarioId: fields[7] as int?,
      dataCriacao: fields[8] as DateTime?,
      dataAtualizacao: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RegistroAcao obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tipo)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.cultivoId)
      ..writeByte(4)
      ..write(obj.plantaId)
      ..writeByte(5)
      ..write(obj.detalhes)
      ..writeByte(6)
      ..write(obj.notas)
      ..writeByte(7)
      ..write(obj.usuarioId)
      ..writeByte(8)
      ..write(obj.dataCriacao)
      ..writeByte(9)
      ..write(obj.dataAtualizacao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegistroAcaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
