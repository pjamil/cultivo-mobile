// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FotoAdapter extends TypeAdapter<Foto> {
  @override
  final int typeId = 10;

  @override
  Foto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Foto(
      id: fields[0] as int,
      url: fields[1] as String,
      thumbnailUrl: fields[2] as String?,
      legenda: fields[3] as String?,
      entityType: fields[4] as String,
      entityId: fields[5] as int,
      cultivoEstado: fields[6] as String?,
      createdAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Foto obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.thumbnailUrl)
      ..writeByte(3)
      ..write(obj.legenda)
      ..writeByte(4)
      ..write(obj.entityType)
      ..writeByte(5)
      ..write(obj.entityId)
      ..writeByte(6)
      ..write(obj.cultivoEstado)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FotoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
