// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cultivo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CultivoAdapter extends TypeAdapter<Cultivo> {
  @override
  final int typeId = 4;

  @override
  Cultivo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cultivo(
      id: fields[0] as int,
      nome: fields[1] as String,
      status: fields[2] as String,
      dataInicio: fields[3] as DateTime?,
      dataFim: fields[4] as DateTime?,
      notas: fields[5] as String?,
      plantaId: fields[6] as int?,
      ambienteId: fields[7] as int?,
      usuarioId: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Cultivo obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nome)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.dataInicio)
      ..writeByte(4)
      ..write(obj.dataFim)
      ..writeByte(5)
      ..write(obj.notas)
      ..writeByte(6)
      ..write(obj.plantaId)
      ..writeByte(7)
      ..write(obj.ambienteId)
      ..writeByte(8)
      ..write(obj.usuarioId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CultivoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
