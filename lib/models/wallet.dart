import 'dart:math';

import 'package:hive/hive.dart';

import 'fork.dart';

part 'wallet.g.dart';

@HiveType(typeId: 1)
class Wallet {
  @HiveField(0)
  final String name;

  final String phrase;

  @HiveField(1)
  final String privateKey;

  @HiveField(2)
  final String publicKey;

  @HiveField(3)
  final String address;

  @HiveField(4)
  final NewFork fork;

  @HiveField(5)
  final int balance;

  Wallet({
    required this.name,
    this.phrase = '',
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
