// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diario.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiarioCultivoAdapter extends TypeAdapter<DiarioCultivo> {
  @override
  final int typeId = 5;

  @override
  DiarioCultivo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiarioCultivo(
      id: fields[0] as int,
      titulo: fields[1] as String,
      conteudo: fields[2] as String,
      data: fields[3] as DateTime?,
      userId: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DiarioCultivo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titulo)
      ..writeByte(2)
      ..write(obj.conteudo)
      ..writeByte(3)
      ..write(obj.data)
      ..writeByte(4)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiarioCultivoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
