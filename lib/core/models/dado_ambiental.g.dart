// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dado_ambiental.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DadoAmbientalAdapter extends TypeAdapter<DadoAmbiental> {
  @override
  final int typeId = 13;

  @override
  DadoAmbiental read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DadoAmbiental(
      id: fields[0] as int,
      cultivoId: fields[1] as int?,
      tipoMedicao: fields[2] as String,
      valor: fields[3] as double,
      unidade: fields[4] as String,
      dataHora: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DadoAmbiental obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cultivoId)
      ..writeByte(2)
      ..write(obj.tipoMedicao)
      ..writeByte(3)
      ..write(obj.valor)
      ..writeByte(4)
      ..write(obj.unidade)
      ..writeByte(5)
      ..write(obj.dataHora);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DadoAmbientalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
