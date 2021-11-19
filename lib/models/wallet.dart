import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'blockchain.dart';

part 'wallet.g.dart';

@HiveType(typeId: 1)
class Wallet {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String privateKey;

  @HiveField(2)
  final String publicKey;

  @HiveField(3)
  final String address;

  @HiveField(4)
  final Blockchain blockchain;

  @HiveField(5)
  final int balance;

  Wallet({
    required this.name,
    required this.privateKey,
    required this.publicKey,
    required this.address,
    required this.blockchain,
    required this.balance,
  });

  String balanceForDisplay() {
    return Wallet.amountToDisplayWithPrecision(balance, blockchain.precision);
  }

  static String amountToDisplayWithPrecision(amount, precision) {
    double display = amount / pow(10, precision);
    return display.toStringAsFixed(precision);
    // In case someone asks for the zeros at the end to be not displayed
    // return display.toString();
  }
}
