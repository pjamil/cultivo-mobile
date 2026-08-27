// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_operation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineOperationAdapter extends TypeAdapter<OfflineOperation> {
  @override
  final int typeId = 11;

  @override
  OfflineOperation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineOperation(
      id: fields[0] as String,
      operation: fields[1] as String,
      entity: fields[2] as String,
      entityId: fields[3] as int?,
      data: (fields[4] as Map?)?.cast<String, dynamic>(),
      url: fields[5] as String,
      timestamp: fields[6] as int,
      synced: fields[7] as bool,
      syncedAt: fields[8] as String?,
      error: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineOperation obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.operation)
      ..writeByte(2)
      ..write(obj.entity)
      ..writeByte(3)
      ..write(obj.entityId)
      ..writeByte(4)
      ..write(obj.data)
      ..writeByte(5)
      ..write(obj.url)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.synced)
      ..writeByte(8)
      ..write(obj.syncedAt)
      ..writeByte(9)
      ..write(obj.error);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineOperationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
