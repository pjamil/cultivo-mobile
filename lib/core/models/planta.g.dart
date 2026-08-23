// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantaAdapter extends TypeAdapter<Planta> {
  @override
  final int typeId = 3;

  @override
  Planta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Planta(
      id: fields[0] as int,
      nome: fields[1] as String,
      especie: fields[2] as String,
      status: fields[3] as String,
      dataPlantio: fields[4] as DateTime?,
      dataColheita: fields[5] as DateTime?,
      notas: fields[6] as String?,
      rendimentoGramas: fields[7] as double?,
      variedadeId: fields[8] as int?,
      meioCultivoId: fields[9] as int?,
      ambienteId: fields[10] as int?,
      usuarioId: fields[11] as int?,
      comecandoDe: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Planta obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nome)
      ..writeByte(2)
      ..write(obj.especie)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.dataPlantio)
      ..writeByte(5)
      ..write(obj.dataColheita)
      ..writeByte(6)
      ..write(obj.notas)
      ..writeByte(7)
      ..write(obj.rendimentoGramas)
      ..writeByte(8)
      ..write(obj.variedadeId)
      ..writeByte(9)
      ..write(obj.meioCultivoId)
      ..writeByte(10)
      ..write(obj.ambienteId)
      ..writeByte(11)
      ..write(obj.usuarioId)
      ..writeByte(12)
      ..write(obj.comecandoDe);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
