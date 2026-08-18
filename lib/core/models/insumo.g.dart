// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insumo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InsumoAdapter extends TypeAdapter<Insumo> {
  @override
  final int typeId = 9;

  @override
  Insumo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Insumo(
      id: fields[0] as int,
      codigo: fields[1] as String,
      nome: fields[2] as String,
      tipo: fields[3] as String,
      quantidade: fields[4] as double,
      unidadeMedida: fields[5] as String,
      estoqueMinimo: fields[6] as double,
      dataCadastro: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Insumo obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.codigo)
      ..writeByte(2)
      ..write(obj.nome)
      ..writeByte(3)
      ..write(obj.tipo)
      ..writeByte(4)
      ..write(obj.quantidade)
      ..writeByte(5)
      ..write(obj.unidadeMedida)
      ..writeByte(6)
      ..write(obj.estoqueMinimo)
      ..writeByte(7)
      ..write(obj.dataCadastro);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsumoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
