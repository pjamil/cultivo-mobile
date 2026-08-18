// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meio_cultivo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeioCultivoAdapter extends TypeAdapter<MeioCultivo> {
  @override
  final int typeId = 7;

  @override
  MeioCultivo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeioCultivo(
      id: fields[0] as int,
      tipo: fields[1] as String,
      descricao: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MeioCultivo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tipo)
      ..writeByte(2)
      ..write(obj.descricao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeioCultivoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
