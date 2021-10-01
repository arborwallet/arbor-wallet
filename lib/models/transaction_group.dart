import 'dart:math';

import 'package:arbor/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'transaction_group.g.dart';

@HiveType(typeId: 5)
class TransactionGroup {
  static const MILLISECONDS_MULTIPLIER = 1000;

  @HiveField(0)
  final String type;

  @HiveField(1)
  final int timestamp;

  @HiveField(2)
  final int block;

  @HiveField(3)
  final int fee;

  @HiveField(4)
  final int amount;

  @HiveField(5)
  final List<Transaction> transactions;

  TransactionGroup({
    required this.type,
    required this.timestamp,
    required this.block,
    required this.fee,
    required this.amount,
    required this.transactions
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

  String toDateOnly() {
    final DateFormat formatter = DateFormat('MMM d, y');
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(timestamp * MILLISECONDS_MULTIPLIER));
  }

  String toTime() {
    final DateFormat formatter = DateFormat('h:mm a');
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(timestamp * MILLISECONDS_MULTIPLIER));
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
