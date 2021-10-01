// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionsGroupAdapter extends TypeAdapter<TransactionsGroup> {
  @override
  final int typeId = 3;

  @override
  TransactionsGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionsGroup(
      address: fields[1] as String,
      transactionsList: (fields[0] as List).cast<Transaction>(),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionsGroup obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.transactionsList)
      ..writeByte(1)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionsGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
