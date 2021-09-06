// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fork.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ForkAdapter extends TypeAdapter<Fork> {
  @override
  final int typeId = 2;

  @override
  Fork read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Fork(
      name: fields[0] as String,
      ticker: fields[1] as String,
      unit: fields[2] as String,
      precision: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Fork obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.ticker)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.precision);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
