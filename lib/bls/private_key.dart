import 'dart:convert';
import 'dart:typed_data';

import 'package:arbor/bls/ec.dart';
import 'package:arbor/bls/hkdf.dart';
import 'package:arbor/clvm/bytes.dart';
import 'package:hex/hex.dart';

class PrivateKey {
  static const int size = 32;

  BigInt value;

  PrivateKey(this.value) : assert(value < defaultEc.n);

  factory PrivateKey.fromBytes(Uint8List bytes) =>
      PrivateKey(bytesToBigInt(bytes, Endian.big) % defaultEc.n);
  factory PrivateKey.fromSeed(Uint8List seed) {
    var L = 48;
    var okm = extractExpand(
        L,
        Uint8List.fromList(seed + [0]),
        Uint8List.fromList(utf8.encode('BLS-SIG-KEYGEN-SALT-')),
        Uint8List.fromList([0, L]));
    return PrivateKey(bytesToBigInt(okm, Endian.big) % defaultEc.n);
  }
  factory PrivateKey.fromBigInt(BigInt n) => PrivateKey(n % defaultEc.n);
  factory PrivateKey.aggregate(List<PrivateKey> privateKeys) =>
      PrivateKey(privateKeys.fold(BigInt.zero,
              (BigInt aggregate, privateKey) => aggregate + privateKey.value) %
          defaultEc.n);

  JacobianPoint getG1() => G1Generator() * value;

  Uint8List toBytes() => bigIntToBytes(value, size, Endian.big);

  @override
  String toString() => 'PrivateKey(0x${const HexEncoder().convert(toBytes())})';

  @override
  bool operator ==(other) => other is PrivateKey && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
