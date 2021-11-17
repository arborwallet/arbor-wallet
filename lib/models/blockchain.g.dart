// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blockchain.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlockchainAdapter extends TypeAdapter<Blockchain> {
  @override
  final int typeId = 2;

  @override
  Blockchain read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Blockchain(
      name: fields[0] as String,
      ticker: fields[1] as String,
      unit: fields[2] as String,
      precision: fields[3] as int,
      logo: fields[4] as String,
      network_fee: fields[5] as int,
      agg_sig_me_extra_data: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Blockchain obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.ticker)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.precision)
      ..writeByte(4)
      ..write(obj.logo)
      ..writeByte(5)
      ..write(obj.network_fee)
      ..writeByte(6)
      ..write(obj.agg_sig_me_extra_data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockchainAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
