// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ambiente.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AmbienteAdapter extends TypeAdapter<Ambiente> {
  @override
  final int typeId = 6;

  @override
  Ambiente read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ambiente(
      id: fields[0] as int,
      nome: fields[1] as String,
      descricao: fields[2] as String?,
      tipo: fields[3] as String,
      comprimento: fields[4] as double?,
      altura: fields[5] as double?,
      largura: fields[6] as double?,
      tempoExposicao: fields[7] as String?,
      orientacao: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Ambiente obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nome)
      ..writeByte(2)
      ..write(obj.descricao)
      ..writeByte(3)
      ..write(obj.tipo)
      ..writeByte(4)
      ..write(obj.comprimento)
      ..writeByte(5)
      ..write(obj.altura)
      ..writeByte(6)
      ..write(obj.largura)
      ..writeByte(7)
      ..write(obj.tempoExposicao)
      ..writeByte(8)
      ..write(obj.orientacao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmbienteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
