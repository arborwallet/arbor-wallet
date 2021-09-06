import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 4)
class Transaction {
  static const MILLISECONDS_MULTIPLIER = 1000;

  @HiveField(0)
  final String type;

  @HiveField(1)
  final int timestamp;

  @HiveField(2)
  final int block;

  @HiveField(3)
  final String address;

  @HiveField(4)
  final int amount;

  Transaction({
    required this.type,
    required this.timestamp,
    required this.block,
    required this.address,
    required this.amount,
  });

  String amountForDisplay(int forkPrecision) {
    double display = amount / pow(10, forkPrecision);
    return display.toStringAsFixed(forkPrecision);
  }

  String timestampForDisplay() {
    //
    final DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp * MILLISECONDS_MULTIPLIER);
    return dt.toString();
  }

  String timeForDisplay() {
    final DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp * MILLISECONDS_MULTIPLIER);
    return dt.toString();
  }

  AssetImage assetImageForType() {
    switch(type) {
      case "receive": {
        return AssetImage("assets/images/transaction-receive.png");
      }
      case "send": {
        return AssetImage("assets/images/transaction-send.png");
      }
      default: {
        return AssetImage("assets/images/transaction-receive.png");
      }
    }

  }

  String typeForDisplay() {
    switch(type) {
      case "receive": {
        return "Received";
      }
      case "send": {
        return "Sent";
      }
      default: {
        return "Unknown";
      }
    }
  }
}
