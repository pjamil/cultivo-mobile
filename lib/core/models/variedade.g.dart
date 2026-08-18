// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variedade.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VariedadeAdapter extends TypeAdapter<Variedade> {
  @override
  final int typeId = 2;

  @override
  Variedade read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Variedade(
      id: fields[0] as int,
      nome: fields[1] as String,
      descricao: fields[2] as String?,
      tipoVariedade: fields[3] as String,
      tipoEspecie: fields[4] as String,
      tempoFloracao: fields[5] as String?,
      origem: fields[6] as String?,
      caracteristicas: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Variedade obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nome)
      ..writeByte(2)
      ..write(obj.descricao)
      ..writeByte(3)
      ..write(obj.tipoVariedade)
      ..writeByte(4)
      ..write(obj.tipoEspecie)
      ..writeByte(5)
      ..write(obj.tempoFloracao)
      ..writeByte(6)
      ..write(obj.origem)
      ..writeByte(7)
      ..write(obj.caracteristicas);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariedadeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
