// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionGroupAdapter extends TypeAdapter<TransactionGroup> {
  @override
  final int typeId = 5;

  @override
  TransactionGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionGroup(
      type: fields[0] as String,
      timestamp: fields[1] as int,
      block: fields[2] as int,
      fee: fields[3] as int,
      amount: fields[4] as int,
      transactions: (fields[5] as List).cast<Transaction>(),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionGroup obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.block)
      ..writeByte(3)
      ..write(obj.fee)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.transactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
