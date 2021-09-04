// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletAdapter extends TypeAdapter<Wallet> {
  @override
  final int typeId = 1;

  @override
  Wallet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wallet(
      name: fields[0] as String,
      password: fields[1] as String,
      phrase: fields[2] as String,
      privateKey: fields[3] as String,
      publicKey: fields[4] as String,
      address: fields[5] as String,
      fork: fields[6] as Fork,
      balance: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Wallet obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.phrase)
      ..writeByte(3)
      ..write(obj.privateKey)
      ..writeByte(4)
      ..write(obj.publicKey)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.fork)
      ..writeByte(7)
      ..write(obj.balance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
