
import 'package:hive/hive.dart';

import 'models.dart';

part 'transactions.g.dart';

@HiveType(typeId: 3)
class Transactions {
  @HiveField(0)
  final String walletAddress;

  @HiveField(1)
  final List<Transaction> list;

  @HiveField(2)
  final Fork fork;

  Transactions({
    required this.walletAddress,
    required this.list,
    required this.fork,
  });
}
