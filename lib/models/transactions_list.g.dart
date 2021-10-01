// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionsListAdapter extends TypeAdapter<TransactionsList> {
  @override
  final int typeId = 3;

  @override
  TransactionsList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionsList(
      list: (fields[0] as List).cast<TransactionGroup>(),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionsList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.list);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionsListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
