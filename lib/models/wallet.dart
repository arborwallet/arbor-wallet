import 'package:hive/hive.dart';
import 'package:arbor/models/fork.dart';

part 'wallet.g.dart';

@HiveType(typeId: 1)
class Wallet {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String phrase;

  @HiveField(3)
  final String privateKey;

  @HiveField(4)
  final String publicKey;

  @HiveField(5)
  final String address;

  @HiveField(6)
  final Fork fork;

  Wallet({
    required this.name,
    required this.password,
    required this.phrase,
    required this.privateKey,
    required this.publicKey,
    required this.address,
    required this.fork,
  });
}
