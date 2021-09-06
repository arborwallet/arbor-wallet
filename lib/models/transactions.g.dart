// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionsAdapter extends TypeAdapter<Transactions> {
  @override
  final int typeId = 3;

  @override
  Transactions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transactions(
      walletAddress: fields[0] as String,
      list: (fields[1] as List).cast<Transaction>(),
      fork: fields[2] as Fork,
    );
  }

  @override
  void write(BinaryWriter writer, Transactions obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.walletAddress)
      ..writeByte(1)
      ..write(obj.list)
      ..writeByte(2)
      ..write(obj.fork);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
