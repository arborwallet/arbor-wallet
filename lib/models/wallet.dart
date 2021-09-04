import 'dart:math';

import 'package:hive/hive.dart';

import 'fork.dart';

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

  @HiveField(7)
  final int balance;

  Wallet({
    required this.name,
    required this.password,
    required this.phrase,
    required this.privateKey,
    required this.publicKey,
    required this.address,
    required this.fork,
    required this.balance,
  });

  String balanceForDisplay() {
    double display = balance / pow(10,fork.precision);
    return display.toStringAsFixed(fork.precision);
    // In case someone asks for the zeros at the end to be not displayed
    // return display.toString();
  }
}
